clc
clear
close all

load x102_sig_visuals.mat
load x101_perf_LDA_win20_timecourse_100x_in.mat perf

perf_2D_motor_in = squeeze(mean(perf(~sig_vis&sig_mem,1,:,:),3));
perf_2D_vismotor_in = squeeze(mean(perf(sig_vis&sig_mem,1,:,:),3));

keep perf_2D_motor_in perf_2D_vismotor_in sig_vis

%% Plot
x = -70:0;
sw = 3;

perf_2D_motor_in = smoothraster(perf_2D_motor_in,sw);
perf_2D_vismotor_in = smoothraster(perf_2D_vismotor_in,sw);

% plot the time course of nonstimulation conditions for the two FEF classes
figure('units','normalized','OuterPosition',[.2 .2 .13 .25])
hold on
h_motor_in = plot3line(x,perf_2D_motor_in,'k',1,1);
h_vismotor_in = plot3line(x,perf_2D_vismotor_in,[.7 .7 .7],1,1);
ylabel('Classification performance (%)')
xlabel('Time from sac onset')
line([-70 0],[50 50],'color','k','linestyle','--')
xlim([-72 2])
set(gca,'XTick',-70:10:0)
%% STATISTICS
for it = 1:size(perf_2D_motor_in,2)
    pval_motor_in(it) = signrank(perf_2D_motor_in(:,it),50);
    pval_vismotor_in(it) = signrank(perf_2D_vismotor_in(:,it),50);    
    
    pval_motorVSvismotor_in(it) = ranksum(perf_2D_motor_in(:,it),perf_2D_vismotor_in(:,it));

end
figure(1)
hold on
ind_sig = pval_motorVSvismotor_in<0.05;
xpval = x(ind_sig);
ypval = 59*ones(length(x));
ypval = ypval(ind_sig);
ylim([49 60])
plot(xpval,ypval,'marker','o','markersize',7,...
    'linestyle','none','markerfacecolor','k','markeredgecolor','w')
legend([h_motor_in h_vismotor_in],{'Motor','Visuomotor'},'location','best')
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
