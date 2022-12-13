% These are not difference plots.
% I have no time to rename the variables.
% This was a copy of x108_1 with minimum required changes.
% Dec. 6, 2022

clc
clear
close all

load x101_perf_LDA_win10_timecourse_25x_IN perf
load 'x102_sig_visuals.mat'

perf_motor_in = squeeze(mean(perf(~sig_vis,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis,:,:,:),3));

diff_mat_mot = cal_diff(perf_motor_in);
diff_mat_vis = cal_diff(perf_vismotor_in);


%% PLOT
plot_timecourse(diff_mat_mot,'motor')
plot_timecourse(diff_mat_vis,'visuomotor')

%% FUNCTIONS

function diff_mat = cal_diff(perf)

for icnd = 1:size(perf,2)
    for itime = 1:size(perf,3)
        
        diff_mat(:,itime,icnd) = perf(:,icnd,itime);
        
    end
end
end


function plot_timecourse(diff_mat,neuron_type)
x = -70:0;
c = lines(7);
sw = 5;

figure
for icnd = 1:5
    v = smoothraster(diff_mat(:,:,icnd),sw);
    p(icnd) = plot3line(x,v,c(icnd,:));        
end
legend(p,{'noStim','fix','vis','mem','sac'})
ylabel('Performance (%)')
xlabel('Time from sac onset')
title(neuron_type)
% ylim([-2.5 2.5])
cleanplot
end
