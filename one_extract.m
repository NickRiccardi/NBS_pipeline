%% Clear all workspaces
clear all;

%% Importport the data
filenames = dir('C:\Users\Xingpei Zhao\Documents\South Carolina\project\NEW DATA\Anomic_Broca');
names = {filenames.name}';
file_r = names(3:end);

%% Extract baseline visit filenames
% n = length(file_r);
% file_n = cell(n,1); %Define empty cell
% for a = 1:n
%     temp = file_r(a);
%     if strlength(temp) ~= 10
%        file_n(a) = file_r(a);  
%     elseif  cell2mat(extractBetween(temp,6,6)) == '1'
%        file_n(a) = file_r(a);
%     else 
%        file_n(a) = {""};
%     end    
% end    
%% Extract rs_fmri_AICHA_r
rs_rcorr = cell(n,2);
for b = 1:n
    temp = file_r(b);
    if  cellstr(temp) ~= ""
        path = strcat('C:\Users\Xingpei Zhao\Documents\South Carolina\project\NEW DATA\Anomic_Broca\',cell2mat(temp));
        load(path)
        rs_rcorr(b,1) = temp;
        rs_rcorr(b,2) = {rest_AICHA.r};    
    else
        rs_rcorr(b,1) = {""};
        rs_rcorr(b,2) = {""};
    end
end

save('NEWdata.mat','rs_rcorr')