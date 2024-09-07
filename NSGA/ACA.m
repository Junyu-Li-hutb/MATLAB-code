function [ant_initial]=ACA(antnum,rand0,distance,inspire,parameter,Coordinate_x,Coordinate_y,Requirement)
  ant_initial={};
  nowNode=1;
  for i=1:antnum
      NOC=0;
      ant_path=[];
      path=nowNode;
      unvisit=22:length(Coordinate_x);
      Content=parameter.L;
      Battery=parameter.B;
      cs_choose=0;
      while ~isempty(unvisit)
          customer_prob=[];
          customer_prob1=[];
          for a2=1:length(unvisit)
              customer_prob(end+1)=inspire(nowNode,unvisit(a2));
          end
          customer_prob1=customer_prob/sum(customer_prob);
          if rand<=rand0
              index111 = find(customer_prob1 == max(customer_prob1));
              nextNode_prob=unvisit(index111(1));
          else
               k=rand;
              c=cumsum(customer_prob1);
              k1=find(k<=c,1,"first");
              nextNode_prob=unvisit(k1);
          end
          eij1=energy(parameter,Content,distance,nowNode,nextNode_prob);%当前节点到下一可能节点的能耗
          cs=chargingstation_choose_near(Battery,nowNode,distance,Content,parameter,Requirement);
          if cs.tag==1
                if NOC==0
                    path(end+1)=cs_choose(end);
                    nowNode=path(end);
                    Battery=parameter.B;
                    NOC=1;
                    continue
                elseif NOC==1
                    path(end+1)=1;
                    ant_path=[ant_path,path];
                    Battery=parameter.B;
                    Content=parameter.L;
                    nowNode=1;
                    path=nowNode;
                    cs_choose=[0];
                    NOC=0;
                    continue
                end
            else
                cs_choose(end+1)=cs.num;
          end
          eij2=energy(parameter,Content-Requirement(nextNode_prob),distance,nextNode_prob,cs.num);
          eij3=energy(parameter,Content-Requirement(nextNode_prob),distance,nextNode_prob,1);
          
          if Content>=Requirement(nextNode_prob)
                if NOC==0
                    if Battery-eij1-eij2>=0                        
                            path(end+1)=nextNode_prob;
                            unvisit(nextNode_prob==unvisit)=[];
                            Content=Content-Requirement(nextNode_prob);
                            Battery=Battery-eij1;
                            nowNode=nextNode_prob;
                    elseif Battery-eij1-eij2<0
                        path(end+1)=cs_choose(end-1);
                        Battery=parameter.B;
                        NOC=1;
                        nowNode=cs_choose(end-1);
                    end
                elseif NOC==1
                    if Battery-eij1-eij3>=0
                            path(end+1)=nextNode_prob;
                            unvisit(nextNode_prob==unvisit)=[];
                            Content=Content-Requirement(nextNode_prob);
                            Battery=Battery-eij1;
                            nowNode=nextNode_prob;                        
                    elseif Battery-eij1-eij3<0
                        path(end+1)=1;
                        ant_path=[ant_path,path];
                        Content=parameter.L;
                        Battery=parameter.B;
                        NOC=0;
                        nowNode=1;
                        path=nowNode;
                        cs_choose=0;
                    end
                end
            elseif Content<Requirement(nextNode_prob)
                if NOC==0
                    eij4=energy(parameter,Content,distance,nowNode,1);
                    if Battery>=eij4
                        path(end+1)=1;
                        ant_path=[ant_path,path];
                        Content=parameter.L;
                        Battery=parameter.B;
                        NOC=0;
                        nowNode=1;
                        path=nowNode;
                        cs_choose=0;
                    else
                        path(end+1)=cs_choose(end);
                        path(end+1)=1;
                        ant_path=[ant_path,path];
                        Content=parameter.L;
                        Battery=parameter.B;
                        NOC=0;
                        nowNode=1;
                        path=nowNode;
                        cs_choose=0;
                    end
                elseif NOC==1
                    path(end+1)=1;
                    ant_path=[ant_path,path];
                    Content=parameter.L;
                    Battery=parameter.B;
                    NOC=0;
                    nowNode=1;
                    path=nowNode;
                    cs_choose=0;
                end
           end
      end
      if NOC==0
          eij5=energy(parameter,Content,distance,nowNode,1);
          if Battery>=eij5
              path(end+1)=1;
              ant_path=[ant_path,path];
              nowNode=1;
          elseif Battery<eij5
              path(end+1)=cs_choose(end);
              path(end+1)=1;
              ant_path=[ant_path,path];
              nowNode=1;
          end
      elseif NOC==1
          path(end+1)=1;
          ant_path=[ant_path,path];
          nowNode=1;
      end
      ant_initial{end+1}=ant_path;
  end
end