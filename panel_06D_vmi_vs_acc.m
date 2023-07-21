function panel_06D_vmi_vs_acc()

load LDA_acc_timecourse_win20_rep200x.mat perf
load vmi.mat vmi

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

acc = squeeze(mean(perf(:,:,:,:),3));
acc = squeeze(mean(acc(:,1,win),3));

msz=10;
color = [.5 .5 .5];
scatter(vmi,acc,msz,'k','fill',...
    'markeredgecolor','none','markerfacecolor',color,'markerfacealpha',.5)
line([-1 1],[50 50],'color','k')
set(gca,'xtick',-1:.5:1,'ytick',46:4:66)
cleanplot
xlabel 'Visuomotor index'
ylabel 'Decoding accuracy (%)'
lsline
xlim([-1.1 1.1])

[rho, p] = corr(vmi,acc,'type','kendal');
disp({'vmiVSacc' rho p})

text(-1,65,['\tau = ',num2str(round(rho,2))])
text(-1,63.5,'p < 0.001 ')

%% 
hold on
a = vmi;
b = acc;
nbins = 7;

m = [a,b];
m = sortrows(m,1);

scatter2nbins(m,nbins)
