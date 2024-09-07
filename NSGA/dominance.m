function dominaceRelation=dominance(fitness_a,fitness_b)
    dominates1=false;
    dominates2=false;
    if fitness_a(1,1)<fitness_b(1,1)
        dominates1=true;
    elseif fitness_a(1,1)>fitness_b(1,1)
        dominates2=true;
    end
    if fitness_a(2,1)>fitness_b(2,1)
        dominates1=true;
    elseif fitness_a(2,1)<fitness_b(2,1)
        dominates2=true;
    end
    if dominates1&&~dominates2
        dominaceRelation=1;
    elseif dominates2&&~dominates1
        dominaceRelation=-1;
    else
        dominaceRelation=0;
    end
end