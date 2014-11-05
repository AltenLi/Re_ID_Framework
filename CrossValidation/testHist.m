function [cmc, nAUC] = testHist(paramALL, paramHist, iter)
%TESTGALF CrossValidation of GaLF

%% Parameters


%% Load Labels & Models
% label   [gallery_label, query_label]   or  [ped]
labels=load(paramALL.LabelFileName);

% models
if paramALL.MAXCLUSTER==1 % SvsS
%     paramSREMD.k = length(gallery_label);
    [ gallerymodels,querymodels ] = get_qtmodels( labels.gallery_label,labels.query_label,paramALL.DIR.ModelDIR );
    disp('Models Loaded.');
else % MvsM MAXCLUSTER>1
%     paramSREMD.k = size(ped,2);
    [ gallerymodels,querymodels ] = get_dyn_hist_models( labels.ped, paramALL.DIR.ModelDIR, 1 );
    disp('Models Loaded.');
end


%% Retrieval using SR-EMD
% Calc model Distances & Scores
    
disp('Calculating model Distances & Scores');

[~,neighborScores,neighborDistances] = calc_hist_score(querymodels, gallerymodels, paramHist.dist_theta);
disp('...ok');

% Calc Votes for Ranking
votes=neighborScores;


%Combine Other Features
% if paramALL.MAXCLUSTER==1
%     %Mix MSCR
%     if paramGaLF.useMSCR
%         mscr_dist=final_mscr_dist(query_label,gallery_label);
%         mscr_score=exp(-mscr_dist.^2./paramSREMD.dist_thetaMSCR^2);
%         votes=votes+paramSREMD.gammaMSCR*mscr_score;
%     end
%     
%     %Mix Fisher Vector
%     if paramGaLF.useFV
%         fisher_scores=calc_fisher_vector_score(query_label,gallery_label,FeatureFISHER,paramSREMD);
%         votes=votes+paramSREMD.gammaf*fisher_scores;
%     end
% end

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
% if paramGaLF.useMSCR
%     save(fullfile(paramALL.DIR.ResultDIR,['score_iter' num2str(iter) '.mat']),'mscr_score','-append');
% end
% if paramGaLF.useFV
%     save(fullfile(paramALL.DIR.ResultDIR,['score_iter' num2str(iter) '.mat']),'fisher_scores','-append');
% end

end

