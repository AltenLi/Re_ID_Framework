function [ gallerymodels,querymodels ] = get_qtmodels( gallery_label, query_label, base_model_dir, imgcount, useFLIP )
%GET_QTMODELS Load Models for re-id
% Author : Qian Li
% Date : 2014.4.21
if nargin < 5
    useFLIP=0;
end
if nargin < 4
    imgcount=0;
end
if nargin<3
    error('not enough arguments for get_qtmodels()');
end
gallerymodels=cell(length(gallery_label),1);
querymodels=cell(length(query_label),1);
labcounts=length(query_label);
for tid=1:labcounts
    querymodels{tid}=load(fullfile(base_model_dir,sprintf('%04d.mat',query_label(tid))), 'features');
    gallerymodels{tid}=load(fullfile(base_model_dir,sprintf('%04d.mat',gallery_label(tid))), 'features');
end
if useFLIP
    for tid=1:labcounts
        querymodels{tid+labcounts}=load(fullfile(base_model_dir,sprintf('%04d.mat',query_label(tid)+imgcount)), 'features');
        gallerymodels{tid+labcounts}=load(fullfile(base_model_dir,sprintf('%04d.mat',gallery_label(tid)+imgcount)), 'features');
    end
end
end
