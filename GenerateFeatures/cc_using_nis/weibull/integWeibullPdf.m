% Weibull probability density function for given scale and shape parameters
% calculated for points.

function weibulPdf = intWeibullPdf(scale, shape, points)

weibulPdf = (shape/(2*(shape^(1/shape))*scale*gamma(1/shape))).* ...
            exp(- (1/shape)*(abs(points./scale).^shape));

