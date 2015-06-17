function [ I_h2sv ] = rgb2h2sv( I_rgb )
%RGB2H2SV tranform RGB image to H2SV image
%  
% Author : Qian Li
% Date : 2014.11.14

r=1;
I_hsv=rgb2hsv(I_rgb);

H=I_hsv(:,:,1);
H=H.*(2*pi);
hy=r*sin(H);
hx=r*cos(H);

%add weight to each
I_h2sv=cat(3,hx,hy,I_hsv(:,:,2),I_hsv(:,:,3));

end

