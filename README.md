# NBS_pipeline

## Input is participant .mat files with connectomes stored within (e.g., M2002.mat -> AICHA_rest.r)

Step 1: Run “one_extract.m”
1.	Extract the correlation matrices of resting state fMRI from matlab data sets
2.	Save as a single matlab file, named “NEWdata.mat”

Step 2: Run “two_prepare.m”
1.	Organize the correlation matrices based on anomic and Broca’s group information
2.	Normalize the correlation matrices by Fisher z-transformation
3.	Save normalized correlation matrices after organization as a matlab file, named “'corr_Z.mat'”
4.	*optional: non-normalized correlation matrices are saved as “corr.mat”

Step 3: Run NBS GUI
1.	Select design matrix and normalized correlation matrices, specify GLM
2.	T-test, 5000 perms, NBS correction
3.	Save results

Step 4: For data visualization, I am using BrainNet Viewer (https://www.nitrc.org/projects/bnv/) for visualizing results. If you have any other preferences, feel free to use it.
1.	Go to folder “Visualization”
2.	Use “Make_files_copy.R” file to generate edge/node input for BrainNetViewer
3.	Use “Make_file_ttest.R” file to group edges regarding associated t-test statistics

Step 5: Complex Network measures
1.	Use “edge.txt” (a binary network generated from identified subnetwork) in the previous step as an input 
2.	Run “four_complex_measures.m” for analysis and visualization of complex network measures
