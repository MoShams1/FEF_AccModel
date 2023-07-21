function panel_03D_reliability_avg()

load x102_sig_visuals.mat
load LDA_acc_timecourse_win20_rep200x perf

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1):find(x==win2);

perf_motor_in = squeeze(mean(perf(~sig_vis,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis,:,:,:),3));

%% PLOT

nostim_mot = squeeze(mean(perf_motor_in(:,1,win),3));
nostim_vis = squeeze(mean(perf_vismotor_in(:,1,win),3));

scatterbar({nostim_mot;nostim_vis})
set(gca,'xcolor','none')
set(gca,'ytick',45:5:65)
ylabel('Decoding accuracy (%)')
xlim([.5 2.5])
ylim([47 68])
line([0 3],[50 50],'color','k')
cleanplot

text(1,47,'Motor','color','k','rotation',45,'horizontalalignment','right')
text(2,47,'Visuomotor','color','k','rotation',45,'horizontalalignment','right')


ESdiff = meanEffectSize(nostim_mot,nostim_vis,effect="cliff");
ESmot = meanEffectSize(nostim_mot,50,effect="cliff");
ESvis = meanEffectSize(nostim_vis,50,effect="cliff");

display(['mean mot: ', num2str(nanmean(nostim_mot))])
display(['mean vis: ', num2str(nanmean(nostim_vis))])
display(['mot vs vis: p=', num2str(ranksum(nostim_mot,nostim_vis)), ' cliff=',...
    num2str(ESdiff.Effect)])
display(['mot vs chance: p=', num2str(signrank(nostim_mot,50)), ' cliff=',...
    num2str(ESmot.Effect)])
display(['vis vs chance: p=', num2str(signrank(nostim_vis,50)), ' cliff=',...
    num2str(ESvis.Effect)])

aster = calaster(ranksum(nostim_mot,nostim_vis));
text(1.5,69,aster,'horizontalalignment','center')
aster = calaster(signrank(nostim_mot,0));
text(1,66.5,aster,'horizontalalignment','center')
aster = calaster(signrank(nostim_vis,0));
text(2,66.5,aster,'horizontalalignment','center')
line([1 2],[68 68],'color','k')
line([1 1],[67.7 68],'color','k')
line([2 2],[67.7 68],'color','k')

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
if p>=0.05
    aster = 'n.s.';
elseif p<0.05
    aster = '*';
elseif p<0.01
    aster = '**';
else
    aster = '***';
end
end