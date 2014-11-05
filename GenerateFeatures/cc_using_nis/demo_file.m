% get 3 parts of human, and pick the main color to represent the pic
% from Pedestrian Parsing via Deep Decompositional Network
% Ping Luo, Xiaogang Wang, and Xiaoou Tang

close all;
clear all;

body_parts=7;
dataset=1;%1:'viper',2:'ilids'
SHOW_FIGURE=0;%0:not show,1:show

switch dataset
    case 1
%         IMGDIR='..\datasets\VIPeRa\';
        IMGDIR='..\datasets\VIPeRa\PPDDN_7\';
        imgs=dir(fullfile(IMGDIR,'*.bmp'));
        MASKDIR='..\..\research\matlab_m\PedParsing\result\VIPeRa\';
%         OUTDIR = '../datasets/VIPeRa/bt_all_100_PPDDN_7/';
%         OUTDIR = '../datasets/VIPeRa/bt_all_auto_PPDDN_7/';
%         OUTDIR = '../datasets/VIPeRa/greyedge_body_PPDDN_7/';
        OUTDIR = '../datasets/VIPeRa/autoycrcb_body_PPDDN_7/';
        
%         OUTDIR = '../datasets/VIPeRa/bt_body_auto_PPDDN_7/';
        mkdir(OUTDIR);
        masks=dir(fullfile(MASKDIR,'*.mat'));
    case 2
        IMGDIR='..\datasets\i-LIDS_Pedestrian\';
        imgs=dir(fullfile(IMGDIR,'*.jpg'));
end

imgcounts=length(imgs);

X = cell(body_parts, imgcounts);
for i=1:length(imgs)
    disp(imgs(i).name);
    I=imread(fullfile(IMGDIR,imgs(i).name));
    I=imresize(I,[160 60]);
    load(fullfile(MASKDIR,masks(i).name));%labelmap
    mask=labelmap==30 | labelmap==51 | labelmap==40 | labelmap==61 | labelmap==10 | labelmap==20;
    
    %grayedge°×Æ½ºâ
    %     mink_norm=5;    % any number between 1 and infinity
    %     sigma=2;        % sigma
    %     diff_order=1;   % differentiation order (1 or 2)
    %
    %     [wR,wG,wB,btimg]=general_cc(double(I),diff_order,mink_norm,sigma);
    %     I=uint8(btimg);
    
    % autoycrcb°×Æ½ºâ
%     I=autoycrcb(I);
    
    maskwen=labelmap==30 | labelmap==51|labelmap==10 | labelmap==20|labelmap==40 | labelmap==61;
    maskwen=repmat(maskwen,[1,1,3]);
    maskedimg=I(logical(maskwen));
    maskedimg=reshape(maskedimg,[],1,3);
    I(logical(maskwen))=autoycrcb(maskedimg);
    
    % "Hair" = 10,
    % "Face" = 20,
    % "UpperClothes" = 30,
    % "LowerClothes" = 40,
    % "LeftArm" = 51,
    % "LeftLeg" = 61,
    % % "LeftShoes" = 63,
    mask3=repmat(mask,[1,1,3]);
    pic=I.*uint8(mask3);
    imwrite(pic,fullfile(OUTDIR,imgs(i).name));
    
    if SHOW_FIGURE
        figure(mod(i+1,2)+1);title(['i:' num2str(i)]);
        %             subplot(1,body_parts,i);
        imshow(pic);
    end
    
    if SHOW_FIGURE
        %             subplot(1,2,2);
        %             scatter3(ps(:,1),ps(:,2),ps(:,3),'.b');
        % %             scatter(ps(:,1),ps(:,2),'.b');
        % %             axis([0 1 0 1]);
        %             xlabel('l'); ylabel('a');
        %             zlabel('b');
    end
    
    
    if SHOW_FIGURE
        if ~mod(i,2)
            pause;
        end
    end
    
end
