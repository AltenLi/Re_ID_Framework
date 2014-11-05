% Maximum likelihood estimation of Weibull parameters for raw data.
% Function fits to integrated Weibull distribution positive data. 
% To evaluate shape parameter the following equation is solved using
% Newton-Raphson method:
% 1 + (1/shape)*log(shape) + (1/shape)*diGamma(1/shape) - 
% - (1/shape)* sum( |x_i^shape/sum(x_i^shape)|*
%   log(|n*x_i^shape/sum(x_i^shape)|) ) = 0,
% where n is size of input data.
% Scale parameter is equal:
% (sum(x_i^shape)/n)^(1/shape).
function [scale shape] = integWeibullMle(data)

data = data + 0.00001; %replace 0 with small number

n = size(data, 2);
eps = 0.01; % precision of Newton-Raphson method's solution
shape = 0.01; %initial value of gamma parameter

shape_next = shape - integWeibullNewton(shape, data, n);
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
    shape_next = shape - integWeibullNewton(shape, data, n);
    nIteration = nIteration +1;
end

shape = shape_next;
scale = abs((sum(abs(data.^shape)/n))^(1/shape));

function out = integWeibullNewton(g, x, n)
% g: current value of shape parameter
% x: input data
% n: size of input data
format long;

x_g = abs(x.^g);
sum_x_g = sum(x_g);
x_i = abs((x_g)./sum_x_g);
ln_x_i = log(n*x_i);

lambda = x_g.*(log(abs(x)).*sum_x_g - sum(x_g.*log(abs(x))))./(sum_x_g^2);
f = 1 + (log(g))/(g) + (1/(g))*psi(1/g) - (1/(g))*sum(x_i.*ln_x_i);
f_prime = 1/(g^2)*(1 - log(g) - psi(1/g) - psi(1, (1/g))*(1/g) + sum(x_i.*ln_x_i)) - (1/g)*(sum(lambda.*(1 + ln_x_i)));

out = f./f_prime;
