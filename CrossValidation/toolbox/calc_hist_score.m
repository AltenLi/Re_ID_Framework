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
[~,sortpos] = sort(scores,2,'descend');%排列并统计每一对在M上的距离，idx记录原标号

neighborIds = sortpos;
neighborScores = scores;
neighborDistances =dist;
end
