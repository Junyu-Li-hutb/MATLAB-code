function [newChrome_part,Chrome_remain,fitness_remain]=choose(Chrome_V2G,rankings,crowdingDis,fitness,choosenum)
    newChrome_part={};
    Chrome_remain=Chrome_V2G;
    fitness_remain=fitness;
    for i=1:choosenum
        num=length(Chrome_remain);
        randnumber1=randi([1,num]);
        randnumber2=randi([1,num]);
        if rankings(randnumber1)<rankings(randnumber2)
            newChrome_part{end+1}=Chrome_remain{randnumber1};
            Chrome_remain{randnumber1}=[];
            Chrome_remain(cellfun(@isempty,Chrome_remain))=[];
            crowdingDis(randnumber1)=[];
            fitness_remain(:,randnumber1)=[];
        elseif rankings(randnumber1)>rankings(randnumber2)
            newChrome_part{end+1}=Chrome_remain{randnumber2};
            Chrome_remain{randnumber2}=[];
            Chrome_remain(cellfun(@isempty,Chrome_remain))=[];
            crowdingDis(randnumber2)=[];
            fitness_remain(:,randnumber2)=[];
        elseif rankings(randnumber1)==rankings(randnumber2)
            if crowdingDis(randnumber1)>crowdingDis(randnumber2)
                newChrome_part{end+1}=Chrome_remain{randnumber1};
                Chrome_remain{randnumber1}=[];
                Chrome_remain(cellfun(@isempty,Chrome_remain))=[];
                crowdingDis(randnumber1)=[];
                fitness_remain(:,randnumber1)=[];
            else
                newChrome_part{end+1}=Chrome_remain{randnumber2};
                Chrome_remain{randnumber2}=[];
                Chrome_remain(cellfun(@isempty,Chrome_remain))=[];
                crowdingDis(randnumber2)=[];
                fitness_remain(:,randnumber2)=[];
            end
        end
    end
end