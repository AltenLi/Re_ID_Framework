function [ gallerymodels,querymodels ] = get_dyn_hist_models( ped,base_model_dir )
%get_dyn_hist_models Get histogram models for MvsM
% Author : Qian Li
% Date : 2014.4.21
gallerymodels=cell(size(ped,2),1);
querymodels=cell(size(ped,2),1);

for i = 1:size(ped,2) % for each ped
    dd = uint16(floor(length(ped(i).dynmodels)/2));
    rnddd = ped(i).rnddd;
    
    % dyn 1
    for j = 1:dd % for each view/2
        ind = ped(i).dynmodels(rnddd(j)); % we are searching for the local index (in permits_ind)
        tmpModel=load(fullfile(base_model_dir,sprintf('%04d.mat',ind)), 'features');
        if j==1
            querymodels{i}=tmpModel;
        else
            %combine models into querymodels{i}.features{1:n}
            for fts=1:length(tmpModel.features)
                querymodels{i}.features{fts}=[querymodels{i}.features{fts},tmpModel.features{fts}];
            end
        end
    end
    
    % dyn 2
    for j = dd+1:length(ped(i).dynmodels) % for each view/2
        ind = ped(i).dynmodels(rnddd(j)); % we are searching for the local index (in permits_ind)
        tmpModel=load(fullfile(base_model_dir,sprintf('%04d.mat',ind)), 'features');
        if j==dd+1
            gallerymodels{i}=tmpModel;
        else
            %combine models
            for fts=1:length(tmpModel.features)
                gallerymodels{i}.features{fts}=[gallerymodels{i}.features{fts},tmpModel.features{fts}];
            end
        end
    end
end

end

