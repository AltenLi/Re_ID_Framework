function [mask,body_parts,feature_parts]=masDDNBG_PARTSP(maskmap)
%masDDNBG_PARTSP get all body parts into mask{1}

matchth=0.8;

body_parts=0;

spseg=get_sp(I);
spids=unique(spseg);

parts=4;
for j=1:parts
    switch j
        case 1%UpperClothes LeftArm whole
            maskfore=maskmap==30 | maskmap==51;
        case 2%LowerClothes LeftLeg whole
            maskfore=maskmap==40 | maskmap==61;
        case 3%Hair Face
            maskfore=maskmap==10 | maskmap==20;
        case 4%Background
            maskfore=maskmap==0;
    end
    for id=1:length(spids)
        pxc=length(find(spseg==spids(id)));
        %             figure;imagesc(spseg==spids(id));
        mpxc=length(find((spseg==spids(id))&maskfore));
        %             disp([num2str(pxc) '===' num2str(mpxc)]);
        if double(mpxc/pxc)>matchth
            body_parts=body_parts+1;
            mask{body_parts}=(spseg==spids(id));
            feature_parts(body_parts)=j;
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

end

