% Maximum likelihood estimation of parameters for Weibull data.
% Function fits a integrated Weibull distribution to a Gaussian derivative
% response in x or y direction with sigma equals 3 of gray-scale image or patch of image.
% Scale and shape parameters are fitted with the maximum likelihood framework,
% and location parameter is approximated with median value of data
% As inputs the following variables have to be transferred:
% data        : 2-dimensional matrix with gray-scale image,
%               can be obtained as
%               data = im2double(rgb2gray(imread(image_file_name)));
% direction:  : direction of Gaussian derivative, acceptable values
%               are 'x' and 'y'.
% useHist     : boolean variable to set of using histogram of input
%               data for MLE of parameters or raw data. Possible values
%               are 0 - raw data; 1 - histogram of data. In histogram case
%               number of bins equal to 1001. 
% doPlot      : boolean variable to visualize the results
% Return values are scale, shape and location parametes of fitted
% integrated Weibull distribution.
% Example of use:
% [scale shape location] = weibullMle(data, 'x', 1, 1);
function [scale shape location] = integWeibullMle(im, direction, useHist, doPlot)

sigma = 3; % sigma value for Gaussian derivative
gaussDerivative = gaussianFilter(im, direction, sigma);
data = gaussDerivative(:)';
location = median(data);
data = data - location;

if (useHist)
    %   build histogram for increasing calculation speed
    nBins = 1001; % number of bins in histogram
    [ax h] = createHist(data, nBins);
    [scale shape] = integWeibullMleHist(ax, h);
else
    [scale shape] = integWeibullMleRaw(data);
end

% plotting *******************************************
if (doPlot)
    % build histogram if it doesn't exist yet
    figure;
    % build histogram for visualization, here number of bins is
    % independent on nBins

    numBins = 1000;
    delta = (max(data) - min(data))/numBins;
    range = (min(data) : delta : max(data));
    visualizationHist = hist(data, range); % now we allow zero bins in histogram
    % histogram normalization
    visualizationHist = visualizationHist./sum(visualizationHist.*delta);

    % calculate pdf with estimated parameters
    weibullPdf = integWeibullPdf(scale, shape, range);

    subplot(2,2,[1 2])
    colormap(gray);
    imagesc(im);
    title('Input image');
    
    subplot(2,2,3)
    colormap(gray);
    imagesc(gaussDerivative);
    title('Gaussian derivative of input image');

    subplot(2,2,4)
    plot(range, visualizationHist, 'r', range, weibullPdf, 'k')
    title('Normalized histogram (red) and PDF with estimated params (black)');
end
% plotting *******************************************

function [ax h] = createHist(data, hBins)

iBin = [1:hBins];
h = hist(data, hBins);
% value of the difference between bins
delta = (max(data) - min(data))/(hBins);
ax = ((min(data) + iBin.*delta) + (min(data) + (iBin-1).*delta))/2;

%skip all values, which are not presented in histogram
ind = find(h);
h = h(ind);
ax = ax(ind);






