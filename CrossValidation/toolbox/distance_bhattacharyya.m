function [HistDist] = distance_bhattacharyya(P, Q) 
%[HistDist] = distance_bhattacharyya(P, Q) 
% 
% INPUTS: 
%   P, Q - hist
% 
% OUTPUTS: 
%   HistDist - Bhattacharyya similarity 
P=P./sum(P);
Q=Q./sum(Q);
BC = sum(sqrt(P.*Q));
HistDist=-log(BC);
