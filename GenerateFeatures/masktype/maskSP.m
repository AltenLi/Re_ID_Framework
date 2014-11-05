function [mask,body_parts,feature_parts]=maskSP(I)
%maskSP superpixel parts
body_parts=0;

spseg=get_sp(I);

spids=unique(spseg);
for id=1:length(spids)
    
    body_parts=body_parts+1;
    mask{body_parts}=(spseg==spids(id));
    feature_parts(body_parts)=1;
    %                 finalseg(spseg==spids(id))=id;
    
end
%         I_seg = segImage(I,spseg);
%         I_seg2 = segImage(I,finalseg+2);
%         I_segPPDDN = segImage(I,maskfore+2);
%         figure;imshow(I_seg);title('spseg');
%         figure;imshow(I_seg2);title('finalseg');
%         figure;imshow(I_segPPDDN);title('PPDDN');
%         pause;

end

