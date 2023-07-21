function panel_04C_stim_on_RT()

load motor_data.mat data


sessions = extract_sessions(data);
nsessions = numel(sessions);
stim_period = {'fixation','visual','memory','presac'};

for isessions = 1:nsessions
    nostim{isessions,1} = sessions{isessions}.no_stim_whole.in.rt';
    for iperiod = 1:4        
        stim{isessions,iperiod} = sessions{isessions}.stim.(stim_period{iperiod}).in.rt';
    end
    
end

subplot(3,5,5)

wostim = cell2mat(nostim(:,1));
wstim_fix = cell2mat(stim(:,1));
wstim_vis = cell2mat(stim(:,2));
wstim_mem = cell2mat(stim(:,3));
wstim_sac = cell2mat(stim(:,4));

x = [1, 2, 3, 4];
y = [mean(wstim_fix)-mean(wostim), mean(wstim_vis)-mean(wostim),...
    mean(wstim_mem)-mean(wostim), mean(wstim_sac)-mean(wostim)];
err =...
    [std(wstim_fix)/sqrt(numel(wstim_fix)),...
    std(wstim_vis)/sqrt(numel(wstim_vis)),...
    std(wstim_mem)/sqrt(numel(wstim_mem)),...
    std(wstim_sac)/sqrt(numel(wstim_sac))];

errorbar(x,y,err*1.96, 'o', 'markersize', 7, 'linewidth',1,'color','k',...
    'CapSize',0, 'MarkerFaceColor','k', 'MarkerEdgeColor','none')
cleanplot

yticks(-20:20:100)
set(gca,'xcolor','none')
ylabel({'Reaction time', 'difference (ms)'})

stat_p = ...
    [ranksum(wostim,wstim_fix),...
    ranksum(wostim,wstim_vis),...
    ranksum(wostim,wstim_mem),...
    ranksum(wostim,wstim_sac)];
stat_d = abs(...
    [meanEffectSize(wostim,wstim_fix,effect='cohen').Effect,...
    meanEffectSize(wostim,wstim_vis,effect='cohen').Effect,...
    meanEffectSize(wostim,wstim_mem,effect='cohen').Effect,...
    meanEffectSize(wostim,wstim_sac,effect='cohen').Effect]);

yline(0,'color','k')

text(1,20,calaster(ranksum(wostim,wstim_fix)),'horizontalalignment','center')
text(2,-25,calaster(ranksum(wostim,wstim_vis)),'horizontalalignment','center')
text(3,30,calaster(ranksum(wostim,wstim_mem)),'horizontalalignment','center')
text(4,90,calaster(ranksum(wostim,wstim_sac)),'horizontalalignment','center')

xlim([.5 4.5])
ylim([-20 100])
pbaspect([.6 1 1])

ytext = -30;
text(1,ytext,'Fix','color','k','rotation',45,'horizontalalignment','right')
text(2,ytext,'Vis','color','k','rotation',45,'horizontalalignment','right')
text(3,ytext,'Del','color','k','rotation',45,'horizontalalignment','right')
text(4,ytext,'Pre','color','k','rotation',45,'horizontalalignment','right')

end


%%
function sessions = extract_sessions(data)

for i = 1:numel(data)
    % count number of trials in a condition
    ntr(i,1) = length(data{i}.no_stim_whole.in.rt);
end

sessions(1) = data(1);
is = 1;
for id = 2:numel(data)
    
    if ntr(id)~=ntr(id-1)
        is = is+1;
        sessions(is) = data(id);
    end

end

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