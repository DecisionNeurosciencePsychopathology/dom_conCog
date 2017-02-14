function b=createSharkCensorRegressor(b)
%This is a file of 1s and 0s, indicating which
%time points are to be included (1) and which are
%to be excluded (0).


%Idea for furutre implementation, you will need to define inpus b,
%onset_time, offset_time, binary_censor. Then you could just rerun this
%function multiple times if you needed various censors. For the output just
%have it be "censor_out" or something, i.e. b.trial_censor =
%createCensorRegressor(b,onset_time,offset_time,b.missed) <-goal

frequency_scale_hz = 10;
%bin_size = 1/frequency_scale_hz; %I believe we are in seconds?
bin_size = 1/frequency_scale_hz*1000;
scan_tr = b.scan_tr;

%If we didn't already grab the subjects volume run length do it now
file_str = sprintf('subjects/%s/%s_block_lengh.mat',num2str(b.id),num2str(b.id));

if ~exist(file_str,'file')
    b=findBlockLength(b);
    block_length = b.block_length; %This is subject specific create that function to grab this from 3dinfo
    save(file_str,'block_length')
else
    load(file_str)
end


b.trials_to_censor = b.missed; %Only missed trials currently
moneytime = b.moneytime;
jittertime = b.jittertime;

%We need to convert the times to ms
stim_OnsetTime = b.stim1_onset;
%stim_NextOnsetTime=[stim_OnsetTime(2:end); (stim_OnsetTime(end)+b.stim_RT(end)*1000)]; %
endOfTrial = b.rew_onset+moneytime+jittertime;
%This is a guess! you need to make sure this is acurate. Find out how much
%time typically elapses between error and next onset, though this will only
%be the rare case in which the subject missed the final trial.
error_time = 2600;
if b.missed(end)==1
    last_time_point = b.stim1_onset(end) + error_time;
else
    last_time_point = b.rew_onset+moneytime+jittertime;
end

endOfTrial = [b.stim1_onset(2:end) last_time_point];




for block_n = 1:b.total_blocks

    %Set up trial ranges
    trial_index_1 = b.trial_index(block_n);
    trial_index_2 = trial_index_1 + b.trials_per_block-1;
    
    %Create epoch eindow
    epoch_window = stim_OnsetTime(trial_index_1:trial_index_2):bin_size:stim_OnsetTime(trial_index_1:trial_index_2)+scan_tr*block_length(block_n)*1000;
    %epoch_window3 = stim_OnsetTime(trial_index_1):bin_size:stim_OnsetTime(trial_index_1)+scan_tr*block_length(block_n)*1000; % Another perhaps more simple way to do the same thing?
    %epoch_window = stim_OnsetTime(b.trial_index(block_n)):bin_size:(feedback_OffsetTime(b.trials_per_block + b.trial_index(block_n) -1));
    event_beg = stim_OnsetTime(trial_index_1:trial_index_2); event_end = endOfTrial(trial_index_1:trial_index_2);
    
    
    tmp_reg.(['regressors' num2str(block_n)]).to_censor = ...
        createSimpleRegressor(event_beg, event_end, epoch_window, b.trials_to_censor(trial_index_1:trial_index_2));
    tmp_reg.(['regressors' num2str(block_n)]).to_censor = ones(size(tmp_reg.(['regressors' num2str(block_n)]).to_censor)) - tmp_reg.(['regressors' num2str(block_n)]).to_censor; %Goes from logical to double
    
    
    % NB: the first 5s are censored because they capture HRF to events
    % preceding the first trial
    tmp_reg.(['hrfreg' num2str(block_n)]).to_censor = ...
        gsresample( ...
        [zeros(50,1)' tmp_reg.(['regressors' num2str(block_n)]).to_censor(1:end-51)], ...
        10,1./scan_tr);
    
end

fnm = fieldnames(tmp_reg.regressors1)';
%Added switch case for subjects with irregular trials
ct=1:length(fnm);
switch b.total_blocks
    case 1
        for ct=1:length(fnm)
            b.hrf_regs.(fnm{ct}) = [tmp_reg.hrfreg1.(fnm{ct})];
        end
    case 2
        for ct=1:length(fnm)
            b.hrf_regs.(fnm{ct}) = [tmp_reg.hrfreg1.(fnm{ct}) tmp_reg.hrfreg2.(fnm{ct})];
        end
    case 3
        for ct=1:length(fnm)
            b.hrf_regs.(fnm{ct}) = [tmp_reg.hrfreg1.(fnm{ct}) tmp_reg.hrfreg2.(fnm{ct}) tmp_reg.hrfreg3.(fnm{ct})];
        end
    otherwise
        disp('Error occured somewhere')
end

b.hrf_regs.to_censor = 1-(ceil(b.hrf_regs.to_censor));
b.hrf_regs.to_censor = ~b.hrf_regs.to_censor;



function foo = createSimpleRegressor(event_begin,event_end,epoch_window,conditional_trials)
% this was not a problem earlier, but for some reason it is now: find indices that would
% result in a negative value and set them both to 0
qbz = ( event_begin == 0 ); qez = ( event_end == 0 );
event_begin( qbz | qez ) = 0; event_end( qbz | qez ) = 0;

% check if optional censoring variable was used
if(~exist('conditional_trials','var') || isempty(conditional_trials))
    conditional_trials = true(length(event_begin),1);
elseif(~islogical(conditional_trials))
    % needs to be logical format to index cells
    conditional_trials = logical(conditional_trials);
end

% this only happened recently, but it's weird
if(any((event_end(conditional_trials)-event_begin(conditional_trials)) < 0))
    error('MATLAB:bandit_fmri:time_travel','feedback is apparently received before RT');
end

% create epoch windows for each trial
epoch = arrayfun(@(a,b) a:b,event_begin,event_end,'UniformOutput',false);

% for each "epoch" (array of event_begin -> event_end), count events
% per_event_histcs = cellfun(@(h) histc(h,epoch_window),epoch(conditional_trials),'UniformOutput',false);
% foo = logical(sum(cell2mat(per_event_histcs),1));

foo = zeros(size(epoch_window));

for n = 1:numel(epoch)
    if(conditional_trials(n))
        foo = logical(foo + histc(epoch{n},epoch_window));
    end
end


% createAndCatRegs(event_begin,event_end,epoch_window);

return

function b=findBlockLength(b)
%Will use expect script to find subject specific block length for specific
%run

fprintf('Logging into Thorndike now....\n')

%How many runs
for run = 1:b.total_blocks
    
    %set command string
    %cmd_str = sprintf('"C:/Users/emtre/OneDrive/Documents/GitHub/explore_clock/expectTest.exp %s %s"', num2str(b.id),num2str(run));
    %JW: Let's make sure the expect scripts are in a dir called aux scripts
    %from now on
    %Need to provide full path!
% % %     dir('aux_scripts')
% % %     cmd_str = sprintf('"aux_scripts/sharkGrabVolumes.exp %s %s"', num2str(b.id),num2str(run));
    exp_file_path = what('aux_scripts');
    exp_file_path = strrep([exp_file_path.path '/sharkGrapVolumes.exp'],'\','/');
    cmd_str = sprintf('"%s %s %s"',exp_file_path, num2str(b.id),num2str(run));
    
    
    %set command string based on which directory you are currently in (explore_clock or bpd_clock)
    %     cdir= cd;
    %     if strcmp(cdir,'C:\Users\emtre\OneDrive\Documents\GitHub\bpd_clock')
    %         cmd_str = sprintf('"C:/Users/emtre/OneDrive/Documents/GitHub/bpd_clock/expectTest.exp %s %s"', num2str(b.id),num2str(run));
    %     else
    %          cmd_str = sprintf('"C:/Users/emtre/OneDrive/Documents/GitHub/explore_clock/expectTest.exp %s %s"', num2str(b.id),num2str(run));
    %     end
    %cmd_str = sprintf('"c:/kod/explore_clock/aux_scripts/expectTest.exp %s %s"', num2str(b.id),num2str(run));
    
    %set cygwin path string
    cygwin_path_sting = 'E:\cygwin\bin\bash --login -c ';
    
    %Run it kick out if failed
    fprintf('Grabbing volumes....\n')
    [status,cmd_out]=system([cygwin_path_sting cmd_str]);
    if status==1
        error('Connection to Thorndike failed :(')
    end
    
    %Grab the volume number
    reg_out = regexp(cmd_out,'(?<=wc -l\s+)[0-9]{3,4}','match');
    
    %Make reg out a number
    b.block_length(run)=str2double(reg_out{1});
end



%Old code stash -- move to archive later
% %     %NOTE THIS NEEDS TO CHANGE I BELIEVE. b.rew_onset will refer to the
% %     %very last rew onset not the last rew onset of that block... both all
% %     %onset times need to reflet the current block
% %     trial_index_1 = b.trial_index(block_n);
% %     trial_index_2 = trial_index_1 + b.trials_per_block-1;
% %     %epoch_window = b.stim1_onset(1):bin_size:(b.rew_onset(end)+moneytime+jittertime);
% %     %epoch_window = b.stim1_onset(1):bin_size:b.stim1_onset(1)+scan_tr*block_length*1000;
% %     epoch_window = b.stim1_onset(trial_index_1):bin_size:(b.rew_onset(trial_index_2)+moneytime+jittertime);
% %     
% %     %     if sum(b.missed) == 0
% % %         tmp_reg.(['regressors' num2str(block_n)]).to_censor = ones(size( tmp_reg.(['regressors' num2str(block_n)]).decision_level_1));
% % %     else
% % %         event_beg = b.stim1_onset; event_end =b.rew_onset+(moneytime+jittertime);
% % %         tmp_reg.(['regressors' num2str(block_n)]).to_censor = ...
% % %             createSimpleRegressor(event_beg, event_end, epoch_window, b.missed);
% % %         tmp_reg.(['regressors' num2str(block_n)]).to_censor = ones(size(tmp_reg.(['regressors' num2str(block_n)]).to_censor)) - tmp_reg.(['regressors' num2str(block_n)]).to_censor;
% % %     end
% %     
% %     
% %     %Censor out any "bad trials" and the shark of the attack trial and next
% %     %trial
% %     event_beg = b.stim1_onset(trial_index_1:trial_index_2); event_end =b.rew_onset(trial_index_1:trial_index_2)+(moneytime+jittertime);
% %     %Add in a bit of code that will just add some time to stim1_onset
% %     %for the missed trials in event end. Then we should be good until we talk
% %     %it over with Alex...
% %     missed_time = 6000; %They have 5 seconds to respond plus a ~1sec x animation? No fixation crosses after missed trial! <- Alex thoughts?
% %     event_end(b.missed(trial_index_1:trial_index_2)) = b.stim1_onset(b.missed(trial_index_1:trial_index_2)) + missed_time;
% %     
% %     %This was the version that would censor the missed trials and the shark
% %     % tmp_reg.(['regressors' num2str(block_n)]).to_censor = ...
% %     %     createSimpleRegressor(event_beg, event_end, epoch_window,shark_epoch,b.missed(trial_index_1:trial_index_2));
% %     % tmp_reg.(['regressors' num2str(block_n)]).to_censor = ones(size(tmp_reg.(['regressors' num2str(block_n)]).to_censor)) - tmp_reg.(['regressors' num2str(block_n)]).to_censor;
% %     
% %     
% %     %Only censor shark
% %     tmp_reg.(['regressors' num2str(block_n)]).to_censor = ...
% %         createSimpleRegressor(event_beg, event_end, epoch_window,shark_epoch,zeros(1,length(b.missed(trial_index_1:trial_index_2))));
% %     tmp_reg.(['regressors' num2str(block_n)]).to_censor = ones(size(tmp_reg.(['regressors' num2str(block_n)]).to_censor)) - tmp_reg.(['regressors' num2str(block_n)]).to_censor;
% %     
% %     
% %     
% %     % % HRF-convolve all the event regressors
% %     % hrfregs = fieldnames(rmfield(tmp_reg.regressors1,{'to_censor','missed_RT'}));
% %     %% AD: I would say we don't need to analyze missed RTs
% %     hrfregs = fieldnames(rmfield(tmp_reg.regressors1,{'to_censor'}));
% %     fprintf('HRF Convolving\n\n')
% %     for n = 1:numel(hrfregs)
% %         % b.hrfreg1.RT
% %         tmp_reg.(['hrfreg' num2str(block_n)]).(hrfregs{n}) = ...
% %             conv(1*tmp_reg.(['regressors' num2str(block_n)]).(hrfregs{n}),hemoir);
% %         %% ask Alex for gsresample
% %         % cut off the tail after convolution and downsample
% %         tmp = gsresample(tmp_reg.(['hrfreg' num2str(block_n)]).(hrfregs{n}),10,1./scan_tr);
% %         %If the scanner runs for to long the tmp var is too short
% %         if length(tmp)<block_length(block_n)
% %             zeros_to_add = block_length(block_n)-length(tmp);
% %             tmp = [tmp zeros(1,zeros_to_add)];
% %         end
% %         tmp_reg.(['hrfreg' num2str(block_n)]).(hrfregs{n}) = tmp(1:block_length(block_n)-1); %should be tmp(1:block_length) where block_length = the total number of TRs that the scanner ran
% %         
% %         fprintf('Percent complete...%.2f\n',n/numel(hrfregs))
% %         
% %     end
% %     
% %     
% %     % shift the tocensor AND BLOCK regressor by the HRF lag = 5 seconds
% %     % we put ALL BOXCARS in HRFREGs FOR SIMPLICITY, but they are not HRF-convolved
% %     
% %     % NB: the first 5s are censored because they capture HRF to events
% %     % preceding the first trial
% %     tmp = gsresample( ...
% %         [zeros(50,1)' tmp_reg.(['regressors' num2str(block_n)]).to_censor(1:end-51)], ...
% %         10,1./scan_tr);
% %     %add 12 TRs to to_censor as a fix for scanner running longer
% %     
% %     %% AD as a stupid hack, we will add an extra volume at the end, 12+1 TRs
% %     %%%%tmp = [tmp 1 1 1 1 1 1 1 1 1 1 1 1 1];
% %     
% %     %tmp = [tmp ones(1,(block_length(block_n)-1)-length(tmp))];
% %     tmp = [tmp ones(1,(block_length(block_n))-length(tmp))]; %This minus 1 was causing the censore file to lose a volume for each block
% %     
% %     % cut off the tail
% %     %tmp_reg.(['hrfreg' num2str(block_n)]).to_censor  = floor(tmp(1:block_length(block_n)-1));
% %     tmp_reg.(['hrfreg' num2str(block_n)]).to_censor  = floor(tmp(1:block_length(block_n))); %This minus 1 was causing the censore file to lose a volume for each block
