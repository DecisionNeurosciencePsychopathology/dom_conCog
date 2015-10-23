%MBMFPC Runs the full task on a PC.
%This calls the tutorial and the Task
%The MBMF versions are basically the same, except for redundancy removal so
%they can be run without a break in between.
%

%SacklerNumber=input('Subject''s Sackler ID? ','s');
% enter subject details
name=input('Subject''s ID? (Please enter 5 numbers (ex 09999)):  ', 's');

%This info is not needed
% gender = [];
% while (strcmp(gender,'m')==0 && strcmp(gender,'f')==0)
%     gender = input('Subject''s Gender? (m or f): ','s');
% end
% dob = input('Subject''s Date of Birth? (YYYY-MM-DD ex:1986-09-25):  ', 's');
% ageV = datevec(datenum(date)-datenum(dob));
% age = ageV(1) + ageV(2)/12 + ageV(3)/365;

contingency =0;
while ismember(contingency, [1 2])==0
    contingency = input('Which version would you like to run (1 or 2): ');
end

fmri =0;
while ismember(fmri, [1 2])==0
    fmri = input('Is this and fMRI scan (yes=1 or no=2): ');
end

[window, choice1, choice2, state, pos1, pos2, money, rts1, rts2, total_before_scanner]=MBMFtutorialPC_short();
save([name '_' num2str(now*1000,9) '_tutorial'], 'choice1', 'choice2', 'state', 'pos1', 'pos2', 'money', 'rts1', 'rts2', 'contingency')

%If not an frmi scan run the behav. version
if fmri==1
    [choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, stim1_ons_sl, ...
    stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, stim2_ons_sl, ...
    stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, rew_ons_sl, ...
    rew_ons_ms, payoff] = NPL_MBMFtaskPC_fmri(name, contingency,total_before_scanner, window);
else
[choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, stim1_ons_sl, ...
    stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, stim2_ons_sl, ...
    stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, rew_ons_sl, ...
    rew_ons_ms, payoff] = NPL_MBMFtaskPC(name, contingency,total_before_scanner, window);
end

save(['_', name '_' num2str(now*1000,9) '_onsets'], 'choice1', 'choice2', 'state', ...
    'pos1', 'pos2', 'money', 'totalwon', 'rts1', 'rts2', 'stim1_ons_sl', 'stim1_ons_ms', ...
    'choice1_ons_sl', 'choice1_ons_ms', 'stim2_ons_sl', 'stim2_ons_ms', ...
    'choice2_ons_sl', 'choice2_ons_ms', 'rew_ons_sl', 'rew_ons_ms', ...
    'name', 'payoff', 'contingency')
