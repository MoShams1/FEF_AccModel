

clc
clear
close all

load motor_data
load x102_sig_visuals

figure('units','normalized','outerposition',[.01 .1 .6 .5])

in = 106;
[mvis_in, mvis_out, msac_in, msac_out] = extract(data{in},in);
plotinout(mvis_in,mvis_out,msac_in,msac_out,'Motor',0)

in = 41;
[mvis_in, mvis_out, msac_in, msac_out] = extract(data{in},in);
plotinout(mvis_in,mvis_out,msac_in,msac_out,'Visuomotor',2)


%% FUNCTIONS

function [vis_in, vis_out, sac_in, sac_out] = extract(data,in)
if in == 106
    kstd = 30; % smoothing kernel's standard deviation
end
if in == 41
    kstd = 20;
end

% ================================================ visual period

% extract saccade toward RF (in) trials and smooth them
in_raw = data.no_stim_whole.in.vis;
vis_in = raster2fr(in_raw,kstd).*1000;

% extract saccade away from RF (out) trials and smooth them
out_raw = data.no_stim_whole.out.vis;
vis_out = raster2fr(out_raw,kstd).*1000;

% ================================================ presaccadic period

% extract saccade toward RF (in) trials and smooth them
in_raw = data.no_stim_whole.in.sac;
sac_in = raster2fr(in_raw,kstd).*1000;

% extract saccade away from RF (out) trials and smooth them
out_raw = data.no_stim_whole.out.sac;
sac_out = raster2fr(out_raw,kstd).*1000;

end


function plotinout(mvisin,mvisout,msacin,msacout,class,subrow)

c = lines(7);

s1 = subplot(2,2,subrow+1);
hold on
p1 = plot3line2(mvisin,c(7,:),1,15);
p2 = plot3line2(mvisout,c(1,:),1,15);
xline([1000 2000],'color','k')
if subrow == 2
    xlabel('Time from cue onset (ms)')
end
ylabel('Discharge rate (spks/s)')
title(class)
set(gca,'xtick',0:500:3000,'XTickLabel',-1000:500:2000)
xlim([700 3000])
cleanplot
pos1 = get(gca,'Position');
if subrow == 0    
    text(1000+50,85,'Probe onset','color','k','rotation',45)
    text(2000+50,85,'Probe offset','color','k','rotation',45)    
end

s2 = subplot(2,2,subrow+2);
hold on
plot3line2(msacin,c(7,:),1,15);
plot3line2(msacout,c(1,:),1,15);
xline(500,'color','k')
if subrow == 2
    xlabel('Time from probe onset (ms)')
end
set(gca,'xtick',300:200:550,'xticklabel',-200:200:50)
set(gca,'ycolor','none')
xlim([300 550])
cleanplot
set(gca,'Position',[pos1(1)+pos1(3)+.05, pos1(2), pos1(3)/12, pos1(4)])
if subrow == 0
    text(500+50,85,'Saccade onset','color','k','rotation',45)
    text(700,65,'in','color',c(7,:))
    text(700,61,'out','color',c(1,:))
end

linkaxes([s1,s2],'y')

end