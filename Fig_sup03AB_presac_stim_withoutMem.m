

clc
clear
close all

load x101_avg_single_stimVSnostim_win15
load x101_meanFR_each_period.mat
load x102_sig_visuals


%% plot stimulation in FIXATION period

base = extract_base(mFR_in,mFR_out);
fig_size = [.1 .1 .25 .3];
figure('units','normalized','outerposition',fig_size)

plot4(nostim.vin,nostim.vout,nostim.sin,nostim.sout,sig_vis,sig_mem,1,base,1)
plot4(fix.vin_stim,fix.vout_stim,fix.sin_stim,fix.sout_stim,sig_vis,sig_mem,0,base,1)
subplot(2,4,1)
title('stim fix')

plot4(nostim.vin,nostim.vout,nostim.sin,nostim.sout,sig_vis,sig_mem,1,base,2)
plot4(vis.vin_stim,vis.vout_stim,vis.sin_stim,vis.sout_stim,sig_vis,sig_mem,0,base,2)
subplot(2,4,2)
title('stim vis')

plot4(nostim.vin,nostim.vout,nostim.sin,nostim.sout,sig_vis,sig_mem,1,base,3)
plot4(mem.vin_stim,mem.vout_stim,mem.sin_stim,mem.sout_stim,sig_vis,sig_mem,0,base,3)
subplot(2,4,3)
title('stim mem')

plot4(nostim.vin,nostim.vout,nostim.sin,nostim.sout,sig_vis,sig_mem,1,base,4)
plot4(pre.vin_stim,pre.vout_stim,pre.sin_stim,pre.sout_stim,sig_vis,sig_mem,0,base,4)
subplot(2,4,4)
title('stim sac')

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


function plot4(mvisin,mvisout,msacin,msacout,sig_vis,sig_mem,label,base,column)
c = lines(7);
hold on
ind = ~sig_vis & ~sig_mem;
plotinout(mvisin(ind,:),mvisout(ind,:),msacin(ind,:),msacout(ind,:),'only-motor',label,0,base(ind,:),ind,column)

ind = sig_vis & ~sig_mem;
plotinout(mvisin(ind,:),mvisout(ind,:),msacin(ind,:),msacout(ind,:),'visuomotor',label,1,base(ind,:),ind,column)

if column == 1
    subplot(2,4,column)
    text(100,15,'in','color',c(1,:))
    text(100,13.5,'in-stim','color',c(7,:))
end
end


function plotinout(mvisin,mvisout,msacin,msacout,class,label,isubplot,base,ind,column)
c = lines(7);
msacinb = msacin - base;
subplot(2,4,4*isubplot+column);
if label
    plot3line2(msacinb,c(1,:),1,15);
    if isubplot == 1
        xlabel('time from sacccade onset (ms)')
    end
    if column == 1
        ylabel({[class,' neurons (n=',num2str(size(mvisin,1)),')'],...
            'norm. discharge rate (spks/s)'})
    end
    set(gca,'xtick',0:250:550,'xticklabel',-500:250:50)
    cleanplot
    if isubplot == 0
        ylim([-2 25])
        set(gca,"YTick",0:5:25)
    else
        ylim([-2 35])
        set(gca,"YTick",0:5:35)
    end
    xlim([0 550])
else
    plot3line2(msacinb,c(7,:),1,15);
end
end