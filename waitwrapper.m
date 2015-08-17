function [sl,ms] = waitwrapper(unt)

global starttime

	while (GetSecs*1000 - starttime) < unt;
    end
	[sl,ms] = slicewrapper;
