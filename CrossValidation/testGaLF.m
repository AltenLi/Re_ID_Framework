function [cmc, nAUC] = testGaLF(paramALL, paramGaLF, iter)
%TESTGALF CrossValidation of GaLF

%% Parameters
% SR_EMD Params
paramGaLF.SREMD.M = eye(paramGaLF.body_parts+1); %M should be symmetric positive definite (SPD) matrix and is the identity matrix in default
[U, S, V]=svd(paramGaLF.SREMD.M);
paramGaLF.SREMD.M_one_half = U * diag(sqrt(diag(S))) * V';  %the square root matrix of paramGaLF.SREMD.M, i.e. paramGaLF.SREMD.M = paramGaLF.SREMD.M_one_half * paramGaLF.SREMD.M_one_half, which is also a SPD matrix


%% Load MSCR Feature
if paramGaLF.useMSCR
    switch paramALL.Dataset
        case 'VIPeR'
            load('SharedMats/MSCRmatch_VIPeR_f1_Exp001.mat','final_mscr_dist');
        case 'iLIDS'
            load('SharedMats/MSCRmatch_iLIDS_f1_Exp001.mat','final_mscr_dist');
        case 'ETHZ3'
            %             FeatureFISHER=load(['Feature_ETHZ_fv_14_Block32_64x128_GMM16_Sample2000.mat']);
    end
end

%% Load Fisher Vector Feature
if paramGaLF.useFV
    switch paramALL.Dataset
        case 'VIPeR'
            FeatureFISHER=load(['SharedMats/Feature_VIPeR_fv_14_Block12_48x128_GMM16_Sample2000.mat']);
        case 'iLIDS'
            FeatureFISHER=load(['SharedMats/Feature_iLIDS_fv_14_Block32_64x128_GMM16_Sample2000.mat']);
        case 'ETHZ3'
            %             FeatureFISHER=load(['Feature_ETHZ_fv_14_Block32_64x128_GMM16_Sample2000.mat']);
    end
    FeatureFISHER=FeatureFISHER.ImgData;
end


%% Load Labels & Models
% label   [gallery_label, query_label]   or  [ped]
labels=load(paramALL.LabelFileName);

% models
if paramALL.MAXCLUSTER==1 % SvsS
%     paramGaLF.SREMD.k = length(gallery_label);
    [ gallerymodels,querymodels ] = get_qtmodels( labels.gallery_label,labels.query_label,paramALL.DIR.ModelDIR, paramALL.Imgcount, paramGaLF.useFLIP );
    disp('Models Loaded.');
else % MvsM MAXCLUSTER>1
%     paramGaLF.SREMD.k = size(ped,2);
    [ gallerymodels,querymodels ] = get_dyn_galf_models( labels.ped,paramALL.DIR.ModelDIR,paramGaLF.feature_parts, paramALL.Imgcount, paramGaLF.useFLIP );
    disp('Models Loaded.');
end


%% Retrieval using SR-EMD
% Calc model Distances & Scores
if strcmp(paramGaLF.mask_type,'PPDDNBG_SP') ...
        || strcmp(paramGaLF.mask_type,'PPDDNBG_PARTSP') ...
        || strcmp(paramGaLF.mask_type,'SP') ...
        || strcmp(paramGaLF.mask_type,'CELLS')
    % for superpixels
    fpids=unique(paramGaLF.feature_parts);
    neighborScores=cell(length(fpids),1);
    neighborDistances=cell(length(fpids),1);
    
    parfor parts=fpids
        disp(parts);
        [~,neighborScores{parts},neighborDistances{parts}] = gmmknnclassify_sp_y_score(querymodels, gallerymodels, parts, paramGaLF.SREMD, paramGaLF.useFLIP);
        disp([num2str(parts) '...ok']);
    end
    
    votes=zeros(length(querymodels),length(gallerymodels));
    for parts=fpids
        partScores=-neighborDistances{parts};
        votes = votes+partScores.*paramGaLF.SREMD.weight(parts);
    end
    
else
    neighborScores=cell(paramGaLF.body_parts,1);
    neighborDistances=cell(paramGaLF.body_parts,1);
    
    parfor parts=1:paramGaLF.body_parts
        disp(parts);
        [~,neighborScores{parts},neighborDistances{parts}] = gmmknnclassify_part_score(querymodels, gallerymodels, parts, paramGaLF.SREMD, paramGaLF.useFLIP);
        disp([num2str(parts) '...ok']);
    end
    
    % Calc Votes for Ranking
    votes=zeros(length(querymodels),length(gallerymodels));
    for parts=1:paramGaLF.body_parts
        partScores=neighborScores{parts};
        votes = votes+partScores.*paramGaLF.SREMD.weight(parts);
    end
end


%Combine Other Features
if paramALL.MAXCLUSTER==1
    %Mix MSCR
    if paramGaLF.useMSCR
        mscr_dist=final_mscr_dist(query_label,gallery_label);
        mscr_score=exp(-mscr_dist.^2./paramGaLF.SREMD.dist_thetaMSCR^2);
        votes=votes+paramGaLF.SREMD.gammaMSCR*mscr_score;
    end
    
    %Mix Fisher Vector
    if paramGaLF.useFV
        fisher_scores=calc_fisher_vector_score(query_label,gallery_label,FeatureFISHER,paramGaLF.SREMD);
        votes=votes+paramGaLF.SREMD.gammaf*fisher_scores;
    end
end

%Ranking
result=zeros(length(querymodels),1);
for id=1:length(querymodels)
    [~,sortpos] = sort(votes(id,:),'descend');%排列并统计每一对的票数，idx记录原标号
    result(sortpos == id) = result(sortpos == id)+1;
end
tcmc=cumsum(result);
cmc=tcmc./length(querymodels);
nAUC = sum(cmc(:))./length(querymodels)*100;

fprintf('Round %d MAP on %s dataset is %f cmc(1) is %f . \n', iter, paramALL.Dataset, nAUC, cmc(1));

% Save Result for each iteration
save(fullfile(paramALL.DIR.ResultDIR,['score_iter' num2str(iter) '.mat']),'votes','neighborScores','neighborDistances','cmc','nAUC');
if paramGaLF.useMSCR
    save(fullfile(paramALL.DIR.ResultDIR,['score_iter' num2str(iter) '.mat']),'mscr_score','-append');
end
if paramGaLF.useFV
    save(fullfile(paramALL.DIR.ResultDIR,['score_iter' num2str(iter) '.mat']),'fisher_scores','-append');
end

end

