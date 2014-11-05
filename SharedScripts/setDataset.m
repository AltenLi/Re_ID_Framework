function [ paramALL ] = setDataset( paramALL )
% function [ paramALL ] = setDataset( paramALL )
% SETDATASET   Set Dataset dir and get image filelist

switch paramALL.Dataset
    case 'VIPER'
        paramALL.DIR.IMGDIR='..\datasets\VIPeR\';
        paramALL.Imgs=dir(fullfile(paramALL.DIR.IMGDIR,'*.bmp'));
    case 'ILIDS'
        paramALL.DIR.IMGDIR='..\datasets\i-LIDS\';
        paramALL.Imgs=dir(fullfile(paramALL.DIR.IMGDIR,'*.jpg'));
    case 'ETHZ3'
        paramALL.DIR.IMGDIR='..\datasets\ETHZ\seq3\';
        paramALL.Imgs=dir(fullfile(paramALL.DIR.IMGDIR,'*.png'));
    case 'ETHZ2'
        paramALL.DIR.IMGDIR='..\datasets\ETHZ\seq2\';
        paramALL.Imgs=dir(fullfile(paramALL.DIR.IMGDIR,'*.png'));
    case 'ETHZ1'
        paramALL.DIR.IMGDIR='..\datasets\ETHZ\seq1\';
        paramALL.Imgs=dir(fullfile(paramALL.DIR.IMGDIR,'*.png'));
    case 'WARD'
        paramALL.DIR.IMGDIR='..\datasets\WARD\WARD\';
        paramALL.Imgs=dir(fullfile(paramALL.DIR.IMGDIR,'*.png'));
end


% Get image counts
paramALL.Imgcount=length(paramALL.Imgs);
if paramALL.Imgcount<0
    error('Dataset folder is empty');
end

end

