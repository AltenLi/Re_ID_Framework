function [ paramALL, paramHist ] = getHist( paramALL )
%GETHIST Summary of this function goes here
%   Detailed explanation goes here

paramHist.sub_width = 12 ; 
paramHist.sub_height = 16;
paramHist.step_width = 6;
paramHist.step_height = 16;
paramHist.nbins = 8;
paramHist.UseMask = 0;%Use DDN Mask
paramHist.dist_theta = 2.2; %Used in dist2score


if paramHist.UseMask==0
    paramHist.featureName=[paramALL.Dataset '_HIST_SUB' num2str(paramHist.sub_width) 'X' num2str(paramHist.sub_height) '_STEP' num2str(paramHist.step_width) 'X' num2str(paramHist.step_height) '_BIN' num2str(paramHist.nbins)];    
else
    paramHist.featureName=[paramALL.Dataset '_HIST_DDN_SUB' num2str(paramHist.sub_width) 'X' num2str(paramHist.sub_height) '_STEP' num2str(paramHist.step_width) 'X' num2str(paramHist.step_height) '_BIN' num2str(paramHist.nbins)];    
end
paramHist.featureFileName=fullfile(paramALL.DIR.FeatureDIR,[paramHist.featureName '.mat']);

%% Get Mask
if paramHist.UseMask==1
    paramALL = setDDNMasks( paramALL );
end

%% Get Feature & Models
fprintf('------------------------------------------------------------------------------------------\n');
fprintf('Extracting pixel descriptors: \n');
start_time = round(clock);

%skip check
if (paramALL.CanSkipFeature && paramALL.CanSkipModel) ...
        && (length(dir(fullfile(paramALL.DIR.ModelDIR, '*.mat')))==paramALL.Imgcount ...
        || length(dir(fullfile(paramALL.DIR.ModelDIR, '*.mat')))==paramALL.Imgcount*2)
    disp(['Feature and model build Skipped']);
else
    fprintf('Building image models --Processing \n');
    get_hist_feature(paramALL, paramHist);
end


end_time = round(clock);
time_elapsed = end_time - start_time;
fprintf('Time elapsed is : %d hours %d minutes %d seconds\n',  time_elapsed(4), time_elapsed(5), time_elapsed(6));

end

