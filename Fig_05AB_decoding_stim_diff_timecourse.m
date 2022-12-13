

clc
clear
close all

load x101_perf_LDA_win10_timecourse_25x_IN perf
load x102_sig_visuals.mat

perf_motor_in = squeeze(mean(perf(~sig_vis,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis,:,:,:),3));

diff_mat_mot = cal_diff(perf_motor_in);
diff_mat_vis = cal_diff(perf_vismotor_in);


%% PLOT

plot_timecourse(diff_mat_mot,'motor')
plot_timecourse(diff_mat_vis,'visuomotor')

%% FUNCTIONS

function diff_mat = cal_diff(perf)

for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)
        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);
        
    end
end
end


function plot_timecourse(diff_mat,neuron_type)
x = -70:0;
c = lines(7);
sw = 5;

figure
for icnd = 1:4    
    v = smoothraster(diff_mat(:,:,icnd),sw);
    p(icnd) = plot3line(x,v,c(icnd,:));        
end
line([-70 0],[0 0],'color','k','linestyle','--')
legend(p,{'fix','vis','mem','sac'})
ylabel('Performance difference (%)')
xlabel('Time from sac onset')
title(neuron_type)
% ylim([-2.5 2.5])
cleanplot

% figure
% % statistics
% for icnd = 1:4    
%     pval = [];
%     v = smoothraster(diff_mat(:,:,icnd),sw);
%     for itime = 1:size(v,2)
%         pval(itime) = signrank(v(:,itime),0);
%     end
%     plot(x,pval,'color',c(icnd,:));    
%     hold on
% end
% line([-70 0],[.05 .05],'color','k','linestyle',':')
% line([-70 0],[.01 .01],'color','k','linestyle','-.')
% line([-70 0],[.001 .001],'color','k','linestyle','--')
% ylim([.0001 1])
% set(gca,'yscale','log')
% cleanplot
end
