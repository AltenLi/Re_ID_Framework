function [ paramALL ] = setDDNMasks( paramALL )
%SETDDNMASKS Summary of this function goes here
%   Detailed explanation goes here

switch paramALL.Dataset
    case 'VIPER'
        paramALL.DIR.MASKDIR='.\SharedMats\DDN\VIPeR\';
        paramALL.Masks=dir(fullfile(paramALL.DIR.MASKDIR,'*.mat'));
    case 'ILIDS'
        paramALL.DIR.MASKDIR='.\SharedMats\DDN\i-LIDS\';
        paramALL.Masks=dir(fullfile(paramALL.DIR.MASKDIR,'*.mat'));
    case 'ETHZ1'
        paramALL.DIR.MASKDIR='.\SharedMats\DDN\ETHZ\seq1\';
        paramALL.Masks=dir(fullfile(paramALL.DIR.MASKDIR,'*.mat'));
    case 'ETHZ2'
        paramALL.DIR.MASKDIR='.\SharedMats\DDN\ETHZ\seq2\';
        paramALL.Masks=dir(fullfile(paramALL.DIR.MASKDIR,'*.mat'));
    case 'ETHZ3'
        paramALL.DIR.MASKDIR='.\SharedMats\DDN\ETHZ\seq3\';
        paramALL.Masks=dir(fullfile(paramALL.DIR.MASKDIR,'*.mat'));
    case 'WARD'
        paramALL.DIR.MASKDIR='.\SharedMats\DDN\WARD\';
        paramALL.Masks=dir(fullfile(paramALL.DIR.MASKDIR,'*.mat'));
end

end

