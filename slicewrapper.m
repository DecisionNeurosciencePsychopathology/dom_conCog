function [sl,ms] = slicewrapper()

global starttime


	ms = 1000*GetSecs-starttime;
	sl = 1000*GetSecs-starttime;%floor((1000*GetSecs-starttime) / 90);
end	
