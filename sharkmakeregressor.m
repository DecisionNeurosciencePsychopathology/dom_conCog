function b = sharkmakeregressor(id)
% Jon Wilson & Alex Dombrovski
% 2015-10: Script creation

%Take care of file creations
data_dir_str= ['C:\kod\dom_conCog\shark_data'];
filename = sprintf('C:\\kod\\dom_conCog\\regs\\%s\\shark%s.mat', id,id);
data_dump_str=sprintf('C:\\kod\\dom_conCog\\regs\\%s\\',id);

if ~exist(data_dump_str,'file')
    mkdir(data_dump_str)
    fprintf('Creating id specific reg folder in: %s\n\n',data_dump_str);
end



%Grab files and names
files = dir(data_dir_str);
%file_names = extractfield(files, 'name')';
file_names = {files.name};
%expression = ('\t*rs\d*'); %Need to add .txt and rerun these guys to grab proper file
expression = [id '.*_onsets.mat']; %Need to add .txt and rerun these guys to grab proper file
%Regex
ind = cellfun(@(x)( ~isempty(x) ), regexp(file_names, expression));

fname = cell2mat(file_names(ind)); %Convert to string

fprintf('File processing: %s\n', fname);

%Load in the data
load([data_dir_str '\' fname])
trials = 200; %Currently just one giant block
%Some times hard coded in the task
moneytime = 1500;
isitime = 1000;
ititime = 1000;
choicetime = 3000;
jittertime=1500;
start = 0;
%Find trials where there was no response
%Will we need one for both levels?
b.missed = (rts1==0 & rts2==0);

%Win/losses win=1 loss=0
b.win_trials = money;
b.loss_trials = ~b.win_trials;


%Seperate into levels initially
%Blue  = 1 Green = 2
%Left choice = 1 right choice = 2
b.decision_level_1_blueRocket = (choice1==1);
b.decision_level_1_greenRocket = (choice1==2);
b.decision_level_2_alien_1 = (choice2==1); 
b.decision_level_2_alien_2 = (choice2==2);

%Switch and stay trials
b.stay_trials = [1 choice1(1:end-1) == [choice1(2:end)]];

%Before index 5 was the switch trial??
b.switch_trials = [0 choice1(1:end-1) ~= [choice1(2:end)]];

%Switches are 1 stays are -1, same scheme for win/loss
b.switch_stay = b.switch_trials + b.stay_trials.*-1;
b.win_loss = b.win_trials + b.loss_trials.*-1;


%Motor regressor
%11/30/15 use keycode 1 and 2 for motor regs
b.left_index_level_1 =(keycode1==1);
b.right_index_level_1 =(keycode1==2);
b.left_index_level_2 = (keycode2==1);
b.right_index_level_2 = (keycode2==2);

%Combine both right and left right is positive
b.right_left_index_level_1 = double(b.right_index_level_1);
b.right_left_index_level_1(b.right_index_level_1==0) = -1;
b.right_left_index_level_2 = double(b.right_index_level_2);
b.right_left_index_level_2(b.right_index_level_2==0) = -1;

%Freqeunt inFrequent
b.frequent_trials = ((choice1==1 & state==2) | (choice1==2 & state==3));
b.infrequent_trials = ~b.frequent_trials;

%Shark trial or not
b.shark_trials = zeros(1,trials);
threat_blocks = [warnings(1):warnings(1)+49 warnings(2):warnings(2)+49];
b.shark_trials(threat_blocks) = 1;
b.no_shark_trials = ~b.shark_trials;

%Grab times

%Stimulus presentation
b.stim1_onset = stim1_ons_ms;
b.stim2_onset = stim2_ons_ms;

b.choice1_onset_ms = choice1_ons_ms;
b.choice2_onset_ms = choice2_ons_ms;

b.rts1= rts1; %appears to be in seconds
b.rts2= rts2;

b.rew_onset = rew_ons_ms;




scan_tr = 1;
%Via 3d_info

%Since we didn't have a specific time to run the scan till, we had to tell
%the tech to stop the scan, as with TCAO, as a result the first 3 pilots
%for this task had different scan block lengths...

if strcmp('TCAO',id)
    block_length = 1651; %One mega block
elseif strcmp('MARLE',id)
    block_length = 1712;
elseif strcmp('JANO',id)
    block_length = 1724;
end
tr = 0.1; %10Hz

%% ask Alex for spm_hrf
hemoir = spm_hrf(tr, [6,16,1,1,6,0,32]); % better than resampling and smoothing

fprintf('computing regressors...\n');
frequency_scale_hz = 10;
% this scale is in msec, but it is separated into bins of X
% Hz (defined by 'frequency_scale' above. the resulting
% output will be in the scale of X Hz.
bin_size = 1/frequency_scale_hz*1000; % convert Hz to mseccds ..

%Currently only 1 mega block
%x = {1:exchangeNum; exchangeNum+1:2*exchangeNum; 2*exchangeNum+1:3*exchangeNum; 3*exchangeNum+1:4*exchangeNum;};
block_n=1;

%epoch_window defines the time interval from first stimulus onset to last
%feedback offset, for each block, in this case we have one mega block...
%Currently this is to the end of the second jitter screen
epoch_window = b.stim1_onset(1):bin_size:(b.rew_onset(end)+moneytime+jittertime);
%epoch_window = b.stim1_onset(1):bin_size:b.stim1_onset(1)+scan_tr*block_length*1000;


% for decision screens, RTs, from partnerchoice onset to response
event_beg = b.stim1_onset;
event_end = b.choice1_onset_ms;
[b.stim_times.dec1_fsl,b.stim_times.dec1_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'decision_level_1_Times',1,1);
[b.stim_times.switchStay_fsl,b.stim_times.switchStay_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'switch_stay_Times',b.switch_stay); %switch 1 stay -1

%When using the -stim_times instead of the -stim_times_FSL option
[b.stim_times.switch_fsl,b.stim_times.switch_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'switch_Times',b.switch_trials,1); 
[b.stim_times.stay_fsl,b.stim_times.stay_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'stay_Times',b.stay_trials,1); 

tmp_reg.(['regressors' num2str(block_n)]).decision_level_1 = ...
    createSimpleRegressor(event_beg,event_end,epoch_window);

% for decision screens, RTs, from partnerchoice onset to response
event_beg = b.stim2_onset;
event_end = b.choice2_onset_ms;
[b.stim_times.dec2_fsl,b.stim_times.dec2_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'decision_level_2_Times',1,1);
[b.stim_times.left_fsl,b.stim_times.left_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'left_index',b.left_index_level_2,1);
[b.stim_times.right_fsl,b.stim_times.right_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'right_index',b.right_index_level_2,1);
tmp_reg.(['regressors' num2str(block_n)]).decision_level_2 = ...
    createSimpleRegressor(event_beg,event_end,epoch_window);


%Very basic regressor, start from onset of stimulus to offset of
%feedback.
event_beg =  b.stim1_onset;
event_end = b.rew_onset+moneytime;
%write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'trial_Times');
[b.stim_times.trial_fsl,b.stim_times.trial_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'trial_Times',1,1);
tmp_reg.(['regressors' num2str(block_n)]).trial = ...
    createSimpleRegressor(event_beg,event_end,epoch_window);


% for feedback, from feedback onset to feedback offset
event_beg = b.rew_onset;
event_end = b.rew_onset+moneytime;
[b.stim_times.feed_fsl,b.stim_times.feed_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'feedback_Times',1,1);
[b.stim_times.winLoss_fsl,b.stim_times.winLoss_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'win_loss_Times',b.win_loss); %wins are 1 loss is -1
[b.stim_times.win_fsl,b.stim_times.win_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'win_Times',b.win_trials,1); %Only win trials
[b.stim_times.loss_fsl,b.stim_times.loss_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'loss_Times',b.loss_trials,1); %Only loss trials
tmp_reg.(['regressors' num2str(block_n)]).feedback = ...
    createSimpleRegressor(event_beg,event_end,epoch_window);


%%%% DMUBLOCK %%%%
%12/1/15 JW: Because we aren't getting very good maps when looking at
%regressors, but seeing activity via the R^2, let's create a trial
%regressor by combining everything except the "jitters" aka the ISI and
%ITI.
%Trial
event_beg = sort([stim1_ons_ms stim2_ons_ms]);
event_end=sort([(choice1_ons_ms+isitime) (rew_ons_ms+moneytime)]);
[b.stim_times.feed_fsl,b.stim_times.feed_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'trialNoJitters',1);
%Decision 1
event_beg = b.stim1_onset;
event_end = choice1_ons_ms+isitime;
[b.stim_times.dec1_fsl,b.stim_times.dec1_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'decision_level_1_Times',1);
%Switch stay
[b.stim_times.switchStay_fsl,b.stim_times.switchStay_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'switch_stay_Times',b.switch_stay); %switch 1 stay -1

%Motor level 1
event_beg = b.stim1_onset;
event_end = choice1_ons_ms;
[b.stim_times.left_1_fsl,b.stim_times.left_1_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'left_index_level_1',b.left_index_level_1);
[b.stim_times.right_1_fsl,b.stim_times.right_1_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'right_index_level_1',b.right_index_level_1);
[b.stim_times.right_left_1_fsl,b.stim_times.right_left_1_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'right_left_index_level_1',b.right_left_index_level_1);


%Decision 2
event_beg = b.stim2_onset;
event_end = b.choice2_onset_ms+isitime;
[b.stim_times.dec2_fsl,b.stim_times.dec2_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'decision_level_2_Times',1);
[b.stim_times.feq_trials_fsl,b.stim_times.feq_trials_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'freq_infreq_Times',(b.frequent_trials+(b.infrequent_trials*-1)));
%Motor level 2
event_beg = b.stim2_onset;
event_end = choice2_ons_ms;
[b.stim_times.left_2_fsl,b.stim_times.left_2_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'left_index_level_2',b.left_index_level_2);
[b.stim_times.right_2_fsl,b.stim_times.right_2_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'right_index_level_2',b.right_index_level_2);
[b.stim_times.right_left_1_fsl,b.stim_times.right_left_1_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'right_left_index_level_2',b.right_left_index_level_2);


%Full motor
event_beg = sort([b.stim1_onset b.stim2_onset]);
event_end = sort([choice1_ons_ms choice2_ons_ms;]);
b.right_left_index = zeros(1,400);
b.right_left_index(1:2:end) = b.right_left_index_level_1;
b.right_left_index(2:2:end) = b.right_left_index_level_2;
[b.stim_times.right_left_fsl,b.stim_times.right_left_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'right_left_index',b.right_left_index);


%Feedback
event_beg = b.rew_onset;
event_end = b.rew_onset+moneytime;
[b.stim_times.feed_fsl,b.stim_times.feed_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'feedback_Times',1);
%Win/Loss 1/-1
[b.stim_times.winLoss_fsl,b.stim_times.winLoss_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'win_loss_Times',b.win_loss); %wins are 1 loss is -1
[b.stim_times.winLoss_fsl,b.stim_times.winLoss_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'win_loss_Times_win_minus1',(b.win_loss*-1)); %wins are 1 loss is -1
%[b.stim_times.winLoss_fsl,b.stim_times.winLoss_spmg]=write3Ddeconv_startTimes(data_dump_str,event_beg,event_end,'win_loss_TimesMC',b.win_loss-mean(b.win_loss)); %wins are 1 loss is -1





%%%%%%%%%%%%%%%%%%

%create to_censor vector
%% AD: I haven't checked this
if sum(b.missed) == 0
   tmp_reg.(['regressors' num2str(block_n)]).to_censor = ones(size( tmp_reg.(['regressors' num2str(block_n)]).decision_level_1));
else
event_beg = b.stim1_onset; event_end =b.rew_onset+(moneytime+jittertime);
tmp_reg.(['regressors' num2str(block_n)]).to_censor = ...
    createSimpleRegressor(event_beg, event_end, epoch_window, b.missed);
tmp_reg.(['regressors' num2str(block_n)]).to_censor = ones(size(tmp_reg.(['regressors' num2str(block_n)]).to_censor)) - tmp_reg.(['regressors' num2str(block_n)]).to_censor;
end
% % HRF-convolve all the event regressors
% hrfregs = fieldnames(rmfield(tmp_reg.regressors1,{'to_censor','missed_RT'}));
%% AD: I would say we don't need to analyze missed RTs
hrfregs = fieldnames(rmfield(tmp_reg.regressors1,{'to_censor'}));
fprintf('HRF Convolving\n\n')
for n = 1:numel(hrfregs)
    % b.hrfreg1.RT
    tmp_reg.(['hrfreg' num2str(block_n)]).(hrfregs{n}) = ...
        conv(1*tmp_reg.(['regressors' num2str(block_n)]).(hrfregs{n}),hemoir);
    %% ask Alex for gsresample
    % cut off the tail after convolution and downsample
    tmp = gsresample(tmp_reg.(['hrfreg' num2str(block_n)]).(hrfregs{n}),10,1./scan_tr);
    %If the scanner runs for to long the tmp var is too short
    if length(tmp)<block_length(block_n)
        zeros_to_add = block_length(block_n)-length(tmp);
        tmp = [tmp zeros(1,zeros_to_add)];
    end
    tmp_reg.(['hrfreg' num2str(block_n)]).(hrfregs{n}) = tmp(1:block_length(block_n)-1); %should be tmp(1:block_length) where block_length = the total number of TRs that the scanner ran
    
    fprintf('Percent complete...%.2f\n',n/numel(hrfregs))
    
end


% shift the tocensor AND BLOCK regressor by the HRF lag = 5 seconds
% we put ALL BOXCARS in HRFREGs FOR SIMPLICITY, but they are not HRF-convolved

% NB: the first 5s are censored because they capture HRF to events
% preceding the first trial
tmp = gsresample( ...
    [zeros(50,1)' tmp_reg.(['regressors' num2str(block_n)]).to_censor(1:end-51)], ...
    10,1./scan_tr);
%add 12 TRs to to_censor as a fix for scanner running longer

%% AD as a stupid hack, we will add an extra volume at the end, 12+1 TRs
%%%%tmp = [tmp 1 1 1 1 1 1 1 1 1 1 1 1 1];

tmp = [tmp ones(1,(block_length-1)-length(tmp))];

% cut off the tail
tmp_reg.(['hrfreg' num2str(block_n)]).to_censor  = floor(tmp(1:block_length(block_n)-1));

%End of block loop if we had one

b.tmp_regs = tmp_reg;

%% concatenate everything
%% CAREFUL here, number of blocks is hard-coded
fnm = fieldnames(tmp_reg.hrfreg1)';
for ct=1:length(fnm)
   % b.hrf_regs.(fnm{ct}) = [tmp_reg.hrfreg1.(fnm{ct}) tmp_reg.hrfreg2.(fnm{ct}) tmp_reg.hrfreg3.(fnm{ct}) tmp_reg.hrfreg4.(fnm{ct})];
    b.hrf_regs.(fnm{ct}) = [tmp_reg.hrfreg1.(fnm{ct}) 0];
end

%JW:why subtract 1 here?? Commented out 1-(ceil...)
%b.hrf_regs.to_censor = 1-(ceil(b.hrf_regs.to_censor));
b.hrf_regs.to_censor = b.hrf_regs.to_censor(1:length(b.hrf_regs.decision_level_1));


%save individual file, see top for path
save(filename,'b');

%cd('C:/regs/')
 %cd(['/Users/',username,'/Box Sync/Suicide studies/regs/trust_current_regs/'])
 cd(data_dump_str)
 %Note the formatting string here currently its %s but it will be %d in
 %future releases
gdlmwrite(sprintf('shark%s.regs',id),[ ...
    b.hrf_regs.to_censor' ...                 % 0    trials with responses
    b.hrf_regs.decision_level_1' ...                  % 1    RT
    b.hrf_regs.decision_level_2' ...                  % 2    RT
    b.hrf_regs.trial' ... %3 simple regressor from stimulus onset to feedback offset
    b.hrf_regs.feedback' ...                  % 4    feedback
    ],'\t');




%We wanted to use FSL to create the initial regs, this command will make
%the input file for this way of analysis
% gdlmwrite(sprintf('shark%s.regs',id),[ ...
%     b.fsl.to_censor' ...                 % 0    trials with responses
%     b.fsl.decision_level_1' ...                  % 1    RT
%     b.fsl.decision_level_2' ...                  % 2    RT
%     b.fsl.trial' ... %3 simple regressor from stimulus onset to feedback offset
%     b.fsl.feedback' ...                  % 4    feedback
%     ],'\t');


return



%%%%%%%%%%%% Regressor functions %%%%%%%%%%%%%
function foo = createSimpleRegressor(event_begin,event_end,epoch_window,conditional_trials)

% TODO: incorporate concatenation of different blocks in this function (maybe?)

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

%parametric_mult = b.condition;
function foo = createParametricRegressor(event_begin,event_end,epoch_window,parametric_mult)
% similar to the other regressor function, but does what Alex thought the other one
% initially did (multiply, not filter)

% this was not ab problem earlier, but for some reason it is now: find indices that would
% result in a negative value and set them both to 0
qbz = ( event_begin == 0 ); qez = ( event_end == 0 );
event_begin( qbz | qez ) = 0; event_end( qbz | qez ) = 0;

% check if optional parametric variable was used
if(~exist('parametric_mult','var') || isempty(parametric_mult))
    parametric_mult = ones(length(event_begin),1);
end

% create epoch windows for each trial
epoch = arrayfun(@(a,b) a:b,event_begin,event_end,'UniformOutput',false);

% for each "epoch" (array of event_begin -> event_end), count events
per_event_histcs = cellfun(@(h) logical(histc(h,epoch_window)),epoch,'UniformOutput',false);

tmp = zeros(size(per_event_histcs{1}));
for n = 1:numel(per_event_histcs)
    tmp = tmp + parametric_mult(n)*per_event_histcs{n};
end

foo = tmp;

return


function [x,y]=write3Ddeconv_startTimes(file_loc,event_beg,event_end,fname,censor,noFSL)

if nargin <6
    %censor = 1;
    noFSL=0;
end
format long
x(:,1) = event_beg';
x(:,2) = event_end'-event_beg';
x=x./1000; %Convert to seconds
x(:,3) = ones(length(x),1).*censor';

%write the -stim_times_FSL
if ~noFSL
    %Save to regs folder
    dlmwrite([file_loc fname '.dat'],x,'delimiter','\t','precision','%.6f')
    y=0;
else
    %write the -stim_times file
    fname = [fname '_noFSL'];
    y = x(logical(x(:,3)),1)';
    %Quick fix hack for just first ten trials troubleshoot SPMG2
    %y = y(1:10);
    dlmwrite([file_loc fname '.dat'],y,'delimiter','\t','precision','%.6f')
end
return
    