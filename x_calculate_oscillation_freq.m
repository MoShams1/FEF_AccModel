

clc
clear
close all

load x101_perf_LDA_win10_timecourse_25x_IN perf
load x102_sig_visuals.mat
% perf: neurons x 5-stim-conditions x repetition x time

% average across repetitions
perf_motor_in = squeeze(mean(perf(~sig_vis,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis,:,:,:),3));
% perf_[...]: neurons x 5-stim-conditions x time

% subtract the accuracy during the no-stim condition from the other
% conditions
diff_mat_mot = cal_diff(perf_motor_in);
diff_mat_vis = cal_diff(perf_vismotor_in);
% diff_mat_[...]: neurons x time x 4-stim-conditions

nostim_mot = smooth_data(squeeze(perf_motor_in(:,1,:)));
nostim_vis = smooth_data(squeeze(perf_vismotor_in(:,1,:)));

osc_act_mot = smooth_data(diff_mat_mot);
osc_act_vis = smooth_data(diff_mat_vis);

nostim_mot{1} = nostim_mot{1} - mean(nostim_mot{1},2);
nostim_vis{1} = nostim_vis{1} - mean(nostim_vis{1},2);
% nostim_mot{1} = nostim_mot{1};
% nostim_vis{1} = nostim_vis{1};

sw = 5;
osc_act_mot{5} = smoothraster(nostim_mot{1},sw);
osc_act_vis{5} = smoothraster(nostim_vis{1},sw);

% figure
% plot3line(1:71,osc_act_mot{1},'r');
% plot3line(1:71,osc_act_mot{2},'g');
% plot3line(1:71,osc_act_mot{3},'b');
% plot3line(1:71,osc_act_mot{4},'m');
% plot3line(1:71,osc_act_mot{5},'k');

%%
Fs = 1000;
c = lines(7);
gray = [.5 .5 .5];
noStim = [0 0 0];
c_map = [gray;c(1,:);c(5,:);c(7,:);noStim];

figure('Units','normalized','OuterPosition',[.2 .2 .3 .3])
a1 = subplot(1,2,1);
hold on
for i = 1:numel(osc_act_vis)
    P1_all = [];
    f_all = [];
    for in = 1:size(osc_act_vis{i},1)
        tt = osc_act_vis{i}(in,:);
        ff = fft(tt);
        L = length(tt);
        P2 = abs(ff/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        % normalize by diving each amplitude to the freq. bin
        P1_all(in,:) = P1 ./ (f(2)-f(1));
    end
    p(i) = plot3line(f(2:end),P1_all(:,2:end),c_map(i,:));
end
% add pink noise
p(i+1) = plot(f(2:end),1./f(2:end),':k','linewidth',1.5);
legend(p,{'Fix','Vis','Mem','Sac','noStim','pink'},'location','northeast')
modify_axis('Visuomotor')

a2 = subplot(1,2,2);
hold on
for i = 1:numel(osc_act_mot)
    P1_all = [];
    f_all = [];
    for in = 1:size(osc_act_mot{i},1)
        tt = osc_act_mot{i}(in,:);
        ff = fft(tt);
        L = length(tt);
        P2 = abs(ff/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        P1_all(in,:) = P1 ./ (f(2)-f(1));
    end
    plot3line(f(2:end),P1_all(:,2:end),c_map(i,:));
end
% add pink noise
plot(f(2:end),1./f(2:end),':k','linewidth',1.5)
legend(p,{'Fix','Vis','Mem','Sac','noStim'},'location','northeast')
modify_axis('Motor')
linkaxes([a1, a2], 'y')


%% FUNCTIONS

function diff_mat = cal_diff(perf)
for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);      
    end
end
end


function oscillatory_act = smooth_data(diff_mat)
sw = 5;
for icnd = 1:size(diff_mat,3)
%     diff_mat(:,:,icnd) = diff_mat(:,:,icnd) - mean(diff_mat(:,:,icnd),2);
    diff_mat(:,:,icnd) = diff_mat(:,:,icnd);
    oscillatory_act{icnd} = smoothraster(diff_mat(:,:,icnd),sw);
end
end


function modify_axis(ntype)
ylim([0 .2])
xlim([-10 200])
set(gca,'xtick',0:50:200)
cleanplot
title(ntype)
xlabel("Frequency (Hz)")
ylabel("Norm. power (dB/Hz)")
end