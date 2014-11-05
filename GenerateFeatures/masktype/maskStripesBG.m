function [mask,body_parts,feature_parts]=maskStripesBG(maskmap)
%maskStripesBG split img into horizonal parts

body_parts=11;%160*60
mask=cell(body_parts,1);
[r,~]=find(maskmap);
ymin=min(r);ymax=max(r);
height=repmat((ymax-ymin)/10+0.0001,10,1);
startpix=ymin:height:ymax;
startpix=round(startpix);

for j=1:body_parts-1
    mask{j}=zeros(160,60);
    endy=round(startpix(j)+height(j)-1);
    if endy>ymax
        endy=ymax;
    end
    mask{j}(startpix(j):endy,:)=maskmap(startpix(j):endy,:);
    mask{j}=logical(mask{j});
end
mask{11}=maskmap==0;
feature_parts=1:body_parts;

end

