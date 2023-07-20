

clc
clear
close all

load motor_data.mat


c = lines(7);

sessions = extract_sessions(data);
nsessions = numel(sessions);
stim_period = {'fixation','visual','memory','presac'};

for isessions = 1:nsessions
    nostim{isessions,1} = sessions{isessions}.no_stim_whole.in.rt';
    for iperiod = 1:4        
        stim{isessions,iperiod} = sessions{isessions}.stim.(stim_period{iperiod}).in.rt';
    end
    
end

figure('units','normalized','outerposition',[.2 .1 .08 .25])

wostim = cell2mat(nostim(:,1));
wstim_fix = cell2mat(stim(:,1));
wstim_vis = cell2mat(stim(:,2));
wstim_mem = cell2mat(stim(:,3));
wstim_sac = cell2mat(stim(:,4));

x = [1, 2, 3, 4, 5];
y = [mean(wostim), mean(wstim_fix), mean(wstim_vis),...
    mean(wstim_mem), mean(wstim_sac)];
err =...
    [std(wostim)/sqrt(numel(wostim)),...
    std(wstim_fix)/sqrt(numel(wstim_fix)),...
    std(wstim_vis)/sqrt(numel(wstim_vis)),...
    std(wstim_mem)/sqrt(numel(wstim_mem)),...
    std(wstim_sac)/sqrt(numel(wstim_sac))];

errorbar(x,y,err*1.96, 'o', 'markersize', 7, 'linewidth',1,'color','k',...
    'CapSize',0, 'MarkerFaceColor','k', 'MarkerEdgeColor','none')
xlim([.5 5.5])
cleanplot

xticks(1:5)
yticks(270:20:370)
xticklabels(["no-Stim.", "Fix", "Vis", "Del", "Sac"])
ylabel('Reaction time (ms)')

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

%% functions
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