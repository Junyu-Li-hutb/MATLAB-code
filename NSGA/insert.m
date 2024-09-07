function [path_cha]=insert(path_cut,time_period,distance,parameter,price,Requirement,Servicetime)
  chargingstation=2:21;
  path_cha={};
  for i=1:size(path_cut,1)
      path_che=path_cut(i,:);
      path_che(cellfun(@isempty,path_che))=[];
      tag_charge=0;
      for aa=1:length(path_che)
          current=path_che{aa}{:};
          if any(current>1&current<22)
              tag_charge=aa;
              index11=find(current>1&current<22);
              path_che{aa}{:}(index11(1))=[];
              break
          end
      end
      cha_juzhen=zeros(2,length(path_che));
      for j=1:length(path_che)
          insert_position=[];dis=[];cs=[];
          path_duan=path_che{j};
          len=length(path_duan{:});
          if len>=2
              for a1=1:len-1
                  nowNode=path_duan{:}(a1);nextNode=path_duan{:}(a1+1);
                  Distance=distance(nowNode,chargingstation)+distance(chargingstation,nextNode);
                  index1=find(Distance==min(Distance));
                  insert_position(end+1)=a1;dis(end+1)=Distance(index1(1));cs(end+1)=chargingstation(index1(1));
              end
              z=[insert_position;cs;dis]';
              zx=sortrows(z,3,"ascend");
              cha_juzhen(1,j)=zx(1,1);cha_juzhen(2,j)=zx(1,2);
          end
      end
      index4=find(cha_juzhen(1,:)>0);
      path_store1={};
      if length(index4)>=2
          path_store={};
          if tag_charge==0
              for a1=1:length(path_che)-1
                  xin_path1=[];
                  if cha_juzhen(1,a1)>0
                      xin_path1=[path_che{a1}{1}(1:cha_juzhen(1,a1)),cha_juzhen(2,a1),path_che{a1}{1}(cha_juzhen(1,a1)+1:end)];
                  else
                      continue
                  end
                  for a2=a1+1:length(path_che)
                      xin_path2=[];
                      path=[];
                      if cha_juzhen(1,a2)>0
                          xin_path2=[path_che{a2}{1}(1:cha_juzhen(1,a2)),cha_juzhen(2,a2)+200,path_che{a2}{1}(cha_juzhen(1,a2)+1:end)];
                      else
                          continue
                      end
                      for b=1:length(path_che)
                          if b==a1
                              path=[path,xin_path1];
                          elseif b==a2
                              path=[path,xin_path2];
                          else
                              path=[path,path_che{b}];
                          end
                      end
                      path_store{end+1}=path;
                  end
              end
              for a1=1:length(path_che)-1
                  xin_path1=[];
                  if cha_juzhen(1,a1)>0
                      xin_path1=[path_che{a1}{1}(1:cha_juzhen(1,a1)),cha_juzhen(2,a1)+200,path_che{a1}{1}(cha_juzhen(1,a1)+1:end)];
                  else
                      continue
                  end
                  for a2=a1+1:length(path_che)
                      xin_path2=[];
                      path=[];
                      if cha_juzhen(1,a2)>0
                          xin_path2=[path_che{a2}{1}(1:cha_juzhen(1,a2)),cha_juzhen(2,a2),path_che{a2}{1}(cha_juzhen(1,a2)+1:end)];
                      else
                          continue
                      end
                      for b=1:length(path_che)
                          if b==a1
                              path=[path,xin_path1];
                          elseif b==a2
                              path=[path,xin_path2];
                          else
                              path=[path,path_che{b}];
                          end
                      end
                      path_store{end+1}=path;
                  end
              end
          else
              for a1=1:tag_charge-1
                  xin_path1=[];
                  if cha_juzhen(1,a1)>0
                      xin_path1=[path_che{a1}{1}(1:cha_juzhen(1,a1)),cha_juzhen(2,a1),path_che{a1}{1}(cha_juzhen(1,a1)+1:end)];
                  else
                      continue
                  end
                  for a2=a1+1:length(path_che)
                      xin_path2=[];
                      path=[];
                      if cha_juzhen(1,a2)>0
                          xin_path2=[path_che{a2}{1}(1:cha_juzhen(1,a2)),cha_juzhen(2,a2)+200,path_che{a2}{1}(cha_juzhen(1,a2)+1:end)];
                      else
                          continue
                      end
                      for b=1:length(path_che)
                          if b==a1
                              path=[path,xin_path1];
                          elseif b==a2
                              path=[path,xin_path2];
                          else
                              path=[path,path_che{b}];
                          end
                      end
                      path_store{end+1}=path;
                  end
              end
              for a1=1:tag_charge-2
                  xin_path1=[];
                   if cha_juzhen(1,a1)>0
                      xin_path1=[path_che{a1}{1}(1:cha_juzhen(1,a1)),cha_juzhen(2,a1)+200,path_che{a1}{1}(cha_juzhen(1,a1)+1:end)];
                  else
                      continue
                  end
                  for a2=a1+1:tag_charge-1
                      xin_path2=[];
                      path=[];
                      if cha_juzhen(1,a2)>0
                          xin_path2=[path_che{a2}{1}(1:cha_juzhen(1,a2)),cha_juzhen(2,a2),path_che{a2}{1}(cha_juzhen(1,a2)+1:end)];%第二段插入
                      else
                          continue
                      end
                      for b=1:length(path_che)
                          if b==a1
                              path=[path,xin_path1];
                          elseif b==a2
                              path=[path,xin_path2];
                          else
                              path=[path,path_che{b}];
                          end
                      end
                      path_store{end+1}=path;
                  end
              end
          end
      else
          path3=[];
          for aa=1:length(path_che)
              path3=[path3,path_che{aa}];
          end
          path2=cat(2,path3{:});
          insert_position=[];dis=[];cs=[];
          for b1=1:length(path2)-1
              nowNode=path2(b1);nextNode=path2(b1+1);
              Distance=distance(nowNode,chargingstation)+distance(chargingstation,nextNode);
              index5=find(Distance==min(Distance));
              insert_position(end+1)=b1;dis(end+1)=Distance(index5(1));cs(end+1)=chargingstation(index5(1));
          end
          y=[insert_position;cs;dis]';
          yy=sortrows(y,3,"ascend");
          path2=[path2(1:yy(1,1)),yy(1,2)+200,path2(yy(1,1)+1:end)];
          path_store1{end+1}=path2;
      end
          path_fit=zeros(2,length(path_store1));
          if length(index4)>=2
              for bb=1:length(path_store)
                  pp=[];
                  for cc=1:length(path_store{bb})
                      pp=[pp,path_store{bb}{cc}];
                  end
                  path_store1{end+1} = pp;
              end
          end
          
          for ii=1:length(path_store1)
              [V2Gprofit,chargecost]=cumputeV2G(path_store1{ii},distance,time_period,parameter,price,Requirement,Servicetime);
              path_fit(1,ii)=V2Gprofit;
              path_fit(2,ii)=chargecost;
          end
          index2=find(path_fit(1,:)==max(path_fit(1,:)));
          if path_fit(1,index2(1))>0
              path_cha{end+1}=path_store1{index2(1)};
          else
              index3=find(path_fit(2,:)==min(path_fit(2,:)));
              path_store1{index3(1)}(path_store1{index3(1)}>200);
              path_cha{end+1}=path_store1{index3(1)};
          end
  end
end