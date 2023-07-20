

clc
clear
close all

load x102_sig_visuals.mat
load LDA_acc_timecourse_win20_rep200x perf

perf_2D_motor_in = squeeze(mean(perf(~sig_vis,1,:,:),3));
perf_2D_vismotor_in = squeeze(mean(perf(sig_vis,1,:,:),3));

clearvars -except perf_2D_motor_in perf_2D_vismotor_in sig_vis

%% plot timecourse
close all

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

sw = 1;

perf_2D_motor_in = smoothraster(perf_2D_motor_in,sw);
perf_2D_vismotor_in = smoothraster(perf_2D_vismotor_in,sw);

% plot the time course of nonstimulation conditions for the two FEF classes
figure('units','normalized','outerposition',[.1 .1 .15 .3])
hold on
h_motor_in = plot3line(x,perf_2D_motor_in,'k');
h_vismotor_in = plot3line(x,perf_2D_vismotor_in,[.7 .7 .7]);

ylabel('Classification performance (%)')
xlabel('Time from sac onset')
line([x(1) x(end)],[50 50],'color','k')
line([0 0],[50 56],'color','k')
line([win1 win1],[50 56],'color','k')
line([win2 win2],[50 56],'color','k')

% add statistics
figure(1)
for it = 1:size(perf_2D_motor_in,2)
%     pval_motor_in(it) = signrank(perf_2D_motor_in(:,it),50);
%     pval_vismotor_in(it) = signrank(perf_2D_vismotor_in(:,it),50);      
    
    [pval_dif_values(it),pval_dif(it)] = ranksum(perf_2D_motor_in(:,it),perf_2D_vismotor_in(:,it));
    tab = meanEffectSize(perf_2D_motor_in(:,it),perf_2D_vismotor_in(:,it),Effect="cliff");
    ES(it) = tab.Effect;
end

mean_cliff_delta = mean(ES(pval_dif & (ES>0)))

% display("Note: Cliff's delta is calculated over significant time points 50ms to 40ms before saccade onset.")

pval_dif = double(pval_dif);
pval_dif(pval_dif==0) = nan;
% pval_dif = BH_correct(pval_dif_values,.05,2);
msz = 3;
plot(x,56.5*pval_dif,'o','markeredgecolor','k','MarkerFaceColor','none','markersize',msz)
legend([h_motor_in h_vismotor_in],...
    {'Motor','Vismotor'},'location','southwest')
set(gca,'YTick',50:2:56)
xlim([-61 10])
ylim([49.8 56.5])
cleanplot


%% 
% figure
% perf_diff = mean(perf_2D_motor_in)-mean(perf_2D_vismotor_in);
% plot(x,perf_diff)
% xlabel 'time from saccade onset (ms)'
% ylabel 'acc(motor) - acc(vismotor) (%)'
% t_max_difference = x(find(perf_diff == max(perf_diff)))
