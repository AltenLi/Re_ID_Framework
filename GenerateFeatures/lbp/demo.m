% close all;clear all;

%% DIRs
ImageDir='../datasets/VIPeR';%VIPeR image dir
imgs=dir(fullfile(ImageDir,'*.bmp'));
% OUTDIR='../../datasets/VIPeR/stripe_part';%VIPeR image dir
% mkdir(OUTDIR);
load('.\stel\STELMasks_VIPeR.mat');%msk{1x1264}

%% Segments
for i=1:2:length(imgs)
    disp(i);
    MAPPING=getmapping(8,'riu2');
    SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
    
    I1=imread(fullfile(ImageDir,imgs(i).name));
    mask1=repmat(uint8(msk{i}),1,1,3);
    I11=rgb2gray(I1.*mask1);
    I12=lbp(I11,SP,0,'i');
    H1=lbp(I11,1,8,MAPPING,'i');
    
    mask1=logical(msk{i});
    mask1=mask1(2:end-1,2:end-1);
    result1=hist(H1(mask1),0:9);
%     result1=result1/sum(result1);
%     H11=lbp(I11,2,16,MAPPING,'i');
    
    I2=imread(fullfile(ImageDir,imgs(i+1).name));
    mask2=repmat(uint8(msk{i+1}),1,1,3);
    I21=rgb2gray(I2.*mask2);
    I22=lbp(I21,SP,0,'i');
    H2=lbp(I21,1,8,MAPPING,'i');
    
    mask2=logical(msk{i+1});
    mask2=mask2(2:end-1,2:end-1);
    result2=hist(H2(mask2),0:9);
%     result2=result2/sum(result2);
%     H21=lbp(I21,2,16,MAPPING,'i');
    
    figure(1);
    subplot(1,3,1);imshow(I12);
    subplot(1,3,2);imshow(I11);
    subplot(1,3,3);stem(result1);
    figure(2);
    subplot(1,3,1);imshow(I22);
    subplot(1,3,2);imshow(I21);
    subplot(1,3,3);stem(result2);
    pause();
    
    
    
    %     imwrite(outimg,fullfile(OUTDIR,imgs(i).name));
end
