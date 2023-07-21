clc
close all
clear

figure('units','normalized','outerposition',[.2 .2 .62 .51])

yoffset = .055;

panel_06AB_vmi

subplot(4,4,[2.5 2.5+4])
panel_06C_vmi_vs_corr_avg
p = get(gca,'position');
set(gca,'position',[p(1), p(2)+yoffset, p(3), p(4)])

subplot(4,4,[3.5 3.5+4])
panel_06D_vmi_vs_acc
p = get(gca,'position');
set(gca,'position',[p(1), p(2)+yoffset, p(3), p(4)])

panel_06E_vmi_vs_accChange