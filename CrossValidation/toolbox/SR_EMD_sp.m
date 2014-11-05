function [dissimilarity]  = SR_EMD_sp(gmm1,gmm2,Params)
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
if strcmp('EMD-theta', Params.DistanceType) == 1 %EMD-theta
    for i=1:M
        for j=1:N
%             %skip empty
%             if gmm1(i).mu(1)<0 || gmm2(i).mu(1)<0
%                 dists(i,j) =  Params.spDistMax;
%                 continue;
%             end
            u = gmm1(i).mu - gmm2(j).mu;
            if Params.UseY && abs(u(Params.YFpos))> Params.yth % y
                dists(i,j) =  Params.spDistMax;
            else
                dists(i,j) =  (1-Params.theta)*sqrt(u' * inv(0.5*(gmm1(i).R + gmm2(j).R)) * u)  + ...
                    Params.theta *norm(gmm1(i).logR- gmm2(j).logR,'fro');
            end
        end
    end
elseif  strcmp('EMD-M', Params.DistanceType)==1 %EMD-M
    for i=1:M
        for j=1:N
%             %skip empty
%             if gmm1(i).mu(4)<0 || gmm2(i).mu(4)<0
%                 dists(i,j) =  Params.spDistMax;
%                 continue;
%             end
            u = gmm1(i).mu - gmm2(j).mu;
            if Params.UseY && abs(u(Params.YFpos))> Params.yth % y
                dists(i,j) =  Params.spDistMax;
            else
                dists(i, j) = norm(Params.M_one_half  * (gmm1(i).EM_logP - gmm2(j).EM_logP), 'fro');
            end
        end
    end
end
if M==1&&N==1
    dissimilarity = dists(1,1);
    return;
end

mindist=min(dists,[],2);
dissimilarity=sum(mindist);
end








