function [Ix,Iy] = grad1up(I)
% ����һ��ͼ���7ά����
% Input:
%       I, ͼ�������ļ���Ϊ[height, width]�ľ���
% Output:
%       newI: ��ͼ����ȡ������
% * ��ǰ�汾��1.0
% * ��    �ߣ������
% * ������ڣ�2012��05��03��
%I = mat2gray(I);
d = [1 -1];
dI = double(I);

% Ix, Iy, Ixx, Iyy
Ix = conv2(d, dI);
Ix = Ix(:, 1:end-1);
Iy = conv2(d,1,dI);
Iy = Iy(1:end-1,:);
return;
