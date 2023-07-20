

clc
clear
close all

load x101_avg_single_stimVSnostim_win15
load x101_meanFR_each_period.mat
load vmi.mat

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1) : find(x==win2);
win = win+500;

%%

base = extract_base(mFR_in,mFR_out);

nostim = nostim.sin(:,win)-base;

stim = fix.sin_stim(:,win)-base;
fix_diff = mean(stim,2)-mean(nostim,2);

stim = vis.sin_stim(:,win)-base;
vis_diff = mean(stim,2)-mean(nostim,2);

stim = mem.sin_stim(:,win)-base;
mem_diff = mean(stim,2)-mean(nostim,2);

stim = pre.sin_stim(:,win)-base;
pre_diff = mean(stim,2)-mean(nostim,2);

figure('units','normalized','outerposition',[.2 .2 .28 .51])
plot_diff_corr(vmi, fix_diff, 1)
plot_diff_corr(vmi, vis_diff, 2)
plot_diff_corr(vmi, mem_diff, 3)
plot_diff_corr(vmi, pre_diff, 4)


%% functions

function base = extract_base(mFR_in,mFR_out)
base = nan(size(mFR_in,1),1);
for in = 1:size(mFR_in,1)
    base(in,1) = mean([mFR_in{in,1};mFR_out{in,1}]);
end
end

function plot_diff_corr(vmi, diff_vec, isubplot)
msz=3;
subplot(2,2,isubplot)
plot(vmi,diff_vec,'ok','markersize',msz)
line([-1 1],[0 0],'color','k','linestyle','--')
% set(gca,'xtick',-1:.5:1,'ytick',46:4:66)
cleanplot
xlabel 'Visuomotor index'
ylabel 'FR difference after stim (spks/s)'
lsline

xlim([-1.1 1.1])
ylim([mean(diff_vec)-2*std(diff_vec), mean(diff_vec)+2*std(diff_vec)])
% axis([-1.1 1.1 -40 40])

[rho, p] = corr(vmi,diff_vec,'type','pearson');
disp([rho, p])

hold on
nbins = 7;
m = [vmi,diff_vec];
m = sortrows(m,1);
scatter2nbins(m,nbins)

end