function [fitness_after,Chrome_fatherandson_after]=deletesame(fitness,Chrome_fatherandson)
    fitness_after=fitness;
    Chrome_fatherandson_after=Chrome_fatherandson;
    for i=1:size(fitness_after,2)
        if fitness_after(1,i)~=0
            index=find(fitness_after(1,:)==fitness_after(1,i));
            if length(index)>1
                for j=2:length(index)
                    if fitness_after(2,i)==fitness_after(2,index(j))
                        fitness_after(:,index(j))=0;
                    end
                end
            end
        end
    end
    index1=find(fitness_after(1,:)==0);
    len=length(index1);
    if len>0
        for i=1:len
            Chrome_fatherandson_after{index1(i)}=[];
        end
    end
    fitness_after(:,index1)=[];
    Chrome_fatherandson_after(cellfun(@isempty,Chrome_fatherandson_after))=[];
end 