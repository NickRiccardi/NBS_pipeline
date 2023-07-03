%% Clear all workspaces;
clear all; close all;clc;

%% Load data
load 'NEWdata.mat'

%% Anomic aphasia data
n = length(rs_rcorr);
name = cellstr(rs_rcorr(:,1));

anomic_name = [  
"M2006.mat",
"M2020.mat",
"M2069.mat",
"M2076.mat",
"M2082.mat",
"M2088.mat",
"M2092.mat",
"M2106.mat",
"M2110.mat",
"M2111.mat",
"M2119.mat",
"M2120.mat",
"M2124.mat",
"M2139.mat",
"M2145.mat",
"M2152.mat",
"M2153.mat",
"M2164.mat",
"M2170.mat",
"M2172.mat",
"M2177.mat",
"M2183.mat",
"M2192.mat",
"M2196.mat",
"M2214.mat",
"M2223.mat",
"M2238.mat",
"M2240.mat",
"M2243.mat",
"M2246.mat",
"M2251.mat",
"M41019.mat",
"M41042.mat",
"M41048.mat",
"M41052.mat",
"M41066.mat",
"M41086.mat",
"M41091.mat",
"M41094.mat"];

n1 = size(anomic_name,1); %number of Anomic group
ind_g1 = zeros(n1,1);

for i = 1:n1
    temp = string(anomic_name(i,:));
    ind_g1(i) = find(name == temp);        
end

rcorr_anomic = rs_rcorr(ind_g1, 2); %corr of Anomic group

%% Broca's aphasia data
broca_name = [
"M2002.mat",
"M2005.mat",
"M2016.mat",
"M2017.mat",
"M2025.mat",
"M2029.mat",
"M2030.mat",
"M2036.mat",
"M2040.mat",
"M2042.mat",
"M2044.mat",
"M2059.mat",
"M2072.mat",
"M2074.mat",
"M2084.mat",
"M2087.mat",
"M2094.mat",
"M2096.mat",
"M2099.mat",
"M2115.mat",
"M2118.mat",
"M2123.mat",
"M2127.mat",
"M2131.mat",
"M2134.mat",
"M2135.mat",
"M2136.mat",
"M2165.mat",
"M2168.mat",
"M2169.mat",
"M2173.mat",
"M2178.mat",
"M2181.mat",
"M2184.mat",
"M2185.mat",
"M2186.mat",
"M2197.mat",
"M2199.mat",
"M2200.mat",
"M2202.mat",
"M2211.mat",
"M2212.mat",
"M2213.mat",
"M2216.mat",
"M2234.mat",
"M2235.mat",
"M2237.mat",
"M2239.mat",
"M41027.mat",
"M41032.mat",
"M41037.mat",
"M41055.mat",
"M41057.mat",
"M41083.mat",
"M41090.mat",
"M4141.mat",
"M4217.mat"];

n2 = size(broca_name,1); %number of Broca's group
ind_g2 = zeros(n2,1);

for i = 1:n2
    temp = string(broca_name(i,:));
    ind_g2(i) = find(name == temp);        
end

rcorr_broca = rs_rcorr(ind_g2,2); %corr of Broca's group
clear temp

%% Export dataset
clear i
corr_AICHA = zeros(384,384,(n1+n2));
corr_Z_AICHA = zeros(384,384,(n1+n2));

for i = 1:(n1+n2)
    if i <= n1
        temp_G1 = cell2mat(rcorr_anomic(i));
        temp_Z_G1 = atanh(temp_G1);
        corr_AICHA(:,:,i) = temp_G1;
        corr_Z_AICHA(:,:,i) = temp_Z_G1;
    else
        temp_G2 = cell2mat(rcorr_broca(i-n1));
        temp_Z_G2 = atanh(temp_G2);
        corr_AICHA(:,:,i) = temp_G2;
        corr_Z_AICHA(:,:,i) = temp_Z_G2;
    end
end

save('corr.mat','corr_AICHA')
save('corr_Z.mat','corr_Z_AICHA')
