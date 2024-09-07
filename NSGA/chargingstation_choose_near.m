function cs=chargingstation_choose_near(Battery,nowNode,distance,nowLoad,parameter,Requirement)
    cs.tag=0;
    chargingstation=2:21;
    eij=[];
    nowLoad=nowLoad-Requirement(nowNode);
    for a3=1:length(chargingstation)
        eij2=energy(parameter,nowLoad,distance,nowNode,chargingstation(a3));
        eij(end+1)=eij2;
    end
    index=find(eij<=Battery);
    if ~isempty(index)
        canreach_cs=[];
        for i=1:length(index)
            canreach_cs(end+1)=chargingstation(index(i));
        end
        juli=[];
        for j=1:length(canreach_cs)
            juli(end+1)=distance(nowNode,canreach_cs(j));
        end
        index1=find(juli==min(juli));

        cs.num=canreach_cs(index1(1));
    else
        cs.tag=1;
    end
end