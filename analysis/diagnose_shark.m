%Previously used to diagnose shark task

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%Turn this into a function later...
% %Let's look at a bunch of errors and where they happen the most, basically
% %why do our participants suck at this task.
% 
% %Stage 1: 1 = A 2 = B
% %Stage 2: 1 = C 2 = D
% 
% % data.ac_outcome = sum(data.choice1==1 & data.choice2==1);
% % data.ad_outcome = sum(data.choice1==1 & data.choice2==2);
% % data.bc_outcome = sum(data.choice1==2 & data.choice2==1);
% % data.bd_outcome = sum(data.choice1==2 & data.choice2==2);
% 
% % fprintf('Number of ac outcomes %d \n', data.ac_outcome);
% % fprintf('Number of ad outcomes %d \n', data.ad_outcome);
% % fprintf('Number of bc outcomes %d \n', data.bc_outcome);
% % fprintf('Number of bd outcomes %d \n', data.bd_outcome);
% 
% 
% data.ac_outcome = (data.state==2 & data.choice2==1);
% data.ad_outcome = (data.state==2 & data.choice2==2);
% data.bc_outcome = (data.state==3 & data.choice2==1);
% data.bd_outcome = (data.state==3 & data.choice2==2);
% 
% %To simplify things lets just say state in state 2 choice is 1(ac) or 2(ad)
% %and in state 3 choice is 3(bc) and 4(bd)
% data.chosen_stim = zeros(1,100);
% data.chosen_stim(data.ac_outcome) = 1;
% data.chosen_stim(data.ad_outcome) = 2;
% data.chosen_stim(data.bc_outcome) = 3;
% data.chosen_stim(data.bd_outcome) = 4;
% 
% %This will plot out the shark contingency
% load('C:\kod\dom_conCog\behav\masterprob.mat')
% probabilies_of_winning(1,:) = reshape(payoff(1,1,1:length(data.state)),1,length(data.state));
% probabilies_of_winning(2,:) = reshape(payoff(1,2,1:length(data.state)),1,length(data.state));
% probabilies_of_winning(3,:) = reshape(payoff(2,1,1:length(data.state)),1,length(data.state));
% probabilies_of_winning(4,:) = reshape(payoff(2,2,1:length(data.state)),1,length(data.state));
% 
% %Up until trial 70 the best choice it (2,2) then its (1,1)
% figure(900+fig_num)
% clf
% subplot(4,1,1)
% plot(smooth(double(data.chosen_stim==1)),'LineWidth',2);
% hold on
% plot(probabilies_of_winning(1,:), 'r--','LineWidth',2);
% tmp=double((data.chosen_stim==1 & data.money==1).*smooth(double(data.chosen_stim==1))');
% tmp(tmp==0)=nan;
% plot(tmp, 'k*')
% title(['Analysis decisions vs probabilites and win occurrances ' data.name])
% 
% subplot(4,1,2)
% plot(smooth(double(data.chosen_stim==2)),'LineWidth',2);
% hold on
% plot(probabilies_of_winning(2,:), 'r--','LineWidth',2);
% tmp=double((data.chosen_stim==2 & data.money==1).*smooth(double(data.chosen_stim==2))');
% tmp(tmp==0)=nan;
% plot(tmp, 'k*')
% 
% subplot(4,1,3)
% plot(smooth(double(data.chosen_stim==3)),'LineWidth',2);
% hold on
% plot(probabilies_of_winning(3,:), 'r--','LineWidth',2);
% tmp=double((data.chosen_stim==3 & data.money==1).*smooth(double(data.chosen_stim==3))');
% tmp(tmp==0)=nan;
% plot(tmp, 'k*')
% 
% subplot(4,1,4)
% plot(smooth(double(data.chosen_stim==4)),'LineWidth',2);
% hold on
% plot(probabilies_of_winning(4,:), 'r--','LineWidth',2);
% tmp=double((data.chosen_stim==4 & data.money==1).*smooth(double(data.chosen_stim==4))');
% tmp(tmp==0)=nan;
% plot(tmp, 'k*')
% 
% 
% fprintf('Number of ac outcomes %d \n', sum(data.ac_outcome));
% fprintf('Number of ad outcomes %d \n', sum(data.ad_outcome));
% fprintf('Number of bc outcomes %d \n', sum(data.bc_outcome));
% fprintf('Number of bd outcomes %d \n', sum(data.bd_outcome));
% 
% % figure(999)
% % subplot(5,2,fig_num)
% % plot(~data.stay, 'r*')
% % hold on
% % plot(data.money)
% % axis([0 100 -.5 1.5])
% % title(['Wins vs switch trials for subj ', data.name])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%