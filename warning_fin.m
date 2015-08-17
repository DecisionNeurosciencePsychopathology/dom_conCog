function warning_fin(w,xCen,yCen,img, img2, galaxypic)

[screenXpixels, screenYpixels] = Screen('WindowSize', w);

amplitude = screenXpixels * 0.25;
frequency = 0.2;
angFreq = 2 * pi * frequency;
startPhase = 0;
time = 0;


%Load in shark position images
pos1 = imread('behav/pos1.png');
pos2 = imread('behav/pos2.png');
pos3 = imread('behav/pos3.png');
pos1 = Screen(w,'MakeTexture', pos1);
pos2 = Screen(w,'MakeTexture', pos2);
pos3 = Screen(w,'MakeTexture', pos3);


% Sync us and get a time stamp
vbl = Screen('Flip', w);
waitframes = 1;


%Tempcode
% Make a base the size of the image???
baseRect = [0 0 650 400];

% % Set the color of the rect to red
% rectColor = [1 1 0];

% Query the frame duration
ifi = Screen('GetFlipInterval', w);
%End temp code


% Maximum priority level
topPriorityLevel = MaxPriority(w);
Priority(topPriorityLevel);

%Define the time intervals of the shakrs appearance
start_time = GetSecs;
end_time = GetSecs+18.3;
pos1_time = GetSecs+3;
pos2_time = GetSecs+9;
pos3_time = GetSecs+14;



%Set prev sin value for image flipping
prev_sin =0;

%Add in the sound code here
[pahandle]=prep_sound('C:\kod\dom_conCog\sounds\warning_sound.wav');

moviename = 'c:\kod\dom_conCog\behav\animations\shark_circling_1.mp4';

% Start audio playback for 'repetitions' repetitions of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.
t1 = PsychPortAudio('Start', pahandle, 0, 0, 1);

% try
% % Open movie file and retrieve basic info about movie:
% [movie] = Screen('OpenMovie', w, moviename);
%
% %Start playback engine
% Screen('PlayMovie', movie, 1, 1);
%
%     % Playback loop: Runs until end of movie or keypress:
%     while ~KbCheck
%         % Wait for next movie frame, retrieve texture handle to it
%         tex = Screen('GetMovieImage', w, movie);
%
%         % Valid texture returned? A negative value means end of movie reached:
%         if tex<=0
%             % We're done, break out of loop:
%             break;
%         end
%
%         % Draw the new texture immediately to screen:
%         Screen('DrawTexture', w, tex);
%
%         %Add message--NEEDS to come down a bit
%         DrawFormattedText(w, 'CAUTION: Cosmic Shark is Near!','center');
%
%         % Update display:
%         Screen('Flip', w);
%
%         % Release texture:
%         Screen('Close', tex);
%
%         %Update time
%         start_time = GetSecs;
%     end
%
%     % Stop playback:
%     Screen('PlayMovie', movie, 0);
%
%     % Close movie:
%     Screen('CloseMovie', movie);
%
% %     % Close Screen, we're done:
% %     Screen('CloseAll');
%
% catch %#ok<CTCH>
%     sca;
%     psychrethrow(psychlasterror);
% end

%     %Add message--NEEDS to come down a bit
%     DrawFormattedText(w, 'CAUTION: Cosmic Shark is Near!','center');


% Loop the animation until a key is pressed
while start_time < end_time
    
    
    %Add message
     DrawFormattedText(w, 'CAUTION: Cosmic Shark is Near!','center',100);
     
     if start_time < pos1_time
         Screen('DrawTexture',w,pos1,[],[]);
     elseif start_time < pos3_time
         Screen('DrawTexture',w,pos2,[],[]);
     elseif start_time > pos3_time 
         Screen('DrawTexture',w,pos3,[],[]);
     end
     
     Screen('FrameRect', w, [255,0,0],[],10)
    
    
    %     %Galaxy background for now
    %     Screen('DrawTexture',w,galaxypic,[],[]);
    
    % Flip to the screen --- may have been source of crash
    vbl  = Screen('Flip', w);
    
    % Increment the time
    %%%time = time + ifi;
    
    
    start_time = GetSecs;
    
end

% Stop playback:
PsychPortAudio('Stop', pahandle);

% Close the audio device:
PsychPortAudio('Close', pahandle);

% % Done. Stop playback:
% Screen('PlayMovie', movie, 0);
%
% % Close movie object:
% Screen('CloseMovie', movie);






%%%OLD CODE
% % Loop the animation until a key is pressed
% while ~KbCheck
%
% %     % Position of the square on this frame
% %     xpos = amplitude * sin(angFreq * time + startPhase);
% %
% %     %Grab current sin value
% %     current_sin = sin(angFreq * time + startPhase);
% %
% %     % Add this position to the screen center coordinate. This is the point
% %     % we want our square to oscillate around
% %     squareXpos = xCen + xpos;
% %
% %     % Center the rectangle on the centre of the screen
% %     centeredRect = CenterRectOnPointd(baseRect, squareXpos, yCen+300);
%
%     %Add message--NEEDS to come down a bit
%     DrawFormattedText(w, 'CAUTION: Cosmic Shark is Near!','center');
%
%
% %     %Galaxy background for now
% %     Screen('DrawTexture',w,galaxypic,[],[]);
%
% %     % Draw the image to screen flip when at the edge
% %     if current_sin - prev_sin >= 0
% %         Screen('DrawTexture',w,img,[],centeredRect); %draw shark might be able to have higher pic dimmensions!
% %     elseif current_sin - prev_sin <= 0
% %         Screen('DrawTexture',w,img2,[],centeredRect); %draw shark might be able to have higher pic dimmensions!
% %     end
%
%     % Flip to the screen --- may have been source of crash
%     %%%%vbl  = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
%
%     % Increment the time
%     %%%time = time + ifi;
%
% %     %Update previous sin value
% %     prev_sin = current_sin;
%
% end
