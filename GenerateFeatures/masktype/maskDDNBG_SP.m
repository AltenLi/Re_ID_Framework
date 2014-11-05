function [mask,body_parts,feature_parts]=maskDDNBG_SP(maskmap,I)
%maskDDNBG_SP get all body parts from mask and superpixel matched up to 80%
matchth=0.8;

body_parts=0;

spseg=get_sp(I);
%match mask
%         mask=cell(body_parts,1);
maskfore=maskmap==30 | maskmap==51|...
    maskmap==10 | maskmap==20|...
    maskmap==40 | maskmap==61;
spids=unique(spseg);
for id=1:length(spids)
    pxc=length(find(spseg==spids(id)));
    %             figure;imagesc(spseg==spids(id));
    mpxc=length(find((spseg==spids(id))&maskfore));
    %             disp([num2str(pxc) '===' num2str(mpxc)]);
    if double(mpxc/pxc)>matchth
        body_parts=body_parts+1;
        mask{body_parts}=(spseg==spids(id));
        feature_parts(body_parts)=1;
        %                 finalseg(spseg==spids(id))=id;
    end
end
%         I_seg = segImage(I,spseg);
%         I_seg2 = segImage(I,finalseg+2);
%         I_segPPDDN = segImage(I,maskfore+2);
%         figure;imshow(I_seg);title('spseg');
%         figure;imshow(I_seg2);title('finalseg');
%         figure;imshow(I_segPPDDN);title('PPDDN');
%         pause;

end

