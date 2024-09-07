function [pcnew]=compute_probability_cross(fitness_remain,nsga)
    costmax=max(fitness_remain(1,:));
    costmin=min(fitness_remain(1,:));
    profitmax=max(fitness_remain(2,:));
    profitmin=min(fitness_remain(2,:));
    costave=mean(fitness_remain(1,:));
    profitave=mean(fitness_remain(2,:));
    pc=[];
    for i=1:2:size(fitness_remain,2)-1
        cost1=fitness_remain(1,i);cost2=fitness_remain(1,i+1);
        profit1=fitness_remain(2,i);profit2=fitness_remain(2,i+1);
        costm=max(cost1,cost2);profitm=max(profit1,profit2);
        if costm<costave
            pc_mid1=(nsga.pc1*(costave-costm)+nsga.pc2*(costm-costmin))/(costave-costmin);
        elseif costm>=costave
            pc_mid1=(nsga.pc2*(costmax-costm)+nsga.pc3*(costm-costave))/(costmax-costave);
        end
        pc(end+1)=pc_mid1;
        if profitm<profitave
            pc_mid2=(nsga.pc1*(profitave-profitm)+nsga.pc2*(profitm-profitmin))/(profitave-profitmin);
        elseif profitm>=profitave
            pc_mid2=(nsga.pc2*(profitmax-profitm)+nsga.pc3*(profitm-profitave))/(profitmax-profitave);
        end
        pc(end+1)=pc_mid2;
    end
    pcnew=mean(pc);
end