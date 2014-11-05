function [ S1,S2 ] = get_dataset_labels( labels )
%GET_DATASET_LABELS Get dataset's labels
% Author : Qian Li
% Date : 2014.4.21
PersonID = bpmacoutvector(labels);
PersonNum = length(PersonID);
S1 = [];
S2 = [];
for i=1:PersonNum
    index_temp = find(labels == PersonID(i));
    if length(index_temp) > 1
        in = randperm(length(index_temp));
        S1 = [S1; index_temp(in(1))];
        S2 = [S2; index_temp(in(2))];
    end
end

end

