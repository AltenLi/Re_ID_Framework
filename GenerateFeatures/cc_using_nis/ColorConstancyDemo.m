% shows example of illuminant estimation based on Grey-World, Shades of
% Gray, max-RGB, and Grey-Edge algorithm
% close all;clear all;

%some example images
input_im=double(imread('D:\lqbaidu\m\datasets\VIPeRa\PPDDN_7\0361001.bmp'));
input_im2=double(imread('D:\lqbaidu\m\datasets\VIPeRa\PPDDN_7\0361002.bmp'));
% input_im=double(imread('D:\lqbaidu\m\datasets\VIPeRa\0174001.bmp'));
% input_im2=double(imread('D:\lqbaidu\m\datasets\VIPeRa\0174002.bmp'));
% input_im=double(imread('building1.jpg'));
%input_im=double(imread('cow2.jpg'));
%input_im=double(imread('dog3.jpg'));

figure(1);
subplot(1,5,1);imshow(uint8(input_im));
title('input image');

% Grey-World
[wR,wG,wB,out1]=general_cc(input_im,0,1,0);
subplot(1,5,2);imshow(uint8(out1));
title('Grey-World');

% max-RGB
[wR,wG,wB,out2]=general_cc(input_im,0,-1,0);
subplot(1,5,3);imshow(uint8(out2));
title('max-RGB');

% Shades of Grey
mink_norm=5;    % any number between 1 and infinity
[wR,wG,wB,out3]=general_cc(input_im,0,mink_norm,0);
subplot(1,5,4);imshow(uint8(out3));
title('Shades of Grey');

% Grey-Edge
mink_norm=5;    % any number between 1 and infinity
sigma=2;        % sigma 
diff_order=1;   % differentiation order (1 or 2)

[wR,wG,wB,out4]=general_cc(input_im,diff_order,mink_norm,sigma);
subplot(1,5,5);imshow(uint8(out4));
title('Grey-Edge');



figure(2);
subplot(1,5,1);imshow(uint8(input_im2));
title('input image');

% Grey-World
[wR,wG,wB,out1]=general_cc(input_im2,0,1,0);
subplot(1,5,2);imshow(uint8(out1));
title('Grey-World');

% max-RGB
[wR,wG,wB,out2]=general_cc(input_im2,0,-1,0);
subplot(1,5,3);imshow(uint8(out2));
title('max-RGB');

% Shades of Grey
mink_norm=5;    % any number between 1 and infinity
[wR,wG,wB,out3]=general_cc(input_im2,0,mink_norm,0);
subplot(1,5,4);imshow(uint8(out3));
title('Shades of Grey');

% Grey-Edge
mink_norm=5;    % any number between 1 and infinity
sigma=2;        % sigma 
diff_order=1;   % differentiation order (1 or 2)

[wR,wG,wB,out4]=general_cc(input_im2,diff_order,mink_norm,sigma);
subplot(1,5,5);imshow(uint8(out4));
title('Grey-Edge');