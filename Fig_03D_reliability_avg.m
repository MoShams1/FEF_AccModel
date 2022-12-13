

clc
clear
close all

load x102_sig_visuals.mat
load x101_perf_LDA_win10_timecourse_25x_in.mat perf

win = 20:30; % to cover -40 ms from sac with a 10 ms window

perf_motor_in = squeeze(mean(perf(~sig_vis,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis,:,:,:),3));

%% PLOT

nostim_mot = squeeze(mean(perf_motor_in(:,1,win),3));
nostim_vis = squeeze(mean(perf_vismotor_in(:,1,win),3));

figure
scatterbar({nostim_mot;nostim_vis})
set(gca,'xtick',[1 2],'xticklabel',{'Motor','Visuomotor'})
ylabel('classification perf.')
ylim([48 60])
pbaspect([.5 1 1])
line([0 3],[50 50],'color','k')
cleanplot

ESdiff = meanEffectSize(nostim_mot,nostim_vis,effect="cliff");
ESmot = meanEffectSize(nostim_mot,50,effect="cliff");
ESvis = meanEffectSize(nostim_vis,50,effect="cliff");
display([ranksum(nostim_mot,nostim_vis),ESdiff.Effect])
display([signrank(nostim_mot,50),ESmot.Effect])
display([signrank(nostim_vis,50),ESvis.Effect])

%% FUNCTIONS
function diff_mat = cal_diff(perf)

for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)
        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);
        
    end
end
end
