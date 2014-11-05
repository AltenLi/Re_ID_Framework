function [mask,body_parts,feature_parts]=maskWhole(maskmap)
%maskWhole get all body parts into mask{1}

body_parts=1;
mask=cell(body_parts,1);
mask{1}=maskmap==30 | maskmap==51|...
    maskmap==10 | maskmap==20|...
    maskmap==40 | maskmap==61;
feature_parts=1:body_parts;

end

