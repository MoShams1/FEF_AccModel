function panel_03C_reliability_timecourse()

load x102_sig_visuals.mat sig_vis
load LDA_acc_timecourse_win20_rep200x perf

perf_2D_motor_in = squeeze(mean(perf(~sig_vis,1,:,:),3));
perf_2D_vismotor_in = squeeze(mean(perf(sig_vis,1,:,:),3));

clearvars -except perf_2D_motor_in perf_2D_vismotor_in sig_vis

%% plot timecourse

x = (-69:0)+10;

win1 = -50;
win2 = -25;

sw = 1;

perf_2D_motor_in = smoothraster(perf_2D_motor_in,sw);
perf_2D_vismotor_in = smoothraster(perf_2D_vismotor_in,sw);

% plot the time course of nonstimulation conditions for the two FEF classes
hold on
h_motor_in = plot3line(x,perf_2D_motor_in,'k');
h_vismotor_in = plot3line(x,perf_2D_vismotor_in,[.7 .7 .7]);
set(gca,'xtick',-60:20:0)
ylabel('Decoding accuracy (%)')
xlabel('Time from sac onset (ms)')
line([x(1) x(end)],[50 50],'color','k')
line([0 0],[52 56],'color','k')

text(-23,52.5,'Motor','color','k')
text(-23,52.2,'Visuomotor','color',[.7 .7 .7]) 

% add statistics
figure(1)
fill([win1 win1 win2 win2],[52 56 56 52],'k','facealpha',.1,'edgecolor','none')
for it = 1:size(perf_2D_motor_in,2)
    [pval_dif_values(it),pval_dif(it)] = ranksum(perf_2D_motor_in(:,it),perf_2D_vismotor_in(:,it));
    tab = meanEffectSize(perf_2D_motor_in(:,it),perf_2D_vismotor_in(:,it),Effect="cliff");
    ES(it) = tab.Effect;
end

mean_cliff_delta = mean(ES(pval_dif & (ES>0)))

pval_dif = double(pval_dif);
pval_dif(pval_dif==0) = nan;

msz = 3;
plot(x,56.5*pval_dif,'o','markeredgecolor','k','MarkerFaceColor','none','markersize',msz)
set(gca,'YTick',50:2:56)
xlim([-62 10])
ylim([51.8 56.5])
cleanplot
