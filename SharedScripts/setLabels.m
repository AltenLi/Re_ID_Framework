function [ labelfilename ] = setLabels( paramALL, iter )
%SETLABELS Summary of this function goes here
%   Detailed explanation goes here
if paramALL.MAXCLUSTER==1 % SvsS
    labelfilename=fullfile(paramALL.DIR.LabelDIR,['labels' num2str(iter) '.mat']);
    if ~paramALL.ReSelectLabel && exist(labelfilename,'file')
%         load(fullfile(paramALL.DIR.LabelDIR,labelfilename),'gallery_label','query_label');
        disp('Label Create Skiped........');
    else
        [ gallery_label, query_label, filename ] = get_labels( paramALL );
        save(labelfilename,'gallery_label','query_label','filename');
        disp('Label Created........');
    end
    
else % MvsM MAXCLUSTER>1
    labelfilename=fullfile(paramALL.DIR.LabelDIR,['dynlabels' num2str(iter) '.mat']);
    if ~paramALL.ReSelectLabel && exist(labelfilename,'file')
%         load(fullfile(paramALL.DIR.LabelDIR,labelfilename),'ped');
        disp('Label Create Skiped........');
    else
        [ ped, filename ] = get_dyn_labels( paramALL );
        save(labelfilename,'ped','filename');
        disp('Label Created........');
    end
end

end

