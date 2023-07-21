function panel_06AB_vmi()

load vmi.mat vmi
load x102_sig_visuals sig_vis

hbins = -1:.05:1;
yoffset = .05;

subplot(4,4,1.4)
h_all = histogram(vmi, hbins);
h_all.FaceColor = [.3 .3 .3];
ylabel Count
cleanhist(h_all)
pbaspect([1 .35 1])
p = get(gca,'position');
set(gca,'position',[p(1), p(2)+yoffset, p(3), p(4)])

text(-.9,10,'All neurons','color',[.3 .3 .3])

subplot(4,4,5.4)
hold on
h(1) = histogram(vmi(sig_vis), hbins);
h(2) = histogram(vmi(~sig_vis), hbins);
h(1).FaceColor = [.7 .7 .7];
h(2).FaceColor = 'k';
ylabel Count
xlabel 'Visuomotor index'
cleanhist(h)
pbaspect([1 .35 1])
p = get(gca,'position');
set(gca,'position',[p(1), p(2)+yoffset, p(3), p(4)])

text(-.9,10,'Motor','color','k')
text(-.9,8,'Visuomotor','color',[.7 .7 .7])

% stat
disp({'HartDip', HartigansDipTest(h_all.Values)})
