function [ Sp2 ] = GetSP( I,par )
%GET_SP Summary of this function goes here
%   Detailed explanation goes here
% Intervening contour using mfm-pb
N = size(I,1);
M = size(I,2);
        
fprintf('running PB\n');
[emag,ephase] = pbWrapper(I,par.pb_timing);
emag = pbThicken(emag);
par.pb_emag = emag;
par.pb_ephase = ephase;
clear emag ephase;

% st=clock;
% fprintf('Ncutting...');
[Sp,~] = imncut_sp(I,par);
% fprintf(' took %.2f minutes\n',etime(clock,st)/60);

% st=clock;
% fprintf('Fine scale superpixel computation...');
Sp2 = clusterLocations(Sp,ceil(N*M/par.sp2));
% fprintf(' took %.2f minutes\n',etime(clock,st)/60);

end

