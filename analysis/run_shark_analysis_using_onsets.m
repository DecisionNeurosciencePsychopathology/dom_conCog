%Script to read in and analzye shark task behavioual data
%By: Jonathan Wilson
%Matlab version: 2015a
%Date created: 10/16/2015

function [ret,stay_data,data]=run_shark_analysis_using_onsets(file_name,subj_num)
%% File i/o
data = load(file_name); %Load in data
contingency_length = length(data.rts1)/4; %blocks = shark|no shark
block_length = length(data.rts1)/2; %runs = full scanner runs 1, 2, ect or seperating one full contingency run

%Grab the dir id
expr='\\([0-9]+)\\';
id = regexp(file_name,expr,'tokens');
id = str2double(id{:});
id_str = num2str(id);

%% Create trial indexes of win/loss, common/rare, and stay/switch trials
%Trial vector
trial = 1:length(data.money);

%Win/loss
win_trials = data.money==1;
loss_trials = data.money==0;

%Common/Rare
common_trials   = (data.choice1==1 & data.state==2) | (data.choice1==2 & data.state==3);
rare_trials     = (data.choice1==1 & data.state==3) | (data.choice1==2 & data.state==2);
data.common_trials = common_trials;

%Stay/switch -- index starts at 1 asking Did subject switch from trial 1 to trial 2?
stay_trials     = data.choice1 == [data.choice1(2:end) 0];
switch_trials = ~stay_trials;
switch_trials(end) = 0; %There can't be a switch from trial 100 to 101
data.switch_trials = switch_trials;

%Interactions
%Win/loss - common/rare
win_common_trials = win_trials & common_trials;
loss_common_trials = loss_trials & common_trials;
win_rare_trials = win_trials & rare_trials;
loss_rare_trials = loss_trials & rare_trials;

%Win/loss - common/rare - stay/switch
win_common_stay_trials = win_common_trials & stay_trials;
loss_common_stay_trials = loss_common_trials & stay_trials;
win_rare_stay_trials = win_rare_trials & stay_trials;
loss_rare_stay_trials = loss_rare_trials & stay_trials;

%Make some quick checks on vector lengths
if sum(win_rare_trials) + sum(loss_rare_trials) ~= sum(rare_trials)
    error('Rare trials don''t add up! This is bad!');
elseif sum(win_common_trials) + sum(loss_common_trials) ~= sum(common_trials)
    error('Common trials don''t add up! This is bad!');
end


%Ask Alex about this part with pcts....
win_common_stay_pct = sum(win_common_stay_trials)/(sum(win_common_trials));
win_rare_stay_pct = sum(win_rare_stay_trials)/(sum(win_rare_trials));
loss_common_stay_pct = sum(loss_common_stay_trials)/(sum(loss_common_trials));
loss_rare_stay_pct = sum(loss_rare_stay_trials)/(sum(loss_rare_trials));


%Print out some data
fprintf('Subject %d\n',subj_num)
fprintf('Total wins: %d\n', sum(data.money))
fprintf('The number of stay trials were: %d\n',sum(stay_trials))
fprintf('The number of switch trials were: %d\n\n',sum(switch_trials))


%For those who contingency didn't get saved
try
    if (data.contingency || id)
    end
catch
    if data.attack<50
        data.contingency=1;
    else
        data.contingency=2;
    end
    expression = '(\w{3,6})_shark*';
    id = regexp(file_name,expression,'match');
    tmp = id{1};
    id = tmp(1:4);
    data = rmfield(data,'ans');
end

%Grab contingency and warnings
contingency = data.contingency(1);
warnings = data.warnings;


%% --Shark--
shark_block = [warnings(1):warnings(1)+contingency_length-1;warnings(2):warnings(2)+contingency_length-1];
shark_trials = sort(reshape(shark_block,block_length,1));
data.shark = zeros(1,length(trial));
data.shark(shark_trials)=1;
shark_trials = data.shark; %For now just rename shark trials to be a logical

%% define shark common|rare|win|stay
win_common_stay_shark_trials = win_common_stay_trials & shark_trials;
win_common_stay_no_shark_trials = win_common_stay_trials & ~shark_trials;

loss_common_stay_shark_trials = loss_common_stay_trials & shark_trials;
loss_common_stay_no_shark_trials = loss_common_stay_trials & ~shark_trials;

win_rare_stay_shark_trials = win_rare_stay_trials & shark_trials;
win_rare_stay_no_shark_trials = win_rare_stay_trials & ~shark_trials;

loss_rare_stay_shark_trials = loss_rare_stay_trials & shark_trials;
loss_rare_stay_no_shark_trials = loss_rare_stay_trials & ~shark_trials;

%create demoninator vectors
win_common_shark = win_common_trials & shark_trials;
win_common_no_shark = win_common_trials & ~shark_trials;

win_rare_shark = win_rare_trials & shark_trials;
win_rare_no_shark = win_rare_trials & ~shark_trials;

loss_common_shark = loss_common_trials & shark_trials;
loss_common_no_shark = loss_common_trials & ~shark_trials;

loss_rare_shark = loss_rare_trials & shark_trials;
loss_rare_no_shark = loss_rare_trials & ~shark_trials;


%% Probabilites
win_common_stay_shark_pct = sum(win_common_stay_shark_trials)/(sum(win_common_shark));
win_common_stay_no_shark_pct = sum(win_common_stay_no_shark_trials)/(sum(win_common_no_shark));

win_rare_stay_shark_pct = sum(win_rare_stay_shark_trials)/(sum(win_rare_shark));
win_rare_stay_no_shark_pct = sum(win_rare_stay_no_shark_trials)/(sum(win_rare_no_shark));

loss_common_stay_shark_pct = sum(loss_common_stay_shark_trials)/(sum(loss_common_shark));
loss_common_stay_no_shark_pct = sum(loss_common_stay_no_shark_trials)/(sum(loss_common_no_shark));

loss_rare_stay_shark_pct = sum(loss_rare_stay_shark_trials)/(sum(loss_rare_shark));
loss_rare_stay_no_shark_pct = sum(loss_rare_stay_no_shark_trials)/(sum(loss_rare_no_shark));



%% Figures
%Make Daw-esqe figure

fig_num = 10*(ceil(subj_num/10.))-10; %10 is 5 rows x 2 cols
sub_plot_num = mod(subj_num,10);

if sub_plot_num==0
    sub_plot_num = 10;
end

if fig_num==0
    fig_num=1;
end

figure(fig_num)
subplot(5,2,sub_plot_num)
stay_data = [win_common_stay_pct win_rare_stay_pct; loss_common_stay_pct loss_rare_stay_pct];
b = bar(stay_data);
b(2).FaceColor = 'r';
title(['Analysis of Choice Behavior for subject ' id_str])
%set(b,'xtick',1)
name = {'Reward'; 'Loss'};
set(gca,'xticklabel',name,'fontsize',9)
if fig_num==1
    legend('Common', 'Rare')
end

%Make Daw-esqe figure with shark graph
figure(fig_num+1)
subplot(5,2,sub_plot_num)
stay_shark_data = [win_common_stay_shark_pct win_common_stay_no_shark_pct; win_rare_stay_shark_pct win_rare_stay_no_shark_pct;...
    loss_common_stay_shark_pct loss_common_stay_no_shark_pct; loss_rare_stay_shark_pct loss_rare_stay_no_shark_pct];
b = bar(stay_shark_data);
b(2).FaceColor = 'r';
title(['Analysis of Choice Behavior for subject ' id_str])
%set(b,'xtick',1)
name = {'Reward-Shark'; 'Reward-No Shark'; 'Loss-Shark'; 'Loss- No Shark'};
set(gca,'xticklabel',name,'fontsize',9)
if sub_plot_num==1
    legend('Common', 'Rare')
end

%% data out
%Create function that will only return the proper fieldnames...
d_fnames = fieldnames(data);
keep_names = {'attack';'choice1';'choice1_ons_ms';'choice1_ons_sl';'choice2';...
    'choice2_ons_ms';'choice2_ons_sl';'contingency';'keycode1';'keycode2';'money';'name';...
    'rew_ons_ms';'rew_ons_sl';'rts1';'rts2';'state';'stim1_ons_ms';...
    'stim1_ons_sl';'stim2_ons_ms';'stim2_ons_sl';'swap_hist';'totalwon';'trial';'warnings';...
    'shark';'money';'stay';'common';'name';'ac_outcome';'ad_outcome';'bc_outcome';'bd_outcome'; 'switch_trials';...
    'common_trials';};
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
ret.id = id;
ret.num_wins = sum(win_trials);
ret.num_loss = sum(loss_trials);
ret.num_common = sum(common_trials);
ret.num_rare = sum(rare_trials);
ret.num_stay = sum(stay_trials);
ret.num_switch = sum(switch_trials);
ret.win_common_stay_pct = win_common_stay_pct;
ret.win_rare_stay_pct = win_rare_stay_pct;
ret.loss_common_stay_pct = loss_common_stay_pct;
ret.loss_rare_stay_pct = loss_rare_stay_pct;
ret.win_common_stay_shark_pct = win_common_stay_shark_pct;
ret.win_common_stay_no_shark_pct = win_common_stay_no_shark_pct;
ret.win_rare_stay_shark_pct = win_rare_stay_shark_pct;
ret.win_rare_stay_no_shark_pct = win_rare_stay_no_shark_pct;
ret.loss_common_stay_shark_pct = loss_common_stay_shark_pct;
ret.loss_common_stay_no_shark_pct = loss_common_stay_no_shark_pct;
ret.loss_rare_stay_shark_pct = loss_rare_stay_shark_pct;
ret.loss_rare_stay_no_shark_pct = loss_rare_stay_no_shark_pct;
ret.contingency = contingency;
