function warning_fin(w,xCen,yCen,img, img2, galaxypic)

[screenXpixels, screenYpixels] = Screen('WindowSize', w);

amplitude = screenXpixels * 0.25;
frequency = 0.2;
angFreq = 2 * pi * frequency;
startPhase = 0;
time = 0;



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

%Set prev sin value for image flipping
prev_sin =0;

%Add in the sound code here
[pahandle]=prep_sound('C:\kod\dom_conCog\sounds\Incoming_Suspense.wav'); 



% Start audio playback for 'repetitions' repetitions of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.
t1 = PsychPortAudio('Start', pahandle, 0, 0, 1);


% Loop the animation until a key is pressed
while ~KbCheck
    
    % Position of the square on this frame
    xpos = amplitude * sin(angFreq * time + startPhase);
    
    %Grab current sin value
    current_sin = sin(angFreq * time + startPhase);
    
    % Add this position to the screen center coordinate. This is the point
    % we want our square to oscillate around
    squareXpos = xCen + xpos;

    % Center the rectangle on the centre of the screen
    centeredRect = CenterRectOnPointd(baseRect, squareXpos, yCen+300);
    
    %Add message--NEEDS to come down a bit
    DrawFormattedText(w, 'CAUTION: Cosmic Shark is Near!','center');
    
    %Galaxy background for now
    Screen('DrawTexture',w,galaxypic,[],[]); 
    
    % Draw the image to screen flip when at the edge
    if current_sin - prev_sin >= 0
        Screen('DrawTexture',w,img,[],centeredRect); %draw shark might be able to have higher pic dimmensions!
    elseif current_sin - prev_sin <= 0
        Screen('DrawTexture',w,img2,[],centeredRect); %draw shark might be able to have higher pic dimmensions!
    end

    % Flip to the screen
    vbl  = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);

    % Increment the time
    time = time + ifi;
    
    %Update previous sin value
    prev_sin = current_sin;

end

% Stop playback:
PsychPortAudio('Stop', pahandle);

% Close the audio device:
PsychPortAudio('Close', pahandle);
