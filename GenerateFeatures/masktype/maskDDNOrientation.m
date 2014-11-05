function [mask,body_parts,feature_parts]=maskDDNOrientation(maskmap,orientation)
%maskDDNOrientation get all body parts from DDN mask and orientation
%
% "Hair" = 10,
% "Face" = 20,
% "UpperClothes" = 30,
% "LowerClothes" = 40,
% "LeftArm" = 51,
% "LeftLeg" = 61,
% "LeftShoes" = 63,

body_parts=11;
mask=cell(body_parts,1);

maskupfront= maskmap==30 | maskmap==51;
maskupback = maskmap==30 | maskmap==51;
[~,c]=find(maskupfront);
x1=min(c);x2=max(c);
xd1=round(x1+(x2-x1)/4);xd2=round(x2-(x2-x1)/4);xmid=round(x2-(x2-x1)/2);
switch orientation
    case 1
        maskupback(:,xd1:xd2)=0;
    case 2
        maskupfront(:,x1:xd1)=0;
        maskupback(:,xmid:x2)=0;
    case 3
        maskupfront(:,x1:xd1)=0;
        maskupback(:,xmid:x2)=0;
    case 4
        maskupfront(:,x1:xd2)=0;
        maskupback(:,xd2:x2)=0;
    case 5
        maskupfront(:,xd1:xd2)=0;
    case 6
        maskupfront(:,xmid:x2)=0;
        maskupback(:,x1:xd1)=0;
    case 7
        maskupfront(:,xmid:x2)=0;
        maskupback(:,x1:xd1)=0;
    case 8
        maskupfront(:,xd2:x2)=0;
        maskupback(:,x1:xd2)=0;
end

maskdown=maskmap==40 | maskmap==61;
for j=1:body_parts
    if j<3%UpperClothes LeftArm
        [r,~]=find(maskupfront);
        y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
        mask{j}=zeros(size(maskupfront));
    end
    if j==9||j==10%UpperClothes LeftArm
        [r,~]=find(maskupback);
        y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
        mask{j}=zeros(size(maskupback));
    end
    if j==4 || j==5%LowerClothes LeftLeg
        [r,~]=find(maskdown);
        y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
        mask{j}=zeros(size(maskdown));
    end
    switch j
        case 1%UpperClothes LeftArm1
            mask{j}(y1:ymid,:)=maskupfront(y1:ymid,:);
        case 2%UpperClothes LeftArm2
            mask{j}(ymid:y2,:)=maskupfront(ymid:y2,:);
        case 3%UpperClothes LeftArm whole
            mask{j}=maskupfront;
            
        case 4%LowerClothes LeftLeg1
            mask{j}(y1:ymid,:)=maskdown(y1:ymid,:);
        case 5%LowerClothes LeftLeg2
            mask{j}(ymid:y2,:)=maskdown(ymid:y2,:);
        case 6%LowerClothes LeftLeg whole
            mask{j}=maskmap==40 | maskmap==61;
            
        case 7%Hair Face
            mask{j}=maskmap==10 | maskmap==20;
        case 8%Background
            mask{j}=maskmap==0;
            
        case 9%UpperClothes LeftArm1
            mask{j}(y1:ymid,:)=maskupback(y1:ymid,:);
        case 10%UpperClothes LeftArm2
            mask{j}(ymid:y2,:)=maskupback(ymid:y2,:);
        case 11%UpperClothes LeftArm whole
            mask{j}=maskupback;
    end
end
feature_parts=1:body_parts;

end

