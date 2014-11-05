function [ gallerymodels,querymodels ] = get_dyn_galf_models( ped,base_model_dir ,feature_parts)
%get_dyn_galf_models Get models for MvsM
% Author : Qian Li
% Date : 2014.4.21
gallerymodels=cell(size(ped,2),1);
querymodels=cell(size(ped,2),1);

for i = 1:size(ped,2) % for each ped
    dd = uint16(floor(length(ped(i).dynmodels)/2));
    rnddd = ped(i).rnddd;
    
    % dyn 1
    
    sumpix=zeros(length(unique(feature_parts)),1);
    for j = 1:dd % for each view/2
        ind = ped(i).dynmodels(rnddd(j)); % we are searching for the local index (in permits_ind)
        tmpModel=load(fullfile(base_model_dir,sprintf('%04d.mat',ind)), 'features');
        if j==1
            querymodels{i}=tmpModel;
            for fts=1:length(tmpModel.features)
                sumpix(fts)=sumpix(fts)+tmpModel.features{fts}.N;
            end
        else
            %combine models
            for fts=1:length(tmpModel.features)
                querymodels{i}.features{fts}=[querymodels{i}.features{fts},tmpModel.features{fts}];
                sumpix(fts)=sumpix(fts)+tmpModel.features{fts}.N;
            end
        end
    end
    for fts=1:length(tmpModel.features)
        for j = 1:dd
            querymodels{i}.features{fts}(j).pb=double(querymodels{i}.features{fts}(j).N/sumpix(fts));
        end
    end
    
    % dyn 2
    sumpix=zeros(length(unique(feature_parts)),1);
    for j = dd+1:length(ped(i).dynmodels) % for each view/2
        ind = ped(i).dynmodels(rnddd(j)); % we are searching for the local index (in permits_ind)
        tmpModel=load(fullfile(base_model_dir,sprintf('%04d.mat',ind)), 'features');
        if j==dd+1
            gallerymodels{i}=tmpModel;
            for fts=1:length(tmpModel.features)
                sumpix(fts)=sumpix(fts)+tmpModel.features{fts}.N;
            end
        else
            %combine models
            for fts=1:length(tmpModel.features)
                gallerymodels{i}.features{fts}=[gallerymodels{i}.features{fts},tmpModel.features{fts}];
                sumpix(fts)=sumpix(fts)+tmpModel.features{fts}.N;
            end
        end
    end
    for fts=1:length(tmpModel.features)
        for j = 1:dd
            gallerymodels{i}.features{fts}(j).pb=double(gallerymodels{i}.features{fts}(j).N/sumpix(fts));
        end
    end
end

end

