%MBMFPC Runs the full task on a PC.
%This calls the tutorial and the Task
%The MBMF versions are basically the same, except for redundancy removal so
%they can be run without a break in between.
%
global inmri

clear
clc

%SacklerNumber=input('Subject''s Sackler ID? ','s');
% enter subject details
name=input('Subject''s ID? (Please enter 5 numbers (ex 09999)):  ', 's');

contingency =0;
while ismember(contingency, [1 2])==0
    contingency = input('Which version would you like to run (1 or 2): ');
    if isempty(contingency)
        contingency =0;
    end
end

self_paced_flag =1;
% while ismember(self_paced_flag, [0 1])==0 
%     self_paced_flag = input('Is this self paced (1) or not (0): ');
%     if isempty(self_paced_flag)
%         self_paced_flag =nan;
%     end
% end

inmri =1;
% while ismember(inmri, [1 0])==0
%     inmri = input('Is this and fMRI scan (yes=1 or no=0): ');
%     if isempty(inmri)
%         inmri =99;
%     end
% end

total_before_scanner_flag =99;
while ismember(total_before_scanner_flag, 1)==0
    total_before_scanner = input('What was the subject''s total from the practice: ');
    fprintf('\nTotal before scanner was %.2f, is this correct?\n',total_before_scanner)
    total_before_scanner_flag = input('\nYes=1, No=2: ');
end

%We run the practice outside the scanner
% [window, choice1, choice2, state, pos1, pos2, money, rts1, rts2, total_before_scanner]=MBMFtutorialPC_short(self_paced_flag);
% save([name '_' num2str(now*1000,9) '_tutorial'], 'choice1', 'choice2', 'state', 'pos1', 'pos2', 'money', 'rts1', 'rts2', 'contingency')

%NOTE!!
%for future realase it might be a good idea to set up the window here


%If not an frmi scan run the behav. version
% if inmri==1
    [choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, stim1_ons_sl, ...
    stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, stim2_ons_sl, ...
    stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, rew_ons_sl, ...
    rew_ons_ms, payoff, attack, warnings, swap_hist,keycode1,keycode2, jitter_time] = NPL_MBMFtaskPC_final(name, contingency, self_paced_flag, total_before_scanner);
% else
% [choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, stim1_ons_sl, ...
%     stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, stim2_ons_sl, ...
%     stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, rew_ons_sl, ...
%     rew_ons_ms, payoff, attack, warnings] = NPL_MBMFtaskPC(name, contingency,total_before_scanner, window);
% end

save(['_', name '_' num2str(now*1000,9) '_onsets'], 'choice1', 'choice2', 'state', ...
    'pos1', 'pos2', 'money', 'totalwon', 'rts1', 'rts2', 'stim1_ons_sl', 'stim1_ons_ms', ...
    'choice1_ons_sl', 'choice1_ons_ms', 'stim2_ons_sl', 'stim2_ons_ms', ...
    'choice2_ons_sl', 'choice2_ons_ms', 'rew_ons_sl', 'rew_ons_ms', ...
    'name', 'payoff', 'contingency', 'attack', 'warnings', 'swap_hist', ...
    'keycode1', 'keycode2', 'jitter_time')

%Close all pointers
fclose all;