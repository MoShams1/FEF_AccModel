function panel_04DE_presac_FR()

load x101_avg_single_stimVSnostim_win15
load x101_meanFR_each_period.mat
load x102_sig_visuals.mat sig_vis


%% plot stimulation in FIXATION period

base = extract_base(mFR_in,mFR_out);

plot4(nostim.sin,sig_vis,1,base,1+5)
plot4(fix.sin_stim,sig_vis,0,base,1+5)
subplot(3,5,1+5)
title('Fix')

plot4(nostim.sin,sig_vis,1,base,2+5)
plot4(vis.sin_stim,sig_vis,0,base,2+5)
subplot(3,5,2+5)
title('Vis')

plot4(nostim.sin,sig_vis,1,base,3+5)
plot4(mem.sin_stim,sig_vis,0,base,3+5)
subplot(3,5,3+5)
title('Del')

plot4(nostim.sin,sig_vis,1,base,4+5)
plot4(pre.sin_stim,sig_vis,0,base,4+5)
subplot(3,5,4+5)
title('Pre')
end

function base = extract_base(mFR_in,mFR_out)
base = nan(size(mFR_in,1),1);
for in = 1:size(mFR_in,1)
    base(in,1) = mean([mFR_in{in,1};mFR_out{in,1}]);
end
end


function plot4(msacin,sig_vis,label,base,column)
c = lines(7);
hold on
ind = ~sig_vis;
plotinout(msacin(ind,:),label,0,base(ind,:),column)

ind = sig_vis;
plotinout(msacin(ind,:),label,1,base(ind,:),column)

if column == 1+5
    subplot(3,5,column)
    text(0,12,'Without stim.','color','k')
    text(0,10.5,'With stim.','color',c(7,:))
end
end


function plotinout(msacin,label,isubplot,base,column)
c = lines(7);
sw = 15;
msacinb = msacin - base;
subplot(3,5,5*isubplot+column);
if label
    plot3line2(msacinb,'k',1,sw);
    if isubplot == 1 && column == 7
        xtext = 'Time from sacccade onset (ms)';
        text(270, -5, xtext);
    end
    if column == 1+5
        ylabel({'Baseline subtracted','discharge rate (spks/s)'})
    end
    set(gca,'xtick',0:250:550,'xticklabel',-500:250:50)
    cleanplot
    if isubplot == 0
        ylim([-2 16])
        line([500 500], [0 16], 'color','k')
        fill([500-50 500-50 500-25 500-25],[0 16 16 0],'k','facealpha',.1,'edgecolor','none')
        set(gca,"YTick",0:5:15)
    else        
        ylim([4 30])
        line([500 500], [5 30], 'color','k')
        fill([500-50 500-50 500-25 500-25],[0 30 30 0],'k','facealpha',.1,'edgecolor','none')
        set(gca,"YTick",5:10:30)
    end
else
    plot3line2(msacinb,c(7,:),1,sw);
end
xlim([-50 550])
end