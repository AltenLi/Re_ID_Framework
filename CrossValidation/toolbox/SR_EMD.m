function [dissimilarity]  = SR_EMD(gmm1,gmm2,Params)
% SR_EMD  [dissimilarity]  = SR_EMD(gmm1,gmm2,Params)
% computes the disimilarity between two Gaussian mixture models gmm1 and gmm2
% by sparse representation, with Params containing the parameters involved.
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

M = length(gmm1);
N = length(gmm2);

dists = zeros(M, N);

u = zeros(size(gmm1(1).mu));
if strcmp('EMD-theta', Params.DistanceType) == 1 %EMD-theta
    for i=1:M
        for j=1:N
            u = gmm1(i).mu - gmm2(j).mu;
            dists(i,j) =  (1-Params.theta)*sqrt(u' * inv(0.5*(gmm1(i).R + gmm2(j).R)) * u)  + ...
                              Params.theta *norm(gmm1(i).logR- gmm2(j).logR,'fro');
        end
    end
elseif  strcmp('EMD-M', Params.DistanceType)==1 %EMD-M
    for i=1:M
        for j=1:N
            dists(i, j) = norm(Params.M_one_half  * (gmm1(i).EM_logP - gmm2(j).EM_logP), 'fro');        
        end
    end
elseif  strcmp('EMD-logeig', Params.DistanceType)==1 %Ma
    for i=1:M
        for j=1:N
            u = gmm1(i).mu - gmm2(j).mu;
            v=log(eig(gmm1(i).R)).^2- log(eig(gmm2(j).R)).^2;
            dists(i,j) =  (1-Params.theta)*sqrt(u' * inv(0.5*(gmm1(i).R + gmm2(j).R)) * u)  + ...
                Params.theta *(v' * v);
            
        end
    end
end


y1    = zeros(M,1);
for i=1:M
    y1(i) = gmm1(i).pb;
end
y2 = zeros(N,1);
for i=1:N
    y2(i) = gmm2(i).pb;
end

if M==1&&N==1
    dissimilarity = dists(1,1);
    return;
end

[dissimilarity] = SR_EMD_opt(dists, y1, y2);

end


function [dissim] = SR_EMD_opt(dists, y1, y2)
    m = size(y2, 1);
   n = size(y1, 1);
   
   c = dists(:);

   % Build A
   A = zeros(m+n, m*n);
   ones_row = ones(1, n);
   for i=1:m
       A(i, (i-1)*n+1:i*n) = ones_row;
   end
   eye_nn = eye(n, n);
   for i=1:m
       A(m+1:m+n, (i-1)*n+1:i*n) = eye_nn;
   end
  
   % Build b
   b = zeros(m+n, 1);
   b(1:m) = y2;
   b(m+1:end) = y1;
   
   A1 = A * double(diag(1./(c+eps(1))));

    % Sparse representation
   param.lambda  = 1e-3; 
   param.lambda2 = 0.0;
   param.mode = 2;  
   param.L = length(b);
   param.pos=true;
   x = mexLasso(b, A1, param);
   dissim = norm(x, 1);
   %We can also compute dissimilarity as follows (pls refer to section 2.3 for explanation)
%    dissim = 0.5* norm(b-A1 * x, 2)^2 + param.lambda * norm(x, 1);
end












