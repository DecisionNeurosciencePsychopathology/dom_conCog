%function [choice1 choice2 state pos1 pos2 money totalwon rts1 rts2 stim1_ons_sl stim1_ons_ms choice1_ons_sl choice1_ons_ms stim2_ons_sl stim2_ons_ms choice2_ons_sl choice2_ons_ms rew_ons_sl rew_ons_ms name payoff] = MBMFtask(name, w)
function [choice1, choice2, state, pos1, pos2, money, totalwon, rts1, rts2, ...
    stim1_ons_sl, stim1_ons_ms, choice1_ons_sl, choice1_ons_ms, ...
    stim2_ons_sl, stim2_ons_ms, choice2_ons_sl, choice2_ons_ms, ...
    rew_ons_sl, rew_ons_ms, payoff, question] = NPL_MBMFtaskPC(name, gender, dob, age, contingency, pre_total, w) 
%MBMFtask
% sequential choice expt
% ND, October 2006

clearvars -except name gender dob age w contingency

% specify the task parameters
global leftpos rightpos boxypos moneyypos moneyxpos animxpos animypos moneytime ...
    isitime ititime choicetime moneypic losepic inmri keyleft keyright...
    starttime tutorial_flag keyback;

tutorial_flag = 0;
keyback = KbName('z');

%Screen Resoultion
% screenResolution=[1920 1200]; %Jon's PC

% Open a new window.
% [ w, windowRect ] = Screen('OpenWindow', max(Screen('Screens')),[ 0 0 0], [0 0 screenResolution] );
% FlipInterval = Screen('GetFlipInterval',w); %monitor refresh rate.
% slack = FlipInterval/2; %used for minimizing accumulation of lags due to vertical refresh

%FOR DEBUG purposes only, w should be populated from tutorial!
w=Screen('OpenWindow',0,[0 0 0]);

totaltrials=200;    %total number of trials in the task
transprob =.7;    % probability of 'correct' transition

[xres,yres] = Screen('windowsize',w);
xcenter = xres/2;
ycenter = yres/2;

ytext = round(1*yres/5);

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

numbreaks = 2;

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

inmri = 0;  % set to 1 to time everything to slices

% if inmri
%     % right handed button box
%     keyleft = 80; %[5]
%     keyright = 81;%[6]
% else
keyleft = KbName('1!');%[u]
keyright = KbName('0)');%[i]
% end

numrewardedtrials = round(totaltrials/3);

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

jitter = zeros(1,totaltrials);

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
s = rng(78);
% shark_att1 = randi([(totaltrials*.25)+1 (totaltrials*.5)],2,1)';
% shark_att2 = randi([(totaltrials*.75)+1 totaltrials],1)';
% shark_attacks = [shark_att1 shark_att2];
% 
% onle one shark attack during the task at pseudorandom spots determined by
% the contingency, it will be towards the end of the first stress block.
 shark_att1 = randi([40 50],1,1)';
 shark_att2 = randi([90 101],1)';


%%Grab correct contengency either shark attack early or later during task.
if contingency ==1
    warnings = [1 101];
    attack = shark_att1;
elseif contingency ==2
    warnings = [51 151];
    attack =shark_att2;
end


%set random number generator
rng('shuffle');
%start_cogent

starttime = GetSecs*1000;

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
shark_fin = imread('behav/fin_final.png');
shark_fin_rev = flipdim(shark_fin ,2); 
galaxy_img = imread('behav/Spiral_galaxy.jpg');
safe_scrn = imread('behav/Safe_screen.png');


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

% initial wait

if (inmri)
    nslices=36;                  %number of slices
    slicewait=5*nslices+1;       %sets initial slicewait to accomodate 5 dummy volumes
else
    slicewait = ceil(0 / 90); %set initial slicewait to now - but time is
    %since cogent was called, which was a few lines ago...?
end

jitter_time = 1.5; %default 1.5 seconds, we can change this to be an array
%which is indexed via totaltrials, the eact time of the jitters will depend
%upon the number of slices, the total trials, the trial length, and the TR I believe.

%%%%%% The Screen should now be carried over from MBMFtutorial
%w=Screen('OpenWindow',0,[0 0 0]); %I uncommented this typically w is passed in via the tutorial!!!
Screen('TextFont',w,'Helvetica');
Screen('TextSize',w,40);
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
    end
end

moneypic = Screen(w,'MakeTexture',moneypic);
losepic = Screen(w,'MakeTexture',losepic);
earth = Screen(w,'MakeTexture',earth);
planetR = Screen(w,'MakeTexture',planetR);
planetP = Screen(w,'MakeTexture',planetP);
cosmic_shark = Screen(w,'MakeTexture', cosmic_shark);
shark_fin = Screen(w,'MakeTexture', shark_fin);
shark_fin_rev = Screen(w,'MakeTexture', shark_fin_rev);
galaxy_img = Screen(w,'MakeTexture', galaxy_img);
safe_scrn = Screen(w,'MakeTexture', safe_scrn);

Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); %necessary for transparency

% make logfile to be filled in in real time
logfile = fopen([name '_' date '.txt'], 'w');
fprintf(logfile,'\ntrial\tchoice1\trts1\tstim1ons_sl\tstim1ons_ms\tchoice1ons_sl\tchoice1ons_ms\tstate\tchoice2\trts2\tstim2ons_sl\tstim2ons_ms\tchoice2ons_sl\tchoice2ons_ms\tSC_ID\tgender\tDOB\tage\twon\n');
%oldfprintf(logfile,'\ntrial choice1   rts1   stim1ons_sl   stim1ons_ms   choice1ons_sl   choice1ons_ms   state   choice2   rts2   stim2ons_sl   stim2ons_ms   choice2ons_sl   choice2ons_ms   won\n\n');


% Pre-Start screen
DrawFormattedText(w,'Press any key to begin',...
    'center',ytext);
Screen('Flip',w);
KbWait([],2);


% % % % main experimental loop % % % % <-modify here!!!
for trial = 1:totaltrials
    
    Screen('Flip',w);
    
    %Break trials
    if find(trial == b) > 0
        
        DrawFormattedText(w, ['Take a break!' '\n\n\n' 'Press any key to continue when you are ready.'],'center','center');
        Screen('Flip',w);
        KbWait([],2);
        Screen('Flip',w);
        WaitSecs((ititime)/1000)
    end
    
    % Warning screen for incoming shark attack!
    %if trial == totaltrials*(1/4)+1 || trial == totaltrials*(3/4)+1
    if ismember(trial,warnings)
        
        %DrawFormattedText(w, 'CAUTION: Incoming Cosmic Shark Attack!','center','center');
        %It's be cool to have the cosmic shark swim by!
        %Screen('Flip',w);
        warning_fin(w,xcenter,ycenter,shark_fin,shark_fin_rev,galaxy_img)
        WaitSecs((ititime*2)/1000) %We can change the wait time to whatever...
    %elseif trial == totaltrials*(.5)+1
    elseif ismember(trial,warnings + totaltrials/4)
        DrawFormattedText(w, 'Shark Is Gone','center', 100);
        Screen('DrawTexture',w,safe_scrn, [],[])
        %Add in clear blue stary sky!
        
        Screen('Flip',w);
        WaitSecs((ititime*2)/1000) %We can change the wait time to whatever...
    end
    
    %After shark attack
    if ismember(trial, attack+1)
%         sum_so_far = sum(money);
%         %Figure out the subtraction of the total here...
%         total_loss = round((sum_so_far-prev_loss)*(1/3));
%         prev_loss = total_loss;
        DrawFormattedText(w,'You lose $25!','center','center',[255, 0, 0, 255],wrap); 
        Screen('Flip',w);
        WaitSecs((ititime*3)/1000) %We can change the wait time to whatever...
    end
    
    
    % first level
    level = 0;
    planetpic = earth; %state 1 planet is earth
    [choice1(trial),rts1(trial),stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial),~,~,~, lastChoice] = ...
        halftrial(planetpic, s(1,:), pos1(trial),w,slicewait, level);
    
    
    % record first choice in log
    fprintf(logfile,'\n%d\t%d\t%f\t%f\t%f\t%f\t%f',trial,choice1(trial),rts1(trial),...
        stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial))
    %fprintf(logfile,'\n%d %d %f %f %f %f %f',trial,choice1(trial),rts1(trial),...
    %   stim1_ons_sl(trial),stim1_ons_ms(trial),choice1_ons_sl(trial),choice1_ons_ms(trial))
    
    if ~choice1(trial) % spoiled
        %we pick up a half-trial of extra time here; not sure what to do about this
        slicewait = slicewait + choicetime + isitime + moneytime + ititime + jitter(trial);
        
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
    
    %Jitter 1--ISI
    fixation_cross(w,black,allCoords,lineWidthPix,white,xcenter,ycenter,jitter_time)
    
    % second level
    level=1;
    [choice2(trial), rts2(trial),stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial),chpos,stimleft,stimright] = ...
        halftrial(planetpic, s(state(trial),:), pos2(trial),w,[],level, lastChoice);
    
    % record second choice in log
    fprintf(logfile,'\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%s\t%f',state(trial),choice2(trial),rts2(trial),...
        stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial),...
        name,gender,dob,age)
    %  fprintf(logfile,'\t%d %d %f %f %f %f %f',state(trial),choice2(trial),rts2(trial),...
    %      stim2_ons_sl(trial),stim2_ons_ms(trial),choice2_ons_sl(trial),choice2_ons_ms(trial))
    
    
    if ~choice2(trial) % spoiled
        slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime + jitter(trial);
        fprintf(logfile,' ')
        continue;
    end
    
    % outcome
    money(trial) = rand < payoff(state(trial)-1,choice2(trial),trial);
    
    [rew_ons_sl(trial),rew_ons_ms(trial)] = drawoutcome(money(trial),w,chpos,stimleft,stimright);
    
    slicewait = slicewait + 2*choicetime + 2*isitime + moneytime + ititime + jitter(trial);
    
    fprintf(logfile,'\t%d',money(trial))
    
    %Jitter 2--ITI
    fixation_cross(w,black,allCoords,lineWidthPix,white,xcenter,ycenter,jitter_time)
    
    %Shark attack!!!
    if ismember(trial,attack)
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
    
end


% figure out what they won

%rewardedtrials = randperm(totaltrials);
%rewardedtrials = rewardedtrials(1:numrewardedtrials);
%totalwon = sum(money(rewardedtrials));
totalwon = sum(money)*.25 + pre_total - 25;



% Ask the transition Question
%DrawFormattedText(w,['Nice!  You found ',num2str(totalwon),' pieces of space treasure. \n\n' 'That''s worth $10! \n\n'],'center','center',[],wrap); %' ,num2str(ceil(totalwon*.05)), '
DrawFormattedText(w,['This is the end of the task. \n\n' 'You''ve won ',num2str(totalwon),'!'],'center','center',[],wrap); 
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
if question==2
    logfile2 = fopen(['wrongtransition_' name '_' date '.txt'], 'w');
    fprintf(logfile2,'%s\t0',name);
else
    logfile2 = fopen(['correcttransition_' name '_' date '.txt'], 'w');
    fprintf(logfile2,'%s\t1',name);
end
fclose('all');

Screen('Close')
Screen('CloseAll')