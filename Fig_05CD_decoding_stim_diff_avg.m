

clc
clear
close all

load x101_perf_LDA_win10_timecourse_25x_IN perf
load x102_sig_visuals

win = 20:30; % to cover -40 ms from sac with a 10 ms window

perf_motor_in = squeeze(mean(perf(~sig_vis,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis,:,:,:),3));

[diff_mat_mot, mat_mot] = cal_diff(perf_motor_in);
[diff_mat_vis, mat_vis] = cal_diff(perf_vismotor_in);

diff_mat_mot = squeeze(mean(diff_mat_mot(:,win,:),2));
diff_mat_vis = squeeze(mean(diff_mat_vis(:,win,:),2));

mat_mot = mean(mat_mot(:,win),2);
mat_vis = mean(mat_vis(:,win),2);

cell_mot = mat2cell(diff_mat_mot,size(diff_mat_mot,1),[1 1 1 1]);
cell_vis = mat2cell(diff_mat_vis,size(diff_mat_vis,1),[1 1 1 1]);

%% PLOT
alpha = .01;

[pvals, cliffs_delta, es] = plot_p(cell_mot,mat_mot);
title('Motor neurons')
pbaspect([1 .8 1])
[sig, ~] = BH_correct(pvals,alpha,2)
cliffs_delta
es

[pvals, cliffs_delta, es] = plot_p(cell_vis,mat_vis);
title('Visuomotor neurons')
pbaspect([1 .8 1])
[sig, ~] = BH_correct(pvals,alpha,2)
cliffs_delta
es

disp(['Note: the alpha level is set to ',num2str(alpha)])

%% FUNCTIONS

function [diff_mat, org_mat] = cal_diff(perf)

for itime = 1:size(perf,3)
    org_mat(:,itime) = perf(:,1,itime);
end

for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);                
    end
    
end
end



function [pvals, cliffs_delta, es] = plot_p(pcell,mat_nostim)
figure('units','normalized','outerposition',[.2 .2 .15 .2])
barplotkon(pcell)
tags = {'fix','vis','mem','pre'};
set(gca,'xtick',1:4,'xticklabel',tags)
ylabel('Performance difference (%)')
cleanplot
pvals = [signrank(pcell{1}),signrank(pcell{2}),signrank(pcell{3}),signrank(pcell{4})];
es1 = meanEffectSize(pcell{1},0,effect="cliff");
es2 = meanEffectSize(pcell{2},0,effect="cliff");
es3 = meanEffectSize(pcell{3},0,effect="cliff");
es4 = meanEffectSize(pcell{4},0,effect="cliff");
cliffs_delta = abs([es1.Effect, es2.Effect, es3.Effect, es4.Effect]);
es = abs([mean(pcell{1}),mean(pcell{2}),mean(pcell{3}),mean(pcell{4})])/...
    (mean(mat_nostim)-50);
end



function barplotkon(A)
ncat = numel(A); % number of categories
bw = .4; % bar width
lw = 1.5;
c = lines(7);

for i = 1:ncat
    fill([i-bw,i+bw,i+bw,i-bw],[0 0 nanmean(A{i}) nanmean(A{i})],c(i,:),'edgecolor','none');
    hold on
    
    count = sum(~isnan(A{i}));
    s(i) = nanstd(A{i},1) / (count.^.5);
    m(i) = nanmean(A{i});
    line([i i],[nanmean(A{i})-s(i) nanmean(A{i})+s(i)],'linewidth',lw,'color','k')    
end
xlim([0 ncat+1])
set(gca,'xtick',1:ncat)
line([0 5],[0 0],'color','k')
ylim([-2 .5])
end


