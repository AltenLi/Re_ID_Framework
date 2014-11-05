%% Create DataSet Label
IMGDIR='../../datasets/WARD/WARD';
imgs=dir(fullfile(IMGDIR,'/*.png'));
OUTPUTNAME='Label_WARD.mat';

imgc=length(imgs);
Labels=zeros(1,imgc);
CameraLabels=zeros(1,imgc);
filename=cell(1,imgc);
for i=1:imgc
    filename{i}=imgs(i).name;
    %label is first 4
    Labels(i) = str2num(filename{i}(1:4));
    CameraLabels(i) = str2num(filename{i}(5:8));
end
save(OUTPUTNAME,'Labels','filename','CameraLabels');