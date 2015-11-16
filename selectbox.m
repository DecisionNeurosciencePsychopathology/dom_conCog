function [pos,buttontime, kickout, keycode] = selectbox(unt)

global keyleft keyright keyback tutorial_flag

if nargin == 0
  unt = Inf;
end

buttontime=0;
kickout=0; %Back button

%clearkeys;
choices = [keyleft keyright];

pos=0; %the variable 'pos' specifies which slot has been selected
    
%loop until one of the choice buttons is pressed, then break out of
%the loop
%while slicewrapper < unt;
  %readkeys;
  %logkeys;
  %[keyout,buttontime,npress] = getkeydown;
  %if isempty(keyout)   % ie. if no button is pressed, then do nothing and continue looping
    %do nothing   
  %elseif keyout==keyleft %left box selected
  %  pos=1;
  %  break
  %elseif keyout==keyright %right box selected
  %  pos=2;
  %  break
  %end

while KbCheck && (slicewrapper < unt);
end
  
while pos == 0 && (slicewrapper < unt)
	[key, buttontime, keycode] = KbCheck;
    if (key && (length(find(keycode)) == 1))
        if find(choices == find(keycode))
            pos = find(choices==find(keycode));
        elseif keyback==find(keycode) && tutorial_flag==1 
            pos=1;
            kickout = 1; %By hitting 'z' or keyback you will kickout of the trial loops back ot the instruction screens
            continue
        end
    end
end

end
