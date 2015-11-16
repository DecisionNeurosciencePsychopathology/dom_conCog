%Script to read in and analzye shark task behavioual data
%By: Jonathan Wilson
%Matlab version: 2015a
%Date created: 10/16/2015

function [ret, stay_data, stay_shark_data, block_data]=run_shark_analysis(file_name,fig_num)
    %file_name = [file_name '.txt'];
    data = read_in_file(file_name);
    
    if ~isempty(strfind(file_name,'LBK')) || ~isempty(strfind(file_name,'CAB')) || ~isempty(strfind(file_name,'JMF')) || ~isempty(strfind(file_name,'RSA')) || ~isempty(strfind(file_name,'HAS')) || ~isempty(strfind(file_name,'TCAO'))
        data.contingency = ones(1,length(data.choice1))';
    else
        data.contingency = repmat(2,1,length(data.choice1))'; 
    end
    %Create trial indexes of win/loss, common/rare, and stay/switch trials
    win_trials = find(data.won==1);
    loss_trials = find(data.won==0);
       
    common_trials = data.trial((data.choice1==1 & data.state==2) | (data.choice1==2 & data.state==3));
    rare_trials = data.trial((data.choice1==1 & data.state==3) | (data.choice1==2 & data.state==2));
    
    stay_trials = data.trial(data.choice1 == [data.choice1(2:end); 0]);
    switch_trials = data.trial(data.choice1 ~= [data.choice1(2:end); 0]);
    
    %Probably a better way to do this but it works
    %Find the win/loss_common/rare trials
%     [~, win_common_trials]=ismember(win_trials,common_trials);
%     
%     %We can cut this down by just saying    win_common_trials=win_trials(ismember(win_trials,common_trials));
%     win_common_trials=common_trials(win_common_trials(win_common_trials~=0));
%     
%    
%     [~, loss_common_trials]=ismember(loss_trials,common_trials);
%     loss_common_trials=common_trials(loss_common_trials(loss_common_trials~=0));
%     
%     [~, win_rare_trials]=ismember(win_trials,rare_trials);
%     win_rare_trials=rare_trials(win_rare_trials(win_rare_trials~=0));
%     
%     [~, loss_rare_trials]=ismember(loss_trials,rare_trials);
%     loss_rare_trials=rare_trials(loss_rare_trials(loss_rare_trials~=0));
    
    
    
    win_common_trials=win_trials(ismember(win_trials,common_trials));
    loss_common_trials = loss_trials(ismember(loss_trials,common_trials));
    win_rare_trials=win_trials(ismember(win_trials,rare_trials));
    loss_rare_trials=loss_trials(ismember(loss_trials,rare_trials));
    
    
    %Find stay probabilites
%     [~, win_common_stay_trials]=ismember(win_common_trials,stay_trials);
%     win_common_stay_trials=stay_trials(win_common_stay_trials(win_common_stay_trials~=0));
%     
%     [~, loss_common_stay_trials]=ismember(loss_common_trials,stay_trials);
%     loss_common_stay_trials=stay_trials(loss_common_stay_trials(loss_common_stay_trials~=0));
%     
%     [~, win_rare_stay_trials]=ismember(win_rare_trials,stay_trials);
%     win_rare_stay_trials=stay_trials(win_rare_stay_trials(win_rare_stay_trials~=0));
%     
%     [~, loss_rare_stay_trials]=ismember(loss_rare_trials,stay_trials);
%     loss_rare_stay_trials=stay_trials(loss_rare_stay_trials(loss_rare_stay_trials~=0));
    
    
    win_common_stay_trials=win_common_trials(ismember(win_common_trials,stay_trials));
    loss_common_stay_trials=loss_common_trials(ismember(loss_common_trials,stay_trials));
    win_rare_stay_trials=win_rare_trials(ismember(win_rare_trials,stay_trials));
    loss_rare_stay_trials=loss_rare_trials(ismember(loss_rare_trials,stay_trials));

    
    
    
    
    win_common_stay_pct = length(win_common_stay_trials)/(length(win_common_trials));
    win_rare_stay_pct = length(win_rare_stay_trials)/(length(win_rare_trials));
    loss_common_stay_pct = length(loss_common_stay_trials)/(length(loss_common_trials));
    loss_rare_stay_pct = length(loss_rare_stay_trials)/(length(loss_rare_trials));
    
    %Grab the probabilites by block
    a = [0 50; 51 100; 101 150; 151 250;];
    win_common_stay_pct_by_block = [];
    win_rare_stay_pct_by_block = [];
    loss_common_stay_pct_by_block = [];
    loss_rare_stay_pct_by_block = [];
    
    for j = 1:length(a)
        win_common_stay_pct_by_block = [win_common_stay_pct_by_block length(win_common_stay_trials(a(j,1)<=win_common_stay_trials & win_common_stay_trials<=a(j,2)))/(length(win_common_trials(a(j,1)<=win_common_trials & win_common_trials<=a(j,2))))];
        win_rare_stay_pct_by_block = [win_rare_stay_pct_by_block length(win_rare_stay_trials(a(j,1)<=win_rare_stay_trials & win_rare_stay_trials<=a(j,2)))/(length(win_rare_trials(a(j,1)<=win_rare_trials & win_rare_trials<=a(j,2))))];
        loss_common_stay_pct_by_block = [loss_common_stay_pct_by_block length(loss_common_stay_trials(a(j,1)<=loss_common_stay_trials & loss_common_stay_trials<=a(j,2)))/(length(loss_common_trials(a(j,1)<=loss_common_trials & loss_common_trials<=a(j,2))))];
        loss_rare_stay_pct_by_block = [loss_rare_stay_pct_by_block length(loss_rare_stay_trials(a(j,1)<=loss_rare_stay_trials & loss_rare_stay_trials<=a(j,2)))/(length(loss_rare_trials(a(j,1)<=loss_rare_trials & loss_rare_trials<=a(j,2))))];
    end
    
    block_data(:,:,1) = win_common_stay_pct_by_block;
    block_data(:,:,2) = win_rare_stay_pct_by_block;
    block_data(:,:,3) = loss_common_stay_pct_by_block;
    block_data(:,:,4) = loss_rare_stay_pct_by_block;
    
    
    % sum(a<=50)
    % sum(51<=a &a<=100)
    % sum(101<=a &a<=150)
    % sum(151<=a )
    
    %Make some quick checks on vector lengths
    if length(win_rare_trials) + length(loss_rare_trials) ~= length(rare_trials)
        error('Rare trials don''t add up! This is bad!');
    elseif length(win_common_trials) + length(loss_common_trials) ~= length(common_trials)
        error('Common trials don''t add up! This is bad!');
    end
    
    
    %These are just frequencies
%     win_common_pct = length(win_common_trials)/length(common_trials);
%     win_rare_pct = length(win_rare_trials)/length(rare_trials);
%     loss_common_pct = length(loss_common_trials)/length(common_trials);
%     loss_rare_pct = length(loss_rare_trials)/length(rare_trials);
    
%     %Make Daw-esqe figure
%     y = [win_common_pct win_rare_pct; loss_common_pct loss_rare_pct];
%     b = bar(y);
%     b(2).FaceColor = 'r';
%     title('Analysis of Choice Behavior')
%     
    
%Print out some data
fprintf('Subject %d\n',fig_num)
fprintf('Total wins: %d\n', sum(data.won))
fprintf('The number of stay trials were: %f\n',length(stay_trials))
fprintf('The number of switch trials were: %f\n\n',length(switch_trials))



contingency = data.contingency(1);
%Look at shark attacks
if contingency ==1
    warnings = [1 101];
elseif contingency ==2
    warnings = [51 151];
end


shark_block = [warnings(1):warnings(1)+49;warnings(2):warnings(2)+49];
shark_trials = sort(reshape(shark_block,100,1));


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


%Probabilites
win_common_stay_shark_pct = length(win_common_stay_shark_trials)/(length(win_common_shark));
win_common_stay_no_shark_pct = length(win_common_stay_no_shark_trials)/(length(win_common_no_shark));

win_rare_stay_shark_pct = length(win_rare_stay_shark_trials)/(length(win_rare_shark));
win_rare_stay_no_shark_pct = length(win_rare_stay_no_shark_trials)/(length(win_rare_no_shark));

loss_common_stay_shark_pct = length(loss_common_stay_shark_trials)/(length(loss_common_shark));
loss_common_stay_no_shark_pct = length(loss_common_stay_no_shark_trials)/(length(loss_common_no_shark));

loss_rare_stay_shark_pct = length(loss_rare_stay_shark_trials)/(length(loss_rare_shark));
loss_rare_stay_no_shark_pct = length(loss_rare_stay_no_shark_trials)/(length(loss_rare_no_shark));




    %Make Daw-esqe figure
    figure(1)
    subplot(5,2,fig_num)
    stay_data = [win_common_stay_pct win_rare_stay_pct; loss_common_stay_pct loss_rare_stay_pct];
    b = bar(stay_data);
    b(2).FaceColor = 'r';
    title(['Analysis of Choice Behavior for subject' num2str(fig_num)])
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
    title(['Analysis of Choice Behavior for subject' num2str(fig_num)])
    %set(b,'xtick',1)
    name = {'Reward-Shark'; 'Reward-No Shark'; 'Loss-Shark'; 'Loss- No Shark'};
    set(gca,'xticklabel',name,'fontsize',9)
    if fig_num==1
        legend('Common', 'Rare')
    end
    
    
%         figure(3)
%     subplot(5,2,fig_num)
%     stay_shark_data = [win_common_stay_shark_pct win_common_stay_no_shark_pct; win_rare_stay_shark_pct win_rare_stay_no_shark_pct;...
%         loss_common_stay_shark_pct loss_common_stay_no_shark_pct; loss_rare_stay_shark_pct loss_rare_stay_no_shark_pct];
%     b = bar(stay_shark_data);
%     b(2).FaceColor = 'r';
%     title(['Analysis of Choice Behavior for subject' num2str(fig_num)])
%     %set(b,'xtick',1)
%     name = {'Reward-Shark'; 'Reward-No Shark'; 'Loss-Shark'; 'Loss- No Shark'};
%     set(gca,'xticklabel',name,'fontsize',9)
%     if fig_num==1
%         legend('Common', 'Rare')
%     end
    
        
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
    
    
    %stay_data = reshape(stay_data,1,numel(stay_data))';
    %stay_shark_data = reshape(stay_shark_data,1,numel(stay_data)*size(stay_shark_data,2))';
function data = read_in_file(file)
    format_spec = '%d%d%f%f%f%f%f%d%d%f%f%f%f%f%s%d%d';
    data = readtable(file,'Delimiter','\t', 'Format',format_spec);
    
