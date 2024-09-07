function crowdingDis=compute_crowdingDis(currentfitness)
    num=size(currentfitness,2);
    crowdingDis=zeros(1,num);
    [~,sortedIndex]=sortrows([currentfitness(1,:);-currentfitness(2,:)]');
    crowdingDis(sortedIndex(1))=inf;
    crowdingDis(sortedIndex(end))=inf;
    for i=2:num-1
        crowdingDis(sortedIndex(i))=crowdingDis(sortedIndex(i))+sum(abs(currentfitness(:,sortedIndex(i+1))-currentfitness(:,sortedIndex(i-1))));
    end
end