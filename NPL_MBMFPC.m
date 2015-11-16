%MBMFPC Runs the full task on a PC.
%This calls the tutorial and the Task
%The MBMF versions are basically the same, except for redundancy removal so
%they can be run without a break in between.
%
global inmri

%SacklerNumber=input('Subject''s Sackler ID? ','s');
% enter subject details
name=input('Subject''s ID? (Please enter 5 numbers (ex 09999)):  ', 's');

contingency =0;
while ismember(contingency, [1 2])==0
    contingency = input('Which version would you like to run (1 or 2): ');
end

inmri =99;
while ismember(inmri, [1 0])==0
    inmri = input('Is this and fMRI scan (yes=1 or no=0): ');
end

[window, choice1, choice2, state, pos1, pos2, money, rts1, rts2, total_before_scanner]=MBMFtutorialPC_short();
save([name '_' num2str(now*1000,9) '_tutorial'], 'choice1', 'choice2', 'state', 'pos1', 'pos2', 'money', 'rts1', 'rts2', 'contingency')

%If not an frmi scan run the behav. version
% if inmri==1
    [choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, stim1_ons_sl, ...
    stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, stim2_ons_sl, ...
    stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, rew_ons_sl, ...
    rew_ons_ms, payoff, attack, warnings, swap_hist,keycode1,keycode2] = NPL_MBMFtaskPC_final(name, contingency,total_before_scanner, window);
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
    'keycode1', 'keycode2')
