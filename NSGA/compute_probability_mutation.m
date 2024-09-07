function [pmnew]=compute_probability_mutation(fitness,nsga)
    costmax=max(fitness(1,:));
    costmin=min(fitness(1,:));
    profitmax=max(fitness(2,:));
    profitmin=min(fitness(2,:));
    costave=mean(fitness(1,:));
    profitave=mean(fitness(2,:));
    pm=[];
    for i=1:size(fitness,2)
        cost=fitness(1,i);profit=fitness(2,i);
        if cost<costave
            pm_mid1=(nsga.pm1*(costave-cost)+nsga.pm2*(cost-costmin))/(costave-costmin);
        elseif cost>=costave
            pm_mid1=(nsga.pm2*(costmax-cost)+nsga.pm3*(cost-costave))/(costmax-costave);
        end
        pm(end+1)=pm_mid1;
        if profit<profitave
            pm_mid2=(nsga.pm1*(profitave-profit)+nsga.pm2*(profit-profitmin))/(profitave-profitmin);
        elseif profit>=profitave
            pm_mid2=(nsga.pm2*(profitmax-profit)+nsga.pm3*(profit-profitave))/(profitmax-profitave);
        end
        pm(end+1)=pm_mid2;
    end
    pmnew=mean(pm);
end