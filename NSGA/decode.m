function [Chrome_V2G]=decode(Chrome,distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex)
  Chrome_V2G={};
  for i=1:length(Chrome)
      path=Chrome{1,i};
      index=find(path==1);
      if ~isempty(index)
          path1={};
          for j=1:2:length(index)-1 
              path1{end+1}=path(index(j):index(j+1));
          end
          path_cut=cell(length(path1),length(time_period));
          for a=1:length(path1)
              nowpath=path1{1,a};
              index1=find(nowpath>1&nowpath<22, 1);
              if ~isempty(index1)
                  [electricity]=compute_elec(nowpath,distance,Requirement,parameter,index1);
                  if electricity<0
                    nowpath(index1)=[];
                  end
              end
              timeNode=0;
              time=0;
              for b=1:length(nowpath)-1
                  nowNode=nowpath(b);nextNode=nowpath(b+1);
                  if nextNode>1&&nextNode<22
                      timeNode=timeNode+(distance(nowNode,nextNode)/parameter.v)/60+60*electricity/parameter.pc;
                  else
                      timeNode=timeNode+(distance(nowNode,nextNode)/parameter.v)/60+Servicetime(nextNode);
                  end
                  time(end+1)=timeNode;
              end
              after_path=cell(1,length(time_period)-1);
              for a1=1:length(time)
                  for a2=1:length(time_period)-1
                      if time(a1)>=time_period(a2)&&time(a1)<time_period(a2+1)
                          after_path{1,a2}(end+1)=nowpath(a1);
                      end
                  end
              end
              for a3=1:length(after_path)
                  path_cut{a,a3}=after_path(1,a3);
              end
          end
      [path_cha]=insertnew3(path_cut,time_period,distance,parameter,price,Requirement,Servicetime,path1,Chargingindex);
      else
          [path1]=decodetsp(path,parameter,distance,Requirement,Servicetime);
          path_cut=cell(length(path1),length(time_period));
          for a=1:length(path1) 
              nowpath=path1{1,a};
              index1=find(nowpath>1&nowpath<22, 1);
              if ~isempty(index1)
                  [electricity]=compute_elec(nowpath,distance,Requirement,parameter,index1);
                  if electricity<0
                    nowpath(index1)=[];
                  end
              end
              timeNode=0;
              time=0;
              for b=1:length(nowpath)-1
                  nowNode=nowpath(b);nextNode=nowpath(b+1);
                  if nextNode>1&&nextNode<22
                      timeNode=timeNode+(distance(nowNode,nextNode)/parameter.v)/60+60*electricity/parameter.pc;
                  else
                      timeNode=timeNode+(distance(nowNode,nextNode)/parameter.v)/60+Servicetime(nextNode);
                  end
                  time(end+1)=timeNode;
              end
              after_path=cell(1,length(time_period)-1);
              for a1=1:length(time)
                  for a2=1:length(time_period)-1
                      if time(a1)>=time_period(a2)&&time(a1)<time_period(a2+1)
                          after_path{1,a2}(end+1)=nowpath(a1);
                      end
                  end
              end
              for a3=1:length(after_path)
                  path_cut{a,a3}=after_path(1,a3);
              end
          end
          [path_cha]=insertnew3(path_cut,time_period,distance,parameter,price,Requirement,Servicetime,path1,Chargingindex);

      end
      Chrome_V2G{end+1}=path_cha;
  end
end