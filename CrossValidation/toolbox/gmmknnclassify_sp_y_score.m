function [neighborIds,neighborScores,neighborDistances]  = gmmknnclassify_sp_y_score(querymodels, gallerymodels, cur_part, SR_EMD_para, useFLIP)
% gmmknnclassify
%
% Please cite the following paper if you use the code:
%
% Peihua Li,  Qilong Wang, Lei Zhang. A Novel Earth Mover's Distance Methodology for Image Matching with
%Gaussian Mixture Models. IEEE Int. Conf. on Computer Vision (ICCV), 2013.
%
% For questions,  please conact:  Qilong Wang  (Email:  wangqilong.415@163.com),
%                                               Peihua  Li (Email: peihuali at dlut dot edu dot cn)
%                                               Lei zhang (Email: cslzhang  at comp dot polyu dot edu dot hk)
%
% The software is provided ''as is'' and without warranty of any kind,
% experess, implied or otherwise, including without limitation, any
% warranty of merchantability or fitness for a particular purpose.

numGalleryVectors = length(gallerymodels);
numQueryVectors = length(querymodels);

if ~useFLIP
    dist = zeros(numQueryVectors,numGalleryVectors);
    for i=1:numQueryVectors
        for j=1:numGalleryVectors
            k=cur_part;%calc cur_part distance
            dist(i,j) = SR_EMD_sp(querymodels{i}.features{k}, gallerymodels{j}.features{k},  SR_EMD_para);
        end
    end
    
else
    dist = zeros(numQueryVectors/2,numGalleryVectors/2);
    for i=1:numQueryVectors/2
        for j=1:numGalleryVectors/2
            k=cur_part;%calc cur_part distance
            tmpdist=ones(1,4);
            tmpdist(1)=SR_EMD_sp(querymodels{i}.features{k},                                  gallerymodels{j}.features{k},  SR_EMD_para);
            tmpdist(2)=SR_EMD_sp(querymodels{i+numQueryVectors/2}.features{k}, gallerymodels{j}.features{k},  SR_EMD_para);
            tmpdist(3)=SR_EMD_sp(querymodels{i}.features{k},                                  gallerymodels{j+numGalleryVectors/2}.features{k},  SR_EMD_para);
            tmpdist(4)=SR_EMD_sp(querymodels{i+numQueryVectors/2}.features{k}, gallerymodels{j+numGalleryVectors/2}.features{k},  SR_EMD_para);
            dist(i,j) = min(tmpdist(:));
        end
    end
    
end
scores=dist2score(dist,SR_EMD_para.dist_theta);
[~,sortpos] = sort(scores,2,'descend');%排列并统计每一对在M上的距离，idx记录原标号

neighborIds = sortpos;
neighborScores = scores;
neighborDistances =dist;
end
