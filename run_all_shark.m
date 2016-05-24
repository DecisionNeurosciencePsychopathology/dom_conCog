clear;
clc;
stay_data=[];
file_list=glob('C:\kod\dom_conCog\shark_data\*onsets.mat');
for i = 1:length(file_list)
    [s(i),temp_stay_data, td]=run_shark_analysis_using_onsets(file_list{i},i);
    trial_data(i) = orderfields(td); %You need to remove the fieldnames that JANO and MARLE dont have...
    stay_data = [stay_data temp_stay_data];
%     stay_shark_data = [stay_shark_data temp_stay_shark_data]; % each subject is a column
%     blk_data(i,:,:) = temp_blk_data;
end

position = 1;
for sub = 1:length(trial_data)
ntrials = length(trial_data(sub).money);
gee.subject(position:position+ntrials-1,1) = repmat({trial_data(sub).name},ntrials,1);
gee.stay(position:position+ntrials-1,1) = [trial_data(sub).stay];
gee.win(position:position+ntrials-1,1) = [trial_data(sub).money];
gee.common(position:position+ntrials-1,1) = [trial_data(sub).common];
gee.shark(position:position+ntrials-1,1) = [trial_data(sub).shark];
gee.trial(position:position+ntrials-1,1) = 1:ntrials;
position = position + ntrials;
end
geeTable = struct2table(gee);
%writetable(geeTable,'shark_gee_n=9_050316');

%[win common stay, win rare stay] vs [loss common stay, loss rare stay]
[h_stay,p_stay,ci_stay,stats_stay] = ttest([s.win_common_stay_pct; s.win_rare_stay_pct]',[s.loss_common_stay_pct; s.loss_rare_stay_pct]');

%[win common stay shark, win rare stay shark, loss common stay shark, loss rare stay shark] vs 
%[win common stay no shark, win rare stay no shark, loss common stay no shark, loss rare stay no shark]
[h_shark,p_shark,ci_shark,stats_shark] = ttest([s.win_common_stay_shark_pct; s.win_rare_stay_shark_pct; s.loss_common_stay_shark_pct; s.loss_rare_stay_shark_pct]',...
    [s.win_common_stay_no_shark_pct; s.win_rare_stay_no_shark_pct; s.loss_common_stay_no_shark_pct; s.loss_rare_stay_no_shark_pct]');


%Old del later
% [h_block,p_block,ci_block,stats_block] = ttest( blk_data(:,:,1:2), blk_data(:,:,3:end));

%% subjects are columns, so let's get row means
mean_stay_data = mean(stay_data,2);
%Plot grand mean of pstay probailites
figure(8); clf;
b = bar([mean_stay_data(1:2)'; mean_stay_data(3:end)']);
b(2).FaceColor = 'r';
title('Mean of Choice Behavior for subject')
name = {'Reward'; 'Loss'};
set(gca,'xticklabel',name,'fontsize',9)
ylabel('Stay')
legend('Common', 'Rare')

%% subjects are rows, so let's get column means
field_names = fieldnames(s);
for i = 1:length(field_names)
    mean_s.(field_names{i}) = mean([s.(field_names{i})]);
end

%% Plot grand mean of pstay probailites
figure(9); clf;
b = bar([[mean_s.win_common_stay_no_shark_pct mean_s.win_rare_stay_no_shark_pct];...
         [mean_s.loss_common_stay_no_shark_pct mean_s.loss_rare_stay_no_shark_pct];...
         [mean_s.win_common_stay_shark_pct mean_s.win_rare_stay_shark_pct];...
         [mean_s.loss_common_stay_shark_pct mean_s.loss_rare_stay_shark_pct]]);
b(2).FaceColor = 'r';
title('Mean of Choice Behavior for subject shark trials')
%set(b,'xtick',1)
name = {'Reward-No Shark'; 'Loss- No Shark';'Reward-Shark'; 'Loss-Shark'};
set(gca,'xticklabel',name,'fontsize',9)
ylabel('Stay')
legend('Common', 'Rare')

%% first, let's make sure there is a reward effect by comparing reward-common vs. loss-common (for both conditions)

% first, no shark
[h,p,ci,stats] = ttest([s.win_common_stay_pct]',[s.loss_common_stay_pct]');
% Shark
[h,p,ci,stats] = ttest([s.win_common_stay_shark_pct]',[s.loss_common_stay_shark_pct]');

[h,p,ci,stats] = ttest([s.win_rare_stay_pct]',[s.loss_rare_stay_pct]');


% first, shark no shark
[h,p,ci,stats] = ttest([s.win_common_stay_pct]',[s.loss_common_stay_pct]');
