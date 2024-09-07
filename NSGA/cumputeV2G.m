function [V2Gprofit,chargecost,totalele]=cumputeV2G(path,distance,time_period,parameter,price,Requirement,Servicetime)
  index1=find(path>1&path<22);
  index2=find(path>200);
  Battery=parameter.B;
  Content=parameter.L;
  time=0;
  chargecost=0;
  totalele=0;
  if ~isempty(index1)
      if index1<index2
          for i=1:length(path)-1
              nowNode=path(i);nextNode=path(i+1);
              if nextNode==path(index1(1))
                  if nowNode>200
                      nowNode=nowNode-200;
                  end
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  Battery=Battery-eij1;
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                  charge=parameter.B-Battery;
                  if time>=time_period(1)&&time<time_period(2)
                      if (time+(charge/parameter.pc)*60)<=time_period(2)
                          chargecost=charge*price.charge2;
                      else
                          charge1=((time_period(2)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge2+(charge-charge1)*price.charge3;
                      end
                      pr1=price.charge2;
                  elseif time>=time_period(2)&&time<time_period(3)
                      if (time+(charge/parameter.pc)*60)<=time_period(3)
                          chargecost=charge*price.charge3;
                      else
                          charge1=((time_period(3)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge3+(charge-charge1)*price.charge2;
                      end
                      pr1=price.charge3;
                  elseif time>=time_period(3)&&time<time_period(4)
                      if (time+(charge/parameter.pc)*60)<=time_period(4)
                          chargecost=charge*price.charge2;
                      else
                          charge1=((time_period(4)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge2+(charge-charge1)*price.charge3;
                      end
                      pr1=price.charge2;
                  elseif time>=time_period(4)&&time<time_period(5)
                      if (time+(charge/parameter.pc)*60)<=time_period(5)
                          chargecost=charge*price.charge3;
                      else
                          charge1=((time_period(5)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge3+(charge-charge1)*price.charge2;
                      end
                      pr1=price.charge3;
                  elseif time>=time_period(5)&&time<time_period(6)
                      if (time+(charge/parameter.pc)*60)<=time_period(6)
                          chargecost=charge*price.charge2;
                      else
                          charge1=((time_period(6)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge2+(charge-charge1)*price.charge1;
                      end
                      pr1=price.charge2;
                  elseif time>=time_period(6)
                      chargecost=charge*price.charge1;
                      pr1=price.charge1;
                  end
                  Battery=parameter.B;
                  time=time+(charge/parameter.pc)*60;
              elseif nextNode==path(index2(1))
                  nextNode=nextNode-200;%恢复放电站编号
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  Battery=Battery-eij1;
                  Content1=Content;
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                  total_eij2=0;
                  for j=index2(1):length(path)-1
                      if j==index2(1)
                          eij2=energy(parameter,Content1,distance,path(j)-200,path(j+1));
                      else
                          eij2=energy(parameter,Content1,distance,path(j),path(j+1));
                      end
                      Content1=Content1-Requirement(path(j+1));
                      total_eij2=total_eij2+eij2;
                  end
                  time_fang=((Battery-total_eij2)/parameter.pf)*60;
                  time_ewai=((distance(nowNode,nextNode)+distance(nextNode,path(i+2))-distance(nowNode,path(i+2)))/parameter.v)/60;
                  cost_energy=eij1+energy(parameter,Content,distance,nextNode,path(i+2))-energy(parameter,Content,distance,nowNode,path(i+2));
                  if time>=time_period(1)&&time<time_period(2)
                      if time+time_fang<=time_period(2)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(2)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                      end
                  elseif time>=time_period(2)&&time<time_period(3)
                      if time+time_fang<=time_period(3)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                      else
                          fang1=((time_period(3)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                      end
                  elseif time>=time_period(3)&&time<time_period(4)
                      if time+time_fang<=time_period(4)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(4)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                      end
                  elseif time>=time_period(4)&&time<time_period(5)
                      if time+time_fang<=time_period(5)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                      else
                          fang1=((time_period(5)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                      end
                  elseif time>=time_period(5)&&time<time_period(6)
                      if time+time_fang<=time_period(6)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(6)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge1;
                      end
                  elseif time>=time_period(6)
                      V2G_shouyi=(Battery-total_eij2)*price.discharge1;
                  end
                  V2Gprofit=V2G_shouyi-(cost_energy+(Battery-total_eij2))*pr1-(time_ewai+time_fang)*price.time;
                  time=time+time_fang;
                  Battery=total_eij2;
              else
                  if nowNode>200
                      nowNode=nowNode-200;
                  end
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  totalele=totalele+eij1;
                  Battery=Battery-eij1;
                  Content=Content-Requirement(nextNode);
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60+Servicetime(nextNode);
              end
          end
      else
          for i=1:length(path)-1
              nowNode=path(i);nextNode=path(i+1);
              if nextNode==path(index2(1))
                  nextNode=nextNode-200;
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  Battery=Battery-eij1;
                  Content1=Content;
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                  total_eij2=0;
                  for j=index2(1):index1(1)-1
                      if j==index2(1)
                          eij2=energy(parameter,Content1,distance,path(j)-200,path(j+1));
                      else
                          eij2=energy(parameter,Content1,distance,path(j),path(j+1));
                      end
                      Content1=Content1-Requirement(path(j+1));
                      total_eij2=total_eij2+eij2;
                  end
                  time_fang=((Battery-total_eij2)/parameter.pf)*60;
                  time_ewai=((distance(nowNode,nextNode)+distance(nextNode,path(i+2))-distance(nowNode,path(i+2)))/parameter.v)/60;
                  cost_energy=eij1+energy(parameter,Content,distance,nextNode,path(i+2))-energy(parameter,Content,distance,nowNode,path(i+2));
                  if time>=time_period(1)&&time<time_period(2)
                      if time+time_fang<=time_period(2)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(2)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                      end
                  elseif time>=time_period(2)&&time<time_period(3)
                      if time+time_fang<=time_period(3)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                      else
                          fang1=((time_period(3)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                      end
                  elseif time>=time_period(3)&&time<time_period(4)
                      if time+time_fang<=time_period(4)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(4)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                      end
                  elseif time>=time_period(4)&&time<time_period(5)
                      if time+time_fang<=time_period(5)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                      else
                          fang1=((time_period(5)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                      end
                  elseif time>=time_period(5)&&time<time_period(6)
                      if time+time_fang<=time_period(6)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(6)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge1;
                      end
                  elseif time>=time_period(6)
                      V2G_shouyi=(Battery-total_eij2)*price.discharge1;
                  end
                  
                  V2Gprofit=V2G_shouyi-(cost_energy+(Battery-total_eij2))*price.charge1-(time_ewai+time_fang)*price.time;
                  time=time+time_fang;
                  Battery=total_eij2;
              elseif nextNode==path(index1(1))
                  if nowNode>200
                      nowNode=nowNode-200;
                  end
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  Battery=Battery-eij1;
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                  Content1=Content;
                  total_eij1=0;
                  for j=index1(1):length(path)-1
                      eij2=energy(parameter,Content1,distance,path(j),path(j+1));
                      Content1=Content1-Requirement(path(j+1));
                      total_eij1=total_eij1+eij2;
                  end
                  if time>=time_period(1)&&time<time_period(2)
                      if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(2)
                          chargecost=(total_eij1-Battery)*price.charge2;
                      else
                          charge1=((time_period(2)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge2+(total_eij1-Battery-charge1)*price.charge3;
                      end
                  elseif time>=time_period(2)&&time<time_period(3)
                      if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(3)
                          chargecost=(total_eij1-Battery)*price.charge3;
                      else
                          charge1=((time_period(3)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge3+(total_eij1-Battery-charge1)*price.charge2;
                      end
                  elseif time>=time_period(3)&&time<time_period(4)
                      if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(4)
                          chargecost=(total_eij1-Battery)*price.charge2;
                      else
                          charge1=((time_period(4)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge2+(total_eij1-Battery-charge1)*price.charge3;
                      end
                  elseif time>=time_period(4)&&time<time_period(5)
                      if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(5)
                          chargecost=(total_eij1-Battery)*price.charge3;
                      else
                          charge1=((time_period(5)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge3+(total_eij1-Battery-charge1)*price.charge2;
                      end
                  elseif time>=time_period(5)&&time<time_period(6)
                      if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(6)
                          chargecost=(total_eij1-Battery)*price.charge2;
                      else
                          charge1=((time_period(6)-time)/60)*parameter.pc;
                          chargecost=charge1*price.charge2+(total_eij1-Battery-charge1)*price.charge1;
                      end
                  elseif time>=time_period(6)
                      chargecost=(total_eij1-Battery)*price.charge1;
                  end
                  
                  time=time+((total_eij1-Battery)/parameter.pc)*60;
                  Battery=total_eij1;
              else
                  if nowNode>200
                      nowNode=nowNode-200;
                  end
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  Battery=Battery-eij1;
                  Content=Content-Requirement(nextNode);
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60+Servicetime(nextNode);
              end
          end
      end
  else
      for i=1:length(path)-1
              nowNode=path(i);nextNode=path(i+1);
              if nextNode==path(index2(1))
                  nextNode=nextNode-200;
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  Battery=Battery-eij1;
                  Content1=Content;
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                  total_eij2=0;
                  for j=index2(1):length(path)-1
                      if j==index2(1)
                          eij2=energy(parameter,Content1,distance,path(j)-200,path(j+1));
                      else
                          eij2=energy(parameter,Content1,distance,path(j),path(j+1));
                      end
                      Content1=Content1-Requirement(path(j+1));
                      total_eij2=total_eij2+eij2;
                  end
                  time_fang=((Battery-total_eij2)/parameter.pf)*60;
                  time_ewai=((distance(nowNode,nextNode)+distance(nextNode,path(i+2))-distance(nowNode,path(i+2)))/parameter.v)/60;
                  cost_energy=eij1+energy(parameter,Content,distance,nextNode,path(i+2))-energy(parameter,Content,distance,nowNode,path(i+2));
                  if time>=time_period(1)&&time<time_period(2)
                      if time+time_fang<=time_period(2)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(2)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                      end
                  elseif time>=time_period(2)&&time<time_period(3)
                      if time+time_fang<=time_period(3)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                      else
                          fang1=((time_period(3)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                      end
                  elseif time>=time_period(3)&&time<time_period(4)
                      if time+time_fang<=time_period(4)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(4)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                      end
                  elseif time>=time_period(4)&&time<time_period(5)
                      if time+time_fang<=time_period(5)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                      else
                          fang1=((time_period(5)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                      end
                  elseif time>=time_period(5)&&time<time_period(6)
                      if time+time_fang<=time_period(6)
                          V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                      else
                          fang1=((time_period(6)-time)/60)*parameter.pf;
                          V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge1;
                      end
                  elseif time>=time_period(6)
                      V2G_shouyi=(Battery-total_eij2)*price.discharge1;
                  end
                  
                  V2Gprofit=V2G_shouyi-(cost_energy+(Battery-total_eij2))*price.charge1-(time_ewai+time_fang)*price.time;
                  time=time+time_fang;
                  Battery=total_eij2;
              else
                  if nowNode>200
                      nowNode=nowNode-200;
                  end
                  eij1=energy(parameter,Content,distance,nowNode,nextNode);
                  totalele=totalele+eij1;
                  Battery=Battery-eij1;
                  Content=Content-Requirement(nextNode);
                  time=time+(distance(nowNode,nextNode)/parameter.v)/60+Servicetime(nextNode);
              end
      end
  end
end