%
%
% This script will learn the classifier, that is necessary for the function
% cc_using_nis to determine the optimal algorithm given an unseen input
% image [1]. This script will compute the natural image statistics of the
% gradient at scales 1, 2, 3 and 5 of the opponent color space. The
% training images that are used are synthetically generated Mondrian-like
% images using the hyperspectral data that is provided by Barnard et al.
% [2]. This classifier can be used on the SFU Grey-ball set [3] to obtain
% the performance that is reported in [1]. 
%
% For more accurate performance, the classifier must be learned using
% images that contain a wide variety of natural image statistcs, like
% indoor and outdoor scenes, street views, coast scenes, close-ups of
% objects/persons, buildings, etc. Also, all images that are used to learn
% the classifier must be images of which the ground truth is known (as the
% performance of all considered algorithms on the input images is necessary
% for the classifier to learn the optimal algorithm given a specific set of
% image statistics). The color constancy methods are taken from the
% Grey-Edge framework [4] and every method is represented by 3 parameters:
% njet, minkowski-norm and sigma (in that order). For more information on
% the Grey-Edge and its parameters, please refer to [4].
%
% Ideally, the classifier should be learned independently of the test data
% (for instance, using artificially created Mondrian-like images with a
% wide range of statistics). However, since data with ground truth is
% rather sparse, what is often done is to learn the classifier on a subset
% of the test data, in a fasion similar to cross-validation. This involves
% the following steps: divide the data set in N parts, learn the classifier
% using (N-1) parts and test the method on the remaining part. This process
% is then repeated N times to obtain an estimate for every image in the
% data set. If the different folds are selected randomly, then the
% cross-validation should be repeated a number of times to ensure that the
% random selection of folds did not accidentally result in an extremely
% positive or negative division. Finally, note that if the often used
% Grey-Ball data set [3] is used for evaluation, then the folds are not
% selected "at random" because of the existing correlation between the
% images. For this data set, 15 fixed folds can be selected, where every
% fold represents one video clip of the data set (as the data set consists
% of 15 different clips). 
% 
% 
% LITERATURE:
% [1] Gijsenij, A., & Gevers, Th. (2010). Color Constancy using Natural
%     Image Statistics and Scene Semantics, accepted for publication in
%     IEEE Transactions on Pattern Analysis and Machine Intelligence.
% [2] Barnard, K., Martin, L., Funt, B.V., & Coath, A. (2002). A Data Set
%     for Color Research. Color Research and Application: 27(3), pp.
%     148-152.
% [3] Ciurea, F., & Funt, B. (2003). A Large Image Database for Color
%     Constancy Research. In Proceedings of the eleventh Color Imaging
%     Conference (pp. 160-164).
% [4] van de Weijer, J., Gevers, Th., & Gijsenij, A. (2007). Edge-based
%     Color Constancy, IEEE Transactions on Image Processing: 16(9), pp.
%     2207-2214.
%
%
addpath('.\weibull');
addpath('.\libsvm-3.17\matlab\');

disp(' ');
disp(' ');
disp('This example script demonstrates how the classifier can be');
disp('learned. Note that this involves estimating the illuminant using');
disp('all of the considered algorithms, computing the Weibull statistics');
disp('and training the classifier. This could take a while...');
disp(' ');
disp('Strike a key to continue...');
disp(' ');
disp(' ');
disp(' ');
pause;


% Specify the name of the file with references to training images. This
% file also contains the chromaticity value of the light source. Only
% images with known illuminant can be used for training the classifier!
% Line i of this input file contains the image name, line i+1 contains the
% color of the light source.  
textfile_with_image_names = 'training_images.lst';

% Open the file with image names
fid = fopen(textfile_with_image_names, 'r');
if(fid<0) 
    display('cannot find file');
    return;
end

% These values determines the size of the smoothing filter that is used to 
% compute the gradient. Thes values should be identical to the values
% that are used when applying the classifier!
considered_sigmas = [1, 2, 3, 5];

% These parameters represent the considered algorithms: [njet, norm, sigma]
considered_methods(1, :) = [0, 1, 3]; % 0th-order method: Shades-of-Grey
considered_methods(2, :) = [1, 2, 1]; % 1st-order method: Grey-Edge
considered_methods(3, :) = [2, 1, 2]; % 2nd-order method: 2nd Grey-Edge

disp('Looping over the training images and computing the features and the performance of the considered algorithms...');
image_id = 0;
nr_bins = 1001;
while (~feof(fid))
    image_id = image_id + 1;
    disp(['  -> Image ' num2str(image_id)]);
    
    % First read the image name
    current_image_name = fgetl(fid);
    % Then read the color of the light source
    current_illuminant = sscanf(fgetl(fid), '%f');
    current_illuminant = current_illuminant ./ norm(current_illuminant);
    
    % Now read the image from disk
    current_image = imread(current_image_name);  
    
    % Compute the Weibull-parameters
    current_features = [];
    for current_sigma = 1:numel(considered_sigmas)
        % Compute gradient at current scale
        [R_grad G_grad B_grad] = norm_derivative(im2double(current_image), considered_sigmas(current_sigma), 1);
%         [O1_grad O2_grad O3_grad] = opponent_color_gradient(im2double(current_image), considered_sigmas(current_sigma));
        
        % Convert to opponent color space O1O2O3
        O1_grad = (R_grad - G_grad)./sqrt(2);
        O2_grad = (R_grad + G_grad - 2.*B_grad)./sqrt(6);
        O3_grad = (R_grad + G_grad + B_grad)./sqrt(3);

        % Compute Weibull parameters
        [O1_values, O1_bins] = hist(O1_grad(:), nr_bins);
        [O1_beta, O1_gamma] = integWeibullMleHist(O1_bins, O1_values);

        [O2_values, O2_bins] = hist(O2_grad(:), nr_bins);
        [O2_beta, O2_gamma] = integWeibullMleHist(O2_bins, O2_values);

        [O3_values, O3_bins] = hist(O3_grad(:), nr_bins);
        [O3_beta, O3_gamma] = integWeibullMleHist(O3_bins, O3_values);

        current_features = [current_features O1_beta O1_gamma O2_beta O2_gamma O3_beta O3_gamma];
    end
    % Store the computed features with all other features in a matrix
    all_train_features(image_id, :) = current_features;
%     all_train_features = (all_train_features - repmat(min(all_train_features), [310, 1]))./repmat(max(all_train_features)-min(all_train_features), [310, 1]);
    
    % Now compute the performance of all considered algorithms on the
    % current image. The angular error is used as performance measure.
    current_errors = [];
    for current_method = 1:size(considered_methods, 1)
        % Apply the current method
        [wR wG wB out] = general_cc(double(current_image), considered_methods(current_method, 1), considered_methods(current_method, 2), considered_methods(current_method, 3));
        
        % Normalize the estimated illuminant
        estimated_illuminant = [wR wG wB];
        estimated_illuminant = estimated_illuminant ./ norm(estimated_illuminant);
        
        % Compute the error by comparing with the provided ground truth.
        % Note that the ground truth of the default images in this script
        % are set to a random value, and are actually unknown! These images
        % are merely used for demonstration.
        current_errors = [current_errors acos(estimated_illuminant * current_illuminant) * (180/pi)];
    end
    % Store the computed errors into one matrix
    all_train_errors(image_id, :) = current_errors;
end
fclose(fid);
format short;
all_train_features(isnan(all_train_features)) = eps;

% Scale features so that the approximate range is [0 1] for both beta and
% gamma. Since the values for beta and gamma are unconstrained, this
% scaling is merely approximate.
scale_min = [0 0];
scale_max = [0.05 4];
all_train_features = (all_train_features - repmat(scale_min, [310, 12]))./repmat(scale_max - scale_min, [310, 12]);

disp('Done! Now computing the classifier...');
% Any other classifier could be used, but for compatibility with the
% function cc_using_nis, the SVM (using the Matlab-wrapper of lib-svm)
% should be used.
curr_gamma = 0.2;
curr_C = 100;

[min_errors train_labels] = min(all_train_errors, [], 2);
current_classifier = svmtrain(train_labels, all_train_features, ['-s 0 -t 2 -g ' num2str(curr_gamma) ' -c ' num2str(curr_C)]);

disp('Done! Now storing the classifier to disk for possible later use...');
% Also store the computed data, so that it can be used at another time (for
% instance to try different classifiers or different parameters).
save('classifier_from_mondrian_images.mat', 'current_classifier', 'considered_sigmas', 'considered_methods', 'all_train_features', 'all_train_errors', 'scale_min', 'scale_max', 'nr_bins');

clear *grad *bins *gamma *beta *values current_features current_illuminant current_image current_image_name current_method current_sigma current_errors estimated_illuminant wR wG wB textfile_with_image_names out image_id fid;

disp('Done! The classifier and the data are stored in the file "classifier_from_mondrian_images.mat"');
disp(' ');
disp(' ');
disp(' ');





