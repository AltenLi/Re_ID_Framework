function   [] = ComputeGMMs( X, feature_parts, paramALL, paramM )
%compute each parts' GMM
% X(j,i)is the j-th part of i-th img
fprintf('Building image models --Processing ');
for i =1:size(X,2)
    outFName = fullfile(paramALL.DIR.ModelDIR, sprintf('%04d.mat',i));
    if paramALL.CanSkipModel && size(dir(outFName), 1)
        continue;
    end
    disp(outFName);
    features = cell(length(unique(feature_parts)),1);
    
    for j=1:length(feature_parts)
        dataArrPart = X{j,i};
        if isempty(dataArrPart)
            break;
        end
        
        [~,omtr] = GaussianMixture(dataArrPart, paramM.init_K, paramM.final_K, false);
        
        omtr = post_one_gmm(omtr);
        features{feature_parts(j)}=[features{feature_parts(j)},omtr.cluster];
        
    end
    sp_make_dir(outFName);
    save(outFName, 'features');
end
fprintf('Completed.\n');

end