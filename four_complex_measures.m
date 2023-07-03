%% Clear all workspaces;
clear all; close all;clc;

%% Load data
%Input: adjancency matrix representing for a binary network 

subnetwork = importdata('edge.txt');
matrix = subnetwork' + subnetwork;

spy(matrix) %Visualize data

hubs = betweenness_bin(matrix); %BCT: betweenness centrality
clus = clustering_coef_bu(matrix); %BCT: clustering coefficients
degrees = degrees_und(matrix); %BCT: degree

%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: XLabel.csv
%
% Auto-generated by MATLAB on 20-May-2020 21:48:49

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 1);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "";

% Specify column names and types
opts.VariableNames = "S_Precentral5L";
opts.VariableTypes = "char";

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "S_Precentral5L", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "S_Precentral5L", "EmptyFieldRule", "auto");

% Import the data
XLabel1 = readtable("XLabel_3.5.csv", opts);


%% Clear temporary variables
clear opts

XLabel1 = table2array(XLabel1);
XLabel_new = replace(XLabel1,'_','-');

% Plot1 - Betweenness centrality
xaxis = [1:50];
scatter(xaxis, hubs,25,'filled')
grid on
title('Betweenness centrality for distinctive subnetwork (whole brain)')
xlabel('Region')
ylabel('Betweenness Centrality')
xticks(1:50)
xticklabels(XLabel_new)
xtickangle(45)
xline(1,'--r')
xline(30,'--r')

% Revised Plot 1
subplot(1,3,3)
[hubs_sort, I] = sort(hubs);
label_sort = XLabel_new(I);
barh(hubs_sort(186:205))
yticks(1:20)
yticklabels(label_sort(186:205))
ax = gca;
ax.FontSize = 12 %for y-axis 
title('\fontsize{18}Betweenness Centrality')

% Plot2 - Clustering coefficient
xaxis = [1:50];
scatter(xaxis, clus,25,'filled')
grid on
title('Clustering coefficient for distinctive subnetwork (whole brain)')
xlabel('Region')
ylabel('Clustering coefficient')
xticks(1:50)
xticklabels(XLabel_new)
xtickangle(45)
xline(33,'--r')
xline(34,'--r')

% Revised Plot 2
subplot(1,3,1)
[clus_sort, I_c] = sort(clus);
label_sort_clus = XLabel_new(I_c);
barh(clus_sort(186:205), 'FaceColor', '#EDB120')
yticks(1:20)
yticklabels(label_sort_clus(186:205))
ax = gca;
ax.FontSize = 12 %for y-axis 
title('\fontsize{18}Clustering Coefficient')

% Plot3 - Degree centrality
xaxis = [1:50];
scatter(xaxis,degrees,25,'filled')
grid on
title('Degree for distinctive subnetwork (whole brain)')
xlabel('Region')
ylabel('Degree')
xticks(1:50)
xticklabels(XLabel_new)
xtickangle(45)
xline(1,'--r')
xline(4,'--r')
xline(11,'--r')
xline(30,'--r')
xline(32,'--r')

% Revised Plot 3
subplot(1,3,2)
[degrees_sort, I_d] = sort(degrees);
label_sort_de = XLabel_new(I_d);
barh(degrees_sort(186:205), 'FaceColor', '#77AC30')
yticks(1:20)
yticklabels(label_sort_de(186:205))
ax = gca;
ax.FontSize = 12 %for y-axis 
title('\fontsize{18}Degree')

%Combination 
measures = [transpose(clus);degrees/20;hubs/800];
x = 1:50;
b = barh(x, measures)
b(2).FaceColor = '#77AC30'
b(3).FaceColor = '#D95319'
yticks(1:50)
yticklabels(XLabel_new)
legend({'Clustering Coefficient','Degree','Betweenness Centrality'})
ax = gca;
ax.FontSize = 12 
title('\fontsize{18}Complex Network Measures')