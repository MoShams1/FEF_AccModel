function panel_02D_corr_avg()

load rt_thresh_timecourse_win20_rtbin10.mat r
load x102_sig_visuals.mat sig_vis

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

r_mat = cell2mat({r.nostim}');

r_mot = mean(r_mat(~sig_vis,win),2);
r_vis = mean(r_mat(sig_vis,win),2);

scatterbar({r_mot;r_vis})
yticks(-.5:.25:.5)
set(gca,'xcolor','none')
ylabel('Correlation coefficient (\tau)')
xlim([.5 2.5])
ylim([-.5 .6])
line([0 3],[0 0],'color','k')
cleanplot

text(1,-0.55,'Motor','color','k','rotation',45,'horizontalalignment','right')
text(2,-0.55,'Visuomotor','color','k','rotation',45,'horizontalalignment','right')

ESdiff = meanEffectSize(r_mot,r_vis,effect="cliff");
ESmot = meanEffectSize(r_mot,0,effect="cliff");
ESvis = meanEffectSize(r_vis,0,effect="cliff");

display(['mean mot: ', num2str(nanmean(r_mot))])
display(['mean vis: ', num2str(nanmean(r_vis))])
display(['mot vs vis: p=', num2str(ranksum(r_mot,r_vis)), ' cliff=',...
    num2str(ESdiff.Effect)])
display(['mot vs chance: p=', num2str(signrank(r_mot,0)), ' cliff=',...
    num2str(ESmot.Effect)])
display(['vis vs chance: p=', num2str(signrank(r_vis,0)), ' cliff=',...
    num2str(ESvis.Effect)])

aster = calaster(ranksum(r_mot,r_vis));
text(1.5,.65,aster,'horizontalalignment','center')
aster = calaster(signrank(r_mot,0));
text(1,.55,aster,'horizontalalignment','center')
aster = calaster(signrank(r_vis,0));
text(2,.55,aster,'horizontalalignment','center')
line([1 2],[.6 .6],'color','k')
line([1 1],[.59 .6],'color','k')
line([2 2],[.59 .6],'color','k')


end


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

function aster = calaster(p)
if p<0.001
    aster = '***';
elseif p<0.01
    aster = '**';
elseif p<0.05
    aster = '*';
else
    aster = 'n.s.';
end
end