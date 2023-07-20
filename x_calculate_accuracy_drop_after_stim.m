

clc
clear
close all

load LDA_acc_timecourse_win20_rep200x perf
load x102_sig_visuals

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

perf = squeeze(mean(perf(:,:,:,:),3));
[diff_mat, mat] = cal_diff(perf);

diff_mat = squeeze(mean(diff_mat(:,win,:),2));

save acc_diff_mat_after_stim.mat diff_mat

 
%% FUNCTIONS

function [diff_mat, org_mat] = cal_diff(perf)

for itime = 1:size(perf,3)
    org_mat(:,itime) = perf(:,1,itime);
end

for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);                
    end
    
end
end