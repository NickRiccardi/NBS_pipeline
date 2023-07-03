%% Clear all workspaces;
clear all; close all;clc;

%% Load data
%load 'corr.mat'
%correlation matrices after Fisher's Z transformation
load 'corr_Z.mat' 

n1 = 39; %number of anomic objects
n2 = 57; %number of broca's objects

%% STEP 1: Calculate test statitics
AA = corr_Z_AICHA;
%AA = corr_AICHA; %optional: use regular correlation matrices

%Number of nodes
N = size(AA,2);
%Number of edges in the upper triangle matrix
J = N*(N-1)/2;
n = size(AA,3); %Number of observations
contrast = [1,-1]; %constrat: anomic group - Broca's group
p = size(contrast,2);%Number of predictors

%Prep: prepare the design (X) matrix
X = ones(n,2);
X([1:n1],2) = 0;
X([(n1+1):(n1+n2)],1) = 0;
%save('DesignMatrix.mat','X');

%Alpha level - 0.05
alpha = 0.05;

%Prep: prepare Y matrix
Y = zeros(n,J);
ind_upper = zeros(J,1);
ind_upper = find(triu(ones(N,N),1));
for i=1:n
    mat = AA(:,:,i);
    mat = mat(1:2:end,1:2:end);
    A = squeeze(AA(:,:,i));
    Y(i,:) = A(ind_upper);
end
clear A
clear mat

%Calculate teststat 
input{1} = Y;
input{2} = X;
input{3} = contrast;
input{4} = 5000;%Permutation times
teststat = myNBS_teststat(input);
%% STEP 2: Obtain p values
teststat_obs = teststat(1,:);%observed test statistics 
%Optional: get p vlaues from exact distribution (t-dist)
%pval_obs = 2*(1 - tcdf(abs(teststat_obs),n-2));

%Get p values from permutaion test
pval_perm = zeros(1,J);
for i=1:5000
       pval_perm = pval_perm + (abs(teststat_obs) <= abs(teststat(i+1,:))); 
       %pval_perm = pval_perm + (teststat_obs <= teststat(i+1,:)); 
end
pval_perm = pval_perm / 5000;

%% STEP 3: Baseline methods - multiple testing correction

%Bonferroni method
r1 = myBonferroni(pval_perm,alpha);

%Holm-bonferroni method
r2 = myHolmBonferroni(pval_perm,alpha);

%FDR - BH procedure
r3 = myFDR(pval_perm,alpha);
%% STEP 4: NBS method
thresh = 3.5; %Choose a threshold
%% Modified the NBS codes with parallel computing
[n_cnt,con_mat,pval,r_nbs]= myNBSstats_p(thresh,alpha,N,teststat);
% 
% %Optional: standard error of p value
% se = 2*sqrt(pval(1)*(1-pval)/(input{4}-1));
%% Use NBS GUI instead
% path of NBS folder
cd 'C:\Users\Xingpei Zhao\Documents\South Carolina\project\4. NBS\NBS1.2\NBS1.2'
NBS

%Results: edge index - option: use GUI result
load('C:\Users\Xingpei Zhao\Documents\South Carolina\project\31. NewData\GUI\GUI_thre3.5_Z.mat')
%load('GUI\GUI_thre5.0.mat')
con_mat = nbs.NBS.con_mat;
plot_nbs = con_mat{1}';
index = find(plot_nbs==1); %Results - edge index

%Results: correponsindg test-stats
Rplot_ttest = zeros(N,N);
Rplot_ttest(ind_upper) = teststat_obs;
Rplot_ttest = Rplot_ttest' + Rplot_ttest;
result_ttest = Rplot_ttest(index);
writematrix(result_ttest,'ttest_thr3.5_Z.xlsx');

%% STEP 5: Visulize the results
%Bonferroni 
ind_bonf = ind_upper(r1);
Rplot_bonf = zeros(N,N);
Rplot_bonf(ind_bonf) = 1;
Rplot_bonf = Rplot_bonf' + Rplot_bonf;

subplot(2,2,1)
h_bonf = heatmap(Rplot_bonf)
h_bonf.Colormap = gray
h_bonf.GridVisible = 'off'
h_bonf.CellLabelColor ='none'
h_bonf.ColorbarVisible ='off'
h_bonf.Title = 'Bonferroni'
h_bonf.XDisplayLabels = nan(size(h_bonf.XDisplayData)) 
h_bonf.YDisplayLabels = nan(size(h_bonf.YDisplayData)) 

%Holm-Bonferroni
ind_hbonf = ind_upper(r2);
Rplot_hbonf = zeros(N,N);
Rplot_hbonf(ind_hbonf) = 1;
Rplot_hbonf = Rplot_hbonf' + Rplot_hbonf;
subplot(2,2,2)
h_hbonf = heatmap(Rplot_hbonf)
h_hbonf.Colormap = gray
h_hbonf.GridVisible = 'off'
h_hbonf.CellLabelColor ='none'
h_hbonf.ColorbarVisible ='off'
h_hbonf.Title = "Holm-Bonf"
h_hbonf.XDisplayLabels = nan(size(h_hbonf.XDisplayData)) 
h_hbonf.YDisplayLabels = nan(size(h_hbonf.YDisplayData)) 

%FDR
ind_fdr = ind_upper(r3);
Rplot_fdr = zeros(N,N);
Rplot_fdr(ind_fdr) = 1;
Rplot_fdr = Rplot_fdr' + Rplot_fdr;
subplot(2,2,3)
h_fdr = heatmap(Rplot_fdr)
h_fdr.Colormap = gray
h_fdr.GridVisible = 'off'
h_fdr.CellLabelColor ='none'
h_fdr.ColorbarVisible ='off'
h_fdr.Title = 'FDR'
h_fdr.XDisplayLabels = nan(size(h_fdr.XDisplayData)) 
h_fdr.YDisplayLabels = nan(size(h_fdr.YDisplayData)) 

%Visulization result
Rplot_nbs = zeros(N,N);
Rplot_nbs(r_nbs) = 1;
Rplot_nbs = Rplot_nbs' + Rplot_nbs;

Rplot_nbs = con_mat{1}; %Be cautious: select correct component
Rplot_nbs = Rplot_nbs' + Rplot_nbs;
subplot(2,2,4)
h_nbs = heatmap(Rplot_nbs)
h_nbs.Colormap = gray
h_nbs.CellLabelColor ='none'
h_nbs.CellLabelColor ='none'
h_nbs.GridVisible = 'off'
h_nbs.ColorbarVisible ='off'
h_nbs.Title = 'NBS'
h_nbs.XDisplayLabels = nan(size(h_nbs.XDisplayData)) 
h_nbs.YDisplayLabels = nan(size(h_nbs.YDisplayData))

save('nbs_result.mat', 'con_mat');
save('nbs_index.mat', 'index');
writematrix(full(Rplot_nbs), 'edge_wholebrain.txt','Delimiter',' ');
