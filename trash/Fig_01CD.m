

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
    kstd = 25; % smoothing kernel's standard deviation
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
xlabel('Time from cue onset (ms)')
ylabel('Discharge rate (spks/s)')
title(class)
legend([p1 p2],{'in' 'out'},'location','northwest')
set(gca,'xtick',0:500:3000,'XTickLabel',-1000:500:2000)
xlim([700 3000])
cleanplot
pbaspect([2 1 1])

s2 = subplot(2,2,subrow+1.8);
hold on
plot3line2(msacin,c(7,:),1,15);
plot3line2(msacout,c(1,:),1,15);
xlabel('Time from sacccade onset (ms)')
set(gca,'xtick',300:200:550,'xticklabel',-200:200:50)
xlim([300 550])
cleanplot
pbaspect([.2 1 1])

linkaxes([s1,s2],'y')
% linkaxes([s1,s2],'x')

end