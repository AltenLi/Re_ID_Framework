function [ ped, filename ] =get_dyn_labels( paramALL )
%GET_DYN_LABELS Get gallery & query labels for MvsM
%   To create label file , see SharedMats\create_dynlabels.m

switch image_dataset
    case 'VIPeR'
        %VIPeR only have SvsS
        error('VIPeR only have SvsS, Please change the value of MAXCLUSTER.')
    case 'iLIDS'
        load('SharedMats/DynPedsModel_iLIDS','ped');%ped
        for i = 1:size(ped,2) % for each ped
            in = randperm(length(ped(i).dynmodels)); % random selection of the data 4 dynamic feature
            ped(i).dynmodels = ped(i).dynmodels(in(1:min(length(ped(i).dynmodels), 2*paramALL.MAXCLUSTER)));
            ped(i).rnddd = 1:length(ped(i).dynmodels);
        end
    case 'ETHZ3'
        load('SharedMats/DynPedsModel_ETHZ3','ped');
        for i = 1:size(ped,2) % for each ped
            in = randperm(length(ped(i).dynmodels)); % random selection of the data 4 dynamic feature
            ped(i).dynmodels = ped(i).dynmodels(in(1:min(length(ped(i).dynmodels), 2*paramALL.MAXCLUSTER)));
            ped(i).rnddd = 1:length(ped(i).dynmodels);
        end
        
    case 'ETHZ2'
        load('SharedMats/DynPedsModel_ETHZ2','ped');
        for i = 1:size(ped,2) % for each ped
            in = randperm(length(ped(i).dynmodels)); % random selection of the data 4 dynamic feature
            ped(i).dynmodels = ped(i).dynmodels(in(1:min(length(ped(i).dynmodels), 2*paramALL.MAXCLUSTER)));
            ped(i).rnddd = 1:length(ped(i).dynmodels);
        end
    case 'ETHZ1'
        load('SharedMats/DynPedsModel_ETHZ1','ped');
        for i = 1:size(ped,2) % for each ped
            in = randperm(length(ped(i).dynmodels)); % random selection of the data 4 dynamic feature
            ped(i).dynmodels = ped(i).dynmodels(in(1:min(length(ped(i).dynmodels), 2*paramALL.MAXCLUSTER)));
            ped(i).rnddd = 1:length(ped(i).dynmodels);
        end
end

end

