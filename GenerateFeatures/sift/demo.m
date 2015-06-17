% I=imread(fullfile('..\..\datasets\VIPeR','0001001.bmp'));
% 
% gridSpacing = 1;
% patchSize = 8;
% 
% [siftarr gridX gridY] = sp_dense_sift(I, gridSpacing,  patchSize);

imageBaseDir='..\..\..\datasets\VIPeR';
imageFileList=dir(fullfile(imageBaseDir,'*.bmp'));
imageFileList={imageFileList.name};
dataBaseDir='..\..\..\datasets\VIPeR_denseSIFT';
params=struct();
params.oldSift=0;
pfig=figure;
canSkip=0;
% GenerateSiftDescriptors( imageFileList, imageBaseDir, dataBaseDir, params, canSkip, pfig);

fprintf('Building Sift Descriptors\n\n');

%% parameters

if(~exist('params','var'))
    params.maxImageSize = 1000;
    params.gridSpacing = 8;
    params.patchSize = 16;
    params.dictionarySize = 200;
    params.numTextonImages = 50;
    params.pyramidLevels = 3;
end
if(~isfield(params,'maxImageSize'))
    params.maxImageSize = 1000;
end
if(~isfield(params,'gridSpacing'))
    params.gridSpacing = 8;
end
if(~isfield(params,'patchSize'))
    params.patchSize = 16;
end
if(~isfield(params,'dictionarySize'))
    params.dictionarySize = 200;
end
if(~isfield(params,'numTextonImages'))
    params.numTextonImages = 50;
end
if(~isfield(params,'pyramidLevels'))
    params.pyramidLevels = 3;
end
if(~exist('canSkip','var'))
    canSkip = 1;
end
if(exist('pfig','var'))
    tic;
end

sifth=128;
siftw=75;
sifts=zeros(siftw,sifth,1,1264);
for f = 1:length(imageFileList)

    %% load image
    imageFName = imageFileList{f};
    [dirN base] = fileparts(imageFName);
    baseFName = [dirN filesep base];
    outFName = fullfile(dataBaseDir, sprintf('%s_sift.mat', baseFName));
    imageFName = fullfile(imageBaseDir, imageFName);
    
%     if(mod(f,100)==0 && exist('pfig','var'))
%         sp_progress_bar(pfig,1,4,f,length(imageFileList));
%     end
    if(exist(outFName,'file')~=0 && canSkip)
        %fprintf('Skipping %s\n', imageFName);
        continue;
    end
    
    features = sp_gen_sift(imageFName,params);
    sifts(:,:,1,f)=features.data;
%     sp_progress_bar(pfig,1,4,f,length(imageFileList),'Generating Sift Descriptors:');
    
    sp_make_dir(outFName);
    save(outFName, 'features');
    

end % for
save('VIPeR_sift.mat','sifts','siftw','sifth');