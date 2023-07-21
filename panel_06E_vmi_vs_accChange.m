function panel_06E_vmi_vs_accChange()

load acc_change_after_stim.mat diff_mat
load vmi.mat vmi

tags = {'Fix','Vis','Del','Pre'};

for i = 1:4
    plot_each(vmi,diff_mat,i,tags{i})
end

end


function plot_each(vmi,diff_mat,isubplot,tag)

acc = diff_mat(:,isubplot);
msz = 10;
color = [.5 .5 .5];

subplot(4,4,[isubplot+8 isubplot+8+4])

% remove outliers
% ind1 = acc < (mean(acc) + 2*std(acc));
% ind2 = acc > (mean(acc) - 2*std(acc));
% ind_valid = ind1 & ind2;
% 
% acc_clean = acc;
% vmi_clean = vmi;
% 
% acc_clean(~ind_valid) = [];
% vmi_clean(~ind_valid) = [];


scatter(vmi,acc,msz,'k','fill',...
    'markeredgecolor','none','markerfacecolor',color,'markerfacealpha',.5)
line([-1 1],[0 0],'color','k')
cleanplot
if isubplot == 2
    text(1.4,-15,'Visuomotor index','horizontalalignment','center')
end
if isubplot == 1
    ylabel({'Decoding accuracy change','after stimulation (pp)'})
end
lsline

xlim([-1.1 1.1])
ylim([-11 10])

[rho, p] = corr(vmi,acc,'type','kendall');
display([rho,p])
 
hold on
nbins = 7;
m = [vmi,acc];
m = sortrows(m,1);
scatter2nbins(m,nbins)

text(-1,10,['\tau = ',num2str(round(rho,2))])
text(-1,8.5,['p = ',num2str(round(p,2))])

text(-1,-9,tag)

end

