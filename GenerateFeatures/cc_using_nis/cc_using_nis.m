% CC_USING_NIS: Use natural image statistics for selection of the optimal
%               color constancy algorithm, and apply this algorithm to the
%               input image. 
% 
%   The pre-learned classifier should be based on the same features as are
%   computed in this function. By default, these features are the beta and
%   gamma parameters of the Weibull-fit of the gradient-based derivative
%   (with sigma = [1, 2, 3, 5]) in the three opponent color channels O1,
%   O2 and O3, hence a 24-dimensional feature vector for every image (2
%   Weibull-parameters times 4 gradient-sigmas times 3 color channels =
%   2*4*3=24 features).
%
% SYNOPSIS:
%    [white_point, output_image] = cc_using_nis(input_data, prelearned_classifier, method_parameters, sigma_values)
%    
% INPUT:
%   INPUT_DATA is a color image of size NxMx3, with values of type double, 
%       ranging from 0 to 255.
%
%   PRELEARNED_CLASSIFIER is the classifier that is learned on separate
%       training data. This classifier should be a libsvm-structure, that
%       is learned using the Matlab-wrapper around the lib-svm packages.
%
%   METHOD_PARAMETERS is an Nx3 matrix, representing the parameters of the
%       methods that are selected to train the classifier (where N is the
%       number of methods that are currently considered). In the current
%       implementation, the parameters should correspond to values that are
%       used by the Grey-Edge framework: njet, mink_norm and sigma (in that
%       order). For more information on these parameters, please consult
%       the appropriate function and literature.
%
%   SIGMA_VALUES is an optional parameter (only used when INPUT_DATA is an
%       image), indicating which values for sigma are used to compute the
%       edge distribution (multiple values are possible). These values
%       should match the values that are used to train the classifier (by
%       default, sigma_values = [1, 2, 3, 5] is used). Note that these
%       sigma_values are completely different from and totally not related
%       to the sigma-parameter of the illuminant estimation framework. 
%
% OUTPUT:
%   WHITE_POINT is the estimated (R,G,B)-values for the color of the
%       light source. Note that only chromaticity of the light source is
%       estimated.
%
%   OUTPUT_IMAGE is the color corrected image.
%
% NOTE:
%   This function requires three external packages. These packages are
%   assumed to be available in the path during execution of this function:
%   - Lib-svm for training and testing the classifier. A Matlab interface
%     to this classifier is available at the website where libsvm can be
%     downloaded: http://www.csie.ntu.edu.tw/~cjlin/libsvm .
%   - The illuminant estimation function general_cc.m provided by Joost van
%     de Weijer, that accompanies the IEEE Transactions on Image Processing
%     paper "Edge-based Color Constancy". See http://cat.cvc.uab.es/~joost/
%     or the paper for more information.
%   - The Weibull-fit, written by Victoria Yanulevskaya, which can be
%     downloaded from: http://staff.science.uva.nl/~mark/ .
%
% LITERATURE :
%
%   A. Gijsenij and Th. Gevers
%   "Color Constancy using Natural Image Statistics and Scene Semantics"
%   IEEE Transactions on Pattern Analysis and Machine Intelligence,
%   accepted (in press), 2010.
%
%
function [white_point, output_image, predicted_label, post_probs] = cc_using_nis(input_image, prelearned_classifier, method_parameters, sigma_values, mask)


% First do some parameter checking
if (nargin < 5)
    mask = zeros(size(input_image, 1), size(input_image, 2));
end
if (nargin < 4)
    sigma_values = [1, 3];
end
if (nargin < 3)
    error('Function should be called with at least three parameters:');
    return;
end
if (~(strcmp(class(prelearned_classifier), 'struct')))
    error('The prelearned classifier should be a classifier that is learned using LIBSVM!');
    return;
end
if (size(prelearned_classifier.SVc, 2) ~= (6*numel(sigma_values)))
    error('The number of features used to learn the classifier should be the same as the number of features used to test the classifier!');
    return;
end
if (size(prelearned_classifier.nSV, 1) ~= size(method_parameters, 1))
    error('The possible methods should be identical to the methods used to train the classifier!');
    return;
end
if ((size(mask, 1) ~= size(input_image, 1)) | (size(mask, 2) ~= size(input_image, 2)))
    error(['The mask provided should be of the same dimensions as the input image: [' num2str(size(input_image, 1)) ', ' num2str(size(input_image, 2)) ']']);
end
nr_bins = 1001;

% Then process the input image and compute the features of the current
% image
current_features = []
for index = 1:numel(sigma_values)
    curr_sigma = sigma_values(index);
    
    % Compute gradient at current scale
    [R_grad G_grad B_grad] = norm_derivative(input_image, sigma_values(curr_sigma), 1);
    
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
current_features(isnan(current_features)) = eps;

% Classify image into one of the algorithms
[predicted_label, accuracy, post_probs] = svmpredict(1, current_features, current_classifier, '-b 1');
post_probs = post_probs(current_classifier.Labels);

% Apply the selected algorithm to the current image. Currently, the
% Grey-Edge framework is used, which already facilitates the estimation and
% the correction. Alternatively, other methods can be used (provided that
% these methods are used also for training the classifier).
current_parameters = method_parameters(predicted_label, :);
[white_R, white_G, white_B, output_image] = general_cc(input_image, current_parameters(1), current_parameters(2), current_parameters(3), mask);
white_point(1) = white_R;
white_point(2) = white_G;
white_point(3) = white_B;


% end