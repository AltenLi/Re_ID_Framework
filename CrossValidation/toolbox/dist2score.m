function [ score ] = dist2score( dist ,theta)
%DIST_SCORE calc the score of the dist
% Author : Qian Li
% Date : 2014.4.21
theta2=max(dist(:))/theta;
score=exp(-dist.^2./theta2^2);

end

