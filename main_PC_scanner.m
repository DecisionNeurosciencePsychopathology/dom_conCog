% sequential choice expt
% ND, October 2006

clear all

HideCursor

% specify the task parameters
global leftpos rightpos boxypos moneyypos moneyxpos animxpos animypos moneytime ...
    isitime ititime choicetime moneypic losepic keyleft keyright...
    starttime ;

totaltrials=10;    %total number of trials in the task
transprob =.7;    % probability of 'correct' transition

[xres,yres] = Screen('windowsize',0);
xcenter = xres/2;
ycenter = yres/2;

leftpos = xcenter-400;
rightpos = xcenter+100;
boxypos = ycenter+50;

moneyypos = ycenter-round(75/2)-200;
moneyxpos = xcenter-round(75/2);

animxpos = 0:50:250;
animypos = 0:50:250;

moneytime = 1500;
isitime = 1000;
ititime = 1000;
choicetime = 3000;

% set break times
% numbreaks = 3;
b=[3,51,101,151];

% set keys
keyleft = KbName('2@');%[u]
keyright = KbName('3#');%[i]

% enter subject details
name=input('Subject''s Sackler ID? (Please enter 5 numbers (ex 09999)):  ', 's');
gender = [];
while (strcmp(gender,'m')==0 && strcmp(gender,'f')==0)
    gender = input('Subject''s Gender? (m or f): ','s');
end
dob = input('Subject''s Date of Birth? (YYYY-MM-DD ex:1986-09-25):  ', 's');
ageV = datevec(datenum(date)-datenum(dob));
age = ageV(1) + ageV(2)/12 + ageV(3)/365;

%Load choice outcomes
load behav/masterprob4
% if session == 1
%     payoff = payoff(:,:,1:67);
% elseif session == 2
%     payoff = payoff(:,:,68:134);
% elseif session == 3
%     payoff = payoff(:,:,135:201);
% end

%set random number generator
rng('shuffle');


% Load the figures
[t(1,1).norm, ~, alpha]=imread('behav/rocket1_norm.png');
t(1,1).norm(:,:,4) = alpha(:,:);
[t(1,1).deact, ~, alpha]=imread('behav/rocket1_deact.png');
t(1,1).deact(:,:,4) = alpha(:,:);
[t(1,1).act1, ~, alpha]=imread('behav/rocket1_a1.png');
t(1,1).act1(:,:,4) = alpha(:,:);
[t(1,1).act2, ~, alpha]=imread('behav/rocket1_a2.png');
t(1,1).act2(:,:,4) = alpha(:,:);
[t(1,1).spoiled, ~, alpha]=imread('behav/rocket1_sp.png');
t(1,1).spoiled(:,:,4) = alpha(:,:);

[t(1,2).norm, ~, alpha]=imread('behav/rocket2_norm.png');
t(1,2).norm(:,:,4) = alpha(:,:);
[t(1,2).deact, ~, alpha]=imread('behav/rocket2_deact.png');
t(1,2).deact(:,:,4) = alpha(:,:);
[t(1,2).act1, ~, alpha]=imread('behav/rocket2_a1.png');
t(1,2).act1(:,:,4) = alpha(:,:);
[t(1,2).act2, ~, alpha]=imread('behav/rocket2_a2.png');
t(1,2).act2(:,:,4) = alpha(:,:);
[t(1,2).spoiled, ~, alpha]=imread('behav/rocket2_sp.png');
t(1,2).spoiled(:,:,4) = alpha(:,:);

[t(2,1).norm, ~, alpha]=imread('behav/alien1_norm.png');
t(2,1).norm(:,:,4) = alpha(:,:);
[t(2,1).deact, ~, alpha]=imread('behav/alien1_deact.png');
t(2,1).deact(:,:,4) = alpha(:,:);
[t(2,1).act1, ~, alpha]=imread('behav/alien1_a1.png');
t(2,1).act1(:,:,4) = alpha(:,:);
[t(2,1).act2, ~, alpha]=imread('behav/alien1_a2.png');
t(2,1).act2(:,:,4) = alpha(:,:);
[t(2,1).spoiled, ~, alpha]=imread('behav/alien1_sp.png');
t(2,1).spoiled(:,:,4) = alpha(:,:);    

[t(2,2).norm, ~, alpha]=imread('behav/alien2_norm.png');
t(2,2).norm(:,:,4) = alpha(:,:);
[t(2,2).deact, ~, alpha]=imread('behav/alien2_deact.png');
t(2,2).deact(:,:,4) = alpha(:,:);
[t(2,2).act1, ~, alpha]=imread('behav/alien2_a1.png');
t(2,2).act1(:,:,4) = alpha(:,:);
[t(2,2).act2, ~, alpha]=imread('behav/alien2_a2.png');
t(2,2).act2(:,:,4) = alpha(:,:);
[t(2,2).spoiled, ~, alpha]=imread('behav/alien2_sp.png');
t(2,2).spoiled(:,:,4) = alpha(:,:); 

[t(3,1).norm, ~, alpha]=imread('behav/alien3_norm.png');
t(3,1).norm(:,:,4) = alpha(:,:);
[t(3,1).deact, ~, alpha]=imread('behav/alien3_deact.png');
t(3,1).deact(:,:,4) = alpha(:,:);
[t(3,1).act1, ~, alpha]=imread('behav/alien3_a1.png');
t(3,1).act1(:,:,4) = alpha(:,:);
[t(3,1).act2, ~, alpha]=imread('behav/alien3_a2.png');
t(3,1).act2(:,:,4) = alpha(:,:);
[t(3,1).spoiled, ~, alpha]=imread('behav/alien3_sp.png');
t(3,1).spoiled(:,:,4) = alpha(:,:);    

[t(3,2).norm, ~, alpha]=imread('behav/alien4_norm.png');
t(3,2).norm(:,:,4) = alpha(:,:);
[t(3,2).deact, ~, alpha]=imread('behav/alien4_deact.png');
t(3,2).deact(:,:,4) = alpha(:,:);
[t(3,2).act1, ~, alpha]=imread('behav/alien4_a1.png');
t(3,2).act1(:,:,4) = alpha(:,:);
[t(3,2).act2, ~, alpha]=imread('behav/alien4_a2.png');
t(3,2).act2(:,:,4) = alpha(:,:);
[t(3,2).spoiled, ~, alpha]=imread('behav/alien4_sp.png');
t(3,2).spoiled(:,:,4) = alpha(:,:);

[moneypic, ~, alpha] = imread('behav/t.png');
moneypic(:,:,4) = alpha(:,:); 
[losepic, ~, alpha] = imread('behav/nothing.png');
losepic(:,:,4) = alpha(:,:); 
 
earth = imread('behav/earth.jpg');
planetR = imread('behav/redplanet1.jpg');
planetP = imread('behav/purpleplanet.jpg');


% initialise data vectors

choice1 = zeros(1,totaltrials);         % first level choice
choice2 = zeros(1,totaltrials);         % second level choice
state = zeros(1,totaltrials);           % second level state
pos1 = rand(1,totaltrials) > .5;        % positioning of first level boxes
pos2 = rand(1,totaltrials) > .5;        % positioning of second level boxes
rts1 = zeros(1,totaltrials);            % first level RT
rts2 = zeros(1,totaltrials);            % second level RT
money = zeros(1,totaltrials);           % win

stim1_ons_sl = zeros(1,totaltrials);    % onset of first-level stim, slices
stim1_ons_ms = zeros(1,totaltrials);    % onset of first-level stim, ms
stim2_ons_sl = zeros(1,totaltrials);    % onset of second-level stim, slices
stim2_ons_ms = zeros(1,totaltrials);    % onset of second-level stim, ms
choice1_ons_sl = zeros(1,totaltrials);  % onset of first-level choice, slices
choice1_ons_ms = zeros(1,totaltrials);  % onset of first-level choice, ms
choice2_ons_sl = zeros(1,totaltrials);  % onset of second-level choice, slices
choice2_ons_ms = zeros(1,totaltrials);  % onset of second-level choice, ms
rew_ons_sl = zeros(1,totaltrials);      % onset of outcome, slices
rew_ons_ms = zeros(1,totaltrials);      % onset of outcome, ms

% Setup Screen
w=Screen('OpenWindow',0,[0 0 0]);
Screen('TextFont',w,'Helvetica');
Screen('TextSize',w,20);
Screen('TextStyle',w,1);
Screen('TextColor',w,[255 255 255]);
wrap = 80;



% convert image arrays to textures
for i = 1:3
    for j = 1:2
        s(i,j).norm = Screen(w,'MakeTexture',t(i,j).norm);
        s(i,j).deact = Screen(w,'MakeTexture',t(i,j).deact);
        s(i,j).act1 = Screen(w,'MakeTexture',t(i,j).act1);
        s(i,j).act2 = Screen(w,'MakeTexture',t(i,j).act2);
        s(i,j).spoiled = Screen(w,'MakeTexture',t(i,j).spoiled);
    end
end

moneypic = Screen(w,'MakeTexture',moneypic);
losepic = Screen(w,'MakeTexture',losepic);
earth = Screen(w,'MakeTexture',earth);
planetR = Screen(w,'MakeTexture',planetR);
planetP = Screen(w,'MakeTexture',planetP);

Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); %necessary for transparency

% make logfile to be filled in in real time
logfile = fopen([name '_' date '.txt'], 'a');
fprintf(logfile,'\ntrial\tchoice1\trts1\tstim1ons_sl\tstim1ons_ms\tchoice1ons_sl\tchoice1ons_ms\tstate\tchoice2\trts2\tstim2ons_sl\tstim2ons_ms\tchoice2ons_sl\tchoice2ons_ms\tSC_ID\tgender\tDOB\tage\twon\n');

%Initial Wait
%WaitSecs(12.5)
slicewait=0;
% main experimental loop
for trial = 1:totaltrials

%Screen('Flip',w);
%Start Screen
    if trial == 1
        Screen('TextSize', w, 20); %% font size
        DrawFormattedText(w, ['Remember!\n\n\n Get as much treasure as possible \n\n\n by picking the best alien!' '\n\n\n' 'Press any key to start when you are ready.'],'center','center');
        Screen('Flip',w);
        KbWait([],2);
        Screen('Flip',w);
        scanner_trigger
        starttime = GetSecs*1000;
    end
%Break Screen
    if find(trial == b) > 0
        Screen('TextSize', w, 20); %% font size
        DrawFormattedText(w, ['Take a break!' '\n\n\n' 'Press any key to continue when you are ready.'],'center','center');
        Screen('Flip',w);
        KbWait([],2);
        Screen('Flip',w);
        scanner_trigger
        starttime = GetSecs*1000;
    end
    
  % first level
    level = 0;
    planetpic = earth; %state 1 planet is earth
    [choice1(trial),rts1(trial),stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial),~,~,~, lastChoice] = ...
  	halftrial_scanner(planetpic, s(1,:), pos1(trial),w,slicewait, level);
   
  % record first choice in log
   fprintf(logfile,'\n%d\t%d\t%f\t%f\t%f\t%f\t%f',trial,choice1(trial),rts1(trial),...
      stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial))
  
  if ~choice1(trial) % spoiled
  	 %we pick up a half-trial of extra time here; wait it out
    WaitSecs((choicetime + isitime + moneytime)/1000);
    Screen('Flip',w)
    scanner_trigger
    continue;
  end

   %determine where we transition
  state(trial) = 2 + xor((rand > transprob),(choice1(trial)-1));
  switch (state(trial)) %set planet pic depending on state
      case 2
          planetpic = planetR;
      case 3
          planetpic = planetP;    
  end

  % second level
  level=1;
  [choice2(trial), rts2(trial),stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial),chpos,stimleft,stimright] = ...
  	halftrial_scanner(planetpic, s(state(trial),:), pos2(trial),w,[],level, lastChoice);
   
  % record second choice in log
  fprintf(logfile,'\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%s\t%f',state(trial),choice2(trial),rts2(trial),...
      stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial),...
      name,gender,dob,age)
  
  if ~choice2(trial) % spoiled
      fprintf(logfile,' ')
      WaitSecs(moneytime/1000)
      Screen('Flip',w)
      scanner_trigger
      continue;
  end
  
  % outcome
  money(trial) = rand < payoff(state(trial)-1,choice2(trial),trial);
  [rew_ons_sl(trial),rew_ons_ms(trial)] = drawoutcome(money(trial),w,chpos,stimleft,stimright);
 
  
  fprintf(logfile,'\t%d',money(trial))
  Screen('Flip',w)
  scanner_trigger
  
end

% figure out what they won
totalwon = sum(money);

DrawFormattedText(w,['Nice!  You found ',num2str(totalwon),' pieces of space treasure. \n\n' 'That''s worth $10!'],'center','center',[],wrap); %' ,num2str(ceil(totalwon*.05)), '
Screen('Flip',w);
KbWait([],2);


% Transition Question
Screen('DrawTexture',w,planetR,[],[]); %draw background planet
Screen('DrawTexture',w,s(1,1).norm,[],[leftpos boxypos leftpos+300 boxypos+300]);
Screen('DrawTexture',w,s(1,2).norm,[],[rightpos boxypos rightpos+300 boxypos+300]);
DrawFormattedText(w,['Which spaceship went mostly to the red planet?'],'center','center',[],wrap); 
Screen('Flip',w);

% get a keystroke
question = selectbox(inf);
if question==0
    logfile2 = fopen(['wrongtransition_' name '_' date '.txt'], 'a');
    fprintf(logfile2,'0');
else
    logfile2 = fopen(['correcttransition_' name '_' date '.txt'], 'a');
    fprintf(logfile2,'1');
end
fclose('all');

% save data
save(['_', name '_' num2str(now*1000,9) '_onsets'], choice1, choice2, state, ...
    pos1, pos2, money, totalwon, rts1, rts2, stim1_ons_sl, stim1_ons_ms, ...
    choice1_ons_sl, choice1_ons_ms, stim2_ons_sl, stim2_ons_ms, ...
    choice2_ons_sl, choice2_ons_ms, rew_ons_sl, rew_ons_ms, ...
    name, gender, dob, age, payoff, question)

Screen('Close',w)