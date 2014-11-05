labelfile='./Labels/WARD/labels1.mat';
IMGDIR='../datasets/WARD/WARD';
labels=load(labelfile);
pairscount=length(labels.gallery_label);
for i=1:pairscount
    I1=imread(fullfile(IMGDIR,filename{labels.gallery_label(i)}));
    I2=imread(fullfile(IMGDIR,filename{labels.query_label(i)}));
    figure(1);
    subplot(1,2,1);imshow(I1);
    subplot(1,2,2);imshow(I2);
    pause();
end