function [ spseg ] = get_sp( I )
%GET_SP get superpixel
%   Detailed explanation goes here
N = size(I,1);
M = size(I,2);

% Number of superpixels coarse/fine.
N_sp=40;
N_sp2=40;
% Number of eigenvectors.
N_ev=40;

% ncut parameters for superpixel computation
diag_length = sqrt(N*N + M*M);
SPpar = imncut_sp;
SPpar.int=0;
SPpar.pb_ic=1;
SPpar.sig_pb_ic=0.05;
SPpar.sig_p=ceil(diag_length/50);
SPpar.verbose=0;
SPpar.nb_r=ceil(diag_length/60);
SPpar.rep = -0.005;  % stability?  or proximity?
SPpar.sample_rate=0.2;
SPpar.nv = N_ev;
SPpar.sp = N_sp;
SPpar.sp2 = N_sp2;


fprintf('running PB\n');
[emag,ephase] = pbWrapper(I,SPpar.pb_timing);
emag = pbThicken(emag);
SPpar.pb_emag = emag;
SPpar.pb_ephase = ephase;
clear emag ephase;

% st=clock;
% fprintf('Ncutting...');
[Sp,~] = imncut_sp(I,SPpar);
% fprintf(' took %.2f minutes\n',etime(clock,st)/60);

% st=clock;
% fprintf('Fine scale superpixel computation...');
spseg = clusterLocations(Sp,ceil(N*M/SPpar.sp2));
% fprintf(' took %.2f minutes\n',etime(clock,st)/60);

end

