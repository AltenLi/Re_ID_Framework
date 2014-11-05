% Maximum likelihood estimation of Weibull parameters for only positive raw data.
% To evaluate shape parameter the following equation is solved using
% Newton-Raphson method:
% n + sum(log( (x_i^shape)*n/sum(x_i^shape) )) -
% n*sum( (x_i^shape)*n/sum(x_i^shape)*log(n*(x_i^shape)/sum(x_i^shape)) ) = 0,
% where n is size of input data.
% Scale parameter is equal:
% (sum(x_i^shape)/n)^(1/shape).

function [scale shape] = integWeibullMle(data)

n = size(data, 2);
eps = 0.01; % precision of Newton-Raphson method's solution
shape = 0.1; %initial value of gamma parameter

shape_next = shape - weibullNewton(shape, data, n);
nIteration = 1; % number of iterations
while abs(shape_next - shape) > eps
    if (isnan(shape_next) || isinf(shape_next) || shape_next > 20 || nIteration > 25)
        break;
    end    
    if (shape_next <= 0)
        shape_next = 0.000001;
        break;
    end
    shape = shape_next;
    shape_next = shape - weibullNewton(shape, data, n);
    nIteration = nIteration +1;
end

shape = shape_next;
scale = (sum((data.^shape)/n))^(1/shape);

function out = weibullNewton(g, x, n)
% g: current value of shape parameter
% x: input data
% n: size of input data
format long;

x_g = x.^g;
sum_x_g = sum(x_g);
x_i = (x_g)./sum_x_g;
ln_x_i = log(n*x_i);

lambda = x_g.*(log(x).*sum_x_g - sum(x_g.*log(x)))./(sum_x_g^2);
f = n + sum(ln_x_i) - n*sum(x_i.*ln_x_i);
f_prime = sum(lambda.*(sum_x_g./x_g - n.*ln_x_i - n));

out = f./f_prime;
