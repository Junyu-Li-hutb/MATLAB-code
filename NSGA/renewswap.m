function [fitness_after,Chrome_fatherandson_after]=renewswap(fitness_afterdelete,Chrome_fatherandson_afterdelete,chromenum,distance,parameter,Requirement,Servicetime,price,time_period,Chargingindex)
    Chrome_fatherandson_afterdelete(cellfun(@isempty,Chrome_fatherandson_afterdelete))=[];
    fitness_after=fitness_afterdelete;
    Chrome_fatherandson_after=Chrome_fatherandson_afterdelete;
    nowlen=size(fitness_afterdelete,2);
    while nowlen<chromenum*2
        suiji=randperm(nowlen,1);
        project=Chrome_fatherandson_after{suiji};
        projectnew=[];
        
        for a=1:length(project)
            project1=project{a};
            project1(project1==1)=[];project1(project1>200)=[];project1(project1>1&project1<22)=[];
            projectnew=[projectnew,project1];
        end
        L=length(projectnew);
        newSol=projectnew;
        randomMethod = randperm(3, 1);
        if randomMethod == 1
            tempIndex = randperm(L, 2);
            tempIndex1 = tempIndex(1);
            tempIndex2 = tempIndex(2);
            newSol([tempIndex1 tempIndex2]) = newSol([tempIndex2 tempIndex1]);
        elseif randomMethod == 2
            tempIndex = randperm(L, 2);
            tempIndex1 = min(tempIndex);
            tempIndex2 = max(tempIndex);
            newSol = newSol([1:tempIndex1-1 tempIndex1+1:tempIndex2 tempIndex1 tempIndex2+1:end]);
        else
            tempIndex = randperm(L, 2);
            tempIndex1 = min(tempIndex);
            tempIndex2 = max(tempIndex);
            newSol(tempIndex1:tempIndex2) = newSol(tempIndex2:-1:tempIndex1);
        end
        newSol={newSol};
        [newSol_V2G]=decode(newSol,distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
        [fit]=compute_fitness(newSol_V2G{1},distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
        newSol_V2G=newSol_V2G{1};
        fitness_after(:,end+1)=0;
            fitness_after(1,nowlen+1)=fit.cost;
            fitness_after(2,nowlen+1)=fit.profit;
            fitness_after(3,nowlen+1)=fit.maxtime;
            Chrome_fatherandson_after{end+1}=newSol_V2G;
            nowlen=nowlen+1;
    end
end