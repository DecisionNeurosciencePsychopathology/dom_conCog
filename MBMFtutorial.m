function [w choice1 choice2 state pos1 pos2 money rts1 rts2]=MBMFtutorial()
%MBMFtutorial
% tutorial for sequential choice task
% This is the OSX version.
% To convert to Windows7:
%   remove path additions
%   find all \n' and replace w/ \n\n' (corrects font spacing)
%   change font size from 30 to 20

clear all

ptbpath = '/Applications/Psychtoolbox';

addpath([ptbpath '/PsychBasic']);
addpath([ptbpath '/PsychOneliners']);
addpath([ptbpath '/PsychPriority']);
addpath([ptbpath '/PsychJava']);
addpath([ptbpath '/PsychAlphaBlending'])
addpath([ptbpath '/PsychRects'])

HideCursor;



%set random number generator
%rand('state',sum(100*clock));
rng('shuffle');

% specify the task parameters (name was added here
global leftpos rightpos boxypos moneyxpos moneyypos animxpos animypos moneytime ...
    isitime ititime choicetime moneypic losepic inmri keyleft keyright starttime;


w=Screen('OpenWindow',0,[0 0 0]);

totaltrials=20;    %total number of trials in the task
transprob = .8;    % probability of 'correct' transition

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

moneytime = round(1000 / 90);
isitime = round(500 / 90);
ititime = round(500 / 90);
truechoicetime = round(3000 / 90);

inmri = 0;

KbName('UnifyKeyNames');
keyleft = KbName('1!');
keyright = KbName('0)');

ytext = round(1*yres/5);

% load payoffs

load tut/masterprob

% Load the figures

% Load the figures
[t(1,1).norm, ~, alpha]=imread('tut/tutrocket1_n.png');
t(1,1).norm(:,:,4) = alpha(:,:);
[t(1,1).deact, ~, alpha]=imread('tut/tutrocket1_d.png');
t(1,1).deact(:,:,4) = alpha(:,:);
[t(1,1).act1, ~, alpha]=imread('tut/tutrocket1_a1.png');
t(1,1).act1(:,:,4) = alpha(:,:);
[t(1,1).act2, ~, alpha]=imread('tut/tutrocket1_a2.png');
t(1,1).act2(:,:,4) = alpha(:,:);
[t(1,1).spoiled, ~, alpha]=imread('tut/tutrocket1_s.png');
t(1,1).spoiled(:,:,4) = alpha(:,:);

[t(1,2).norm, ~, alpha]=imread('tut/tutrocket2_n.png');
t(1,2).norm(:,:,4) = alpha(:,:);
[t(1,2).deact, ~, alpha]=imread('tut/tutrocket2_d.png');
t(1,2).deact(:,:,4) = alpha(:,:);
[t(1,2).act1, ~, alpha]=imread('tut/tutrocket2_a1.png');
t(1,2).act1(:,:,4) = alpha(:,:);
[t(1,2).act2, ~, alpha]=imread('tut/tutrocket2_a2.png');
t(1,2).act2(:,:,4) = alpha(:,:);
[t(1,2).spoiled, ~, alpha]=imread('tut/tutrocket2_s.png');
t(1,2).spoiled(:,:,4) = alpha(:,:);

[t(2,1).norm, ~, alpha]=imread('tut/tutalien1_n.png');
t(2,1).norm(:,:,4) = alpha(:,:);
[t(2,1).deact, ~, alpha]=imread('tut/tutalien1_d.png');
t(2,1).deact(:,:,4) = alpha(:,:);
[t(2,1).act1, ~, alpha]=imread('tut/tutalien1_a1.png');
t(2,1).act1(:,:,4) = alpha(:,:);
[t(2,1).act2, ~, alpha]=imread('tut/tutalien1_a2.png');
t(2,1).act2(:,:,4) = alpha(:,:);
[t(2,1).spoiled, ~, alpha]=imread('tut/tutalien1_s.png');
t(2,1).spoiled(:,:,4) = alpha(:,:);    

[t(2,2).norm, ~, alpha]=imread('tut/tutalien2_n.png');
t(2,2).norm(:,:,4) = alpha(:,:);
[t(2,2).deact, ~, alpha]=imread('tut/tutalien2_d.png');
t(2,2).deact(:,:,4) = alpha(:,:);
[t(2,2).act1, ~, alpha]=imread('tut/tutalien2_a1.png');
t(2,2).act1(:,:,4) = alpha(:,:);
[t(2,2).act2, ~, alpha]=imread('tut/tutalien2_a2.png');
t(2,2).act2(:,:,4) = alpha(:,:);
[t(2,2).spoiled, ~, alpha]=imread('tut/tutalien2_s.png');
t(2,2).spoiled(:,:,4) = alpha(:,:); 

[t(3,1).norm, ~, alpha]=imread('tut/tutalien3_n.png');
t(3,1).norm(:,:,4) = alpha(:,:);
[t(3,1).deact, ~, alpha]=imread('tut/tutalien3_d.png');
t(3,1).deact(:,:,4) = alpha(:,:);
[t(3,1).act1, ~, alpha]=imread('tut/tutalien3_a1.png');
t(3,1).act1(:,:,4) = alpha(:,:);
[t(3,1).act2, ~, alpha]=imread('tut/tutalien3_a2.png');
t(3,1).act2(:,:,4) = alpha(:,:);
[t(3,1).spoiled, ~, alpha]=imread('tut/tutalien3_s.png');
t(3,1).spoiled(:,:,4) = alpha(:,:);    

[t(3,2).norm, ~, alpha]=imread('tut/tutalien4_n.png');
t(3,2).norm(:,:,4) = alpha(:,:);
[t(3,2).deact, ~, alpha]=imread('tut/tutalien4_d.png');
t(3,2).deact(:,:,4) = alpha(:,:);
[t(3,2).act1, ~, alpha]=imread('tut/tutalien4_a1.png');
t(3,2).act1(:,:,4) = alpha(:,:);
[t(3,2).act2, ~, alpha]=imread('tut/tutalien4_a2.png');
t(3,2).act2(:,:,4) = alpha(:,:);
[t(3,2).spoiled,~, alpha]=imread('tut/tutalien4_s.png');
t(3,2).spoiled(:,:,4) = alpha(:,:);

[moneypic,~, alpha] = imread('behav/t.png');
moneypic(:,:,4) = alpha(:,:); 
[losepic, map, alpha] = imread('behav/nothing.png');
losepic(:,:,4) = alpha(:,:); 
 
earth = imread('behav/earth.jpg');
planetR = imread('tut/tutgreenplanet.jpg');
planetP = imread('tut/tutyellowplanet.jpg');



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



% initialise data vectors
choice1 = zeros(1,totaltrials);         % first level choice
choice2 = zeros(1,totaltrials);         % second level choice
state = zeros(1,totaltrials);           % second level state
pos1 = rand(1,totaltrials) > .5;        % positioning of first level boxes
pos2 = rand(1,totaltrials) > .5;        % positioning of second level boxes
rts1 = zeros(1,totaltrials);            % first level RT
rts2 = zeros(1,totaltrials);            % second level RT
money = zeros(1,totaltrials);           % win

Screen('TextFont',w,'Helvetica');
Screen('TextSize',w,30);
Screen('TextStyle',w,1);
Screen('TextColor',w,[255 255 255]);
wrap = 80;

starttime = GetSecs*1000;

% screen 1
DrawFormattedText(w,'Press any key to start the tutorial and to continue from page to page.',...
    'center',ytext);
Screen('Flip',w);
KbWait([],2);

% screen 2
% planetpic = earth;
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
% DrawFormattedText(w,['In this game, you will be taking a spaceship from earth \n' 'to look for space treasure on two different planets.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% planetpic = planetR;
% 
% % screen 3
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
% DrawFormattedText(w,['Each planet has two aliens on it. \n\n' 'And each alien has its own space treasure mine.'],'center', round(ytext),[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% %screen 3 again
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
% DrawFormattedText(w,['On each planet, you will pick one alien to ask for space treasure. \n\n' 'These aliens are nice, so if an alien just brought treasure \n' 'up from the mine, it will share it with you.'],'center', round(ytext),[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% % screen 5
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
% DrawFormattedText(w,['For each choice, choose the left alien by pressing the 1 key \n' 'and the right alien by pressing the 0 key. \n\n' 'The choice you make will be highlighted.\n\n' 'Try practicing a few times now.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% for t =1:3
%    pos = selectbox(inf);
%    xander = find((pos==[1 2])==0);
%   for i = 1:5
%     Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
%     Screen('DrawTexture',w,s(2,pos).act1,[],posvect(pos,1:4));
%     Screen('DrawTexture',w,s(2,xander).deact,[],posvect(xander,1:4));
%     Screen('Flip',w);
%     WaitSecs(0.1);
%     Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
%     Screen('DrawTexture',w,s(2,pos).act2,[],posvect(pos,1:4));
%     Screen('DrawTexture',w,s(2,xander).deact,[],posvect(xander,1:4));
%     Screen('Flip',w);
%     WaitSecs(0.1);
%   end
%   if t ~= 3
%   Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
%   Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
%   Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
%   DrawFormattedText(w,'Now try another one.','center',ytext,[],wrap);          
%   Screen('Flip',w);
%   end
% end
% 
% 
% % Explain Treasure
% DrawFormattedText(w,'After you choose an alien, you will find out whether you got treasure.','center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% DrawFormattedText(w,['After you choose an alien, you will find out whether you got treasure.' '\n\n' 'Which looks like this.'],'center',ytext,[],wrap);
% Screen('DrawTexture',w,moneypic,[],[]); %draw background planet
% Screen('Flip',w);
% KbWait([],2);
% 
% %Explain No Treasure
% DrawFormattedText(w,'If the alien couldn''t bring treasure up this time you''ll see an empty circle.','center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% DrawFormattedText(w,['If the alien couldn''t bring treasure up this time you''ll see an empty circle.' '\n\n' 'Which looks like this.'],'center',ytext,[],wrap);
% Screen('DrawTexture',w,losepic,[],[]); %draw background planet
% Screen('Flip',w);
% KbWait([],2);
% 
% % screen 4 If an alien has a good mine that means it can easily dig u
% DrawFormattedText(w,['If an alien has a good mine that means it can easily dig up space treasure\n' 'and it will be very likely to have some to share. \n\n'...
%     'It might not have treasure EVERY time you ask, but it will most of the time.\n\n'  'Another alien might have a bad mine that is hard to dig through at the moment,\n' 'and won''t have treasure to share most times you ask.']...
%     ,'center',ytext,[],wrap);
% Screen('Flip',w,[]);
% KbWait([],2);
% 
% 
% 
% % screen 11
% planetpic = planetP;
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(3,1).norm,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
% DrawFormattedText(w,['For example, the alien on the yellow planet has a good mine right now.\n' 'Try asking it for treasure 10 times by pressing either the 1 or 0 keys.']...
%     ,'center',ytext,[],wrap);
% Screen('Flip',w);
% 
% a=[1 0 1 1 1 0 1 0 1 1];
%   
%   for j = 1:length(a)  
%     pos = selectbox(inf);
%     
%     for i = 1:5
%       Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
%       Screen('DrawTexture',w,s(3,1).act1,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
%       Screen('Flip',w)
%       WaitSecs(0.1);
%       Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
%       Screen('DrawTexture',w,s(3,1).act2,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
%       Screen('Flip',w)
%       WaitSecs(0.1);
%     end
%      Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
%      Screen('DrawTexture',w,s(3,1).deact,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
%      drawoutcome(a(j),w,0);
%      %Screen('Flip',w)
%      %WaitSecs(1);
%     if j ~= length(a)
%         Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
%         Screen('DrawTexture',w,s(3,1).norm,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
%         Screen('Flip',w)
%     end
%   end
% 
% 
%  Screen('DrawTexture',w,s(3,1).norm,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
%  DrawFormattedText(w,['See, this alien shared treasure most of the times you asked,\n' 'but not every time. \n\n'...
%      'Every alien has treasure in its mine, but they can''t share every time.\n\n' 'Some will be more likely to share because it is easier to dig right now.\n\n'],'center',ytext,[],wrap);
%  Screen('Flip',w)
%  KbWait([],2);
%  KbWait([],2);
%  
% %% We removed this section because we are no longer swapping the stimulus presentation 
% % planetpic = planetR;
% % screen 14
% % Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% % Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
% % Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
% % DrawFormattedText(w,['Next, you can choose between two aliens\n' 'and try to figure out which one has more treasure to share.' '\n\n'...
% %     'Each alien will sometimes come up on the right...'], 'center',ytext,[],wrap);
% % Screen('Flip',w);
% % KbWait([],2);
% % 
% % Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% % Screen('DrawTexture',w,s(2,2).norm,[],leftposvect);
% % Screen('DrawTexture',w,s(2,1).norm,[],rightposvect);
% % DrawFormattedText(w,'...and sometimes come up on the left.','center',ytext,[],wrap);
% % Screen('Flip',w);
% % KbWait([],2);
% % 
% % Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% % Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
% % Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
% % DrawFormattedText(w,['Which side an alien appears on does not matter.\n' 'For instance, left is not luckier than right.'],'center',ytext,[],wrap);
% % Screen('Flip',w);
% % KbWait([],2);
% 
% %%
% % screen 15
% planetpic = planetR;
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
% DrawFormattedText(w,['You can practice choosing now.\n' 'You have 20 choices to try to figure out which alien has a good mine.' '\n\n'...
%     'Remember, key 1 is for the left alien, and key 0 is for the right alien.' '\n\n' 'Click any key to start'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% 
% choicetime = inf;
% 
% for t = 1:20
%   % set up pictures, swapping sides randomly
%   level=0; % this is required for the actual task
%   [choice, a, b, c, d, e, pos, stimleft, stimright] = halftrial(planetpic, s(2,:),rand > .5,w,[],level);
%   
%   if choice == 1
%     win = rand < .30;
%   else
%     win = rand < .80;
%   end
%   
%   drawoutcome(win,w,pos,stimleft,stimright);
% 
%   %Screen('Flip',w);
%   %WaitSecs(1);
% end
% Screen('Flip',w);
% Screen('Flip',w);
% 
% 
% % screen 14
% Screen('DrawTexture',w,s(2,2).norm,[],(rightposvect + leftposvect)/2);
% DrawFormattedText(w,['Good. You might have learned that this alien had treasure more often.\n' 'Also, even if this alien had a better mine,\n' 'you couldn''t be sure if it had treasure all the time.' '\n\n' ...
%     'Each alien is like a game of chance, you can never be sure but you can guess.\n'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% DrawFormattedText(w,['The treasure an alien can give will change during the game.\n\n' ...
%     'Those with a good mine might get to a part of the mine that is hard to dig.\n' 'Those with little to share might find easier treasure to dig.\n\n' 'Any changes in an alien''s mine will happen slowly,\n' 'so try to focus to get as much treasure as possible.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% % screen 12
% % DrawFormattedText(w,['While the chance an alien has treasure to share changes over time,\n' 'it changes slowly. \n\n' ...
% %                      'So an alien with a good treasure mine right now will stay good for a while.\n'  'To find the alien with the best mine at each point in time,\n' 'you must concentrate.\n\n'],...
% %     'center',ytext,[],wrap);
% % Screen('Flip',w);
% % KbWait([],2);
% 
% 
% % screen 15
% planetpic = earth;
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
% DrawFormattedText(w,['Now that you know how to pick aliens, you can learn to play the whole game.\n'  'You will travel from earth to one of two planets.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% % screen 15
% planetpic = planetR;
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
% DrawFormattedText(w,'Here is the green planet',...
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% % screen 1
% planetpic = planetP;
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(3,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(3,2).norm,[],rightposvect);
% DrawFormattedText(w,'And here is the yellow planet',...
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% % screen 1
% planetpic = earth;
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
% DrawFormattedText(w,['First you need to choose which spaceship to take. \n\n' 'The spaceships can fly to either planet, but one will fly mostly\n' 'to the green planet, and the other mostly to the yellow planet.'],... 
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% Screen('DrawTexture',w,planetpic,[],[]); %draw background planet
% Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
% DrawFormattedText(w,['The planet a spaceship goes to most won''t change during the game.\n\n' 'Pick the one that you think will take you to the alien\n' 'with the best mine, but remember, sometimes you''ll go to the other planet!'],...
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% 
% 
% DrawFormattedText(w,['Let''s practice before doing the full game. \n\n' 'Remember, you want to find as much space treasure as you can\n' 'by asking an alien to share with you.'],... %% The aliens share somewhat randomly, but you can find the one with the best mine at any point in the game by asking it to share! \n\n'...
%     ...%%'How easy it is for an alien to get treasure out of its mine changes slowly over time, so keep track of which aliens are good to ask right now. '],...
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2)
% 
%  
% DrawFormattedText(w,['How much bonus money you make is based on how much space treasure you find.\n' 'This is just a practice round of 20 flights, you''re not playing for money now.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2)
%  
%  
% % another screen
% Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
% Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
% DrawFormattedText(w,['You will have three seconds to make each choice.  If you are too slow,\n' 'you will see a large X appear on each alien and that choice will be over.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2)
% Screen('DrawTexture',w,s(1,1).spoiled,[],leftposvect);
% Screen('DrawTexture',w,s(1,2).spoiled,[],rightposvect);
% DrawFormattedText(w,'Dont feel rushed, but please try to make a choice every time.','center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2)
% DrawFormattedText(w,'Good luck! Remember that 1 selects left and 0 selects right.','center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
%  
% choicetime = truechoicetime;
%  
% % main experimental loop
%  
% for trial = 1:totaltrials
%  
%   % first level
%   level=0;
%    planetpic = earth; %state 1 planet is earth 
%   [choice1(trial), rts1(trial),~,~,~,~,~,~,~, lastChoice] = halftrial(planetpic, s(1,:), pos1(trial),w,[],level);
%   
%   if ~choice1(trial) % spoiled
%     Screen('Flip',w);
%     WaitSecs(ititime * 90/1000); 
%     continue;
%   end
%   
%   % determine where we transition
%   
%   state(trial) = 2 + xor((rand > transprob),(choice1(trial)-1));
%   switch (state(trial)) %set planet pic depending on state
%       case 2
%           planetpic = planetR;
%       case 3
%           planetpic = planetP;    
%   end
%   % second level
%   level = 1;
%   [choice2(trial), rts2(trial), b, c, d, e, pos, leftstim, rightstim] = halftrial(planetpic, s(state(trial),:), pos2(trial),w,[], level, lastChoice);
%  
%   if ~choice2(trial) % spoiled
%       Screen('Flip',w);
%       WaitSecs(ititime * 90/1000); 
%       continue;
%   end
%   
%   % outcome
%   money(trial) = rand < payoff(state(trial)-1,choice2(trial),trial);
%  
%   drawoutcome(money(trial),w,pos,leftstim,rightstim);
%   
%   Screen('Flip',w);
%   WaitSecs(ititime * 90/1000);
% end
%  
% DrawFormattedText(w,['That is the end of the practice game.' '\n\n'  'Press a key to see how you did...'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
%  
% DrawFormattedText(w,['You got '  num2str(sum(money)) ' pieces of treasure.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
%  
% DrawFormattedText(w,['Okay, that is nearly the end of the tutorial! \n\n' ...
% 'In the real game, the planets, aliens, and spaceships will be new colors,\n' 'but the rules will be the same. \n\n'  'The game is hard, so you will need to concentrate,\n' 'but don''t be afraid to trust your instincts.\n\n'  'Here are three hints on how to play the game.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
%  
% DrawFormattedText(w,['Hint #1:' '\n\n' 'Remember which aliens have treasure. How good a mine is changes slowly,\n' 'so an alien that has a lot of treasure to share now,\n' 'will probably be able to share a lot in the near future.\n\n'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
% 
% DrawFormattedText(w,['Hint #2:' '\n\n' 'Remember, each alien has its own mine.  Just because one alien has a bad\n' 'mine and can''t share very often, does not mean another has a good mine. \n\n' ...
%     'Also, there are no funny patterns in how an alien shares,\n' 'like every other time you ask, or depending on which spaceship you took.\n' 'The aliens are not trying to trick you.'],'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
%  
% DrawFormattedText(w,['Hint #3:' '\n\n' 'The spaceship you choose is important because often an alien on one planet\n' 'may be better than the ones on another planet.\n\n'  'You can find more treasure by finding the spaceship\n' 'that is most likely to take you to right planet.'],...
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
%  
%  
% DrawFormattedText(w,['OK! Now you know how to play. \n\n'...
%     'In the real game we''ll count how many pieces of space treasure\n' 'you find and pay you real money for it at the end.\n\n'...
%     'Ready?  Now its time to play the game!  Good luck space traveler!'],...
%     'center',ytext,[],wrap);
% Screen('Flip',w);
% KbWait([],2);
 
Screen('Close');