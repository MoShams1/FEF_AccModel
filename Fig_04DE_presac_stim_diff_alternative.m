

clc
clear
close all

load x101_avg_single_stimVSnostim_win15
load x101_meanFR_each_period.mat
load x102_sig_visuals.mat

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1)+500 : find(x==win2)+500;

%%

base = extract_base(mFR_in,mFR_out);


[nostim_m, nostim_vm] = plot4(nostim.sin(:,win),sig_vis,base);

[stim_m, stim_vm] = plot4(fix.sin_stim(:,win),sig_vis,base);
fix_diff_m = mean(stim_m,2)-mean(nostim_m,2);
fix_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);

[stim_m, stim_vm] = plot4(vis.sin_stim(:,win),sig_vis,base);
vis_diff_m = mean(stim_m,2)-mean(nostim_m,2);
vis_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);

[stim_m, stim_vm] = plot4(mem.sin_stim(:,win),sig_vis,base);
mem_diff_m = mean(stim_m,2)-mean(nostim_m,2);
mem_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);

[stim_m, stim_vm] = plot4(pre.sin_stim(:,win),sig_vis,base);
pre_diff_m = mean(stim_m,2)-mean(nostim_m,2);
pre_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);


plot_diff(fix_diff_m,vis_diff_m,mem_diff_m,pre_diff_m)
plot_diff(fix_diff_vm,vis_diff_vm,mem_diff_vm,pre_diff_vm)

%% stat
[signrank(fix_diff_m),signrank(vis_diff_m),signrank(mem_diff_m),signrank(pre_diff_m)]
[signrank(fix_diff_vm),signrank(vis_diff_vm),signrank(mem_diff_vm),signrank(pre_diff_vm)]

%% functions

function base = extract_base(mFR_in,mFR_out)
base = nan(size(mFR_in,1),1);
for in = 1:size(mFR_in,1)
    base(in,1) = mean([mFR_in{in,1};mFR_out{in,1}]);
end
end


function [m, vm] = plot4(M,sig_vis,base)
ind = ~sig_vis;
m = M(ind,:) - base(ind,:);
ind = sig_vis;
vm = M(ind,:) - base(ind,:);
end

function plot_diff(fix_diff, vis_diff, mem_diff, pre_diff)
fig_size = [.2 .2 .12 .25];
x = [1 2 3 4];
y = [mean(fix_diff), mean(vis_diff), mean(mem_diff), mean(pre_diff)];
err =...
    [std(fix_diff)/sqrt(numel(fix_diff)),...
    std(vis_diff)/sqrt(numel(vis_diff)),...
    std(mem_diff)/sqrt(numel(mem_diff)),...
    std(pre_diff)/sqrt(numel(pre_diff))];

figure('units','normalized','outerposition',fig_size)
errorbar(x,y,err, 'o', 'markersize', 7, 'linewidth',1,'color','k',...
    'CapSize',0, 'MarkerFaceColor','k', 'MarkerEdgeColor','none')
line([0 5], [0 0], 'color', 'k')
ylabel 'Discharge difference (spks/s)'
set(gca,'xtick',1:4,'xticklabel',["Fix", "Vis", "Del", "Sac"])
xlim([.5 4.5])
cleanplot
end