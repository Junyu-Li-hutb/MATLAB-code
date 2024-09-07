function [rankings,crowdingDis]=fast_nondominated_sort(fitness)
    [~,num]=size(fitness);
    rankings=zeros(num,1);
    crowdingDis=zeros(num,1);
    dominatedCount=zeros(num,1);
    dominationSet=cell(num,1);
    for i=1:num
        dominationSet{i}=[];
    end
    for i=1:num
        for j=1:num
            if i~=j
                dominaceRelation=check_dominance(fitness(:,i),fitness(:,j));
                if dominaceRelation==1
                    dominationSet{i}=[dominationSet{i},j];
                elseif dominaceRelation==-1
                    dominatedCount(i)=dominatedCount(i)+1;
                end
            end
        end
    end
    currentRank=1;
    rank1=find(dominatedCount==0);
    rankings(rank1)=currentRank;
    while ~isempty(rank1)
        nextRank=[];
        len=length(rank1);
        for i=1:len
            zhuzhen=dominationSet{rank1(i)};
            for j=zhuzhen
                dominatedCount(j)=dominatedCount(j)-1;
                if dominatedCount(j)==0
                    nextRank=[nextRank,j];
                    rankings(j)=currentRank+1;
                end 
            end
        end
        currentRank=currentRank+1;
        rank1=nextRank;
    end
    for i=1:currentRank-1
        currentrankIndividuals=find(rankings==i);
        if length(currentrankIndividuals)>1
            currentfitness=fitness(:,currentrankIndividuals);
            crowdingDis(currentrankIndividuals)=compute_crowdingDis(currentfitness);
        end
    end
end