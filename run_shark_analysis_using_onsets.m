%Script to read in and analzye shark task behavioual data
%By: Jonathan Wilson
%Matlab version: 2015a
%Date created: 10/16/2015

function [ret,stay_data,data]=run_shark_analysis_using_onsets(file_name,fig_num)
%% File i/o
data = load(file_name);

contingency_length = length(data.rts1)/4; %blocks = shark|no shark
block_length = length(data.rts1)/2; %runs = full scanner runs 1, 2, ect or seperating one full contingency run

%% Create trial indexes of win/loss, common/rare, and stay/switch trials
win_trials = find(data.money==1);
loss_trials = find(data.money==0);
data.trial = 1:length(data.money);

%% Left choice = 1 Right choice = 2
%11/30/15 only the rockets switch sides, keycode1 = the actual decision
%i.e. did they chose left or right, choice is what rocket they chose blue being 1
%Green being 2.
data.common   = (data.choice1==1 & data.state==2) | (data.choice1==2 & data.state==3);
common_trials = data.trial(data.common);

data.rare     = (data.choice1==1 & data.state==3) | (data.choice1==2 & data.state==2);
rare_trials   = data.trial(data.rare);

data.stay     = data.choice1 == [data.choice1(2:end) 0];
stay_trials   = data.trial(data.stay);

% data.switch   = data.trial(data.choice1 ~= [data.choice1(1) data.choice1(1:end-1)]);
switch_trials = 1 - stay_trials;

win_common_trials=win_trials(ismember(win_trials,common_trials));
loss_common_trials = loss_trials(ismember(loss_trials,common_trials));
win_rare_trials=win_trials(ismember(win_trials,rare_trials));
loss_rare_trials=loss_trials(ismember(loss_trials,rare_trials));


win_common_stay_trials=win_common_trials(ismember(win_common_trials,stay_trials));
loss_common_stay_trials=loss_common_trials(ismember(loss_common_trials,stay_trials));
win_rare_stay_trials=win_rare_trials(ismember(win_rare_trials,stay_trials));
loss_rare_stay_trials=loss_rare_trials(ismember(loss_rare_trials,stay_trials));

%Ask Alex about this part with pcts....
win_common_stay_pct = length(win_common_stay_trials)/(length(win_common_trials));
win_rare_stay_pct = length(win_rare_stay_trials)/(length(win_rare_trials));
loss_common_stay_pct = length(loss_common_stay_trials)/(length(loss_common_trials));
loss_rare_stay_pct = length(loss_rare_stay_trials)/(length(loss_rare_trials));


%Make some quick checks on vector lengths
if length(win_rare_trials) + length(loss_rare_trials) ~= length(rare_trials)
    error('Rare trials don''t add up! This is bad!');
elseif length(win_common_trials) + length(loss_common_trials) ~= length(common_trials)
    error('Common trials don''t add up! This is bad!');
end


%Print out some data
fprintf('Subject %d\n',fig_num)
fprintf('Total wins: %d\n', sum(data.money))
fprintf('The number of stay trials were: %d\n',length(stay_trials))
fprintf('The number of switch trials were: %d\n\n',length(switch_trials))


%For those who contingency didn't get saved
try
    if (data.contingency || data.name)
    end
catch
    if data.attack<50
        data.contingency=1;
    else
        data.contingency=2;
    end
    expression = '(\w{3,6})_shark*';
    data.name = regexp(file_name,expression,'match');
    tmp = data.name{1};
    data.name = tmp(1:4);
    data = rmfield(data,'ans');
end

%Grab contingency and warnings
contingency = data.contingency(1);
warnings = data.warnings;


%% --Shark--
shark_block = [warnings(1):warnings(1)+contingency_length-1;warnings(2):warnings(2)+contingency_length-1];
shark_trials = sort(reshape(shark_block,block_length,1));
data.shark = zeros(1,length(data.trial));
data.shark(shark_trials)=1;

%% define shark common|rare|win|stay
win_common_stay_shark_trials=win_common_stay_trials(ismember(win_common_stay_trials,shark_trials));
win_common_stay_no_shark_trials=win_common_stay_trials(~ismember(win_common_stay_trials,shark_trials));

loss_common_stay_shark_trials=loss_common_stay_trials(ismember(loss_common_stay_trials,shark_trials));
loss_common_stay_no_shark_trials=loss_common_stay_trials(~ismember(loss_common_stay_trials,shark_trials));

win_rare_stay_shark_trials=win_rare_stay_trials(ismember(win_rare_stay_trials,shark_trials));
win_rare_stay_no_shark_trials=win_rare_stay_trials(~ismember(win_rare_stay_trials,shark_trials));

loss_rare_stay_shark_trials=loss_rare_stay_trials(ismember(loss_rare_stay_trials,shark_trials));
loss_rare_stay_no_shark_trials=loss_rare_stay_trials(~ismember(loss_rare_stay_trials,shark_trials));

%create demoninator vectors
win_common_shark = win_common_trials(ismember(win_common_trials,shark_trials));
win_common_no_shark = win_common_trials(~ismember(win_common_trials,shark_trials));

win_rare_shark = win_rare_trials(ismember(win_rare_trials,shark_trials));
win_rare_no_shark = win_rare_trials(~ismember(win_rare_trials,shark_trials));

loss_common_shark = loss_common_trials(ismember(loss_common_trials,shark_trials));
loss_common_no_shark = loss_common_trials(~ismember(loss_common_trials,shark_trials));

loss_rare_shark = loss_rare_trials(ismember(loss_rare_trials,shark_trials));
loss_rare_no_shark = loss_rare_trials(~ismember(loss_rare_trials,shark_trials));


%% Probabilites
win_common_stay_shark_pct = length(win_common_stay_shark_trials)/(length(win_common_shark));
win_common_stay_no_shark_pct = length(win_common_stay_no_shark_trials)/(length(win_common_no_shark));

win_rare_stay_shark_pct = length(win_rare_stay_shark_trials)/(length(win_rare_shark));
win_rare_stay_no_shark_pct = length(win_rare_stay_no_shark_trials)/(length(win_rare_no_shark));

loss_common_stay_shark_pct = length(loss_common_stay_shark_trials)/(length(loss_common_shark));
loss_common_stay_no_shark_pct = length(loss_common_stay_no_shark_trials)/(length(loss_common_no_shark));

loss_rare_stay_shark_pct = length(loss_rare_stay_shark_trials)/(length(loss_rare_shark));
loss_rare_stay_no_shark_pct = length(loss_rare_stay_no_shark_trials)/(length(loss_rare_no_shark));



%% Figures
%Make Daw-esqe figure
figure(1)
subplot(5,2,fig_num)
stay_data = [win_common_stay_pct win_rare_stay_pct; loss_common_stay_pct loss_rare_stay_pct];
b = bar(stay_data);
b(2).FaceColor = 'r';
title(['Analysis of Choice Behavior for subject ' data.name])
%set(b,'xtick',1)
name = {'Reward'; 'Loss'};
set(gca,'xticklabel',name,'fontsize',9)
if fig_num==1
    legend('Common', 'Rare')
end

%Make Daw-esqe figure with shark graph
figure(2)
subplot(5,2,fig_num)
stay_shark_data = [win_common_stay_shark_pct win_common_stay_no_shark_pct; win_rare_stay_shark_pct win_rare_stay_no_shark_pct;...
    loss_common_stay_shark_pct loss_common_stay_no_shark_pct; loss_rare_stay_shark_pct loss_rare_stay_no_shark_pct];
b = bar(stay_shark_data);
b(2).FaceColor = 'r';
title(['Analysis of Choice Behavior for subject ' data.name])
%set(b,'xtick',1)
name = {'Reward-Shark'; 'Reward-No Shark'; 'Loss-Shark'; 'Loss- No Shark'};
set(gca,'xticklabel',name,'fontsize',9)
if fig_num==1
    legend('Common', 'Rare')
end

%% data out
%Create function that will only return the proper fieldnames...
d_fnames = fieldnames(data);
keep_names = {'attack';'choice1';'choice1_ons_ms';'choice1_ons_sl';'choice2';...
    'choice2_ons_ms';'choice2_ons_sl';'contingency';'keycode1';'keycode2';'money';'name';...
    'rew_ons_ms';'rew_ons_sl';'rts1';'rts2';'state';'stim1_ons_ms';...
    'stim1_ons_sl';'stim2_ons_ms';'stim2_ons_sl';'swap_hist';'totalwon';'trial';'warnings';...
    'shark';'money';'stay';'common';'name';};
for i = 1:length(d_fnames)
    if ~ismember(d_fnames{i},keep_names)
        data=rmfield(data,d_fnames{i});
    end
end


%Rewrite these so its not confusing anymore
stay_data = [win_common_stay_pct; win_rare_stay_pct; loss_common_stay_pct; loss_rare_stay_pct];
stay_shark_data = [win_common_stay_shark_pct; win_common_stay_no_shark_pct; win_rare_stay_shark_pct; win_rare_stay_no_shark_pct;...
    loss_common_stay_shark_pct; loss_common_stay_no_shark_pct; loss_rare_stay_shark_pct; loss_rare_stay_no_shark_pct];


%Save resutls in ret struct
ret.win_common_stay_pct=win_common_stay_pct;
ret.win_rare_stay_pct=win_rare_stay_pct;
ret.loss_common_stay_pct=loss_common_stay_pct;
ret.loss_rare_stay_pct=loss_rare_stay_pct;
ret.win_common_stay_shark_pct= win_common_stay_shark_pct;
ret.win_common_stay_no_shark_pct=win_common_stay_no_shark_pct;
ret.win_rare_stay_shark_pct=win_rare_stay_shark_pct;
ret.win_rare_stay_no_shark_pct=win_rare_stay_no_shark_pct;
ret.loss_common_stay_shark_pct=loss_common_stay_shark_pct;
ret.loss_common_stay_no_shark_pct=loss_common_stay_no_shark_pct;
ret.loss_rare_stay_shark_pct=loss_rare_stay_shark_pct;
ret.loss_rare_stay_no_shark_pct=loss_rare_stay_no_shark_pct;
ret.contingency = contingency;
