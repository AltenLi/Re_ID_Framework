% Add Paths
curr_dir=pwd;
addpath(genpath(fullfile(curr_dir, 'GenerateFeatures')));
addpath(genpath(fullfile(curr_dir, 'GenerateModels')));
addpath(genpath(fullfile(curr_dir, 'SharedScripts')));
% addpath(genpath(fullfile(curr_dir, 'SharedMats')));
addpath(genpath(fullfile(curr_dir, 'CrossValidation')));
addpath(genpath(fullfile(curr_dir, 'Methods')));


paramALL = struct();

paramALL.MAXCLUSTER  = 1; % maximum number of images per signatures (=1 SvsS, >1 MvsM)
paramALL.IterMax = 10;% iterate num
paramALL.CanSkipFeature = 1;%skip exist model creating
paramALL.CanSkipModel = 1;%skip exist model creating
paramALL.ReSelectLabel = 1;%re-select the test label
paramALL.CleanLastFMR = 1;%re-select the test label
paramALL.Dataset=upper('ETHZ1'); % 'VIPeR' 'iLIDS' 'ETHZ3' 'WARD'

paramALL.DIR.FeatureDIR='Features\';%Feature File Dir
paramALL.DIR.LabelDIR=['Labels\' paramALL.Dataset '\'];
paramALL.DIR.ResultDIR=['Results\' paramALL.Dataset '\'];
paramALL.DIR.ModelDIR=['Models\' paramALL.Dataset '\'];

%del tmp folders
if paramALL.CleanLastFMR
    if exist(paramALL.DIR.FeatureDIR,'dir')
        rmdir(paramALL.DIR.FeatureDIR,'s');
    end
    if exist(paramALL.DIR.ResultDIR,'dir')
        rmdir(paramALL.DIR.ResultDIR,'s');
    end
    if exist(paramALL.DIR.ModelDIR,'dir')
        rmdir(paramALL.DIR.ModelDIR,'s');
    end
end

%mkdirs
if ~exist(paramALL.DIR.FeatureDIR,'dir')
    mkdir(paramALL.DIR.FeatureDIR);
end
if ~exist(paramALL.DIR.LabelDIR,'dir')
    mkdir(paramALL.DIR.LabelDIR);
end
if ~exist(paramALL.DIR.ResultDIR,'dir')
    mkdir(paramALL.DIR.ResultDIR);
end
if ~exist(paramALL.DIR.ModelDIR,'dir')
    mkdir(paramALL.DIR.ModelDIR);
end


