function [mask,body_parts,feature_parts]=maskCells(maskmap)
%maskCells split img into vertical & horizenal patches

[height,width]= size(maskmap);
bgmap=maskmap==0;
fgmap=~bgmap;%get front-img
body_parts=0;
sub_width = 12 ; sub_height = 16;
step_width =6 ; step_height = 16;
for cross_w = 1 : step_width :width+1-sub_width
    fpnow=0;
    for cross_h = 1 : step_height :height+1-sub_height
        fpnow=fpnow+1;
        body_parts=body_parts+1;
        mask{body_parts}=zeros(height,width);
        mask{body_parts}(cross_h: cross_h+sub_height-1, cross_w: cross_w+sub_width-1)=fgmap(cross_h: cross_h+sub_height-1, cross_w: cross_w+sub_width-1);
        mask{body_parts}=logical(mask{body_parts});
        feature_parts(body_parts)=fpnow;
    end
end

%Add Background Part
fpnow=fpnow+1;
body_parts=body_parts+1;
mask{body_parts}=logical(bgmap);
feature_parts(body_parts)=fpnow;

%         [height,width]= size(maskmap);
%         body_parts=0;
%         sub_width = 12 ; sub_height = 16;
%         step_width =6 ; step_height = 16;
%         for cross_w = 1 : step_width :width+1-sub_width
%             for cross_h = 1 : step_height :height+1-sub_height
%                 body_parts=body_parts+1;
%                 mask{body_parts}=zeros(height,width);
%                 mask{body_parts}(cross_h: cross_h+sub_height-1, cross_w: cross_w+sub_width-1)=1;
%                 mask{body_parts}=logical(mask{body_parts});
%             end
%         end
%         feature_parts=1:body_parts;

end

