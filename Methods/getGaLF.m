function [ paramALL, paramGaLF ] = getGaLF( paramALL )
%GETGALF Summary of this function goes here
%   Get other Features\Set Mask\Load Mats  --- Generate the Model

%% Parameters
paramGaLF = struct();
paramGaLF.init_K = 1;%GMM
paramGaLF.final_K = 1;%GMM
paramGaLF.bt_type = 'bt_body_nohead_100';% 'bt_body_100' 'bt_body_nohead_100' 'cc_nohead'
paramGaLF.useMSCR = 0;
paramGaLF.useFV = 0;
paramGaLF.useFLIP = 0;%if the fliplr img used for re-id
paramGaLF.useNorm = 0;%if the feature normailized (!not finished!)
paramGaLF.mask_type ='PPDDNBG';%'STRIPES' 'WHOLE' 'PPDDN' 'PPDDNBG'  'CELLS' 'PPDDNBG_SP' 'MAT' 'PPDDNBGH'
paramGaLF.feature_type = {'LAB', 'Y', 'DY'};%'RGB' 'HSV' 'LAB' 'X' 'Y' 'DX' 'DY' 'SIFT' 'TRANS' 'SAL' 'LBP' 'DXY' 'DDX 'DDY' 'GDX' 'GDY''

paramGaLF.featureName=[paramALL.Dataset '_' cell2mat(paramGaLF.feature_type) '_' paramGaLF.bt_type '_' paramGaLF.mask_type ];
paramGaLF.featureFileName=fullfile(paramALL.DIR.FeatureDIR,[paramGaLF.featureName '.mat']);

% SR-EMD params
paramGaLF.SREMD = struct();
paramGaLF.SREMD.DistanceType = 'EMD-theta';  %  'EMD-M'   'EMD-theta'
paramGaLF.SREMD.theta = 0.4;  %default theta
paramGaLF.SREMD.dist_theta = 2.2;%score theta
paramGaLF.SREMD.dist_thetaMSCR = 1.3;%score theta
paramGaLF.SREMD.dist_thetaFV = 55;%score theta
% paramGaLF.SREMD.k = 0;  % used in gmmknnclasify.m
paramGaLF.SREMD.weight = ones(50,1);  % 每部分权重
paramGaLF.SREMD.gammaMSCR = 8;%MSCR权重
paramGaLF.SREMD.gammaf = 8;%Fisher Vector权重

paramGaLF.SREMD.UseY = 0;%匹配块的时候对y方向是否有阈值限定
paramGaLF.SREMD.YFpos = 4;%y是特征的第几维
paramGaLF.SREMD.yth = 100;%y方向距离匹配阈值
paramGaLF.SREMD.spDistMax = 100;%superpixel diff row dist

%% Get Mask
paramALL = setDDNMasks( paramALL );

%% Get Feature
fprintf('------------------------------------------------------------------------------------------\n');
fprintf('Extracting pixel descriptors: \n');
start_time = round(clock);

%skip check
if ~exist(paramGaLF.featureFileName,'file') ...
        || ~paramALL.CanSkipFeature
    get_pixels_feature(paramALL,paramGaLF);
    
end

disp(['Loading....' paramGaLF.featureName]);
load(paramGaLF.featureFileName,'body_parts','feature_parts');
paramGaLF.feature_parts = feature_parts;
paramGaLF.body_parts = body_parts;
disp('Loaded.');

end_time = round(clock);
time_elapsed = end_time - start_time;
fprintf('Time elapsed is : %d hours %d minutes %d seconds\n',  time_elapsed(4), time_elapsed(5), time_elapsed(6));


%% Compute image models by Gaussian Mixture Models (GMMs)
fprintf('------------------------------------------------------------------------------------------\n');
fprintf('Building image models by Gaussian Mixture Models (GMMs): \n');
start_time = round(clock);

%skip check
if paramALL.CanSkipModel  ...
        && ( length(dir(fullfile(paramALL.DIR.ModelDIR, '*.mat')))==paramALL.Imgcount ...
        || length(dir(fullfile(paramALL.DIR.ModelDIR, '*.mat')))==paramALL.Imgcount*2 )
    disp('Build Skiped');
else
    fprintf('Building image models --Processing \n');
    load(paramGaLF.featureFileName,'X');
    ComputeGMMs(X, feature_parts, paramALL, paramGaLF);
    clear 'X','imgs';
end

end_time = round(clock);
time_elapsed = end_time - start_time;
fprintf('Time elapsed is : %d hours %d minutes %d seconds\n',  time_elapsed(4), time_elapsed(5), time_elapsed(6));

end

