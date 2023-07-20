clc
clear
close all

load acc_diff_mat_after_stim.mat
load vmi.mat
load x102_sig_visuals

figure('units','normalized','outerposition',[.2 .2 .28 .51])
for i = 1:4
    plot_each(vmi,diff_mat,i)
end


function plot_each(vmi,diff_mat,isubplot)
acc = diff_mat(:,isubplot);
msz = 3;
subplot(2,2,isubplot)
plot(vmi,acc,'ok','markersize',msz)
line([-1 1],[0 0],'color','k')
cleanplot
xlabel 'Visuomotor index'
ylabel 'Acc difference after stim (pp)'
lsline

xlim([-1.1 1.1])
ylim([mean(acc)-2*std(acc), mean(acc)+2*std(acc)])
% axis([-1.1 1.1 -12 12])

[rho, p] = corr(vmi,acc,'type','spearman');
display([rho,p])
 
hold on
nbins = 7;
m = [vmi,acc];
m = sortrows(m,1);
scatter2nbins(m,nbins)
end

% function plot_diff_corr(vmi, diff_vec, isubplot)
% msz=3;
% subplot(2,2,isubplot)
% plot(vmi,diff_vec,'ok','markersize',msz)
% line([-1 1],[0 0],'color','k','linestyle','--')
% % set(gca,'xtick',-1:.5:1,'ytick',46:4:66)
% cleanplot
% xlabel 'Visuomotor index'
% ylabel 'Firing rate difference (spks/s)'
% lsline
% 
% axis([-1.1 1.1 -40 40])
% 
% [rho, p] = corr(vmi,diff_vec,'type','pearson');
% disp([rho, p])
% 
% hold on
% nbins = 10;
% m = [vmi,diff_vec];
% m = sortrows(m,1);
% scatter2nbins(m,nbins)
% 
% end
