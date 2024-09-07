function [path1]=decodetsp(path,parameter,distance,Requirement,Servicetime)
    path1={};
    path2=[];
    NOC=0;
    nowLoad=parameter.L;
    nowBattery=parameter.B;
    cs_choose=[0];
    nowNode=1;
    path2(end+1)=nowNode;
    while ~isempty(path)
        nextNode=path(1);
        eij1=energy(parameter,nowLoad,distance,nowNode,nextNode);
        cs=chargingstation_choose_near(nowBattery,nextNode,distance,nowLoad,parameter,Requirement);
        if cs.tag==1
            if NOC==0
                path2(end+1)=cs_choose(end);
                nowNode=path2(end);
                nowBattery=parameter.B;
                NOC=1;
                continue
            elseif NOC==1
                path2(end+1)=1;
                path1{end+1}=path2;
                nowBattery=parameter.B;
                nowLoad=parameter.L;
                nowNode=1;
                path2=nowNode;
                cs_choose=[0];
                NOC=0;
                continue
            end
        else
            cs_choose(end+1)=cs.num;
        end
        eij2=energy(parameter,nowLoad-Requirement(nextNode),distance,nowNode,cs.num);
        eij3=energy(parameter,nowLoad-Requirement(nextNode),distance,nowNode,1);
        if nowLoad>=Requirement(nextNode)
            if NOC==0
                if nowBattery-eij1-eij2>=0
                        path2(end+1)=nextNode;
                        path(find(nextNode==path))=[];
                        nowLoad=nowLoad-Requirement(nextNode);
                        nowBattery=nowBattery-eij1;
                        nowNode=nextNode;
                elseif nowBattery-eij1-eij2<0
                    path2(end+1)=cs_choose(end-1);
                    nowBattery=parameter.B;
                    NOC=1;
                    nowNode=path2(end);
                end
            elseif NOC==1
                if nowBattery-eij1-eij3>=0
                        path2(end+1)=nextNode;
                       path(find(nextNode==path))=[];
                       nowLoad=nowLoad-Requirement(nextNode);
                       nowBattery=nowBattery-eij1;
                       nowNode=nextNode;
                elseif nowBattery-eij1-eij3<0
                    path2(end+1)=1;
                    path1{end+1}=path2;
                    nowLoad=parameter.L;
                    nowBattery=parameter.B;
                    nowNode=1;
                    path2=nowNode;
                    cs_choose=[0];
                    NOC=0;
                end
            end
        elseif nowLoad<Requirement(nextNode)
            if NOC==0
               eij4=energy(parameter,nowLoad,distance,nowNode,1);
               if nowBattery>=eij4
                   path2(end+1)=1;
                   path1{end+1}=path2;
                   nowLoad=parameter.L;
                   nowBattery=parameter.B;
                   nowNode=1;
                   path2=nowNode;
                   cs_choose=[0];
                   NOC=0;
               elseif nowBattery<eij4
                   path2(end+1)=cs_choose(end);
                   nowBattery=parameter.B;
                   path2(end+1)=1;
                   path1{end+1}=path2;
                   nowLoad=parameter.L;
                   nowBattery=parameter.B;
                   nowNode=1;
                   path2=nowNode;
                   cs_choose=[0];
                   NOC=0;
               end
            elseif NOC==1
                path2(end+1)=1;
                path1{end+1}=path2;
                nowLoad=parameter.L;
                nowBattery=parameter.B;
                nowNode=1;
                path2=nowNode;
                cs_choose=[0];
                NOC=0;
            end
        end
    end
    if NOC==0
        eij5=energy(parameter,nowLoad,distance,nowNode,1);
        if nowBattery>=eij5
            path2(end+1)=1;
            path1{end+1}=path2;
        elseif nowBattery<eij5
            path2(end+1)=cs_choose(end);
            nowBattery=parameter.B;
            path2(end+1)=1;
            path1{end+1}=path2;
        end
    elseif NOC==1
        path2(end+1)=1;
        path1{end+1}=path2;
    end
end