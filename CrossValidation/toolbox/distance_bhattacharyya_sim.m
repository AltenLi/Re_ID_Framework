function [HistDistSim] = distance_bhattacharyya_sim(P, Q) 
%[HistDistSim] = distance_bhattacharyya_sim(P, Q) 
% 
% INPUTS: 
%   P, Q - hist
% 
% OUTPUTS: 
%   HistDist - Bhattacharyya similarity 

Sum1=sum(P);Sum2=sum(Q);
Sumup = sqrt(P.*Q);
SumDown = sqrt(Sum1*Sum2);
Sumup = sum(Sumup);
HistDistSim=1-sqrt(1-Sumup/SumDown);
