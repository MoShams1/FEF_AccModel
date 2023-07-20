function panel_6C_vmi_vs_corr_avg()

load vmi.mat vmi
load rt_thresh_timecourse_win20_rtbin10_spearman.mat r

rho = struct2cell(r);
istim_period = 1;
rho_nostim = cell2mat(rho(istim_period,:)');
% 123 neurons x 70 time-bins

[~,t_min] = min(rho_nostim(:,1:end-10),[],2);
t_min = t_min-60;  % wrt sac onset

msz=10;
color = [.5 .5 .5];
scatter(vmi,t_min,msz,'k','fill',...
    'markeredgecolor','none','markerfacecolor',color,'markerfacealpha',.5)
set(gca,'xtick',-1:.5:1,'ytick',-80:20:0)
cleanplot
xlabel 'Visuomotor index'
ylabel 'Time of min corr coeff wrt sac. (ms)'
xlim([-1.1 1.1])
ylim([mean(t_min)-2*std(t_min), mean(t_min)+2*std(t_min)])
[rho, p] = corr(vmi,t_min);
disp({'vmiVScorr_time' rho p})
lsline
add_binned(vmi, t_min)
end

function add_binned(a,b)
hold on
nbins = 7;
m = [a,b];
m = sortrows(m,1);
scatter2nbins(m,nbins)
end
