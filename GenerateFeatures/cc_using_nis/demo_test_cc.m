%
%
% This script will apply the learned classifier on some example images.
% Note that this script should match the training phase in all of the
% following choice:
% - The number of bins that are used to create the edge-histogram.
% - The sigma-values that are used to compute the Weibull-statistics, and
%   hence the dimensions of the features.
% - The algorithms that are considered, and hence the dimension of the
%   output of the classifier.
% - The scaling factors of the features.
% If the script "demo_train_cc.m" was used to train the classifier, then
% these parameters are saved in "classifier_from_mondrian_images.mat".
%
%

addpath('.\weibull');
addpath('.\libsvm-3.17\matlab\');

clear all;

% Load the pre-learned classifier
load('./classifier_from_mondrian_images.mat');

% filename = 'building';
% filename = 'car';
% filename = 'cow';
% filename = 'dog1';
filefolder='../datasets/VIPeRa/PPDDN_7_nohead/';
imgs=dir(fullfile(filefolder,'*.bmp'));
% MASKDIR='.\PPDDN\VIPeRa\';
% masks=dir(fullfile(MASKDIR,'*.mat'));
outdir=[filefolder 'cc_nohead/'];
mkdir(outdir);

% pwidth=60;
% pheight=160;

for i=1:length(imgs)
    filename=imgs(i).name;
    disp(filename);
    % Read a test image
    % test_image = imread(['./example_images/' filename '.jpg']);
    test_image = imread([filefolder filename]);
%     test_image=imresize(test_image,[pheight pwidth]);
%     maskmap=load(fullfile(MASKDIR,masks(i).name));%maskmap.labelmap
    
    % Proceed with the consecutive steps:
    % - Compute the Weibull-parameters for the current image.
    current_features = [];
    for current_sigma = 1:numel(considered_sigmas)
        [R_grad G_grad B_grad] = norm_derivative(im2double(test_image), considered_sigmas(current_sigma), 1);
        O1_grad = (R_grad - G_grad)./sqrt(2);
        O2_grad = (R_grad + G_grad - 2.*B_grad)./sqrt(6);
        O3_grad = (R_grad + G_grad + B_grad)./sqrt(3);
        
        [O1_values, O1_bins] = hist(O1_grad(:), nr_bins);
        [O1_beta, O1_gamma] = integWeibullMleHist(O1_bins, O1_values);
        
        [O2_values, O2_bins] = hist(O2_grad(:), nr_bins);
        [O2_beta, O2_gamma] = integWeibullMleHist(O2_bins, O2_values);
        
        [O3_values, O3_bins] = hist(O3_grad(:), nr_bins);
        [O3_beta, O3_gamma] = integWeibullMleHist(O3_bins, O3_values);
        
        current_features = [current_features O1_beta O1_gamma O2_beta O2_gamma O3_beta O3_gamma];
    end
    format short;
    % - Compute the performance of all considered algorithms on the image.
    for current_method = 1:size(considered_methods, 1)
        % Apply the current method
        [wR, wG, wB, out] = general_cc(double(test_image), considered_methods(current_method, 1), considered_methods(current_method, 2), considered_methods(current_method, 3));
        
        % Normalize the estimated illuminant
        estimated_illuminants(current_method, :) = [wR wG wB];
        estimated_illuminants(current_method, :) = estimated_illuminants(current_method, :) ./ norm(estimated_illuminants(current_method, :));
    end
    % - Scale the features
    current_features = (current_features - repmat(scale_min, [1 12])) ./ repmat(scale_max - scale_min, [1 12]);
    
    % Finally, apply the learned classifier to the current image to determine
    % the optimal algorithm...
    [out1, out2, out3] = svmpredict(1, current_features, current_classifier);
    % ... and apply this algorithm to the image to obtain the output image:
    
    test_image_corrected=uint8(zeros(size(test_image)));
    for c=1:3
        test_image_corrected(:,:,c) = test_image(:,:,c) ./ (sqrt(3)*estimated_illuminants(current_classifier.Label(out1), c));
    end
    % figure; imshow(test_image); title('Input image');
    % figure; imshow(test_image_corrected); title('Corrected image');
    
    imwrite(test_image_corrected,[outdir filename]);
end;