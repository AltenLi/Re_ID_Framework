function [ siftarr, gridX, gridY ] = get_sift_feature( I )
%GET_SIFT_FEATURE Summary of this function goes here
%   Detailed explanation goes here
[siftarr, gridX, gridY] = sp_dense_sift(I, 1,  8);

end

