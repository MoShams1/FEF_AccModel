function panel_05AB_acc_diff_after_stim()

load LDA_acc_timecourse_win20_rep200x perf
load x102_sig_visuals.mat sig_vis

perf_motor_in = squeeze(mean(perf(~sig_vis,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis,:,:,:),3));

diff_mat_mot = cal_diff(perf_motor_in);
diff_mat_vis = cal_diff(perf_vismotor_in);


%% PLOT

plot_timecourse(diff_mat_mot,'Motor',1);
plot_timecourse(diff_mat_vis,'Visuomotor',3);

end

function diff_mat = cal_diff(perf)

for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)
        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);
        
    end
end
end


function plot_timecourse(diff_mat,neuron_type,isubplot)

x = (-69:0) + 10;
win1 = -50;
win2 = -25;

sw = 3;

clines = lines(7);
c1 = [.5 .5 .5];
c2 = clines(1,:);
c3 = clines(5,:);
c4 = clines(7,:);
c = [c1;c2;c3;c4];


subplot(2,2,isubplot)
fill([-50 -50 -25 -25],[-3 4 4 -3],'k','facealpha',.1,'edgecolor','none')
for icnd = 1:4
    v = smoothraster(diff_mat(:,:,icnd),sw);
    p(icnd) = plot3line(x,v,c(icnd,:));
end
line([-60 10],[0 0],'color','k')
line([0 0],[-3 4],'color','k')
set(gca,'ytick',-3:1.5:3)
ylabel({'Decoding accuracy change','after stimulation (pp)'})
xlabel('Time from saccade onset (ms)')
title(neuron_type)
xlim([-62 10])
ylim([-3.6 3])
cleanplot
pbaspect([1 .6 1])
if isubplot == 1
    text(3,3.2,'Fix','color',c(1,:))
    text(3,2.5,'Vis','color',c(2,:))
    text(3,1.8,'Del','color',c(3,:))
    text(3,1.1,'Pre','color',c(4,:))
end
end
