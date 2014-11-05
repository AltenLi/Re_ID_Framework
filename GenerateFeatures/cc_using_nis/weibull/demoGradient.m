im =  im2double(rgb2gray (imread('pic.jpg')));

fprintf('Estimated parameters of Weibull distribution:\n');
[scaleHist shapeHist locationHist] = weibullMle(im, 1, 1); % for histogram
fprintf('scale = %g, shape = %g, location = %g for histogram of data\n', scaleHist, shapeHist, locationHist);
[scale shape location] = weibullMle(im, 0, 1); % for raw data 
fprintf('scale = %g, shape = %g, location = %g for raw data\n', scale, shape, location);