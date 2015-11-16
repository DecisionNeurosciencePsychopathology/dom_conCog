function fixation_cross(w,black,allCoords,lineWidthPix,white,xcenter,ycenter,jitter_time)

  Screen('FillRect',w,black)
  Screen('DrawLines', w, allCoords,...
      lineWidthPix, white, [xcenter ycenter], 2);
  
  % Flip to the screen
  Screen('Flip', w);
  
  %Jitter time length
  WaitSecs(jitter_time);
  
 