load('ETHZ2.mat');
ped=struct();
person_ids=unique(Labels);
for i=1:length(person_ids)
    list=find(Labels==person_ids(i));
    perm=randperm(length(list));
    ped(i).dynmodels=list(perm);
    ped(i).rnddd=1:length(ped(i).dynmodels);
end
save('DynPedsModel_ETHZ2.mat','ped');