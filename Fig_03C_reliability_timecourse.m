

clc
clear
close all

load x102_sig_visuals.mat
load x101_perf_LDA_win10_timecourse_25x_in.mat perf

perf_2D_motor_in = squeeze(mean(perf(~sig_vis,1,:,:),3));
perf_2D_vismotor_in = squeeze(mean(perf(sig_vis,1,:,:),3));

keep perf_2D_motor_in perf_2D_vismotor_in sig_vis

%%

x = -70:0;
sw = 3;

perf_2D_motor_in = smoothraster(perf_2D_motor_in,sw);
perf_2D_vismotor_in = smoothraster(perf_2D_vismotor_in,sw);

% plot the time course of nonstimulation conditions for the two FEF classes
figure
hold on
h_motor_in = plot3line(x,perf_2D_motor_in,'k',1,1);
h_vismotor_in = plot3line(x,perf_2D_vismotor_in,[.7 .7 .7],1,1);

ylabel('Classification performance (%)')
xlabel('Time from sac onset')
line([-70 0],[50 50],'color','k','linestyle','--')

% STATISTICS
for it = 1:size(perf_2D_motor_in,2)
    pval_motor_in(it) = signrank(perf_2D_motor_in(:,it),50);
    pval_vismotor_in(it) = signrank(perf_2D_vismotor_in(:,it),50);      
    
    pval_motorVSvismotor_in(it) = ranksum(perf_2D_motor_in(:,it),perf_2D_vismotor_in(:,it));
    tab = meanEffectSize(perf_2D_motor_in(:,it),perf_2D_vismotor_in(:,it),Effect="cliff");
    ES(it) = tab.Effect;
end

figure(1)
hold on
ind_sig = pval_motorVSvismotor_in<0.05;
% ind_sig = BH_correct(pval_motorVSvismotor_in,.05,2);
mean_cliff_delta = mean(ES(ind_sig & (ES>0)))
display("Note: Cliff's delta is calculated over significant time points 50ms to 40ms before saccade onset.")
xpval = x(ind_sig);
ypval = 54*ones(length(x));
ypval = ypval(ind_sig);
ylim([49.8 54])
plot(xpval,ypval,'marker','o','markersize',7,'markerfacecolor','k','markeredgecolor','w')
legend([h_motor_in h_vismotor_in],...
    {'Motor','Vismotor'},'location','best')
set(gca,'YTick',49:1:54)
cleanplot

% figure
% hold on
% plot(x,pval_motor_in,'k')
% plot(x,pval_vismotor_in,'r')
% plot(x,pval_motorVSvismotor_in,'g')
% line([-70 0],[.05 .05],'color','k','linestyle',':')
% line([-70 0],[.01 .01],'color','k','linestyle','-.')
% line([-70 0],[.001 .001],'color','k','linestyle','--')
% set(gca,'yscale','log')
% pbaspect([1 .5 1])
% cleanplot
