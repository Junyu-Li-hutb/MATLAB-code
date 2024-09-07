function dominaceRelation=check_dominance(fitnessa,fitnessb)
    if fitnessa(1,1)<=fitnessb(1,1)&&fitnessa(2,1)>fitnessb(2,1)
        dominaceRelation=1;
    elseif fitnessa(1,1)<fitnessb(1,1)&&fitnessa(2,1)>=fitnessb(2,1)
        dominaceRelation=1;
    elseif fitnessa(1,1)>=fitnessb(1,1)&&fitnessa(2,1)<fitnessb(2,1)
        dominaceRelation=-1;
    elseif fitnessa(1,1)>fitnessb(1,1)&&fitnessa(2,1)<=fitnessb(2,1)
        dominaceRelation=-1;
    else
        dominaceRelation=0;
    end
end