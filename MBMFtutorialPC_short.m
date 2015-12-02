function [w, choice1, choice2,state, pos1, pos2 ,money, rts1, rts2, total_before_scanner]=MBMFtutorialPC_short()
%MBMFtutorial
% tutorial for sequential choice task
% This is the PC version.
% To convert to OSX:
%   add in path additions
%   find all \n\n' and replace w/ \n' (corrects font spacing)
%   change font size from 20 to 30

%clear all;

HideCursor;

%set random number generator
%rand('state',sum(100*clock));
rng('shuffle');

% specify the task parameters (name was added here
global leftpos rightpos boxypos moneyxpos moneyypos animxpos animypos moneytime ...
    isitime ititime choicetime moneypic losepic inmri keyleft keyright starttime...
    keyback tutorial_flag shark_attack_block;

tutorial_flag = 1;
shark_attack_block=0;

%Screen Resoultion
%screenResolution=[1920 1200]; %Jon's PC
screenResolution=[1920 1080]; %SPECC's PC

%Try this out hoping it works!
Pix_SS = get(0,'screensize');
screenResolution=Pix_SS(3:end);

% Open a new window.
[ w, windowRect ] = Screen('OpenWindow', max(Screen('Screens')),[ 0 0 0], [0 0 screenResolution] );
FlipInterval = Screen('GetFlipInterval',w); %monitor refresh rate.
slack = FlipInterval/2; %used for minimizing accumulation of lags due to vertical refresh

% Set process priority to max to minimize lag or sharing process time with other processes.
Priority(MaxPriority(w));

%w=Screen('OpenWindow',0,[0 0 0]);

totaltrials=40;    %total number of trials in the task
shark_trials = 12; %total number of shark trials
%11/16/15 tutorial is 70/30
transprob = .7;    % probability of 'correct' transition 

[xres,yres] = Screen('windowsize',w);
xcenter = xres/2;
ycenter = yres/2;

leftpos = xcenter-400;
rightpos = xcenter+100;
boxypos = ycenter+50;

leftposvect = [leftpos boxypos leftpos+300 boxypos+300];
rightposvect = [rightpos boxypos rightpos+300 boxypos+300];
posvect = [leftposvect; rightposvect];

moneyypos = ycenter-round(75/2)-200;
moneyxpos = xcenter-round(75/2);

animxpos = 0:50:250;
animypos = 0:50:250;

moneytime = 1500;
% isitime = round(500 / 90);
% ititime = round(500 / 90);
truechoicetime = 3000;
isitime = 1000;
ititime = 1000;

slicewait = ceil(0 / 90);

inmri = 0;

KbName('UnifyKeyNames');
keyleft = KbName('1!');
keyright = KbName('0)');
keyback = KbName('z');

ytext = round(1*yres/5);

% load payoffs

load tut/masterprob

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

[t(2,1).norm, ~, alpha]=imread('behav/alien3_norm.png');
t(2,1).norm(:,:,4) = alpha(:,:);
[t(2,1).deact, ~, alpha]=imread('behav/alien3_deact.png');
t(2,1).deact(:,:,4) = alpha(:,:);
[t(2,1).act1, ~, alpha]=imread('behav/alien3_a1.png');
t(2,1).act1(:,:,4) = alpha(:,:);
[t(2,1).act2, ~, alpha]=imread('behav/alien3_a2.png');
t(2,1).act2(:,:,4) = alpha(:,:);
[t(2,1).spoiled, ~, alpha]=imread('behav/alien3_sp.png');
t(2,1).spoiled(:,:,4) = alpha(:,:);

[t(2,2).norm, ~, alpha]=imread('behav/alien4_norm.png');
t(2,2).norm(:,:,4) = alpha(:,:);
[t(2,2).deact, ~, alpha]=imread('behav/alien4_deact.png');
t(2,2).deact(:,:,4) = alpha(:,:);
[t(2,2).act1, ~, alpha]=imread('behav/alien4_a1.png');
t(2,2).act1(:,:,4) = alpha(:,:);
[t(2,2).act2, ~, alpha]=imread('behav/alien4_a2.png');
t(2,2).act2(:,:,4) = alpha(:,:);
[t(2,2).spoiled, ~, alpha]=imread('behav/alien4_sp.png');
t(2,2).spoiled(:,:,4) = alpha(:,:);

[t(3,1).norm, ~, alpha]=imread('behav/alien1_norm.png');
t(3,1).norm(:,:,4) = alpha(:,:);
[t(3,1).deact, ~, alpha]=imread('behav/alien1_deact.png');
t(3,1).deact(:,:,4) = alpha(:,:);
[t(3,1).act1, ~, alpha]=imread('behav/alien1_a1.png');
t(3,1).act1(:,:,4) = alpha(:,:);
[t(3,1).act2, ~, alpha]=imread('behav/alien1_a2.png');
t(3,1).act2(:,:,4) = alpha(:,:);
[t(3,1).spoiled, ~, alpha]=imread('behav/alien1_sp.png');
t(3,1).spoiled(:,:,4) = alpha(:,:);

[t(3,2).norm, ~, alpha]=imread('behav/alien2_norm.png');
t(3,2).norm(:,:,4) = alpha(:,:);
[t(3,2).deact, ~, alpha]=imread('behav/alien2_deact.png');
t(3,2).deact(:,:,4) = alpha(:,:);
[t(3,2).act1, ~, alpha]=imread('behav/alien2_a1.png');
t(3,2).act1(:,:,4) = alpha(:,:);
[t(3,2).act2, ~, alpha]=imread('behav/alien2_a2.png');
t(3,2).act2(:,:,4) = alpha(:,:);
[t(3,2).spoiled, ~, alpha]=imread('behav/alien2_sp.png');
t(3,2).spoiled(:,:,4) = alpha(:,:);


[moneypic,~, alpha] = imread('behav/t.png');
moneypic(:,:,4) = alpha(:,:);
[losepic, map, alpha] = imread('behav/nothing.png');
losepic(:,:,4) = alpha(:,:);

earth = imread('behav/earth.jpg');
planetR = imread('behav/redplanet1.jpg');
planetP = imread('behav/purpleplanet.jpg');

%shark textures
%Images
cosmic_shark = imread('behav/cosmic_shark.png');
[shark_fin,~,alpha]  = imread('behav/fin_final.png');
shark_fin(:,:,4) = alpha(:,:);
shark_fin_rev = flipdim(shark_fin ,2);
galaxy_img = imread('behav/Spiral_galaxy.jpg');
safe_scrn = imread('behav/Safe_screen.png');

%Textures
cosmic_shark = Screen(w,'MakeTexture', cosmic_shark);
shark_fin = Screen(w,'MakeTexture', shark_fin);

shark_fin_rev = Screen(w,'MakeTexture', shark_fin_rev);
galaxy_img = Screen(w,'MakeTexture', galaxy_img);
safe_scrn = Screen(w,'MakeTexture', safe_scrn);

% convert image arrays to textures
for i = 1:3
    for j = 1:2
        s(i,j).norm = Screen(w,'MakeTexture',t(i,j).norm);
        s(i,j).deact = Screen(w,'MakeTexture',t(i,j).deact);
        s(i,j).act1 = Screen(w,'MakeTexture',t(i,j).act1);
        s(i,j).act2 = Screen(w,'MakeTexture',t(i,j).act2);
        s(i,j).spoiled = Screen(w,'MakeTexture',t(i,j).spoiled);
        s(i,j).shark = shark_fin;
    end
end

moneypic = Screen(w,'MakeTexture',moneypic);
losepic = Screen(w,'MakeTexture',losepic);
earth = Screen(w,'MakeTexture',earth);
planetR = Screen(w,'MakeTexture',planetR);
planetP = Screen(w,'MakeTexture',planetP);

Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); %necessary for transparency

% initialise data vectors
choice1 = zeros(1,totaltrials);         % first level choice
choice2 = zeros(1,totaltrials);         % second level choice
state = zeros(1,totaltrials);           % second level state
pos1 = rand(1,totaltrials) > .5;        % positioning of first level boxes
pos2 = rand(1,totaltrials) > .5;        % positioning of second level boxes
rts1 = zeros(1,totaltrials);            % first level RT
rts2 = zeros(1,totaltrials);            % second level RT
money = zeros(1,totaltrials);           % win
money2 = zeros(1,shark_trials);          % win

Screen('TextFont',w,'Helvetica');
Screen('TextSize',w,48);
Screen('TextStyle',w,1);
Screen('TextColor',w,[255 0 0]);
wrap = 80;

starttime = GetSecs*1000;

% screen 1
DrawFormattedText(w,'Press any key',...
    'center',ytext);
Screen('Flip',w);
KbWait([],2);

% screen 2
planetpic = earth;
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['You will be riding a spaceship \n\n' 'to look for space treasure on \n\n'  'two planets.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

planetpic = planetP;

% screen 3
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
DrawFormattedText(w,['Each planet has two aliens. \n\n\n' 'Each alien has a treasure mine.'],'center', round(ytext),[],wrap);
Screen('Flip',w);
KbWait([],2);

%screen 3 again
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
DrawFormattedText(w,['On each planet, you will order \n\n' 'one alien to give you treasure'],'center', round(ytext),[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 5
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
%%Screen('DrawTexture',w,s(1,1).shark,[],[660 450 960 620]);
DrawFormattedText(w,['Order the left alien by pressing the 1 key \n\n' 'and the right alien by pressing the 0 key. \n\n\n' 'Practice a few times now.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

for t =1:3 %Number of box trials
    pos = selectbox(inf);
    xander = find((pos==[1 2])==0);
    for i = 1:5
        Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
        Screen('DrawTexture',w,s(2,pos).act1,[],posvect(pos,1:4));
        Screen('DrawTexture',w,s(2,xander).deact,[],posvect(xander,1:4));
        Screen('Flip',w);
        WaitSecs(0.1);
        Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
        Screen('DrawTexture',w,s(2,pos).act2,[],posvect(pos,1:4));
        Screen('DrawTexture',w,s(2,xander).deact,[],posvect(xander,1:4));
        Screen('Flip',w);
        WaitSecs(0.1);
    end
    if t ~= 3
        Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
        Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
        Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
        DrawFormattedText(w,'Now try another one.','center',ytext,[],wrap);
        Screen('Flip',w);
    end
end


% Explain Treasure
% DrawFormattedText(w,'After you choose an alien, you will find out whether you got treasure.','center',ytext,[],wrap);
% Screen('Flip',w);


KbWait([],2);

DrawFormattedText(w,['After you choose an alien, \n\n' 'you may get treasure.' ],'center',ytext,[],wrap);
Screen('DrawTexture',w,moneypic,[],[]); %draw background planet
Screen('Flip',w);
KbWait([],2);

%Explain No Treasure
DrawFormattedText(w,'Or no treasure.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
DrawFormattedText(w,'Or no treasure.','center',ytext,[],wrap);
Screen('DrawTexture',w,losepic,[],[]); %draw background planet
Screen('Flip',w);
KbWait([],2);

% screen 4 If an alien has a good mine that means it can easily dig u
DrawFormattedText(w,['Your luck with any alien will change.']...
    ,'center',ytext,[],wrap);
Screen('Flip',w,[]);
KbWait([],2);

%% Initial practice
alien_trials = 30;
kickout = 0;
% screen 15
while kickout==0
    planetpic = planetP;
    Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
    Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
    Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
    DrawFormattedText(w,['You can practice now.\n\n' 'You have 30 choices to try \n\n' 'to figure out which alien has more treasure.' '\n\n\n'...
        'Key 1: LEFT alien, key 0: RIGHT alien.' '\n\n\n'],'center',ytext,[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    
    choicetime = inf;
    
    for t = 1:alien_trials %Number of alien trials
        % set up pictures, swapping sides randomly
        level=0; % this is required for the actual task
        [choice, a, b, c, d, e, pos, stimleft, stimright,~,kickout] = halftrial(planetpic, s(2,:),rand > .5,w,[],level);
        
        if kickout; break; end
        
        if choice == 1
            win = rand < .20;
        else
            win = rand < .80;
        end
        
        drawoutcome(win,w,pos,stimleft,stimright);
        
        %Screen('Flip',w);
        WaitSecs(.5);
    end
    Screen('Flip',w);
    Screen('Flip',w);
    
    if t~=alien_trials
        kickout=0;
    else
        kickout=1;
    end
    
end

% screen 14
Screen('DrawTexture',w,s(2,2).norm,[],(rightposvect + leftposvect)/2);
DrawFormattedText(w,['Good. The RIGHT alien had treasure more often.\n\n' 'But that WILL CHANGE gradually.\n\n'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

%screen 15
DrawFormattedText(w,['How much bonus money you make is \n\n' 'based on how much space treasure you find.\n\n'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2)

% screen 12
% DrawFormattedText(w,['While the chance an alien has treasure to share changes over time,\n\n' 'it changes slowly. \n\n\n' ...
%                      'So an alien with a good treasure mine right now will stay good for a while.\n\n'  'To find the alien with the best mine at each point in time,\n\n' 'you must concentrate.\n\n\n'],...
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);


% screen 15
planetpic = earth;
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['Now that you know how to pick aliens, \n\n' 'you can learn to play the whole game.\n\n'  'You will travel to one of two planets.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 15
planetpic = planetR;
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(3,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(3,2).norm,[],rightposvect);
DrawFormattedText(w,'Red planet',...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 1
planetpic = planetP;
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
DrawFormattedText(w,'Or purple planet',...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 1
planetpic = earth;
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['You will chose a spaceship. \n\n\n' 'One spaceship will fly mostly\n\n' 'to the red planet, \n\n' 'and the other mostly to the purple planet.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['The planet a spaceship goes to most will NEVER change.\n\n\n' 'Pick the one that will take you to the alien\n\n' 'with the most treasure, but sometimes \n\n' 'you''ll go to the other planet!'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

kickout=0;
while kickout==0
    
    DrawFormattedText(w,['Let''s practice before doing the full game.'],... %% The aliens share somewhat randomly, but you can find the one with the best mine at any point in the game by asking it to share! \n\n\n'...
        ...%%'How easy it is for an alien to get treasure out of its mine changes slowly over time, so keep track of which aliens are good to ask right now. '],...
        'center',ytext,[],wrap);
    Screen('Flip',w);
    KbWait([],2)
    
    
    % another screen
    Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
    Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
    DrawFormattedText(w,['You will have three seconds to make each choice. \n\n' 'If you are too slow, you will see a large X \n\n' 'appear on each alien and that choice will be over.'],'center',ytext,[],wrap);
    Screen('Flip',w);
    KbWait([],2)
    Screen('DrawTexture',w,s(1,1).spoiled,[],leftposvect);
    Screen('DrawTexture',w,s(1,2).spoiled,[],rightposvect);
    DrawFormattedText(w,['Dont feel rushed, but please try \n\n' 'to make a choice every time.'],'center',ytext,[],wrap);
    Screen('Flip',w);
    KbWait([],2)
    DrawFormattedText(w,['Good luck! \n\n' 'Remember that 1 selects left and 0 selects right.'],'center',ytext,[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    DrawFormattedText(w,['You''re playing for real money now, \n\n' 'each treasure is worth $0.25.'],'center',ytext,[],wrap);
    Screen('Flip',w);
    KbWait([],2)
    
    choicetime = truechoicetime;
    
    % main experimental loop
    
    money = zeros(1,totaltrials);
    for trial = 1:totaltrials %Number of rocket trials
        
        % first level
        level=0;
        planetpic = earth; %state 1 planet is earth
        [choice1(trial), rts1(trial),~,~,~,~,~,~,~, lastChoice, kickout] = halftrial(planetpic, s(1,:), pos1(trial),w,[],level);
        
        
        if kickout; break; end %Back button (see slectbox.m)
        
        if ~choice1(trial) % spoiled
            %we pick up a half-trial of extra time here; not sure what to do about this
            slicewait = slicewait + choicetime + isitime + moneytime + ititime;
            
            continue;
        end
        
        state(trial) = 2 + xor((rand > transprob),(choice1(trial)-1));
        switch (state(trial)) %set planet pic depending on state
            case 2
                planetpic = planetP;
            case 3
                planetpic = planetR;
        end
        % second level
        level = 1;
        [choice2(trial), rts2(trial), b, c, d, e, pos, leftstim, rightstim] = halftrial(planetpic, s(state(trial),:), pos2(trial),w,[], level, lastChoice);
        
        if ~choice2(trial) % spoiled
            slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime;
            continue;
        end
        
        % outcome
        money(trial) = rand < payoff(state(trial)-1,choice2(trial),trial);
        
        drawoutcome(money(trial),w,pos,leftstim,rightstim);
        
        Screen('Flip',w);
        %WaitSecs(ititime * 90/1000);
        slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime;
    end
    
    %Part of the back button code
    if trial~=totaltrials
        kickout=0;
    else
        kickout=1;
    end
end
DrawFormattedText(w,['That is the end of the practice game.' '\n\n\n'  'Press a key to see how you did...'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['You got '  num2str(sum(money)) ' pieces of treasure.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% DrawFormattedText(w,['Okay, that is nearly the end of the tutorial! \n\n\n' ...
% 'In the real game, the planets, aliens, and spaceships will be new colors,\n\n' 'but the rules will be the same. \n\n\n'  'The game is hard, so you will need to concentrate,\n\n' 'but don''t be afraid to trust your instincts.\n\n\n'  'Here are three hints on how to play the game.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);

%DrawFormattedText(w,['Hint #1:' '\n\n\n' 'Remember which aliens have treasure. That changes slowly,\n\n' 'so an alien with a lot of treasure now,\n\n' 'will have a lot in the near future.\n\n\n'],'center',ytext,[],wrap);
DrawFormattedText(w,['Hint #1:' '\n\n\n' 'If an alien has a lot of treasure,\n\n' 'stick with that alien,\n\n' 'if he runs out try another one.\n\n\n'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Hint #2:' '\n\n\n' 'Aliens are INDEPENDENT.  Just because one alien has \n\n' 'little treasure, does not mean another has a lot. \n\n\n' ...
    'Also, there are NO FUNNY PATTERNS,\n\n' 'like aliens sharing treasure every other time, \n\n' 'or depending on which spaceship you took.\n\n'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

%DrawFormattedText(w,['Hint #3:' '\n\n\n' 'The spaceship you choose is important because often \n\n' 'an alien on one planet may be better \n\n' 'than the ones on another planet.\n\n\n'  'Find the spaceship that is\n\n' 'most likely to take you to the right planet.'],...
%    'center',ytext,[],wrap);
% DrawFormattedText(w,['Hint #3:' '\n\n\n' 'Try to take the spaceship to \n\n' 'the planet with the alien that \n\n' 'is currently the best.\n\n\n'  'Remember there is always one\n\n' 'best alien.'],...
%     'center',ytext,[],wrap);
DrawFormattedText(w,['Hint #3:' '\n\n\n' 'It''s important to choose \n\n' 'the spaceship that leads to the \n\n' ' alien that is currently the best to do well.\n\n\n'  'Remember there is always one\n\n' 'best alien.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

%Additional Shark trials
DrawFormattedText(w,['However... \n\n Danger lurks in deep space'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['On some trials a Cosmic Shark' '\n\n' 'will attack and take $10 worth of treasure!'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['You will be warned of the possibility of ' '\n\n' 'the shark attacking, but will not know' '\n\n' 'when the attack will occur.' '\n\n'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['You will also know when the shark is gone.' '\n\n' 'When the shark leaves it will not' '\n\n' 'reappear until you see another warning'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Now for real money let''s run' '\n\n' 'through the game with the shark'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);


%% Main shark practice loop
%Shark variables and textures
warnings = 1;
attack =8;
%Its a shark attack block
shark_attack_block=1;

% Sound
% Perform basic initialization of the sound driver:
InitializePsychSound;

for trial = 1:shark_trials %Number of shark trials

    Screen('Flip',w);
    %After shark attack
    if ismember(trial, attack+1)
        shark_attack_block=0; %remove shark attack threat
        DrawFormattedText(w,'You lose $10!','center','center',[255, 0, 0, 255],wrap);
        Screen('Flip',w);
        WaitSecs((ititime*3)/1000) %We can change the wait time to whatever...
    end
    
    % Warning screen for incoming shark attack!
    %if trial == totaltrials*(1/4)+1 || trial == totaltrials*(3/4)+1
    if ismember(trial,warnings)
        warning_fin(w,xcenter,ycenter,shark_fin,shark_fin_rev,galaxy_img)
        WaitSecs((ititime*1)/1000) %We can change the wait time to whatever...
        %elseif trial == totaltrials*(.5)+1
    elseif ismember(trial,10)
        DrawFormattedText(w, 'Shark Is Gone','center', 100);
        Screen('DrawTexture',w,safe_scrn, [],[])
        %Add in clear blue stary sky!
        
        Screen('Flip',w);
        WaitSecs((ititime*3)/1000) %We can change the wait time to whatever...
    end
    
    
    % first level
    level=0;
    planetpic = earth; %state 1 planet is earth
    [choice1(trial), rts1(trial),~,~,~,~,~,~,~, lastChoice] = halftrial(planetpic, s(1,:), pos1(trial),w,[],level);
    
    
    if ~choice1(trial) % spoiled
        %we pick up a half-trial of extra time here; not sure what to do about this
        slicewait = slicewait + choicetime + isitime + moneytime + ititime;
        %Was skipping over attack if no response
        if ismember(trial,attack); shark_attack(w,cosmic_shark); end
        continue;
    end
    
    
    % determine where we transition
    
    state(trial) = 2 + xor((rand > transprob),(choice1(trial)-1));
    switch (state(trial)) %set planet pic depending on state
        case 2
            planetpic = planetP;
        case 3
            planetpic = planetR;
    end
    % second level
    level = 1;
    [choice2(trial), rts2(trial), b, c, d, e, pos, leftstim, rightstim] = halftrial(planetpic, s(state(trial),:), pos2(trial),w,[], level, lastChoice);
    
    
    if ~choice2(trial) % spoiled
        slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime;
        %Was skipping over attack if no response
        if ismember(trial,attack); shark_attack(w,cosmic_shark); end
        continue;
    end
    
    % outcome
    money2(trial) = rand < payoff(state(trial)-1,choice2(trial),trial);
    
    drawoutcome(money2(trial),w,pos,leftstim,rightstim);
    
    Screen('Flip',w);
    slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime;
    
    
    %Shark attack!!!
    if ismember(trial,attack); shark_attack(w,cosmic_shark); end
%     if ismember(trial,attack)
%         [pahandle, wav_time]=prep_sound('C:\kod\dom_conCog\sounds\Monster_Gigante.wav');
%         t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
%         Screen('DrawTexture',w,cosmic_shark,[],[]); %draw shark might be able to have higher pic dimmensions!
%         Screen('Flip',w);
%         WaitSecs(wav_time) %We can change the wait time to whatever...
%         % Stop playback:
%         PsychPortAudio('Stop', pahandle);
%         
%         % Close the audio device:
%         PsychPortAudio('Close', pahandle);
%     end
end %End shark practice loop

%Figure out how much they won
totalwon = sum(money) + sum(money2); 
total_after_shark = (totalwon*.25)+ 10 - 10; %$10 endowment?
total_before_scanner = total_after_shark + 20;

DrawFormattedText(w,['End of the tutorial \n\n' 'Your total winnings are ',num2str(total_after_shark) ],... 
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['You''re awarded an addional $20 for the scanner task \n\n'...
    'Bringing your total to ',num2str(total_before_scanner),' when you enter \n\n' 'the scanner'],... 
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Once in the scanner each shark \n\n'...
    'attacks will take $25'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);


DrawFormattedText(w,['OK! Now you know how to play. \n\n\n'...
    'Ready?  \n\n\n' 'Now its time to play the game!  \n\n\n' 'Good luck space traveler!'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

Screen('Close');



function shark_attack(w,cosmic_shark)
        %[pahandle, wav_time]=prep_sound('C:\kod\dom_conCog\sounds\Monster_Gigante.wav');
        [pahandle, wav_time]=prep_sound('sounds\Monster_Gigante.wav');
        t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
        Screen('DrawTexture',w,cosmic_shark,[],[]); %draw shark might be able to have higher pic dimmensions!
        Screen('Flip',w);
        WaitSecs(wav_time) %We can change the wait time to whatever...
        % Stop playback:
        PsychPortAudio('Stop', pahandle);
        
        % Close the audio device:
        PsychPortAudio('Close', pahandle);
