function get_hist_feature( paramALL, paramHist )
%GET_HIST_FEATURE Summary of this function goes here
%   Detailed explanation goes here

params.pheight = 160;
params.pwidth = 60;

for i=1:length(paramALL.Imgs)
    I=imread([paramALL.DIR.IMGDIR paramALL.Imgs(i).name]);
    I=imresize(I,[params.pheight params.pwidth]);
    if paramHist.UseMask==1
        im_mask=load([paramALL.DIR.MASKDIR paramALL.Masks(i).name]);
        im_mask=uint8(repmat(im_mask.labelmap,1,1,3)>0);
        I=I.*im_mask;
    end
    hsv=rgb2hsv(I);
%     [IH IW dim]=size(hsv);
    hsv(:,:,3) = histeq(hsv(:,:,3));%直方图均衡化
    
    region = 0;
    hist_temp  = zeros(paramHist.nbins, params.pheight*params.pwidth/(paramHist.sub_height*paramHist.sub_width)*4*3);
    for ch = 1 : 3
        for cross_w = 1 : paramHist.step_width :params.pwidth+1-paramHist.sub_width
            for cross_h = 1 : paramHist.step_height :params.pheight+1-paramHist.sub_height
                temp_region = hsv(cross_h: cross_h+paramHist.sub_height-1, cross_w: cross_w+paramHist.sub_width-1,ch);
                a_y = hist(temp_region(:),0: (1+0.00001)/paramHist.nbins :1);
                region = region + 1;
                hist_temp(:, region)=a_y(:);
            end
        end
    end
    hist_temp(:,region+1:end) = [] ;
    
    features=hist_temp(:);
    %normalize
    features=features./paramHist.sub_width./paramHist.sub_height;
    
%     save( fullfile(paramALL.DIR.FeatureDIR, paramHist.featureName),'region','paramHist');
    
    outFName = fullfile(paramALL.DIR.ModelDIR, sprintf('%04d.mat',i));
    sp_make_dir(outFName);
    save(outFName, 'features');
    disp([outFName '...ok']);
end
    
save(fullfile(paramALL.DIR.FeatureDIR,paramHist.featureName),'paramHist','paramALL','params');
disp('done');
end

