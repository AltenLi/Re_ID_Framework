function [ scores ] = calc_fisher_vector_score( query_label,gallery_label,X,param )
%CALC_FISHER_VECTOR_SCORE 
% Calculate the fisher vector feature distance & score
% Author : Qian Li
% Date : 2014.4.21
dists = sqdist(X(:,query_label), X(:,gallery_label));
scores=exp(-dists.^2./param.dist_thetaFV^2);
end

