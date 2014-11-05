function [sorted_element, element_count] = bpmacoutvector(in)
%�������������Ĳ�ֵͬ�ı�ţ��������
%Input:
%     in: Ϊһ�����������
% output��
%      sortted_element:��in�еĲ���ͬ��ֵ��������
%      element_count����Ӧ��sortted_element�е�Ԫ�ص���in�еĸ���

% * ��ǰ�汾��1.0
% * ��    �ߣ������
% * ������ڣ�2005��01��11��
 

if nargin==0, selfdemo; return, end

[m,n] = size(in);
in1 = sort(in(:)');
in1 = [in1 in1(length(in1))+1];
index = find(diff(in1) ~= 0);
sorted_element = in1(index);
element_count = diff([0, index]);
if n == 1,
	sorted_element = sorted_element';
	element_count = element_count';
end

% ====== Self demo ======
function selfdemo
in = [5 3 3 2 1 5 5 3 4 7 20 20 20];
fprintf('The input vector "in" is\n');
for i = 1:length(in),
	fprintf('%g ', in(i));
end
fprintf('\n\n"[sorted_element, element_count] = countele(in)" produces the following output:\n');
[sorted_element, element_count] = countele(in)
