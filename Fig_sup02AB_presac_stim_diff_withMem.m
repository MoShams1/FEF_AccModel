

clc
clear
close all

load x101_avg_single_stimVSnostim_win15
load x101_meanFR_each_period.mat
load x102_sig_visuals

%% plot stimulation in FIXATION period

base = extract_base(mFR_in,mFR_out);
fig_size = [.1 .1 .25 .2];
figure('units','normalized','outerposition',fig_size)

[nostim_m, nostim_vm] = plot4(nostim.sin,sig_vis,sig_mem,base);

[stim_m, stim_vm] = plot4(fix.sin_stim,sig_vis,sig_mem,base);
subplot(2,4,1)
plotdiff(stim_m-nostim_m)
title('fix')
subplot(2,4,1+4)
plotdiff(stim_vm-nostim_vm)

[stim_m, stim_vm] = plot4(vis.sin_stim,sig_vis,sig_mem,base);
subplot(2,4,2)
plotdiff(stim_m-nostim_m)
title('vis')
subplot(2,4,2+4)
plotdiff(stim_vm-nostim_vm)

[stim_m, stim_vm] = plot4(mem.sin_stim,sig_vis,sig_mem,base);
subplot(2,4,3)
plotdiff(stim_m-nostim_m)
title('mem')
subplot(2,4,3+4)
plotdiff(stim_vm-nostim_vm)

[stim_m, stim_vm] = plot4(pre.sin_stim,sig_vis,sig_mem,base);
subplot(2,4,4)
plotdiff(stim_m-nostim_m)
title('sac')
subplot(2,4,4+4)
plotdiff(stim_vm-nostim_vm)


% for ifig = 1:4
%     stim_period = {'fixation','visual','delay','presac'};
%     saveas(figure(ifig),['x102_stim_period_',stim_period{ifig}])
% end

%% functions

function base = extract_base(mFR_in,mFR_out)
base = nan(size(mFR_in,1),1);
for in = 1:size(mFR_in,1)
    base(in,1) = mean([mFR_in{in,1};mFR_out{in,1}]);
end
end


function [m, vm] = plot4(M,sig_vis,sig_mem,base)
hold on
ind = ~sig_vis & sig_mem;
m = M(ind,:) - base(ind,:);
ind = sig_vis & sig_mem;
vm = M(ind,:) - base(ind,:);
end


function plotdiff(M)
plot3line2(M,'k',1,15);
line([0 550],[0 0],'color','k')
set(gca,'xtick',0:250:550,'xticklabel',-500:250:50)
xlim([0 550])
ylim([-15 10])
% add statistics
for i = 1:size(M,2)
    if signrank(M(:,i)) < 0.01
        p(i) = mean(M(:,i));
    else
        p(i) = nan;
    end
end
hold on
plot(p,'color',[1 .4 .2],'linewidth',3)
cleanplot
end