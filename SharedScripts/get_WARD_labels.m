function [ S1,S2 ] = get_WARD_labels( labels, camLabels, camALabel, camBLabel )
%GET_DATASET_LABELS Get dataset WARD labels
% Author : Qian Li
% Date : 2014.11.5
PersonID = bpmacoutvector(labels);
PersonNum = length(PersonID);
S1 = [];
S2 = [];
for i=1:PersonNum
    index_temp = find(labels == PersonID(i));
    if camALabel == camBLabel
        if length(index_temp) > 1
            in = randperm(length(index_temp));
            S1 = [S1; index_temp(in(1))];
            S2 = [S2; index_temp(in(2))];
        end
    else
        index_tempA = index_temp(camLabels(index_temp) == camALabel);
        if length(index_tempA) > 1
            in = randperm(length(index_tempA));
            S1 = [S1; index_tempA(in(1))];
        end
        index_tempB = index_temp(camLabels(index_temp) == camBLabel);
        if length(index_tempB) > 1
            in = randperm(length(index_tempB));
            S2 = [S2; index_tempB(in(1))];
        end
    end
end

end

