

clc
clear
close all

load(fullfile('..','motor_data.mat'))


c = lines(7);

sessions = extract_sessions(data);
nsessions = numel(sessions);
stim_period = {'fixation','visual','memory','presac'};

for isessions = 1:nsessions
    
    for iperiod = 1:4        
        stim{isessions,iperiod} = sessions{isessions}.stim.(stim_period{iperiod}).in.rt';
        nostim{isessions,iperiod} = sessions{isessions}.no_stim_whole.in.rt';
    end
    
end

figure('units','normalized','outerposition',[.2 .1 .25 .9])

for iperiod = 1:4
    
    subplot(4,1,iperiod)
    hold on
    wostim = cell2mat(nostim(:,iperiod));
    wstim = cell2mat(stim(:,iperiod));
    h(1) = histogram(wostim,0:20:800,'facecolor','k','norm','pdf');
    h(2) = histogram(wstim,0:20:800,'facecolor',c(7,:),'norm','pdf');
    ylabel('Normalized count')    
    title(['Stim. period: ',stim_period{iperiod}])
    cleanhist(h)
    
    es = meanEffectSize(wostim,wstim,effect='cohen');

    text(400,.0124,['n sessions= ',num2str(nsessions)])
    text(400,.0111,['n stim trials= ',num2str(length(wstim))])
    text(400,.0098,['n nostim trials= ',num2str(length(wostim))])
    text(400,.0085,['Stimulation induced delay= ',num2str(mean(wstim)-mean(wostim)),'ms'])
    text(400,.0072,['pval= ',num2str(ranksum(wstim,wostim))])
    text(400,.0059,['Cohen''s d= ',num2str(abs(es.Effect))])
    
    pbaspect([1 .5 1])

    if iperiod==4
        xlabel('Reaction time (ms)')
    end
    
end

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