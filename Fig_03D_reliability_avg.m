

clc
clear
close all

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

figure('units','normalized','outerposition',[.1 .1 .15 .35])
scatterbar({nostim_mot;nostim_vis})
set(gca,'xtick',[1 2],'xticklabel',{'Motor','Visuomotor'})
ylabel('Classification accuracy (%)')
ylim([47.5 64])
pbaspect([.5 1 1])
line([0 3],[50 50],'color','k')
cleanplot

ESdiff = meanEffectSize(nostim_mot,nostim_vis,effect="cliff");
ESmot = meanEffectSize(nostim_mot,50,effect="cliff");
ESvis = meanEffectSize(nostim_vis,50,effect="cliff");

display(['mot vs vis: p=', num2str(ranksum(nostim_mot,nostim_vis)), ' cliff=',...
    num2str(ESdiff.Effect)])
display(['mot vs chance: p=', num2str(signrank(nostim_mot,50)), ' cliff=',...
    num2str(ESmot.Effect)])
display(['vis vs chance: p=', num2str(signrank(nostim_vis,50)), ' cliff=',...
    num2str(ESvis.Effect)])

%% FUNCTIONS
function diff_mat = cal_diff(perf)

for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)
        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);
        
    end
end
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