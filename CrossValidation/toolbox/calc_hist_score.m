function [neighborIds,neighborScores,neighborDistances]  = calc_hist_score(querymodels, gallerymodels, dist_theta)
% calc_hist_score
%
% Author : Qian Li
% Date : 2014.4.21

numGalleryVectors = length(gallerymodels);
numQueryVectors = length(querymodels);

dist = zeros(numQueryVectors,numGalleryVectors);
for i=1:numQueryVectors
    for j=1:numGalleryVectors
        dist(i,j) = distance_euc(querymodels{i}.features, gallerymodels{j}.features);
    end
end

scores=dist2score(dist,dist_theta);
[~,sortpos] = sort(scores,2,'descend');%���в�ͳ��ÿһ����M�ϵľ��룬idx��¼ԭ���

neighborIds = sortpos;
neighborScores = scores;
neighborDistances =dist;
end
