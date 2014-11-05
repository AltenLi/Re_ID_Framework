function [mask,body_parts,feature_parts]=maskDDN(maskmap)
%maskDDN get all body parts from DDN mask
%
% "Hair" = 10,
% "Face" = 20,
% "UpperClothes" = 30,
% "LowerClothes" = 40,
% "LeftArm" = 51,
% "LeftLeg" = 61,
% "LeftShoes" = 63,

body_parts=7;
mask=cell(body_parts,1);
maskup=maskmap==30 | maskmap==51;
maskdown=maskmap==40 | maskmap==61;
for j=1:body_parts
    if j<3%UpperClothes LeftArm
        [r,~]=find(maskup);
        y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
        mask{j}=zeros(size(maskup));
    end
    if j==4 || j==5%LowerClothes LeftLeg
        [r,~]=find(maskdown);
        y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
        mask{j}=zeros(size(maskdown));
    end
    switch j
        case 1%UpperClothes LeftArm1
            mask{j}(y1:ymid,:)=maskup(y1:ymid,:);
        case 2%UpperClothes LeftArm2
            mask{j}(ymid:y2,:)=maskup(ymid:y2,:);
        case 3%UpperClothes LeftArm whole
            mask{j}=maskmap==30 | maskmap==51;
            
        case 4%LowerClothes LeftLeg1
            mask{j}(y1:ymid,:)=maskdown(y1:ymid,:);
        case 5%LowerClothes LeftLeg2
            mask{j}(ymid:y2,:)=maskdown(ymid:y2,:);
        case 6%LowerClothes LeftLeg whole
            mask{j}=maskmap==40 | maskmap==61;
            
        case 7%Hair Face
            mask{j}=maskmap==10 | maskmap==20;
    end
end
feature_parts=1:body_parts;

end

