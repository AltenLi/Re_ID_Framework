function [sorted_element, element_count] = bpmacoutvector(in)
%计算输入向量的不同值的标号，及其个数
%Input:
%     in: 为一输入的向量，
% output：
%      sortted_element:将in中的不相同的值进行排序
%      element_count：对应于sortted_element中的元素的在in中的个数

% * 当前版本：1.0
% * 作    者：马丙鹏
% * 完成日期：2005年01月11日
 

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
