%Simulating the payoff matrix over 100 trials
load('C:\kod\dom_conCog\behav\masterprob.mat')
for j = 1:4
    switch j
        case 1 
            r=1;
            c=1;
        case 2
            r=1;
            c=2;
            
        case 3
            r=2;
            c=1;
            
        case 4
            r=2;
            c=2;
    
    end
    
    for i = 1:100
        money(j,i) = rand < payoff(r,c,i);
    end
end

sum(money,2)