%% This is the framework of Re-ID,
% including Feature Extraction\Modeling\CrossValidation
% including Unsupervised & Supervised
%
% Author : Qian Li
% Date : 2014.10.31
% E-mail : liqian115@gmail.com

clear all;close all;

% if matlabpool('size') == 0
%     n = feature('numCores');
%     if n>12
%         n=12;
%     end
%     matlabpool('local', n);
% end

run('.\init.m');
paramALL = setDataset( paramALL );

cmclen=getCmcLength(paramALL.Dataset);
cmc = zeros(paramALL.IterMax, cmclen);
nAUC= zeros(paramALL.IterMax,1);

for  iter = 1: paramALL.IterMax;
    %% Set Labels
    paramALL.LabelFileName = setLabels( paramALL, iter );
    
    
    %% Feature Extraction & Modeling
%     [ paramALL, paramMethod ] = getGaLF( paramALL );
    [ paramALL, paramMethod ] = getHist( paramALL );
    
    %% Person Re-identification CrossValidation
%     [cmc(iter,:), nAUC(iter)]=testGaLF(paramALL, paramMethod, iter);
    [cmc(iter,:), nAUC(iter)]=testHist(paramALL, paramMethod, iter);
    
    
end

fprintf('\n\nAverage MAP result %d rounds of  on %s %f  .\n',paramALL.IterMax , paramALL.Dataset,  median(nAUC));

%% Save Result
meannAUC=median(nAUC,1);
meanCMC=median(cmc,1);
meanCMC1=meanCMC(1);

% fename=cell2mat(paramGaLF.feature_type);
fename=paramMethod.featureName;
if paramALL.MAXCLUSTER>1
    fename=[fename '_MvsM'];
end
if exist('paramMethod.useMSCR','var') && paramMethod.useMSCR
    fename=[fename '_MSCR'];
end
if exist('paramMethod.useFV','var') && paramMethod.useFV
    fename=[fename '_FV'];
end

save([paramALL.DIR.ResultDIR 'score_' fename  '.mat'],...
    'nAUC','cmc','meanCMC1','meanCMC','meannAUC','paramMethod','paramALL');

if matlabpool('size') > 0
    matlabpool close;
end