function [ labelfilename ] = setLabels( paramALL, iter )
%SETLABELS Get dataset labels for this iterator
%  Input:
%   paramALL --- 
%   iter
if paramALL.MAXCLUSTER==1 % SvsS
    labelfilename=fullfile(paramALL.DIR.LabelDIR,['labels' num2str(iter) '.mat']);
    if ~paramALL.ReSelectLabel && exist(labelfilename,'file')
        disp('Label Create Skiped........');
    else
        [ gallery_label, query_label, filename ] = get_labels( paramALL );
        save(labelfilename,'gallery_label','query_label','filename');
        disp('Label Created........');
    end
    
else % MvsM MAXCLUSTER>1
    labelfilename=fullfile(paramALL.DIR.LabelDIR,['dynlabels' num2str(iter) '.mat']);
    if ~paramALL.ReSelectLabel && exist(labelfilename,'file')
        disp('Label Create Skiped........');
    else
        [ ped, filename ] = get_dyn_labels( paramALL );
        save(labelfilename,'ped','filename');
        disp('Label Created........');
    end
end

end

