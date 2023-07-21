
clear
close all
clc

load motor_data.mat

win = 20;
n_rtbins = 10;
kstd = 1;

for ineuron = 1:numel(data)
    
    disp(ineuron)
    
    [r(ineuron,:), rp(ineuron,:)] = extract_corr(data{ineuron},win,n_rtbins,kstd);
    
end

save(['rt_thresh_timecourse_win',num2str(win), ...
    '_rtbin',num2str(n_rtbins),'.mat'], ...
    'r', 'rp')


%% functions
function [r, rp] = extract_corr(neuron,win,n_rtbins,kstd)

% no-stimulation
nostim.fef = raster2fr(neuron.no_stim_whole.in.sac,kstd).*1000;
nostim.rt = neuron.no_stim_whole.in.rt';
[r.nostim,rp.nostim] = cal_corr(nostim,win,n_rtbins);


% stimulation
stim.fix.fef = raster2fr(neuron.stim.fixation.in.sac,kstd).*1000;
stim.fix.rt = neuron.stim.fixation.in.rt';
[r.fix,rp.fix] = cal_corr(stim.fix,win,n_rtbins);

stim.vis.fef = raster2fr(neuron.stim.visual.in.sac,kstd).*1000;
stim.vis.rt = neuron.stim.visual.in.rt';
[r.vis,rp.vis] = cal_corr(stim.vis,win,n_rtbins);

stim.del.fef = raster2fr(neuron.stim.memory.in.sac,kstd).*1000;
stim.del.rt = neuron.stim.memory.in.rt';
[r.del,rp.del] = cal_corr(stim.del,win,n_rtbins);

stim.pre.fef = raster2fr(neuron.stim.presac.in.sac,kstd).*1000;
stim.pre.rt = neuron.stim.presac.in.rt';
[r.pre,rp.pre] = cal_corr(stim.pre,win,n_rtbins);

end




function [r,rp] = cal_corr(A,win,n_rtbins)

rt = A.rt;
fef = A.fef;

rt_bins = binrt(rt,n_rtbins);

for ib = 1:max(rt_bins)
    
    ind = rt_bins == ib;
    
    rt_b(ib,1) = mean(rt(ind));
    
    it_cntr = 0;    
    for it = 500-69:500
        it_cntr = it_cntr+1;
        fef_b(ib,it_cntr) = mean(mean(fef(ind,it:it+win),2),1);
    end
    
end

for it = 1:size(fef_b,2)
    
    [r(it),rp(it)] = corr(rt_b,fef_b(:,it),'type','kendall');

end

end



function rt_bins = binrt(rt,n_rtbins)

rt_bins = nan(length(rt),1);

markers = quantile(rt,n_rtbins-1);
markers = [min(rt),markers,max(rt)];

for imarker = 1:length(markers)-1
    rt_bins(rt>=markers(imarker) & rt<markers(imarker+1)+1) = imarker;
end

end