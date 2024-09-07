clc;
clear;
close all;
tic
filepath=['data\R' num2str(204) '.xlsx'];
data=xlsread(filepath,['C' num2str(2) ':' 'F' num2str(122)]);
Coordinate_x=data(:,1)';Coordinate_y=data(:,2)';
Requirement=data(:,3)';
Servicetime=data(:,4)';
Requirement=Requirement*4;
parameter.W=4500;
parameter.L=2500;
parameter.B=105;
parameter.a=0;
parameter.g=9.8;
parameter.Oij=0;
parameter.Cr=0.01;
parameter.Cd=0.7;
parameter.S=6.71;
parameter.density=1.29;
parameter.v=13.89;
parameter.efficiency=0.9;
parameter.A=2.2;
parameter.aij=parameter.a+parameter.Cr*parameter.g;
parameter.pc=120;
parameter.pf=60;
price.vehicle=150;
price.time=0.3;
price.chargefire1=0.7;
price.chargefire2=1.75;
price.chargefire3=2.1;
price.chargenew1=0.38;
price.chargenew2=0.95;
price.chargenew3=1.14;
price.discharge1=0.5;
price.discharge2=1.55;
price.discharge3=1.9;
Chargingindex=cell(1,2);
Chargingindex{1,1}=[5 9 13 17 21 ];
Chargingindex{1,2}=[2 3 4 6 7 8 10 11 12 14 15 16 18 19 20];
inspire=[];  
distance=[]; 
for i=1:length(Coordinate_x)
  for j=1:length(Coordinate_x)
      if i==j
          distance(i,j)=inf;
          inspire(i,j)=0;
      else
          distance(i,j)=sqrt(power(Coordinate_x(i)*1000-Coordinate_x(j)*1000,2)+power(Coordinate_y(i)*1000-Coordinate_y(j)*1000,2));
          inspire(i,j)=1/distance(i,j);
      end
  end
end
maxiter=600;
chromenum=100;
choosenum=30;
nsga.pc1=0.9; nsga.pc2=0.7; nsga.pc3=0.5;
nsga.pm1=0.1; nsga.pm2=0.05; nsga.pm3=0.01;
antnum=40;
rand0=0.2;
chenum=floor(sum(Requirement)/parameter.L)+1;
[ant_initial]=ACA(antnum,rand0,distance,inspire,parameter,Coordinate_x,Coordinate_y,Requirement);%蚁群生成初始解
rand_initial={};
for i=1:chromenum-antnum
    rand=randperm(100)+21;
    rand_initial{end+1}=rand;
end
Chrome=[ant_initial,rand_initial];
time_period=[0,120,240,420,600,780,900,1380];
[Chrome_V2G]=decode(Chrome,distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
fitness=zeros(3,length(Chrome_V2G));
for i=1:length(Chrome_V2G)
    [fit,~]=compute_fitness(Chrome_V2G{i},distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
    fitness(1,i)=fit.cost;
    fitness(2,i)=fit.profit;
    fitness(3,i)=fit.maxtime;
end
[rankings,crowdingDis]=fast_nondominated_sort(fitness);
newChrome={};
[newChrome_part,Chrome_remain,fitness_remain]=choose(Chrome_V2G,rankings,crowdingDis,fitness,choosenum);
[pcnew]=compute_probability_cross(fitness_remain,nsga);
[pmnew]=compute_probability_mutation(fitness,nsga);
[newChrome_cross]=cross(Chrome_remain,pcnew,distance);
[newChrome_part,Chrome_wait]=mutation(pmnew,newChrome_cross,newChrome_part,distance);
[Chrome_done]=decode(Chrome_wait,distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
newChrome=horzcat(newChrome,newChrome_part);newChrome=horzcat(newChrome,Chrome_done);
oldChrome=Chrome_V2G;
for iter=1:maxiter
    Chrome_fatherandson=horzcat(newChrome,oldChrome);
    lengths = cellfun(@length, Chrome_fatherandson);
    index = find(lengths < chenum);
    if length(index)>0
        for f=1:length(index)
            Chrome_fatherandson{index(f)}=[];
        end
        Chrome_fatherandson(cellfun(@isempty,Chrome_fatherandson))=[];
    end
    fitness=zeros(3,length(Chrome_fatherandson));
    for i=1:length(Chrome_fatherandson)
        [fit,~]=compute_fitness(Chrome_fatherandson{i},distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
        fitness(1,i)=fit.cost;
        fitness(2,i)=fit.profit;
        fitness(3,i)=fit.maxtime;
    end
    [fitness_afterdelete,Chrome_fatherandson_afterdelete]=deletesame(fitness,Chrome_fatherandson);
    [fitness_after,Chrome_fatherandson_after]=renewswap(fitness_afterdelete,Chrome_fatherandson_afterdelete,chromenum,distance,parameter,Requirement,Servicetime,price,time_period,Chargingindex);    
    [rankings,crowdingDis]=fast_nondominated_sort(fitness_after);
    [rankings_new,crowdingDis_new,newChrome_father]=newfather(rankings,crowdingDis,Chrome_fatherandson_after,chromenum);
    oldChrome=newChrome_father;
    newChrome={};
    [newChrome_part,Chrome_remain,fitness_remain]=choose(oldChrome,rankings_new,crowdingDis_new,fitness,choosenum);
    [pcnew]=compute_probability_cross(fitness_remain,nsga);
    [pmnew]=compute_probability_mutation(fitness,nsga);
    [newChrome_cross]=cross(Chrome_remain,pcnew,distance);
    [newChrome_part,Chrome_wait]=mutation(pmnew,newChrome_cross,newChrome_part,distance);
    Chrome_wait(cellfun(@isempty,Chrome_wait))=[];
    for g=1:length(Chrome_wait)
        if length(Chrome_wait{g})~=100
            keyboard
        end
    end
    [Chrome_done]=decode(Chrome_wait,distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
    newChrome=horzcat(newChrome,newChrome_part);newChrome=horzcat(newChrome,Chrome_done);
    disp(iter)
end
lengths = cellfun(@length, newChrome);
index = find(lengths < chenum);
if length(index)>0
        for f=1:length(index)
            newChrome{index(f)}=[];
        end
       newChrome(cellfun(@isempty,newChrome))=[];
end
Chrome_fatherandson=newChrome;
fitness=zeros(3,length(Chrome_fatherandson));
for i=1:length(Chrome_fatherandson)
     [fit]=compute_fitness(Chrome_fatherandson{i},distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
     fitness(1,i)=fit.cost;
     fitness(2,i)=fit.profit;
     fitness(3,i)=fit.maxtime;
end
[rankings,~]=fast_nondominated_sort(fitness);
index=find(rankings==1);
fitness_pareto=fitness(:,index);
Chrome_pareto=Chrome_fatherandson(index);
[fitness_paretolast,Chrome_paretolast]=deletesame(fitness_pareto,Chrome_pareto);
costpareto=[];
for d=1:size(fitness_paretolast,2)
    costpareto(end+1)=fitness_paretolast(1,d)-fitness_paretolast(2,d);
end
index3=find(costpareto==min(costpareto));
solution_lowcost=Chrome_paretolast{index3(1)};
Serial=index3(1);
drawpoint(fitness_paretolast,fitness,Serial);
drawsolutionxu(solution_lowcost,Coordinate_x,Coordinate_y,Chargingindex);
[fit,solution_lowcost]=compute_fitness(solution_lowcost,distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
disp(fit)