


clear
close all
clc

load rt_thresh_timecourse_win20_rtbin10_spearman.mat
load x102_sig_visuals.mat


figure('units','normalized','outerposition',[.1 .1 .15 .25])
hold on


x = (-69:0) + 10;  % time from saccade (ms)
% note: x values are shifted 10 ms rightward to convert forward averaging
% to central averaging
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

rho = struct2cell(r);

istim_period = 1;
rho_nostim = cell2mat(rho(istim_period,:)');

ind_mot = ~sig_vis;
ind_vis = sig_vis;

plot3line(x,rho_nostim(ind_mot,:),'k',0,0);
plot3line(x,rho_nostim(ind_vis,:),[.7 .7 .7],0,0);
line([x(1) x(end)],[0 0],'color','k')
line([0 0],[-.2 .1],'color','k')
line([win1 win1],[-.2 .1],'color','k')
line([win2 win2],[-.2 .1],'color','k')
xlabel('Time from sacccade onset (ms)')
ylabel('Kendall''s Tau')
xlim([-62 12])
ylim([-.16 .1])
cleanplot

% add stats
alpha_val = 0.05;
for it = 1:length(x)
    [~,s_mot(it)] = signrank(rho_nostim(ind_mot,it),0,'alpha',alpha_val);
    [~,s_vis(it)] = signrank(rho_nostim(ind_vis,it),0,'alpha',alpha_val);
    [~,s_dif(it)] = ranksum(rho_nostim(ind_mot,it), rho_nostim(ind_vis,it), ...
        'alpha',alpha_val);
end
msz = 2;
s_mot = double(s_mot);
s_vis = double(s_vis);
s_dif = double(s_dif);
s_mot(s_mot==0) = nan;
s_vis(s_vis==0) = nan;
s_dif(s_dif==0) = nan;
plot(x,s_mot*0.1,'v','markeredgecolor','none','MarkerFaceColor','k','markersize',msz)
plot(x,s_vis*0.09,'v','markeredgecolor','none','MarkerFaceColor',[.6 .6 .6],'markersize',msz)
plot(x,s_dif*0.08,'v','markeredgecolor','k','MarkerFaceColor','none','markersize',msz)


%% 
% figure
% plot(x,nanmean(rho_nostim(ind_mot,:))-nanmean(rho_nostim(ind_vis,:)))


