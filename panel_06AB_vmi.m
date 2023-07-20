function panel_6AB_vmi()

load vmi.mat vmi
load x102_sig_visuals sig_vis

hbins = -1:.05:1;

subplot(4,2,1)
h_all = histogram(vmi, hbins);
h_all.FaceColor = [.3 .3 .3];
ylabel Count
cleanhist(h_all)

subplot(4,2,3)
hold on
h(1) = histogram(vmi(sig_vis), hbins);
h(2) = histogram(vmi(~sig_vis), hbins);
h(1).FaceColor = [.7 .7 .7];
h(2).FaceColor = 'k';
ylabel Count
xlabel 'Visuomotor index'
legend('Visuomotor','Motor','location','best')
cleanhist(h)

% stat
disp({'HartDip', HartigansDipTest(h_all.Values)})
