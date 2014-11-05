function [mask,body_parts,feature_parts]=maskMat(maskmap)
%maskMat get labels from single MAT file 

mlabel=unique(maskmap(:));
body_parts=length(mlabel);
mask=cell(body_parts,1);
for i=1:body_parts
    mask{i}=maskmap==mlabel(i);
end
feature_parts=1:body_parts;

end

