function panel_6D_vmi_vs_corr_time()
load vmi.mat vmi
load rt_thresh_timecourse_win20_rtbin10_spearman.mat r

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

rho = struct2cell(r);
istim_period = 1;
rho_nostim = cell2mat(rho(istim_period,:)');
% 123 neurons x 70 time-bins

rho_mean = nanmean(rho_nostim(:,win),2);

msz=10;
color = [.5 .5 .5];
scatter(vmi,rho_mean,msz,'k','fill',...
    'markeredgecolor','none','markerfacecolor',color,'markerfacealpha',.5)
set(gca,'xtick',-1:.5:1,'ytick',-.5:.25:.5)
line([-1 1],[0 0],'color','k')
cleanplot
xlabel 'Visuomotor index'
ylabel 'Average correlation coefficient'
xlim([-1.1 1.1])
ylim([-2*std(rho_mean), 2*std(rho_mean)])
[rho, p] = corr(vmi,rho_mean);
disp({'vmiVScorr_avg' rho p})
lsline
add_binned(vmi, rho_mean)
end

function add_binned(a,b)
hold on
nbins = 7;
m = [a,b];
m = sortrows(m,1);
scatter2nbins(m,nbins)
end
