function get_pixels_feature(paramALL,paramMethod)
%get_pixels_feature_DDN Group the Pedestrian Parts' Pixel to Feature File
% get parts of human, and pick the main color to represent the pic
% with Pedestrian Parsing via Deep Decompositional Network
% Ping Luo, Xiaogang Wang, and Xiaoou Tang
%
% Author : Qian Li
% Date : 2014.4.21

%!!!!normalize may be not work on some features!!!

%% Get Settings From feature_type
%resize imgs to 160*60 for match the mask
params=struct();
params.pwidth=60;
params.pheight=160;

if ismember('SAL',paramMethod.feature_type)
    params.sal=load('SharedMats/Gbvs_salience.mat');
end
% load orientation
switch paramALL.Dataset
    case 'VIPER'
        tmp=load('SharedMats/viper_orientation_8.mat');
        params.orientation=tmp.orientation;
    case 'ILIDS'
        params.orientation=zeros(1,paramALL.Imgcount);%exception for empty
    case 'ETHZ3'
        params.orientation=zeros(1,paramALL.Imgcount);%exception for empty
    case 'ETHZ2'
        params.orientation=zeros(1,paramALL.Imgcount);%exception for empty
    case 'ETHZ1'
        params.orientation=zeros(1,paramALL.Imgcount);%exception for empty
    otherwise
        params.orientation=zeros(1,paramALL.Imgcount);%exception for empty
end
params.MAPPING=getmapping(8,'riu2');


%% Grouping Pixels
X= cell(1, paramALL.Imgcount);
for i=1:paramALL.Imgcount
    disp(paramALL.Imgs(i).name);
    I=imread(fullfile(paramALL.DIR.IMGDIR,paramALL.Imgs(i).name));
    if strcmp(paramMethod.mask_type,'MAT')
        maskmap.labelmap=indexBlock_new;
    elseif strcmp(paramMethod.mask_type,'WHOLE')
        I=imresize(I,[params.pheight params.pwidth]);
        maskmap.labelmap= true(size(I(:,:,1)));
    else
        I=imresize(I,[params.pheight params.pwidth]);
        maskmap=load(fullfile(paramALL.DIR.MASKDIR,paramALL.Masks(i).name));%maskmap.labelmap
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Color Balance
    switch paramMethod.bt_type
        case 'bt_body_100'
            if strcmp(paramMethod.mask_type,'MAT')
                maskwen=maskmap.labelmap==2 | maskmap.labelmap==5 | maskmap.labelmap==6 | maskmap.labelmap==8 | maskmap.labelmap==9 | ...
                    maskmap.labelmap==11 | maskmap.labelmap==14 | maskmap.labelmap==15 | maskmap.labelmap==17 | maskmap.labelmap==18 | maskmap.labelmap==19;
            else
                maskwen=maskmap.labelmap==30 | maskmap.labelmap==51|maskmap.labelmap==10 | maskmap.labelmap==20|maskmap.labelmap==40 | maskmap.labelmap==61;
            end
            maskwen=repmat(maskwen,[1,1,3]);
            maskedimg=I(logical(maskwen));
            maskedimg=reshape(maskedimg,[],3);
            I(logical(maskwen))=balance_temperature(maskedimg);
        case 'bt_body_nohead_100'
            if strcmp(paramMethod.mask_type,'MAT')
                maskwen=maskmap.labelmap==5 | maskmap.labelmap==6 | maskmap.labelmap==8 | maskmap.labelmap==9 | maskmap.labelmap==11 |...
                    maskmap.labelmap==14 | maskmap.labelmap==15 | maskmap.labelmap==17 | maskmap.labelmap==18 | maskmap.labelmap==19;
            else
                maskwen=maskmap.labelmap==30 | maskmap.labelmap==51|maskmap.labelmap==40 | maskmap.labelmap==61;
            end
            maskwen=repmat(maskwen,[1,1,3]);
            maskedimg=I(logical(maskwen));
            maskedimg=reshape(maskedimg,[],3);
            I(logical(maskwen))=balance_temperature(maskedimg);
        case 'cc_nohead'
            I=cc_pic(I,I);
    end
    
    I= im2double(I);
    I_gray=rgb2gray(I);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get the masks
    % the example of mask file is at  GenerateFeatures\masktype\ReadMe.txt
    paramMethod.mask_type=upper(paramMethod.mask_type);
    switch paramMethod.mask_type
        case 'WHOLE'
            [allmasks,body_parts,feature_parts]=maskWhole(maskmap.labelmap);
        case 'PPDDN'
            [allmasks,body_parts,feature_parts]=maskDDN(maskmap.labelmap);
        case 'PPDDNBG'
            [allmasks,body_parts,feature_parts]=maskDDNBG(maskmap.labelmap);
        case 'CELLS'
            [allmasks,body_parts,feature_parts]=maskCells(maskmap.labelmap);
        case 'STRIPES'
            [allmasks,body_parts,feature_parts]=maskStripes(maskmap.labelmap);
        case 'STRIPESBG'
            [allmasks,body_parts,feature_parts]=maskStripesBG(maskmap.labelmap);
        case 'SP'
            [allmasks,body_parts,feature_parts]=maskSP(I);
        case 'PPDDNBG_SP'
            [allmasks,body_parts,feature_parts]=maskDDNBG_SP(maskmap.labelmap,I);
        case 'PPDDNBG_PARTSP'
            [allmasks,body_parts,feature_parts]=masDDNBG_PARTSP(maskmap.labelmap);
        case 'MAT'
            [allmasks,body_parts,feature_parts]=maskMat(maskmap.labelmap);
        case 'PPDDNBGORT'
            [allmasks,body_parts,feature_parts]=maskDDNOrientation(maskmap.labelmap,params.orientation);
        case 'PPDDNBGH'
            [allmasks,body_parts,feature_parts]=maskDDNBGHierarchical(maskmap.labelmap);
        otherwise % default is whole
            [allmasks,body_parts,feature_parts]=maskWhole(maskmap.labelmap);
    end%switch paramMethod.mask_type
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get features
    if ismember('SIFT',paramMethod.feature_type)
        params.siftarr=get_sift_feature(rgb2gray(I));
    end
    if ismember('TRANS',paramMethod.feature_type)
        R=I(:,:,1);
        G=I(:,:,2);
        B=I(:,:,3);
        Rm=mean2(R);
        Gm=mean2(G);
        Bm=mean2(B);
        Rs=std2(R)^2;
        Gs=std2(G)^2;
        Bs=std2(B)^2;
        params.R=(R-Rm)/Rs;
        params.G=(G-Gm)/Gs;
        params.B=(B-Bm)/Bs;
    end
    if ismember('LBP',paramMethod.feature_type)
        lbp_h=lbp(I_gray,1,8,params.MAPPING,'i');
        params.lbp_res=ones(size(I_gray));
        params.lbp_res(2:end-1,2:end-1)=lbp_h;
    end
    
    for j=1:body_parts
        mask=logical(allmasks{j});
        clear ps;
        ps=get_ps(I, mask, paramMethod, i);
        X{j,i}=ps;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If FLIP
    if paramMethod.useFLIP
        % flip the image and mask
        I(:,:,1)=fliplr(I(:,:,1));
        I(:,:,2)=fliplr(I(:,:,2));
        I(:,:,3)=fliplr(I(:,:,3));
        I_gray=fliplr(I_gray);
        for mid=1:length(allmasks)
            allmasks{mid}=fliplr(allmasks{mid});
        end
        
        if ismember('SIFT',paramMethod.feature_type)
            params.siftarr=get_sift_feature(rgb2gray(I));
        end
        if ismember('TRANS',paramMethod.feature_type)
            R=I(:,:,1);
            G=I(:,:,2);
            B=I(:,:,3);
            Rm=mean2(R);
            Gm=mean2(G);
            Bm=mean2(B);
            Rs=std2(R)^2;
            Gs=std2(G)^2;
            Bs=std2(B)^2;
            params.R=(R-Rm)/Rs;
            params.G=(G-Gm)/Gs;
            params.B=(B-Bm)/Bs;
        end
        if ismember('LBP',paramMethod.feature_type)
            lbp_h=lbp(I_gray,1,8,params.MAPPING,'i');
            params.lbp_res=ones(size(I_gray));
            params.lbp_res(2:end-1,2:end-1)=lbp_h;
        end
        
        for j=1:body_parts
            mask=logical(allmasks{j});
            clear ps;
            ps=get_ps(I, mask, paramMethod, i);
            X{j,i+paramALL.Imgcount}=ps;
        end
        
    end %if paramMethod.useFLIP
    
end%for i=1:paramALL.Imgcount


%% Output
save([paramALL.DIR.FeatureDIR paramMethod.featureName],'X','paramALL','paramMethod','body_parts','feature_parts', '-v7.3');






%% Detail
    function ps=get_ps(I, mask, paramM, i, params)
        ps=[];
        mask3=repmat(mask,[1,1,3]);
        if ismember('SIFT',paramM.feature_type)
            mask=mask(4:end-3,4:end-3);
            mask3=repmat(mask,[1,1,128]);
            if paramM.useNorm
                %                 points=params.siftarr(mask3);
            else
                points=params.siftarr(mask3);
            end
            ps=[ps,reshape(points,[],128)];
        end
        if ismember('RGB',paramM.feature_type)
            if paramM.useNorm
                points=I(mask3);
            else
                points=I(mask3).*255;
            end
            ps=[ps,reshape(points,[],3)];
        end
        if ismember('HSV',paramM.feature_type)
            I_hsv=rgb2hsv(I);
            if paramM.useNorm
                points=I_hsv(mask3);
            else
                points=I_hsv(mask3).*255;
            end
            ps=[ps,reshape(points,[],3)];
        end
        if ismember('LAB',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            
            points=I_lab(mask3);
            points=reshape(points,[],3);
            if paramM.useNorm
                points(:,1)=points(:,1)./100;
                points(:,2)=points(:,2)./255;
                points(:,3)=points(:,3)./255;
            end
            ps=[ps,points];
        end
        if ismember('TRANS',paramM.feature_type)
            points=cat(3,params.R(mask),params.G(mask),params.B(mask));
            points=reshape(points,[],3);
            if paramM.useNorm
                %                 points(:,1)=points(:,1)./100;
                %                 points(:,2)=points(:,2)./255;
                %                 points(:,3)=points(:,3)./255;
            end
            ps=[ps,points];
        end
        
        if ismember('X',paramM.feature_type)
            [~,pX]=find(mask);
            if paramM.useNorm
                pX=pX./params.pwidth;
            end
            ps=[ps,pX];
        end
        if ismember('Y',paramM.feature_type)
            [pY,~]=find(mask);
            if paramM.useNorm
                pY=pY./params.pheight;
            end
            ps=[ps,pY];
        end
        if ismember('PX',paramM.feature_type)
            [~,c]=find(mask);
            x1=min(c);x2=max(c);xmid=round((x2+x1)/2);
            pX=c-xmid;
            if paramM.useNorm
                pX=pX./(x2-x1+1);
            end
            ps=[ps,pX];
        end
        if ismember('PY',paramM.feature_type)
            [r,~]=find(mask);
            y1=min(r);y2=max(r);ymid=round((y2+y1)/2);
            pY=r-ymid;
            if paramM.useNorm
                pY=pY./(y2-y1+1);
            end
            ps=[ps,pY];
        end
        if ismember('DX',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            [gX,~]=gradient(I_lab);
            points=gX(mask3);
            points=reshape(points,[],3);
            if paramM.useNorm
                points(:,1)=points(:,1)./200;
                points(:,2)=points(:,2)./510;
                points(:,3)=points(:,3)./510;
            end
            ps=[ps,reshape(points,[],3)];
            
        end
        if ismember('DY',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            [~,gY]=gradient(I_lab);
            points=gY(mask3);
            points=reshape(points,[],3);
            if paramM.useNorm
                points(:,1)=points(:,1)./200;
                points(:,2)=points(:,2)./510;
                points(:,3)=points(:,3)./510;
            end
            ps=[ps,reshape(points,[],3)];
        end
        if ismember('DXY',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            [gX,gY]=gradient(I_lab);
            gXY=sqrt(gX.^2+gY.^2);
            points=gXY(mask3);
            if paramM.useNorm
                points=points./361;
            end
            ps=[ps,reshape(points,[],3)];
        end
        %         if ismember('GDXY',paramGaLF.feature_type)
        %             cform = makecform('srgb2lab');
        %             I_lab= applycform(I, cform);
        %             [grX,grY]=gradient(I_lab);
        %             points=sqrt(grX.^2+grY.^2);
        %             points=cat(2,grX(mask),grY(mask));
        %             if paramGaLF.useNorm
        % %                 points=points./510;
        %             end
        %                 ps=[ps,reshape(points,[],3)];
        %         end
        if ismember('GDX',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            for ch=1:3
                [gX,~]=grad1up(I_lab(:,:,ch));
                points=gX(mask);
                if paramM.useNorm
                    %                     points(:,1)=points(:,1)./200;
                    %                     points(:,2)=points(:,2)./510;
                    %                     points(:,3)=points(:,3)./510;
                end
                ps=[ps,points];
            end
            for ch=1:3
                [gX,~]=grad1down(I_lab(:,:,ch));
                points=gX(mask);
                if paramM.useNorm
                    %                     points(:,1)=points(:,1)./200;
                    %                     points(:,2)=points(:,2)./510;
                    %                     points(:,3)=points(:,3)./510;
                end
                ps=[ps,points];
            end
        end
        
        if ismember('GDY',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            for ch=1:3
                [~,gY]=grad1up(I_lab(:,:,ch));
                points=gY(mask);
                if paramM.useNorm
                    %                     points(:,1)=points(:,1)./200;
                    %                     points(:,2)=points(:,2)./510;
                    %                     points(:,3)=points(:,3)./510;
                end
                ps=[ps,points];
            end
            for ch=1:3
                [~,gY]=grad1down(I_lab(:,:,ch));
                points=gY(mask);
                if paramM.useNorm
                    %                     points(:,1)=points(:,1)./200;
                    %                     points(:,2)=points(:,2)./510;
                    %                     points(:,3)=points(:,3)./510;
                end
                ps=[ps,points];
            end
        end
        
        if ismember('DDX',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            [ddX1,~]=grad2(I_lab(:,:,1));
            [ddX2,~]=grad2(I_lab(:,:,2));
            [ddX3,~]=grad2(I_lab(:,:,3));
            points=cat(3,ddX1(mask),ddX2(mask),ddX3(mask));
            if paramM.useNorm
                points(:,1)=points(:,1)./200;
                points(:,2)=points(:,2)./510;
                points(:,3)=points(:,3)./510;
            end
            ps=[ps,reshape(points,[],3)];
            
        end
        if ismember('DDY',paramM.feature_type)
            cform = makecform('srgb2lab');
            I_lab= applycform(I, cform);
            [~,ddY1]=grad2(I_lab(:,:,1));
            [~,ddY2]=grad2(I_lab(:,:,2));
            [~,ddY3]=grad2(I_lab(:,:,3));
            points=cat(3,ddY1(mask),ddY2(mask),ddY3(mask));
            if paramM.useNorm
                points(:,1)=points(:,1)./200;
                points(:,2)=points(:,2)./510;
                points(:,3)=points(:,3)./510;
            end
            ps=[ps,reshape(points,[],3)];
        end
        
        if ismember('LBP',paramM.feature_type)
            result_lbp=params.lbp_res(mask);
            ps=[ps,result_lbp];
        end
        
        %     Salience_map
        if ismember('SAL',paramM.feature_type)
            sal=reshape(params.sal.Salience_map(:,i),128,48);
            sal=imresize(sal,[160 60]);
            ps=ps.*repmat(sal(mask),1,size(ps,2));
            %             ps=ps./repmat(sum(sum(sal(mask))),1,size(ps,2));
        end
        if isempty(ps)
            ps=[-100;-99];%add two elements for skip modeling errors
            warning('the feature part is empty');
        end
    end % end function

end

