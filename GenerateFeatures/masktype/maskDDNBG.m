function [mask,body_parts,feature_parts]=maskDDNBG(maskmap)
%maskDDN get all body parts from DDN mask
%
% "Hair" = 10,
% "Face" = 20,
% "UpperClothes" = 30,
% "LowerClothes" = 40,
% "LeftArm" = 51,
% "LeftLeg" = 61,
% "LeftShoes" = 63,

body_parts=8;
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
        case 8%Background
            mask{j}=maskmap==0;
    end
end
feature_parts=1:body_parts;

%     case 'PPDDNBG'
%         % "Hair" = 10,
%         % "Face" = 20,
%         % "UpperClothes" = 30,
%         % "LowerClothes" = 40,
%         % "LeftArm" = 51,
%         % "LeftLeg" = 61,
%         % "LeftShoes" = 63,
%
%         body_parts=12;
%         mask=cell(body_parts,1);
%         maskup=maskmap==30 | maskmap==51;
%         maskdown=maskmap==40 | maskmap==61;
%         for j=1:body_parts
%             if j<5  %UpperClothes LeftArm
%                 [r,c]=find(maskup);
%                 y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
%                 x1=min(c);x2=max(c);xmid=round((x2+x1)/2);
%                 mask{j}=zeros(size(maskup));
%             end
%             if j>=6 || j<=9  %LowerClothes LeftLeg
%                 [r,c]=find(maskdown);
%                 y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
%                 x1=min(c);x2=max(c);xmid=round((x2+x1)/2);
%                 mask{j}=zeros(size(maskdown));
%             end
%             switch j
%                 case 1%UpperClothes LeftArm1
%                     mask{j}(y1:ymid,x1:xmid)=maskup(y1:ymid,x1:xmid);
%                 case 2%UpperClothes LeftArm2
%                     mask{j}(y1:ymid,xmid:x2)=maskup(y1:ymid,xmid:x2);
%                 case 3%UpperClothes LeftArm1
%                     mask{j}(ymid:y2,x1:xmid)=maskup(ymid:y2,x1:xmid);
%                 case 4%UpperClothes LeftArm2
%                     mask{j}(ymid:y2,xmid:x2)=maskup(ymid:y2,xmid:x2);
%                 case 5%UpperClothes LeftArm whole
%                     mask{j}=maskmap==30 | maskmap==51;
%
%                 case 6%UpperClothes LeftArm1
%                     mask{j}(y1:ymid,x1:xmid)=maskdown(y1:ymid,x1:xmid);
%                 case 7%UpperClothes LeftArm2
%                     mask{j}(y1:ymid,xmid:x2)=maskdown(y1:ymid,xmid:x2);
%                 case 8%UpperClothes LeftArm1
%                     mask{j}(ymid:y2,x1:xmid)=maskdown(ymid:y2,x1:xmid);
%                 case 9%UpperClothes LeftArm2
%                     mask{j}(ymid:y2,xmid:x2)=maskdown(ymid:y2,xmid:x2);
%                 case 10%LowerClothes LeftLeg whole
%                     mask{j}=maskmap==40 | maskmap==61;
%
%                 case 11%Hair Face
%                     mask{j}=maskmap==10 | maskmap==20;
%                 case 12%Background
%                     mask{j}=maskmap==0;
%
%             end
%         end
%         feature_parts=[1,1,2,2,3,4,4,5,5,6,7,8];

end

