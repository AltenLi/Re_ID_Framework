function [ counts ] = getCmcLength( dataset )
%GET_CMC_LENGTH Get Test Length for CMC initial
% Author : Qian Li
% Date : 2014.4.21
switch dataset
    case 'VIPER'
        counts=316;
    case 'ILIDS'
        ilids_labels=load('SharedMats/Label_iLIDS','Labels');
        [gallery_label,~]=get_dataset_labels(ilids_labels.Labels);
        counts=length(gallery_label);
    case 'ETHZ1'
        ETHZ1_labels=load('SharedMats/Label_ETHZ1','Labels');
        [gallery_label,~]=get_dataset_labels(ETHZ1_labels.Labels);
        counts=length(gallery_label);
    case 'ETHZ2'
        ETHZ2_labels=load('SharedMats/Label_ETHZ2','Labels');
        [gallery_label,~]=get_dataset_labels(ETHZ2_labels.Labels);
        counts=length(gallery_label);
    case 'ETHZ3'
        ETHZ3_labels=load('SharedMats/Label_ETHZ3','Labels');
        [gallery_label,~]=get_dataset_labels(ETHZ3_labels.Labels);
        counts=length(gallery_label);
    case 'WARD'
        WARD_labels=load('SharedMats/Label_WARD','Labels','filename');
        [gallery_label,~]=get_dataset_labels(WARD_labels.Labels);
        counts=length(gallery_label);
end

end

