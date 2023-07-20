

clc
clear
close all

load x101_perf_LDA_win10_timecourse_25x_in.mat perf
load x102_sig_visuals

win = 20:30; % to cover -40 ms from sac with a 10 ms window

perf_motor_in = squeeze(mean(perf(~sig_vis&sig_mem,:,:,:),3));
perf_vismotor_in = squeeze(mean(perf(sig_vis&sig_mem,:,:,:),3));

diff_mat_mot = cal_diff(perf_motor_in);
diff_mat_vis = cal_diff(perf_vismotor_in);
diff_mat_mot = squeeze(mean(diff_mat_mot(:,win,:),2));
diff_mat_vis = squeeze(mean(diff_mat_vis(:,win,:),2));

cell_mot = mat2cell(diff_mat_mot,size(diff_mat_mot,1),[1 1 1 1]);
cell_vis = mat2cell(diff_mat_vis,size(diff_mat_vis,1),[1 1 1 1]);

%% PLOT
pvals = plot_p(cell_mot);
title('Motor neurons')
pbaspect([1 .8 1])
[sig, alpha_hat] = BH_correct(pvals,.05,2)

pvals = plot_p(cell_vis);
title('Visuomotor neurons')
pbaspect([1 .8 1])
[sig, alpha_hat] = BH_correct(pvals,.05,2)

%% FUNCTIONS

function diff_mat = cal_diff(perf)

for icnd = 2:size(perf,2)
    for itime = 1:size(perf,3)
        
        diff_mat(:,itime,icnd-1) = perf(:,icnd,itime) - perf(:,1,itime);
        
    end
end
end



function pvals = plot_p(pcell)
figure('units','normalized','outerposition',[.2 .2 .15 .2])
barplotkon(pcell)
tags = {'fix','vis','mem','pre'};
set(gca,'xtick',1:4,'xticklabel',tags)
ylabel('Performance difference (%)')
cleanplot
pvals = [signrank(pcell{1}),signrank(pcell{2}),signrank(pcell{3}),signrank(pcell{4})];
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
ylim([-3.5 1.5])
set(gca,'YTick',-3:1:1.5)
end


