I=imread(fullfile('..\..\datasets\VIPeR','0001001.bmp'));

gridSpacing = 1;
patchSize = 8;

[siftarr gridX gridY] = sp_dense_sift(I, gridSpacing,  patchSize);
