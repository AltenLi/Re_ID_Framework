function [Ix,Iy] = grad1up(I)
% 计算一幅图像的7维特征
% Input:
%       I, 图像数据文件，为[height, width]的矩阵
% Output:
%       newI: 对图像提取的特征
% * 当前版本：1.0
% * 作    者：马丙鹏
% * 完成日期：2012年05月03日
%I = mat2gray(I);
d = [1 -1];
dI = double(I);

% Ix, Iy, Ixx, Iyy
Ix = conv2(d, dI);
Ix = Ix(:, 1:end-1);
Iy = conv2(d,1,dI);
Iy = Iy(1:end-1,:);
return;
