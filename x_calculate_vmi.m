

clc
clear
close all
load motor_data
load x102_sig_visuals

kstd = 15;

win_vis = 1050:1350;
win_vis_base = 700:1000;
win_mot = 450:550;
win_mot_base = 50:150;

for ineuron = 1:numel(data)
    raster_vis = data{1,ineuron}.no_stim_whole.in.vis(:,win_vis);
    vis = mean(raster2fr(raster_vis,kstd).*1000, 1);    
    
    raster_vis_base = data{1,ineuron}.no_stim_whole.in.vis(:,win_vis_base);
    vis_base = mean(mean(raster2fr(raster_vis_base,kstd).*1000));

    raster_mot = data{1,ineuron}.no_stim_whole.in.sac(:,win_mot);
    mot = mean(raster2fr(raster_mot,kstd).*1000, 1);

    raster_mot_base = data{1,ineuron}.no_stim_whole.in.sac(:,win_mot_base);
    mot_base = mean(mean(raster2fr(raster_mot_base,kstd).*1000));

    visx(ineuron) = abs(max(vis) - vis_base);
    motx(ineuron) = abs(max(mot) - mot_base);
    vmi(ineuron,1) = (motx(ineuron) - visx(ineuron)) / (motx(ineuron) + visx(ineuron));
end

save vmi.mat vmi
