%function [choice1 choice2 state pos1 pos2 money totalwon rts1 rts2 stim1_ons_sl stim1_ons_ms choice1_ons_sl choice1_ons_ms stim2_ons_sl stim2_ons_ms choice2_ons_sl choice2_ons_ms rew_ons_sl rew_ons_ms name payoff] = MBMFtask(name, w)
function [choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, ...
    stim1_ons_sl, stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, ...
    stim2_ons_sl, stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, ...
    rew_ons_sl, rew_ons_ms, payoff, attack, warnings, swap_hist,...
    keycode1, keycode2, jitter_time] = NPL_MBMFtaskPC_final(name, contingency, self_paced_flag, pre_total, w)
%MBMFtask
% sequential choice expt
% ND, October 2006

clearvars -except name gender dob age w contingency pre_total self_paced_flag

KbName('UnifyKeyNames');

% specify the task parameters
global leftpos rightpos boxypos moneyypos moneyxpos animxpos animypos moneytime ...
    isitime ititime choicetime moneypic losepic inmri keyleft keyright...
    starttime tutorial_flag keyback shark_attack_block escKey caretKey equalsKey...
    slack spaceKey;

tutorial_flag = 0;
keyback = KbName('z');

%JUST DEBUGGING ONLY
%inmri = 1;

%Screen Resoultion
% screenResolution=[1920 1200]; %Jon's PC
%screenResolution=[1920 1080]; %SPECC's PC

% Open a new window.
% [ w, windowRect ] = Screen('OpenWindow', max(Screen('Screens')),[ 0 0 0], [0 0 screenResolution] );
% FlipInterval = Screen('GetFlipInterval',w); %monitor refresh rate.
% slack = FlipInterval/2; %used for minimizing accumulation of lags due to vertical refresh

%If window doesn't exist already create it
if (~exist('w', 'var'))
%     Pix_SS = get(0,'screensize');
%     screenResolution=Pix_SS(3:end);
    screenResolution=[1024 768]; %Scanner res
    [ w, windowRect ] = Screen('OpenWindow', max(Screen('Screens')),[ 0 0 0], [0 0 screenResolution] );
    %[ w, windowRect ] = Screen('OpenWindow', max(Screen('Screens')),[ 204 204 204], [0 0 screenResolution] );
end
%totaltrials=200;    %total number of trials in the task
totaltrials=100;    %total number of trials in the task
transprob =.8;    % probability of 'correct' transition
swap_prob = .4;     %Probability that the rockets switch position

[xres,yres] = Screen('windowsize',w);
xcenter = xres/2;
ycenter = yres/2;

ytext = round(1*yres/5);

leftpos = xcenter-400;
rightpos = xcenter+100;
boxypos = ycenter+50;

moneyypos = ycenter-round(75/2)-200;
moneyxpos = xcenter-round(75/2);

leftposvect = [leftpos boxypos leftpos+300 boxypos+300];
rightposvect = [rightpos boxypos rightpos+300 boxypos+300];
posvect = [leftposvect; rightposvect];

animxpos = 0:50:250;
animypos = 0:50:250;

moneytime = 1500;
isitime = 1000;
ititime = 1000;

%Alex wanted self paced verios of task
if ~self_paced_flag
    choicetime = 3000;
else
    choicetime = 5000;
end

preStartWait = 8.0; %initial fixation

numbreaks = 1;

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

%% Fixation cross
% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%% Sound
% Perform basic initialization of the sound driver:
InitializePsychSound;

%%
% set break times

% b = 1:blocklength:totaltrials;
% b(1)=[];

b = 0:round(totaltrials/(numbreaks+1)):totaltrials;
b(1) = [];
if totaltrials - b(length(b)) < round(totaltrials/(numbreaks+1))*0.5
    b(length(b)) = [];
end

%inmri = 0;  % set to 1 if subject is in the scanner

% if inmri
%     % right handed button box
%     keyleft = 80; %[5]
%     keyright = 81;%[6]
% else

% Set keys.
%spaceKey  = KbName('SPACE');
escKey  = KbName('ESCAPE');
caretKey = KbName('6^'); %used for scanner trigger
equalsKey = KbName('=+'); %used for scanner trigger
spaceKey = KbName('SPACE'); %used for scanner trigger

if inmri
    %Right button glove is 1-5! (According to clock task)
    keyleft = KbName('7&');%[u]
    keyright = KbName('2@');%[i]
    % end
else
    keyleft = KbName('1!');%[u]
    keyright = KbName('0)');%[i]
end


% enter subject details Shouldn't be necessary now
%name=input('Subjects initials? ','s');
%number=input('Subjects number? ');
%session = input('Session? ');

load behav/masterprob4
% if session == 1
%     payoff = payoff(:,:,1:67);
% elseif session == 2
%     payoff = payoff(:,:,68:134);
% elseif session == 3
%     payoff = payoff(:,:,135:201);
% end

% create iti jitter matrix, mean 18 slices
t_mean_jitter = 1500;
t_max_jitter = 10000;
jitter_time = createJitters(t_mean_jitter,t_max_jitter,totaltrials);

%jitter = repmas([0:2:18],1,ceil(totaltrials/10));
%jitter = [repmat([0:2:18],1,6),[3:2:15]];
%ind    = randperm(length(jitter));
%jitter = jitter(ind);
%jitter = jitter * 2;


% configure cogent a=settings
%config_display(1,1,[0.4 0.4 0.4],[1 1 1], 'Arial', 20, 3)
%config_log
%config_keyboard(100,5,'exclusive' )
%if (inmri)
%    config_serial(1);
%end
%cgloadlib


%get psudo random shark attacks, if you want them to always be different
%just remove the s = rng line and move the shark attack lines of code under
%the rng('shuffle') command
%for attack block 1 and 2
%s = rng(78);
% shark_att1 = randi([(totaltrials*.25)+1 (totaltrials*.5)],2,1)';
% shark_att2 = randi([(totaltrials*.75)+1 totaltrials],1)';
% shark_attacks = [shark_att1 shark_att2];


% onle one shark attack during the task at pseudorandom spots determined by
% the contingency, it will be towards the end of the first stress block.
%set random number generator
rng(78); %Set all random actions to pseudorandom seed 78 10/29/15 TEST to be sure of this!!!

%%Grab correct contengency either shark attack early or later during task.
blocks = floor(1:totaltrials/4:totaltrials);
block_len= diff([blocks(1) blocks(2)]);
attack_blocks = [blocks(2)-1-10 blocks(2)-1; blocks(3)-1-10 blocks(3)-1];

if contingency ==1
    %warnings = [1 101];
    %attack = randi([40 50],1,1)';
    warnings = [blocks(1) blocks(3)];
    attack = randi(attack_blocks(1,:));
    safe_blocks = [blocks(2) blocks(4)];
elseif contingency ==2
    %warnings = [51 151];
    %attack = randi([90 101],1)';
    warnings = [blocks(2) blocks(4)];
    attack = randi(attack_blocks(2,:));
    safe_blocks = [blocks(1) blocks(3)];
end


%attack_block = [warnings(1):warnings(1)+49;warnings(2):warnings(2)+49];
attack_block = [warnings(1):warnings(1)+(block_len-1);warnings(2):warnings(2)+(block_len-1)];

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
cosmic_shark = imread('behav/cosmic_shark.png');
[shark_fin,~,alpha]  = imread('behav/fin_final.png');
shark_fin(:,:,4) = alpha(:,:);
shark_fin_rev = flip(shark_fin ,2);
galaxy_img = imread('behav/Spiral_galaxy.jpg');
safe_scrn = imread('behav/Safe_screen.png');


earth = Screen(w,'MakeTexture',earth);
planetR = Screen(w,'MakeTexture',planetR);
planetP = Screen(w,'MakeTexture',planetP);
cosmic_shark = Screen(w,'MakeTexture', cosmic_shark);
shark_fin = Screen(w,'MakeTexture', shark_fin);
shark_fin_rev = Screen(w,'MakeTexture', shark_fin_rev);
galaxy_img = Screen(w,'MakeTexture', galaxy_img);
safe_scrn = Screen(w,'MakeTexture', safe_scrn);


% initialise data vectors

choice1 = zeros(1,totaltrials);         % first level choice
choice2 = zeros(1,totaltrials);         % second level choice
state = zeros(1,totaltrials);           % second level state
pos1 = rand(1,totaltrials) > .5;        % positioning of first level boxes
pos2 = rand(1,totaltrials) > .5;        % positioning of second level boxes
rts1 = zeros(1,totaltrials);            % first level RT
rts2 = zeros(1,totaltrials);            % second level RT
money = zeros(1,totaltrials);           % win
swap_hist = zeros(1,totaltrials);       % did the rockts change positions
keycode1 = zeros(1,totaltrials);        % Which button was pressed first stage
keycode2 = zeros(1,totaltrials);        % Which button was pressed second stage

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
right_before_outcome = zeros(1,totaltrials);   % documents time before feedback
right_after_sec_jitter = zeros(1,totaltrials); % documents time after second jitter


% initial wait

%Not sure about this line of code here, I think syncScannerPulse already
%accounts for the dummy slices?
% if (inmri)
%     nslices=36;                  %number of slices
%     slicewait=5*nslices+1;       %sets initial slicewait to accomodate 5 dummy volumes
% else
slicewait = ceil(0 / 90); %set initial slicewait to now - but time is
%since cogent was called, which was a few lines ago...?
% end

%jitter_time = 1.5; %default 1.5 seconds, we can change this to be an array
%which is indexed via totaltrials, the eact time of the jitters will depend
%upon the number of slices, the total trials, the trial length, and the TR I believe.

%%%%%% The Screen should now be carried over from MBMFtutorial
%w=Screen('OpenWindow',0,[0 0 0]); %I uncommented this typically w is passed in via the tutorial!!!
Screen('TextFont',w,'Helvetica');
Screen('TextSize',w,30);
Screen('TextStyle',w,1);
Screen('TextColor',w,[255 0 0]); %Red font
wrap = 80;

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

%Remove cursor
HideCursor;

Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); %necessary for transparency

% make logfile to be filled in in real time
logfile = fopen([name '_' date '.txt'], 'w');
fprintf(logfile,'\ntrial\tchoice1\trts1\tstim1ons_sl\tstim1ons_ms\tchoice1ons_sl\tchoice1ons_ms\tswap_hist\tkeycode1\tjitter1\tstate\tchoice2\trts2\tstim2ons_sl\tstim2ons_ms\tchoice2ons_sl\tchoice2ons_ms\tkeycode2\tjitter2\tSC_ID\tcontingency\twon\n');
%oldfprintf(logfile,'\ntrial choice1   rts1   stim1ons_sl   stim1ons_ms   choice1ons_sl   choice1ons_ms   state   choice2   rts2   stim2ons_sl   stim2ons_ms   choice2ons_sl   choice2ons_ms   won\n\n');

%Add in optional instructions here...just for fmri version!?
if inmri
    DrawFormattedText(w,'Let''s Recap.','center', round(ytext),[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    Screen('DrawTexture',w,earth,[],[]); %draw background planet
    Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
    Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
    DrawFormattedText(w,['Use your left index finger. \n\n\n' 'to choose options on the left.'],'center', round(ytext),[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    
    Screen('DrawTexture',w,earth,[],[]); %draw background planet
    Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
    Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
    DrawFormattedText(w,['Use your right index finger. \n\n\n' 'to choose options on the right.'],'center', round(ytext),[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    Screen('DrawTexture',w,earth,[],[]); %draw background planet
    Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
    Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
    DrawFormattedText(w,['First you will choose a rocket.'],'center', round(ytext),[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    Screen('DrawTexture',w,planetR,[],[]); %draw background planet
    Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
    Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
    DrawFormattedText(w,['Then you will choose and alien.'],'center', round(ytext),[],wrap);
    Screen('Flip',w);
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
    
    DrawFormattedText(w,'Rockets will also begin to switch sides. \n\n Be sure to pay close attention.','center', round(ytext),[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    DrawFormattedText(w,'The position of the rocket does not matter, \n\n only the rocket itself matters','center', round(ytext),[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    DrawFormattedText(w,'Lets''s get started','center', round(ytext),[],wrap);
    Screen('Flip',w);
    KbWait([],2);
    
    DrawFormattedText(w,'Waiting for scanner pulse...','center', round(ytext),[],wrap);
    Screen('Flip',w);
    %     KbWait([],2);
end





%% BEGIN TASK AFTER SYNC OBTAINED FROM SCANNER
if inmri
    
    [slack,scannerStart]=startSync(w);
    %     FlipInterval = Screen('GetFlipInterval',w); %monitor refresh rate.
    %     slack = FlipInterval/2;
    %
    %
    %     [scannerStart, priorFlip] = scannerPulseSync;
    %
    %     % Grab the time right after the scanner syncs
    %     starttime = GetSecs*1000;
    %
    %     fprintf('pulse flip: %.5f\n', priorFlip);
    
    %initial fixation of 3 seconds to allow for steady state magnetization.
    %count down from 3 to 1, then a 1-second blank screen.
    %priorFlip = fixation(preStartWait - 4.0, 1, scannerStart);
    
    %fprintf('fix flip: %.5f\n', priorFlip);
    
    for cdown = 1:3
        DrawFormattedText(w, ['Beginning in\n\n' num2str(4.0 - cdown)],'center','center',white);
        priorFlip = Screen('Flip', w, scannerStart + 4.0 + (cdown - 1.0) - slack);
        %fprintf('cdown: %d, fix flip: %.5f\n', cdown, priorFlip);
        %WaitSecs(1.0);
    end
    
else
    
    %set reference time right at the start of the trials
    starttime = GetSecs*1000;
end


% % % % main experimental loop % % % %
for trial = 1:totaltrials
    %display some stats
    fprintf('Trial: %d\n',trial)
    fprintf('The jitter time for level 1 is: %d\n',jitter_time(trial,1))
    fprintf('The jitter time for level 2 is: %d\n',jitter_time(trial,2))
    
    % Initally flip the screen
    Screen('Flip',w);
    
    
    %% After shark attack
    if ismember(trial, attack+1)
        DrawFormattedText(w,'You lose $25!','center','center',[255, 0, 0, 255],wrap);
        Screen('Flip',w);
        WaitSecs((ititime*3)/1000) %We can change the wait time to whatever...
    end
    
    %% Break trials...NO BREAKS FOR YOU!?
    if find(trial == b+1) > 0
        %Allow for a break at b, if in MRI, sync the scanner pulse again.
        %Press the space bar to continue...
        while(1)
            Screen('Flip',w);
            DrawFormattedText(w, 'End of block','center',round(ytext),[],wrap);
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if(keyIsDown && (keyCode(spaceKey))), break; end
        end
        Screen('Flip',w);
        DrawFormattedText(w, ['Take a break!' '\n\n\n' 'Press any key to continue\n\nwhen you are ready.'],'center',round(ytext),[],wrap);
        KbWait([],2);
        Screen('Flip',w);
        WaitSecs((ititime)/1000)
        if inmri
            DrawFormattedText(w,'Waiting for scanner pulse...','center', round(ytext),[],wrap);
            Screen('Flip',w);
            %             KbWait([],2);
            [slack,scannerStart]=startSync(w);
            for cdown = 1:3
                DrawFormattedText(w, ['Beginning in\n\n' num2str(4.0 - cdown)],'center','center',white);
                priorFlip = Screen('Flip', w, scannerStart + 4.0 + (cdown - 1.0) - slack);
            end
        else
            starttime = GetSecs*1000;
        end
        
    end
    
    %% Warning screen for incoming shark attack!
    if ismember(trial,warnings)
        warning_fin(w,xcenter,ycenter,shark_fin,shark_fin_rev,galaxy_img)
        WaitSecs((ititime*2)/1000) %We can change the wait time to whatever...
        %elseif ismember(trial,warnings + totaltrials/4)
    elseif ismember(trial,safe_blocks)
        DrawFormattedText(w, 'Shark Is Gone','center', 100);
        Screen('DrawTexture',w,safe_scrn, [],[])
        Screen('Flip',w);
        WaitSecs((ititime*2)/1000) %We can change the wait time to whatever...
    end
    
    %% Check if shark attacak trial
    %this will take care of when to remind subject it is a shark attack
    %block
    if any(find(trial==attack_block))
        shark_attack_block=1;
    else
        shark_attack_block=0;
    end
    
    
    %% first level
    level = 0;
    %Will it be a swap trial
    swap = rand<swap_prob;
    planetpic = earth; %state 1 planet is earth
    [choice1(trial),rts1(trial),stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial),keycode1(trial),~,~, lastChoice] = ...
        halftrial(planetpic, s(1,:), pos1(trial),w,slicewait, level,[],swap);
    
    %Need swap history to determine right left choices
    swap_hist(trial) = swap;
    
    % record first choice in log
    fprintf(logfile,'%d\t%d\t%f\t%f\t%f\t%f\t%f\t%d\t%d\t%f',trial,choice1(trial),rts1(trial),...
        stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial),swap_hist(trial),keycode1(trial),jitter_time(trial,1));
    %fprintf(logfile,'\n%d %d %f %f %f %f %f',trial,choice1(trial),rts1(trial),...
    %   stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial))
    
    if ~choice1(trial) % spoiled
        %Take care of log file
        fprintf(logfile,'\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%d\t%f\t%s\t%d',state(trial),choice2(trial),rts2(trial),...
        stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial),...
        keycode2(trial),jitter_time(trial,2),name,contingency);
        fprintf(logfile,'\t%d\n',money(trial));
        %we pick up a half-trial of extra time here; not sure what to do about this
        slicewait = slicewait + choicetime + isitime + moneytime + ititime + jitter_time(trial,1);
        if ismember(trial,attack); shark_attack(w,cosmic_shark); end %If they don't respond during shark attack
        continue;
    end
    
    
    fprintf('After first choice!\n')
    
    %determine where we transition
    state(trial) = 2 + xor((rand > transprob),(choice1(trial)-1));
    switch (state(trial)) %set planet pic depending on state
        case 2
            planetpic = planetR;
        case 3
            planetpic = planetP;
    end
    
    %Jitter 1--ISI
    fixation_cross(w,black,allCoords,lineWidthPix,white,xcenter,ycenter,jitter_time(trial,1))
    
    %% second level
    level=1;
    [choice2(trial), rts2(trial),stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial),keycode2(trial),stimleft,stimright] = ...
        halftrial(planetpic, s(state(trial),:), pos2(trial),w,[],level, lastChoice);
    
    % record second choice in log
    fprintf(logfile,'\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%d\t%f\t%s\t%d',state(trial),choice2(trial),rts2(trial),...
        stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial),...
        keycode2(trial),jitter_time(trial,2),name,contingency);
    %  fprintf(logfile,'\t%d %d %f %f %f %f %f',state(trial),choice2(trial),rts2(trial),...
    %      stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial))
    
    
    if ~choice2(trial) % spoiled
        %Take care of log
        fprintf(logfile,'\t%d\n',money(trial));
        slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime + jitter_time(trial,2);
        fprintf(logfile,' ');
        if ismember(trial,attack); shark_attack(w,cosmic_shark); end %If they don't respond during shark attack
        continue;
    end
    
    fprintf('After second choice!\n')
    
    %% outcome
    money(trial) = rand < payoff(state(trial)-1,choice2(trial),trial);
    right_before_outcome(trial)=(GetSecs*1000 - starttime);
    [rew_ons_sl(trial),rew_ons_ms(trial)] = drawoutcome(money(trial),w,keycode2(trial),stimleft,stimright);
    %right_after_outcome(trial)=(GetSecs*1000 - starttime);
    slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime + jitter_time(trial,2);
    
    fprintf(logfile,'\t%d\n',money(trial));
    
    %Jitter 2--ITI
    fixation_cross(w,black,allCoords,lineWidthPix,white,xcenter,ycenter,jitter_time(trial,2))
    right_after_sec_jitter(trial)=(GetSecs*1000 - starttime);
    
    %% Shark attack!!!
    if ismember(trial,attack); shark_attack(w,cosmic_shark); end
    
end


% figure out what they won
totalwon = sum(money)*.25 + pre_total - 25;


%Just to be safe save the entire workspace
save(sprintf('%s_workspace_ouput',name));


% Display last bit of text before exiting
DrawFormattedText(w,['This is the end of the task. \n\n' 'You''ve won \n $ ',num2str(totalwon),'!'],'center','center',[],wrap);
Screen('Flip',w);
KbWait([],2);
fclose('all');

Screen('Close')
Screen('CloseAll')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           support functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [slack,scannerStart]=startSync(w)
        %Returns the scanner start time used for sequence timing.
        
        FlipInterval = Screen('GetFlipInterval',w); %monitor refresh rate.
        slack = FlipInterval/2;
        
        
        [scannerStart, priorFlip] = scannerPulseSync;
        
        % Grab the time right after the scanner syncs
        starttime = GetSecs*1000;
        
        fprintf('pulse flip: %.5f\n', priorFlip);
        
    end

    function [seconds, VBLT] = scannerPulseSync
        while(1)
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if(keyIsDown && keyCode(escKey))
                error('quit early\n')
            end
            
            if(keyIsDown && (keyCode(caretKey) || keyCode(equalsKey))), break; end
            WaitSecs(.0005);
        end
        % change the screen to prevent key code carrying forward
        % and obtain time stamp of pulse for use with timings
        [VBLT, ~] = Screen('Flip', w);
    end


    function shark_attack(w,cosmic_shark)
        [pahandle, wav_time]=prep_sound('sounds\Monster_Gigante.wav');
        t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
        Screen('DrawTexture',w,cosmic_shark,[],[]); %draw shark might be able to have higher pic dimmensions!
        Screen('Flip',w);
        WaitSecs(wav_time) %We can change the wait time to whatever...
        % Stop playback:
        PsychPortAudio('Stop', pahandle);
        
        % Close the audio device:
        PsychPortAudio('Close', pahandle);
    end


    function jitters = createJitters(mean_jitter_time,max_jitter_time,n_trials)
        %Return a two column array with jitter times in seconds based on a
        %random distribution around the mean jitter time with longer times
        %outside the mean added to replicate a pseudo-gamma distribution.
        n_trials = n_trials*2;
        data=randi([mean_jitter_time-250,mean_jitter_time+250],1,n_trials-100);
        data(n_trials-100+1:n_trials)=randi([mean_jitter_time,max_jitter_time],1,100);
        
        %This was creating a prob dist, now we just create the jitters and shuffle them, seems easier...
        %pd = fitdist(data','gam');
        %jitters=random(pd,n_trials,1);
        
        %Shuffle jitter times
        jitters = data(randperm(length(data)));
        jitters = reshape(jitters,n_trials/2,2)./1000; %Convert to seconds
    end
end