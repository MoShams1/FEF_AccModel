function panel_04FG_presac_stim_diff_avg()

load x101_avg_single_stimVSnostim_win15
load x101_meanFR_each_period.mat
load x102_sig_visuals.mat sig_vis

x = (-69:0)+10;
win1 = -50;
win2 = -25;
win = find(x==win1)+500 : find(x==win2)+500;

%%

base = extract_base(mFR_in,mFR_out);


[nostim_m, nostim_vm] = plot4(nostim.sin(:,win),sig_vis,base);

[stim_m, stim_vm] = plot4(fix.sin_stim(:,win),sig_vis,base);
fix_diff_m = mean(stim_m,2)-mean(nostim_m,2);
fix_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);

[stim_m, stim_vm] = plot4(vis.sin_stim(:,win),sig_vis,base);
vis_diff_m = mean(stim_m,2)-mean(nostim_m,2);
vis_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);

[stim_m, stim_vm] = plot4(mem.sin_stim(:,win),sig_vis,base);
mem_diff_m = mean(stim_m,2)-mean(nostim_m,2);
mem_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);

[stim_m, stim_vm] = plot4(pre.sin_stim(:,win),sig_vis,base);
pre_diff_m = mean(stim_m,2)-mean(nostim_m,2);
pre_diff_vm = mean(stim_vm,2)-mean(nostim_vm,2);


plot_diff(fix_diff_m,vis_diff_m,mem_diff_m,pre_diff_m, 5+5)
ylim([-3 1])
plot_diff(fix_diff_vm,vis_diff_vm,mem_diff_vm,pre_diff_vm, 10+5)
ylim([-6 1])

end

function base = extract_base(mFR_in,mFR_out)
base = nan(size(mFR_in,1),1);
for in = 1:size(mFR_in,1)
    base(in,1) = mean([mFR_in{in,1};mFR_out{in,1}]);
end
end


function [m, vm] = plot4(M,sig_vis,base)
ind = ~sig_vis;
m = M(ind,:) - base(ind,:);
ind = sig_vis;
vm = M(ind,:) - base(ind,:);
end

function plot_diff(fix_diff, vis_diff, mem_diff, pre_diff, isubplot)
x = [1 2 3 4];
y = [mean(fix_diff), mean(vis_diff), mean(mem_diff), mean(pre_diff)];
err =...
    [std(fix_diff)/sqrt(numel(fix_diff)),...
    std(vis_diff)/sqrt(numel(vis_diff)),...
    std(mem_diff)/sqrt(numel(mem_diff)),...
    std(pre_diff)/sqrt(numel(pre_diff))];

subplot(3,5,isubplot)
errorbar(x,y,err, 'o', 'markersize', 7, 'linewidth',1,'color','k',...
    'CapSize',0, 'MarkerFaceColor','k', 'MarkerEdgeColor','none')
line([0 5], [0 0], 'color', 'k')
ylabel({'Baseline subtracted','discharge rate difference (spks/s)'})
set(gca,'xcolor','none')
xlim([.5 4.5])
pbaspect([.6 1 1])
cleanplot

if isubplot == 10
    ytext = -3.5;
else
    ytext = -6.5;
end

text(1,ytext,'Fix','color','k','rotation',45,'horizontalalignment','right')
text(2,ytext,'Vis','color','k','rotation',45,'horizontalalignment','right')
text(3,ytext,'Del','color','k','rotation',45,'horizontalalignment','right')
text(4,ytext,'Pre','color','k','rotation',45,'horizontalalignment','right')

%% stat
disp(['pval dis. diff. ', num2str([signrank(fix_diff),signrank(vis_diff),signrank(mem_diff),signrank(pre_diff)])])

text(1,ytext+.5,calaster(signrank(fix_diff)),'horizontalalignment','center')
text(2,ytext+.5,calaster(signrank(vis_diff)),'horizontalalignment','center')
text(3,ytext+.5,calaster(signrank(mem_diff)),'horizontalalignment','center')
text(4,ytext+.5,calaster(signrank(pre_diff)),'horizontalalignment','center')

end

function aster = calaster(p)
if p<0.001
    aster = '***';
elseif p<0.01
    aster = '**';
elseif p<0.05
    aster = '*';
else
    aster = '';
end
end