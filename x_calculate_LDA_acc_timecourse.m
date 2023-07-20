

clc
clear
close all

load motor_data.mat

nrep = 200;
win = 20;

tic

for irep = 1:nrep
    display(irep)    
    iT_cntr = 0;    
    for itsac = 500-69:1:500
        iT_cntr = iT_cntr+1;
        [perf(:,:,irep,iT_cntr), CM(:,:,irep,iT_cntr)] = run_all(data,itsac,win);
    end    
end

toc

% perf: 123-neurons x 5-stim-conditions x repetitions x times
save(['LDA_acc_timecourse_win',num2str(win),'_rep',num2str(nrep),'x.mat'], ...
    'perf', 'CM')


%% FUNCTIONS

function [perf, CM] = run_all(data,itsac,win)

for in = 1:numel(data)
    
    N = data{in};
    
    % set the fixation and saccade windows
    T = win;
    
    t1_sac = itsac;
    t2_sac = t1_sac + T;    
    

    
    % train the model ------------------------------------------------
    
    % count the number of no-stimulation trials for neuron N
    ntrials = length(N.no_stim_whole.in.rt);
    
    % divide train and test trials from the no-stimulation pool of trials
    all_nostim = 1:ntrials;
    p_train = .75;
    train_set = randperm(ntrials,round(p_train*ntrials));
    test_set = setdiff(all_nostim,train_set);
    
    % calculate the saccade vector
    train.sac = sum(N.no_stim_whole.in.sac(train_set,t1_sac:t2_sac),2);
    
    % calculate the fixation vector
    fix_mat = N.no_stim_whole.in.sac(train_set,:);
    train.fix = make_fixvec(fix_mat,t1_sac,T);
    
    % train an LDA model
    model = train_LDA(train);
    
    
    
    % test the model -------------------------------------------------
    
    % no-stim
    test.sac = sum(N.no_stim_whole.in.sac(test_set,t1_sac:t2_sac),2);
    fix_mat  =     N.no_stim_whole.in.sac(test_set,:);
    test.fix = make_fixvec(fix_mat,t1_sac,T);
    [perf(in,1), CM{in,1}] = test_LDA(model,test);
    
    % stim in fixation
    test.sac = sum(N.stim.fixation.in.sac(:,t1_sac:t2_sac),2);
    fix_mat  =     N.stim.fixation.in.sac;
    test.fix = make_fixvec(fix_mat,t1_sac,T);
    [perf(in,2), CM{in,2}] = test_LDA(model,test);
    
    % stim in visual
    test.sac = sum(N.stim.visual.in.sac(:,t1_sac:t2_sac),2);
    fix_mat  =     N.stim.visual.in.sac;
    test.fix = make_fixvec(fix_mat,t1_sac,T);
    [perf(in,3), CM{in,3}] = test_LDA(model,test);
    
    % stim in memory
    test.sac = sum(N.stim.memory.in.sac(:,t1_sac:t2_sac),2);
    fix_mat  =     N.stim.memory.in.sac;
    test.fix = make_fixvec(fix_mat,t1_sac,T);
    [perf(in,4), CM{in,4}] = test_LDA(model,test);
    
    % stim in presac
    test.sac = sum(N.stim.presac.in.sac(:,t1_sac:t2_sac),2);
    fix_mat  =     N.stim.presac.in.sac;
    test.fix = make_fixvec(fix_mat,t1_sac,T);
    [perf(in,5), CM{in,5}] = test_LDA(model,test);
    
end
end



function model = train_LDA(data)
% create data
dat = [data.fix; data.sac];
% create labels
lab_fix = repmat({'fix'},length(data.fix),1);
lab_sac = repmat({'sac'},length(data.sac),1);
lab = [lab_fix;lab_sac];
% train the model
model = fitcdiscr(dat,lab, 'discrimType','diagLinear');
end



function [perf, conf] = test_LDA(model,data)
% create data
dat = [data.fix; data.sac];
% create labels
lab_fix = repmat({'fix'},length(data.fix),1);
lab_sac = repmat({'sac'},length(data.sac),1);
lab = [lab_fix;lab_sac];
% test
lab_pred = predict(model,dat);
% calculate the precision of the predictions
cmp = strcmp(lab,lab_pred);
perf = sum(cmp)/length(cmp)*100;
conf = confusionmat(lab,lab_pred);
end



function fixvec = make_fixvec(fix_mat,t1_sac,T)
nfix_trials = size(fix_mat,1);
time_vec = randperm(t1_sac - T - 100, nfix_trials);
for itrial = 1:nfix_trials
    t1_fix = time_vec(itrial);
    t2_fix = t1_fix + T;
    fixvec(itrial,1) = sum(fix_mat(itrial,t1_fix:t2_fix),2);
end
end