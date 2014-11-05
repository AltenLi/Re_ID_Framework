% Weibull probability density function for given scale and shape parameters
% calculated for points.

function weibulPdf = weibullPdf(scale, shape, points)

weibulPdf = (shape/scale).*(points./scale).^(shape-1).* ...
             exp(- (points./scale).^shape);

