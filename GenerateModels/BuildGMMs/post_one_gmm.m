function [omtr]=post_one_gmm(omtr)
% post_one_gmm(omtr) computes the logarithms of the covariance matrix and 
% embedding symmetric positive definte matrix (SPD) of each component
% Gaussian in a  Gaussian mixture model (GMM)
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

one_gmm = omtr.cluster;

my_eps = eps(1/2);

dim = omtr.M;
G   = ones(dim+1);
for i = 1 : omtr.K
    [U S V] = svd(one_gmm(i).R);
    one_gmm(i).logR = U *  diag(log(diag(S) + my_eps)) * V';

    G(1:dim, 1:dim) = one_gmm(i).R + one_gmm(i).mu * one_gmm(i).mu';
    G(dim+1, 1:dim) = one_gmm(i).mu';
    G(1:dim, dim+1) = one_gmm(i).mu;
    G(dim+1, dim+1) = 1;
    
    const = det(G)^(-1/(dim+1));
    G =  const.*G;
            
    [U S V] =svd(G);
    one_gmm(i).EM_logP =  U *  diag(log(diag(S) + my_eps)) * V';
end

omtr.cluster = one_gmm;

end