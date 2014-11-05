function [ gallery_label, query_label, filename ] = get_labels( paramALL )
%GET_LABELS 
% Get gallery & query labels for SvsS
switch paramALL.Dataset
    case 'VIPER'
        cvpridx=load('SharedMats/cvpridx.mat');
        cvpridx=cvpridx.cvpridx;
%         a=sort([cvpridx*2-1,cvpridx*2]);%pick some labels
%         VIPeR_labels=load('SharedMats/Label_VIPeR','Labels','filename');
%         VIPeR_labels.filename=VIPeR_labels.filename(a);
%         VIPeR_labels.Labels=VIPeR_labels.Labels(a);
%         [gallery_label,query_label]=get_dataset_labels(VIPeR_labels.Labels);
        VIPeR_labels=load('SharedMats/Label_VIPeR','Labels','filename');
        Kidxa=1:2:1264;
        Kidxb=2:2:1264;
        perm = randperm(length(cvpridx(:)));
        idx = perm(1:316);%pick 316 pairs
        gallery_label  = Kidxa(cvpridx(idx));
        query_label  = Kidxb(cvpridx(idx));
        filename=VIPeR_labels.filename;
    case 'ILIDS'
        ilids_labels=load('SharedMats/Label_iLIDS','Labels','filename');
        filename=ilids_labels.filename;
        [gallery_label,query_label]=get_dataset_labels(ilids_labels.Labels);
    case 'ETHZ1'
        ETHZ1_labels=load('SharedMats/Label_ETHZ1','Labels','filename');
        filename=ETHZ1_labels.filename;
        [gallery_label,query_label]=get_dataset_labels(ETHZ1_labels.Labels);
    case 'ETHZ2'
        ETHZ2_labels=load('SharedMats/Label_ETHZ2','Labels','filename');
        filename=ETHZ2_labels.filename;
        [gallery_label,query_label]=get_dataset_labels(ETHZ2_labels.Labels);
    case 'ETHZ3'
        ETHZ3_labels=load('SharedMats/Label_ETHZ3','Labels','filename');
        filename=ETHZ3_labels.filename;
        [gallery_label,query_label]=get_dataset_labels(ETHZ3_labels.Labels);
    case 'WARD'
        %camLabels=[ 1, 2, 3]
        camALabel=1;
        camBLabel=2;
        WARD_labels=load('SharedMats/Label_WARD','Labels','filename', 'CameraLabels');
        filename=WARD_labels.filename;
%         [gallery_label,query_label]=get_dataset_labels(WARD_labels.Labels);
        [gallery_label,query_label] = get_WARD_labels( WARD_labels.Labels, WARD_labels.CameraLabels, camALabel, camBLabel );
        
end
end

