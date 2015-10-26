stay_data=[];
stay_shark_data=[];
blk_data = [];
for i = 1:10
    file_list=glob('C:\kod\dom_conCog\shark_data\*.txt');
    [s.(['subj_' num2str(i)]) temp_stay_data temp_stay_shark_data temp_blk_data]=run_shark_analysis(file_list{i},i);
    stay_data = [stay_data temp_stay_data];
    stay_shark_data = [stay_shark_data temp_stay_shark_data];
    blk_data(i,:,:) = temp_blk_data;
end

stop=0;

%stay_data = [win_common_stay_pct; win_rare_stay_pct; loss_common_stay_pct; loss_rare_stay_pct];
%stay_shark_data = [win_common_stay_shark_pct; win_common_stay_no_shark_pct; win_rare_stay_shark_pct; win_rare_stay_no_shark_pct;...
%    loss_common_stay_shark_pct; loss_common_stay_no_shark_pct; loss_rare_stay_shark_pct; loss_rare_stay_no_shark_pct];


%[h_stay,p_stay,ci_stay,stats_stay] = ttest(stay_data');
%[h_shark,p_shark,ci_shark,stats_shark] = ttest(stay_shark_data');

%[h_shark,p_shark,ci_shark,stats_shark] = ttest(stay_shark_data(1:4,:)',stay_shark_data(5:8,:)');


% contingency_1_data=[];
% contingency_2_data=[];
% fieldname = fieldnames(s);
% 
% for i = 1:length(fieldname);
%     field=fieldname(i);
%     if s.(field{:}).contingency==1
%         contingency_1_data = [contingency_1_data stay_shark_data(:,i)];
%     else
%         contingency_2_data = [contingency_2_data stay_shark_data(:,i)];
%     end
% end
% 
% 
% [h_conting1,p_conting1,ci_conting1,stats_conting1] = ttest(contingency_1_data(1:2:end,:)',contingency_1_data(2:2:end,:)');
% [h_conting2,p_conting2,ci_conting2,stats_conting2] = ttest(contingency_2_data(1:2:end,:)',contingency_2_data(2:2:end,:)');

[h_stay,p_stay,ci_stay,stats_stay] = ttest(stay_data(1:2,:)',stay_data(3:end,:)')
[h_shark,p_shark,ci_shark,stats_shark] = ttest(stay_shark_data(1:2:end,:)',stay_shark_data(2:2:end,:)')
[h_block,p_block,ci_block,stats_block] = ttest( blk_data(:,:,1:2), blk_data(:,:,3:end))

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


mean_stay_shark_data = mean(stay_shark_data,2);
%Reshape data for graph
mean_stay_shark_data = [mean_stay_shark_data(1:2) mean_stay_shark_data(3:4); mean_stay_shark_data(5:6) mean_stay_shark_data(7:8);];

%Plot grand mean of pstay probailites
figure(9); clf;
b = bar([mean_stay_shark_data(1,:); mean_stay_shark_data(2,:);...
    mean_stay_shark_data(3,:); mean_stay_shark_data(4,:)]);
b(2).FaceColor = 'r';
title('Mean of Choice Behavior for subject shark trials')
%set(b,'xtick',1)
name = {'Reward-Shark'; 'Reward-No Shark'; 'Loss-Shark'; 'Loss- No Shark'};
set(gca,'xticklabel',name,'fontsize',9)
ylabel('Stay')
legend('Common', 'Rare')

stoper=0;
