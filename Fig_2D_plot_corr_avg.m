


clear
close all
clc

load rt_thresh_timecourse_win20_rtbin10_spearman.mat
load x102_sig_visuals.mat

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

r_mat = cell2mat({r.nostim}');

r_mot = mean(r_mat(~sig_vis,win),2);
r_vis = mean(r_mat(sig_vis,win),2);


figure('units','normalized','outerposition',[.1 .1 .15 .35])
scatterbar({r_mot;r_vis})
set(gca,'xtick',[1 2],'xticklabel',{'Motor','Vismotor'})
ylabel('Correlation coefficient')
% ylim([-.42 .4])
pbaspect([.5 1 1])
line([0 3],[0 0],'color','k')
cleanplot

ESdiff = meanEffectSize(r_mot,r_vis,effect="cliff");
ESmot = meanEffectSize(r_mot,0,effect="cliff");
ESvis = meanEffectSize(r_vis,0,effect="cliff");

display(['mot vs vis: p=', num2str(ranksum(r_mot,r_vis)), ' cliff=',...
    num2str(ESdiff.Effect)])
display(['mot vs chance: p=', num2str(signrank(r_mot,0)), ' cliff=',...
    num2str(ESmot.Effect)])
display(['vis vs chance: p=', num2str(signrank(r_vis,0)), ' cliff=',...
    num2str(ESvis.Effect)])

%%
function scatterbar(A,marksz)
% A: a cell of cetegories
ncat    = numel(A); % number of categories
stdx    = .07; % standard deviation of scatters in each category
linelm  = .4; % line length for median
if nargin < 2
    marksz  = 50; % marker size
end

c = [0 0 0; .7 .7 .7];

hold on
for icat = 1:ncat    
    rng default
    n = numel(A{icat});
    x = randn(n,1)*stdx + icat;
    
    scatter(x,A{icat},marksz,c(icat,:),'.');
    line([icat-linelm icat+linelm],[nanmedian(A{icat}) nanmedian(A{icat})],'color','k')    
end

xlim([0 ncat+1])
set(gca,'xtick',1:ncat)
end