function [fit]=computeV2Gnew2(path,distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex)
    fit.timecost=0;
    fit.servicetimecost=sum(Servicetime)*price.time;
    fit.chargecost=0;
    fit.profit=0;
    fit.charge_begin=[];
    fit.discharge_begin=[];
    fit.charge_num=0;
    fit.discharge_num=0;
    fit.V2Gshouyi=0;
    fit.fangtime=0;
    fit.ewaitime=0;
    fit.chongtime=0;
    fit.fangelecost=0;
    fit.ewaielecost=0;
    time_length=[];
    index1=find(path>200);
    index2=find(path>1&path<22);
    Battery=parameter.B;
    Content=parameter.L;
    time=0;
    
    if ~isempty(index2)
        if ~isempty(index1)
            if index2<index1
                for a=1:length(path)-1
                    nowNode=path(a);nextNode=path(a+1);
                    if nextNode==path(index2)
                        if nowNode>200
                            nowNode=nowNode-200;
                        end
                        eij1=energy(parameter,Content,distance,nowNode,nextNode);
                        Battery=Battery-eij1;
                        time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                        fit.charge_begin(end+1)=time;
                        fit.charge_num=fit.charge_num+1;
                        charge=parameter.B-Battery;
                        if ismember(nextNode,Chargingindex{1,1})
                            tag=0;
                        else
                            tag=1;
                        end
                        if time>time_period(1)&&time<time_period(2)
                            if tag==0
                                if (time+(charge/parameter.pc)*60)<=time_period(2)
                                    chargecost=charge*price.chargenew2;
                                else
                                    charge1=((time_period(2)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew2+(charge-charge1)*price.chargenew1;
                                end 
                                pr1=price.chargenew2;
                            else
                                if (time+(charge/parameter.pc)*60)<=time_period(2)
                                    chargecost=charge*price.chargefire2;
                                else
                                    charge1=((time_period(2)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire2+(charge-charge1)*price.chargefire3;
                                end 
                                pr1=price.chargefire2;
                            end
                        elseif time>=time_period(2)&&time<time_period(4)
                            if tag==0
                                if (time+(charge/parameter.pc)*60)<=time_period(4)
                                    chargecost=charge*price.chargenew1;
                                else
                                    charge1=((time_period(4)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew1+(charge-charge1)*price.chargenew2;
                                end 
                                pr1=price.chargenew1;
                            else
                                if (time+(charge/parameter.pc)*60)<=time_period(4)
                                    chargecost=charge*price.chargefire3;
                                else
                                    charge1=((time_period(4)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire3+(charge-charge1)*price.chargefire2;
                                end 
                                pr1=price.chargefire3;
                            end
                         elseif time>=time_period(4)&&time<time_period(5)
                            if tag==0
                                if (time+(charge/parameter.pc)*60)<=time_period(5)
                                    chargecost=charge*price.chargenew2;
                                else
                                    charge1=((time_period(5)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew2+(charge-charge1)*price.chargenew1;
                                end 
                                pr1=price.chargenew2;
                            else
                                if (time+(charge/parameter.pc)*60)<=time_period(5)
                                    chargecost=charge*price.chargefire2;
                                else
                                    charge1=((time_period(5)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire2+(charge-charge1)*price.chargefire3;
                                end 
                                pr1=price.chargefire2;
                            end
                        elseif time>=time_period(5)&&time<time_period(6)
                            if tag==0
                                if (time+(charge/parameter.pc)*60)<=time_period(6)
                                    chargecost=charge*price.chargenew3;
                                else
                                    charge1=((time_period(6)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew3+(charge-charge1)*price.chargenew3;
                                end 
                                pr1=price.chargenew3;
                            else
                                if (time+(charge/parameter.pc)*60)<=time_period(6)
                                    chargecost=charge*price.chargefire3;
                                else
                                    charge1=((time_period(6)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire3+(charge-charge1)*price.chargefire2;
                                end 
                                pr1=price.chargefire3;
                            end
                        elseif time>=time_period(6)&&time<time_period(7)
                            if tag==0
                                if (time+(charge/parameter.pc)*60)<=time_period(7)
                                    chargecost=charge*price.chargenew3;
                                else
                                    charge1=((time_period(7)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew3+(charge-charge1)*price.chargenew3;
                                end 
                                pr1=price.chargenew3;
                            else
                                if (time+(charge/parameter.pc)*60)<=time_period(7)
                                    chargecost=charge*price.chargefire2;
                                else
                                    charge1=((time_period(7)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire2+(charge-charge1)*price.chargefire1;
                                end 
                                pr1=price.chargefire2;
                            end
                        elseif time>=time_period(7)&&time<time_period(8)
                            if tag==0
                                chargecost=charge*price.chargenew3;
                                pr1=price.chargenew3;
                            else
                                chargecost=charge*price.chargefire1;
                                pr1=price.chargefire1;
                            end           
                        end
                        Battery=parameter.B;
                        time=time+(charge/parameter.pc)*60;
                        fit.chongtime=fit.chongtime+(charge/parameter.pc)*60*price.time;
                        fit.chargecost=fit.chargecost+chargecost;
                    elseif nextNode==path(index1)
                        nextNode=nextNode-200;
                        eij1=energy(parameter,Content,distance,nowNode,nextNode);
                        Battery=Battery-eij1;
                        Content1=Content;
                        time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                        total_eij2=0;
                        fit.discharge_begin(end+1)=time;
                        fit.discharge_num=fit.discharge_num+1;
                        for b=index1:length(path)-1
                            if b==index1
                                eij2=energy(parameter,Content1,distance,path(b)-200,path(b+1));
                            else
                                eij2=energy(parameter,Content1,distance,path(b),path(b+1));
                            end
                            Content1=Content1-Requirement(path(b+1));
                            total_eij2=total_eij2+eij2;
                        end
                        time_fang=((Battery-total_eij2)/parameter.pf)*60;
                        fit.fangtime=fit.fangtime+time_fang*price.time;
                        time_ewai=((distance(nowNode,nextNode)+distance(nextNode,path(a+2))-distance(nowNode,path(a+2)))/parameter.v)/60;
                        fit.ewaitime=fit.ewaitime+time_ewai*price.time;
                        cost_energy=eij1+energy(parameter,Content,distance,nextNode,path(a+2))-energy(parameter,Content,distance,nowNode,path(a+2));
                        if time>=time_period(1)&&time<time_period(2)
                            if time+time_fang<=time_period(2)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                            else
                                fang1=((time_period(2)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                            end
                        elseif time>=time_period(2)&&time<time_period(4)
                            if time+time_fang<=time_period(4)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                            else
                                fang1=((time_period(4)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                            end
                        elseif time>=time_period(4)&&time<time_period(5)
                            if time+time_fang<=time_period(5)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                            else
                                fang1=((time_period(5)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                            end
                        elseif time>=time_period(5)&&time<time_period(6)
                            if time+time_fang<=time_period(6)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                            else
                                fang1=((time_period(6)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                            end
                        elseif time>=time_period(6)&&time<time_period(7)
                            if time+time_fang<=time_period(7)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                            else
                                fang1=((time_period(7)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge1;
                            end
                        elseif time>=time_period(7)
                            V2G_shouyi=(Battery-total_eij2)*price.discharge1;
                        end
                        fit.V2Gshouyi=fit.V2Gshouyi+V2G_shouyi;
                        V2Gprofit=V2G_shouyi-(cost_energy+(Battery-total_eij2))*pr1-(time_ewai+time_fang)*price.time;
                        fit.profit=fit.profit+V2Gprofit;
                        fit.ewaielecost=fit.ewaielecost+cost_energy*pr1;
                        fit.fangelecost=(Battery-total_eij2)*pr1;
                        time=time+time_fang;
                        Battery=total_eij2;
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
                fit.timecost=fit.timecost+time*price.time;
            else
                for a=1:length(path)-1
                    nowNode=path(a);nextNode=path(a+1);
                    if nextNode==path(index1)
                        nextNode=nextNode-200;
                        eij1=energy(parameter,Content,distance,nowNode,nextNode);
                        Battery=Battery-eij1;
                        Content1=Content;
                        time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                        total_eij2=0;
                        fit.discharge_begin(end+1)=time;
                        fit.discharge_num=fit.discharge_num+1;
                        for b=index1:index2-1
                            if b==index1
                                eij2=energy(parameter,Content1,distance,path(b)-200,path(b+1));
                            else
                                eij2=energy(parameter,Content1,distance,path(b),path(b+1));                                    
                            end
                            Content1=Content1-Requirement(path(b+1));
                            total_eij2=total_eij2+eij2;
                        end
                        time_fang=((Battery-total_eij2)/parameter.pf)*60;
                        fit.fangtime=fit.fangtime+time_fang*price.time;
                        time_ewai=((distance(nowNode,nextNode)+distance(nextNode,path(a+2))-distance(nowNode,path(a+2)))/parameter.v)/60;
                        fit.ewaitime=fit.ewaitime+time_ewai*price.time;
                        cost_energy=eij1+energy(parameter,Content,distance,nextNode,path(a+2))-energy(parameter,Content,distance,nowNode,path(a+2));
                        if time>=time_period(1)&&time<time_period(2)
                            if time+time_fang<=time_period(2)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                            else
                                fang1=((time_period(2)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                            end
                        elseif time>=time_period(2)&&time<time_period(4)
                            if time+time_fang<=time_period(4)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                            else
                                fang1=((time_period(4)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                            end
                        elseif time>=time_period(4)&&time<time_period(5)
                            if time+time_fang<=time_period(5)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                            else
                                fang1=((time_period(5)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                            end
                        elseif time>=time_period(5)&&time<time_period(6)
                            if time+time_fang<=time_period(6)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                            else
                                fang1=((time_period(6)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                            end
                        elseif time>=time_period(6)&&time<time_period(7)
                            if time+time_fang<=time_period(7)
                                V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                            else
                                fang1=((time_period(7)-time)/60)*parameter.pf;
                                V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge1;
                            end
                        elseif time>=time_period(7)
                            V2G_shouyi=(Battery-total_eij2)*price.discharge1;
                        end
                        fit.V2Gshouyi=fit.V2Gshouyi+V2G_shouyi;
                        V2Gprofit=V2G_shouyi-(cost_energy+(Battery-total_eij2))*price.chargefire1-(time_ewai+time_fang)*price.time;
                        fit.fangelecost=(Battery-total_eij2)*price.chargefire1;
                        fit.ewaielecost=fit.ewaielecost+cost_energy*price.chargefire1;
                        fit.profit=fit.profit+V2Gprofit;
                        time=time+time_fang;
                        Battery=total_eij2;
                    elseif nextNode==path(index2)
                        if nowNode>200
                            nowNode=nowNode-200;
                        end
                        eij1=energy(parameter,Content,distance,nowNode,nextNode);
                        Battery=Battery-eij1;
                        time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                        Content1=Content;
                        fit.charge_begin(end+1)=time;
                        fit.charge_num=fit.charge_num+1;
                        total_eij1=0;
                        for j=index2:length(path)-1
                            eij2=energy(parameter,Content1,distance,path(j),path(j+1));
                            Content1=Content1-Requirement(path(j+1));
                            total_eij1=total_eij1+eij2;
                        end
                        if ismember(nextNode,Chargingindex{1,1})
                            tag=0;
                        else
                            tag=1;
                        end
                        if time>time_period(1)&&time<time_period(2)
                            if tag==0
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(2)
                                    chargecost=(total_eij1-Battery)*price.chargenew2;
                                else
                                    charge1=((time_period(2)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew2+((total_eij1-Battery)-charge1)*price.chargenew1;
                                end 
                            else
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(2)
                                    chargecost=(total_eij1-Battery)*price.chargefire2;
                                else
                                    charge1=((time_period(2)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire2+((total_eij1-Battery)-charge1)*price.chargefire3;
                                end
                            end
                        elseif time>=time_period(2)&&time<time_period(4)
                            if tag==0
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(4)
                                    chargecost=(total_eij1-Battery)*price.chargenew1;
                                else
                                    charge1=((time_period(4)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew1+((total_eij1-Battery)-charge1)*price.chargenew2;
                                end
                            else
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(4)
                                    chargecost=(total_eij1-Battery)*price.chargefire3;
                                else
                                    charge1=((time_period(4)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire3+((total_eij1-Battery)-charge1)*price.chargefire2;
                                end
                            end
                         elseif time>=time_period(4)&&time<time_period(5)
                            if tag==0
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(5)
                                    chargecost=(total_eij1-Battery)*price.chargenew2;
                                else
                                    charge1=((time_period(5)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew2+((total_eij1-Battery)-charge1)*price.chargenew1;
                                end
                            else
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(5)
                                    chargecost=(total_eij1-Battery)*price.chargefire2;
                                else
                                    charge1=((time_period(5)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire2+((total_eij1-Battery)-charge1)*price.chargefire3;
                                end
                            end
                        elseif time>=time_period(5)&&time<time_period(6)
                            if tag==0
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(6)
                                    chargecost=(total_eij1-Battery)*price.chargenew3;
                                else
                                    charge1=((time_period(6)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew3+((total_eij1-Battery)-charge1)*price.chargenew3;
                                end
                            else
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(6)
                                    chargecost=(total_eij1-Battery)*price.chargefire3;
                                else
                                    charge1=((time_period(6)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire3+((total_eij1-Battery)-charge1)*price.chargefire2;
                                end
                            end
                        elseif time>=time_period(6)&&time<time_period(7)
                            if tag==0
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(7)
                                    chargecost=(total_eij1-Battery)*price.chargenew3;
                                else
                                    charge1=((time_period(7)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargenew3+((total_eij1-Battery)-charge1)*price.chargenew3;
                                end
                            else
                                if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(7)
                                    chargecost=(total_eij1-Battery)*price.chargefire2;
                                else
                                    charge1=((time_period(7)-time)/60)*parameter.pc;
                                    chargecost=charge1*price.chargefire2+((total_eij1-Battery)-charge1)*price.chargefire1;
                                end
                            end
                        elseif time>=time_period(7)&&time<time_period(8)
                            if tag==0
                                chargecost=(total_eij1-Battery)*price.chargenew3;
                            else
                                chargecost=(total_eij1-Battery)*price.chargefire1;
                            end           
                        end
                        time=time+((total_eij1-Battery)/parameter.pc)*60;
                        fit.chongtime=fit.chongtime+((total_eij1-Battery)/parameter.pc)*60*price.time;
                        Battery=total_eij1;
                        fit.chargecost=fit.chargecost+chargecost;
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
                fit.timecost=fit.timecost+time*price.time;
            end
        else
            for a=1:length(path)-1
                nowNode=path(a);nextNode=path(a+1);
                if nowNode==path(index2)
                    eij1=energy(parameter,Content,distance,nowNode,nextNode);
                    Battery=Battery-eij1;
                    time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                    Content1=Content;
                    fit.charge_begin(end+1)=time;
                    fit.charge_num=fit.charge_num+1;
                    total_eij1=0;
                    for j=index2(1):length(path)-1
                        eij2=energy(parameter,Content1,distance,path(j),path(j+1));
                        Content1=Content1-Requirement(path(j+1));
                        total_eij1=total_eij1+eij2;
                    end
                    if ismember(nextNode,Chargingindex{1,1})
                        tag=0;
                    else
                        tag=1;
                    end
                    if time>time_period(1)&&time<time_period(2)
                        if tag==0
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(2)
                                chargecost=(total_eij1-Battery)*price.chargenew2;
                            else
                                charge1=((time_period(2)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargenew2+((total_eij1-Battery)-charge1)*price.chargenew1;
                            end 
                        else
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(2)
                                chargecost=(total_eij1-Battery)*price.chargefire2;
                            else
                                charge1=((time_period(2)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargefire2+((total_eij1-Battery)-charge1)*price.chargefire3;
                            end
                        end
                    elseif time>=time_period(2)&&time<time_period(4)
                        if tag==0
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(4)
                                chargecost=(total_eij1-Battery)*price.chargenew1;
                            else
                                charge1=((time_period(4)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargenew1+((total_eij1-Battery)-charge1)*price.chargenew2;
                            end
                        else
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(4)
                                chargecost=(total_eij1-Battery)*price.chargefire3;
                            else
                                charge1=((time_period(4)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargefire3+((total_eij1-Battery)-charge1)*price.chargefire2;
                            end
                        end
                     elseif time>=time_period(4)&&time<time_period(5)
                        if tag==0
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(5)
                                chargecost=(total_eij1-Battery)*price.chargenew2;
                            else
                                charge1=((time_period(5)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargenew2+((total_eij1-Battery)-charge1)*price.chargenew1;
                            end
                        else
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(5)
                                chargecost=(total_eij1-Battery)*price.chargefire2;
                            else
                                charge1=((time_period(5)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargefire2+((total_eij1-Battery)-charge1)*price.chargefire3;
                            end
                        end
                    elseif time>=time_period(5)&&time<time_period(6)
                        if tag==0
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(6)
                                chargecost=(total_eij1-Battery)*price.chargenew3;
                            else
                                charge1=((time_period(6)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargenew3+((total_eij1-Battery)-charge1)*price.chargenew3;
                            end
                        else
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(6)
                                chargecost=(total_eij1-Battery)*price.chargefire3;
                            else
                                charge1=((time_period(6)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargefire3+((total_eij1-Battery)-charge1)*price.chargefire2;
                            end
                        end
                    elseif time>=time_period(6)&&time<time_period(7)
                        if tag==0
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(7)
                                chargecost=(total_eij1-Battery)*price.chargenew3;
                            else
                                charge1=((time_period(7)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargenew3+((total_eij1-Battery)-charge1)*price.chargenew3;
                            end
                        else
                            if (time+((total_eij1-Battery)/parameter.pc)*60)<=time_period(7)
                                chargecost=(total_eij1-Battery)*price.chargefire2;
                            else
                                charge1=((time_period(7)-time)/60)*parameter.pc;
                                chargecost=charge1*price.chargefire2+((total_eij1-Battery)-charge1)*price.chargefire1;
                            end
                        end
                    elseif time>=time_period(7)&&time<time_period(8)
                        if tag==0
                            chargecost=(total_eij1-Battery)*price.chargenew3;
                        else
                            chargecost=(total_eij1-Battery)*price.chargefire1;
                        end           
                    end
                    time=time+((total_eij1-Battery)/parameter.pc)*60;
                    fit.chongtime=fit.chongtime+((total_eij1-Battery)/parameter.pc)*60*price.time;
                    Battery=total_eij1;
                    fit.chargecost=fit.chargecost+chargecost;
                else
                    eij1=energy(parameter,Content,distance,nowNode,nextNode);
                    Battery=Battery-eij1;
                    Content=Content-Requirement(nextNode);
                    time=time+(distance(nowNode,nextNode)/parameter.v)/60+Servicetime(nextNode);
                end
            end
            fit.timecost=fit.timecost+time*price.time;
        end
    else 
        if ~isempty(index1)
            for a=1:length(path)-1
                nowNode=path(a);nextNode=path(a+1);
                if nextNode==path(index1)
                    nextNode=nextNode-200;
                    eij1=energy(parameter,Content,distance,nowNode,nextNode);
                    Battery=Battery-eij1;
                    Content1=Content;
                    time=time+(distance(nowNode,nextNode)/parameter.v)/60;
                    total_eij2=0;
                    fit.discharge_begin(end+1)=time;
                    fit.discharge_num=fit.discharge_num+1;
                    for j=index1:length(path)-1
                        if j==index1
                            eij2=energy(parameter,Content1,distance,path(j)-200,path(j+1));
                        else
                            eij2=energy(parameter,Content1,distance,path(j),path(j+1));
                        end
                        Content1=Content1-Requirement(path(j+1));
                        total_eij2=total_eij2+eij2;
                    end
                    time_fang=((Battery-total_eij2)/parameter.pf)*60;
                    fit.fangtime=fit.fangtime+time_fang*price.time;
                    time_ewai=((distance(nowNode,nextNode)+distance(nextNode,path(a+2))-distance(nowNode,path(a+2)))/parameter.v)/60;
                    fit.ewaitime=fit.ewaitime+time_ewai*price.time;
                    cost_energy=eij1+energy(parameter,Content,distance,nextNode,path(a+2))-energy(parameter,Content,distance,nowNode,path(a+2));
                    if time>=time_period(1)&&time<time_period(2)
                        if time+time_fang<=time_period(2)
                            V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                        else
                            fang1=((time_period(2)-time)/60)*parameter.pf;
                            V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                        end
                    elseif time>=time_period(2)&&time<time_period(4)
                        if time+time_fang<=time_period(4)
                            V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                        else
                            fang1=((time_period(4)-time)/60)*parameter.pf;
                            V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                        end
                    elseif time>=time_period(4)&&time<time_period(5)
                        if time+time_fang<=time_period(5)
                            V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                        else
                            fang1=((time_period(5)-time)/60)*parameter.pf;
                            V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge3;
                        end
                    elseif time>=time_period(5)&&time<time_period(6)
                        if time+time_fang<=time_period(6)
                            V2G_shouyi=(Battery-total_eij2)*price.discharge3;
                        else
                            fang1=((time_period(6)-time)/60)*parameter.pf;
                            V2G_shouyi=fang1*price.discharge3+((Battery-total_eij2)-fang1)*price.discharge2;
                        end
                    elseif time>=time_period(6)&&time<time_period(7)
                        if time+time_fang<=time_period(7)
                            V2G_shouyi=(Battery-total_eij2)*price.discharge2;
                        else
                            fang1=((time_period(7)-time)/60)*parameter.pf;
                            V2G_shouyi=fang1*price.discharge2+((Battery-total_eij2)-fang1)*price.discharge1;
                        end
                    elseif time>=time_period(7)
                        V2G_shouyi=(Battery-total_eij2)*price.discharge1;
                    end
                    fit.V2Gshouyi=fit.V2Gshouyi+V2G_shouyi;
                    V2Gprofit=V2G_shouyi-(cost_energy+(Battery-total_eij2))*price.chargefire1-(time_ewai+time_fang)*price.time;
                    fit.profit=fit.profit+V2Gprofit;
                    fit.ewaielecost=fit.ewaielecost+cost_energy*price.chargefire1;
                    fit.fangelecost=(Battery-total_eij2)*price.chargefire1;
                    time=time+time_fang;
                    Battery=total_eij2;
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
            fit.timecost=fit.timecost+time*price.time;
        else
            for a=1:length(path)-1
                nowNode=path(a);nextNode=path(a+1);
                eij1=energy(parameter,Content,distance,nowNode,nextNode);
                Battery=Battery-eij1;
                Content=Content-Requirement(nextNode);
                time=time+(distance(nowNode,nextNode)/parameter.v)/60+Servicetime(nextNode);
            end
            fit.timecost=fit.timecost+time*price.time;
        end
    end
    time_length(end+1)=time;
    fit.maxtime=max(time_length);
end