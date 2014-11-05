function [ btimg,wR,wG,wB ] = balance_temperature( maskedimg )
%BALANCE_TEMPERATURE Balance the temperatur of each img
% Author : Qian Li
% Date : 2014.4.21
img_1=maskedimg(:,1);
img_2=maskedimg(:,2);
img_3=maskedimg(:,3);

Rave=mean(mean(img_1));
Gave=mean(mean(img_2));
Bave=mean(mean(img_3));

Kave=100;
wR=Kave/Rave;
wG=Kave/Gave;
wB=Kave/Bave;
img__1=wR*img_1;img__2=wG*img_2;img__3=wB*img_3;

btimg=cat(2,img__1,img__2,img__3);

end

