%MBMFPC Runs the full task on a PC.
%This calls the tutorial and the Task
%The MBMF versions are basically the same, except for redundancy removal so
%they can be run without a break in between.
%

%SacklerNumber=input('Subject''s Sackler ID? ','s');
% enter subject details
name=input('Subject''s Sackler ID? (Please enter 5 numbers (ex 09999)):  ', 's');
gender = [];
while (strcmp(gender,'m')==0 && strcmp(gender,'f')==0)
    gender = input('Subject''s Gender? (m or f): ','s');
end
dob = input('Subject''s Date of Birth? (YYYY-MM-DD ex:1986-09-25):  ', 's');
ageV = datevec(datenum(date)-datenum(dob));
age = ageV(1) + ageV(2)/12 + ageV(3)/365;

[window, choice1, choice2, state, pos1, pos2, money, rts1, rts2]=MBMFtutorialPC();
save([name '_' num2str(now*1000,9) '_tutorial'], 'choice1', 'choice2', 'state', 'pos1', 'pos2', 'money', 'rts1', 'rts2')


[choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, stim1_ons_sl, ...
    stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, stim2_ons_sl, ...
    stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, rew_ons_sl, ...
    rew_ons_ms, payoff, question]= MBMFtaskPC(name, gender, dob, age, window);
save(['_', name '_' num2str(now*1000,9) '_onsets'], 'choice1', 'choice2', 'state', ...
    'pos1', 'pos2', 'money', 'totalwon', 'rts1', 'rts2', 'stim1_ons_sl', 'stim1_ons_ms', ...
    'choice1_ons_sl', 'choice1_ons_ms', 'stim2_ons_sl', 'stim2_ons_ms', ...
    'choice2_ons_sl', 'choice2_ons_ms', 'rew_ons_sl', 'rew_ons_ms', ...
    'name', 'gender', 'dob', 'age', 'payoff', 'question')
