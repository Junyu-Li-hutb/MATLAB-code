function [path_cha]=insertnew3(path_cut,time_period,distance,parameter,price,Requirement,Servicetime,path1,Chargingindex)
    path_cha={};
    chargingstation=2:21;
    for i=1:size(path_cut,1)
        path_che=path_cut(i,:);
        path_che(cellfun(@isempty,path_che))=[];
        tag_charge=0;
        for a=1:length(path_che)
            current=path_che{a}{:};
            if any(current>1&current<22)
                tag_charge=a;
                index1=find(current>1&current<22);
                tag_chargeplace=index1-1;
                tag_cs=path_che{a}{:}(index1(1));
                path_che{a}{:}(index1(1))=[];
                break
            end
        end
        cha=zeros(3,2*length(path_che));
        for b=1:length(path_che)
            
            insert_position1=[];dis1=[];cs1=[];
            insert_position2=[];dis2=[];cs2=[];
            path_duan=path_che{b};
            len=length(path_duan{:});
            if len>=2
                for c=1:len-1
                    nowNode=path_duan{:}(c);nextNode=path_duan{:}(c+1);
                    Distance1=distance(nowNode,Chargingindex{1,1})+distance(Chargingindex{1,1},nextNode)-distance(nowNode,nextNode);
                    Distance2=distance(nowNode,Chargingindex{1,2})+distance(Chargingindex{1,2},nextNode)-distance(nowNode,nextNode);
                    index2=find(Distance1==min(Distance1));index3=find(Distance2==min(Distance2));
                    insert_position1(end+1)=c;dis1(end+1)=Distance1(index2(1));cs1(end+1)=Chargingindex{1,1}(index2(1));
                    insert_position2(end+1)=c;dis2(end+1)=Distance2(index3(1));cs2(end+1)=Chargingindex{1,2}(index3(1));
                end
                index4=find(dis1==min(dis1));index5=find(dis2==min(dis2));
                if insert_position1(index4(1))<insert_position2(index5(1))
                    cha(1,2*b-1)=b;cha(2,2*b-1)=insert_position1(index4(1));cha(3,2*b-1)=cs1(index4(1));
                    cha(1,2*b)=b;cha(2,2*b)=insert_position2(index5(1));cha(3,2*b)=cs2(index5(1));
                else
                    cha(1,2*b-1)=b;cha(2,2*b-1)=insert_position2(index5(1));cha(3,2*b-1)=cs2(index5(1));
                    cha(1,2*b)=b;cha(2,2*b)=insert_position1(index4(1));cha(3,2*b)=cs1(index4(1));
                end
            end
        end
        index6=find(cha(1,:)>0);
        path_store1={};
        path_store={};
        if length(index6)>2
            if tag_charge==0
                for d=1:size(cha,2)-1
                    if cha(1,d)>0
                        xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                    else
                        continue
                    end
                    for e=d+1:size(cha,2)
                        xin_path2=[];path=[];tag=0;
                        if cha(1,e)>0
                            if ismember(cha(3,e),Chargingindex{1,2})
                                if mod(d,2)==1
                                    if e==d+1
                                        xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e)+200,xin_path1(cha(2,e)+2:end)];
                                        tag=1;
                                    else
                                        xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                    end
                                else
                                    xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                end
                                if tag==1
                                    for f=1:length(path_che)
                                        if f==fix((d+1)/2)
                                            path=[path,xin_path2];
                                        else
                                            path=[path,path_che{f}{1}];
                                        end
                                    end
                                elseif tag==0
                                    for f=1:length(path_che)
                                        if f==fix((d+1)/2)
                                            path=[path,xin_path1];
                                        elseif f==fix((e+1)/2)
                                            path=[path,xin_path2];
                                        else
                                            path=[path,path_che{f}{1}];
                                        end
                                    end
                                end
                                path_store{end+1}=path;
                            end
                        end
                        
                    end
                end
                for  d=1:size(cha,2)-1
                    xin_path1=[];
                    if cha(1,d)>0
                        if ismember(cha(3,d),Chargingindex{1,2})
                            xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d)+200,path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                        else
                            continue
                        end
                    else
                        continue
                    end
                    for e=d+1:size(cha,2)
                        xin_path2=[];path=[];tag=0;
                        if cha(1,e)>0
                            if mod(d,2)==1
                                if e==d+1
                                    xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e),xin_path1(cha(2,e)+2:end)];
                                    
                                    tag=1;
                                else
                                    xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                end
                            else
                                xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                            end
                            if tag==1
                                for f=1:length(path_che)
                                    if f==fix((d+1)/2)
                                        path=[path,xin_path2];
                                    else
                                        path=[path,path_che{f}{1}];
                                    end
                                end
                            elseif tag==0
                                for f=1:length(path_che)
                                    if f==fix((d+1)/2)
                                        path=[path,xin_path1];
                                    elseif f==fix((e+1)/2)
                                        path=[path,xin_path2];
                                    else
                                        path=[path,path_che{f}{1}];
                                    end
                                end
                            end
                            path_store{end+1}=path;
                        end
                    end
                end
                for d=1:size(cha,2)
                    xin_path1=[];
                    if cha(1,d)>0
                        if ismember(cha(3,d),Chargingindex{1,2})
                            xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d)+200,path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                        else
                            continue
                        end
                    else
                        continue
                    end
                    path=[];
                    for f=1:length(path_che)
                        if f==fix((d+1)/2)
                            path=[path,xin_path1];
                        else
                            path=[path,path_che{f}{1}];
                        end
                    end
                    path_store{end+1}=path;
                end
            else
                if tag_charge==1
                    if tag_chargeplace<cha(2,1)&&tag_chargeplace<cha(2,2)
                        xin_path1=[path_che{1}{1}(1:tag_chargeplace),tag_cs,path_che{1}{1}(tag_chargeplace+1:end)];
                        for e=1:size(cha,2)
                            xin_path2=[];path=[];
                            if e==1||e==2
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e)+200,xin_path1(cha(2,e)+2:end)];
                                        for f=1:length(path_che)
                                            if f==1
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                            else
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        for f=1:length(path_che)
                                            if f==1
                                                path=[path,xin_path1];
                                            elseif f==fix((e+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                            end
                        end
                        xin_path1=[path_che{1}{1}(1:tag_chargeplace),tag_cs,path_che{1}{1}(tag_chargeplace+1:end)];
                        path=[];
                        for f=1:length(path_che)
                            if f==1
                                path=[path,xin_path1];
                            else
                                path=[path,path_che{f}{1}];
                            end
                        end
                        path_store{end+1}=path;
                    elseif tag_chargeplace>=cha(2,1)&&tag_chargeplace<=cha(2,2)
                        xin_path1=[path_che{1}{1}(1:cha(2,1)),cha(3,1),path_che{1}{1}(cha(2,1)+1:end)];
                        for e=2:size(cha,2)
                            xin_path2=[];path=[];
                            if e==2
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e)+200,xin_path1(cha(2,e)+2:end)];
                                        for f=1:length(path_che)
                                            if f==1
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                            else
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        for f=1:length(path_che)
                                            if f==1
                                                path=[path,xin_path1];
                                            elseif f==fix((e+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                            end
                        end
                        xin_path1=[path_che{1}{1}(1:cha(2,1)),cha(3,1),path_che{1}{1}(cha(2,1)+1:end)];
                        path=[];
                        for f=1:length(path_che)
                            if f==1
                                path=[path,xin_path1];
                            else
                                path=[path,path_che{f}{1}];
                            end
                        end
                        path_store{end+1}=path;
    
                    elseif tag_chargeplace>cha(2,1)&&tag_chargeplace>cha(2,2)
                        for d=1:2
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            for e=d+1:size(cha,2)
                                xin_path2=[];path=[];tag=0;
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        if mod(d,2)==1
                                            if e==d+1
                                                xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e)+200,xin_path1(cha(2,e)+2:end)];
                                                
                                                tag=1;
                                            else
                                                xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                            end
                                        else
                                            xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        end
                                        if tag==1
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        elseif tag==0
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path1];
                                                elseif f==fix((e+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                                    
                            end
                        end
                        if cha(1,1)>0&&cha(1,2)>0
                            if ismember(cha(3,1),Chargingindex{1,2})
                                xin_path1=[path_che{1}{1}(1:cha(2,1)),cha(3,1)+200,path_che{1}{1}(cha(2,1)+1:cha(2,2)),cha(3,2),path_che{1}{1}(cha(2,2)+1:end)];
                                path=[];
                                for f=1:length(path_che)
                                    if f==1
                                        path=[path,xin_path1];
                                    else
                                        path=[path,path_che{f}{1}];
                                    end
                                end
                                 path_store{end+1}=path;
                            end
                        end
                        for d=1:2
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{1}{1}(1:cha(2,d)),cha(3,d),path_che{1}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            path=[];
                            for f=1:length(path_che)
                                if f==1
                                    path=[path,xin_path1];
                                else
                                    path=[path,path_che{f}{1}];
                                end
                            end
                            path_store{end+1}=path;
                        end
                    end
                else
                    if tag_chargeplace<cha(2,tag_charge*2-1)&&tag_chargeplace<cha(2,tag_charge*2)
                        for d=1:tag_charge*2-2
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            for e=d+1:size(cha,2)
                                xin_path2=[];path=[];tag=0;
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        if mod(d,2)==1
                                            if e==d+1
                                                xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e)+200,xin_path1(cha(2,e)+2:end)];
                                                tag=1;
                                            else
                                                xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                            end
                                        else
                                            xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        end
                                        if tag==1
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        elseif tag==0
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path1];
                                                elseif f==fix((e+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                                    
                            end
                        end
                        for d=1:tag_charge*2-3
                            xin_path1=[];
                            if cha(1,d)>0
                                if ismember(cha(3,d),Chargingindex{1,2})
                                    xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d)+200,path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                                else
                                    continue
                                end
                            else
                                continue
                            end
                            for e=d+1:tag_charge*2-2
                                xin_path2=[];path=[];tag=0;
                                if cha(1,e)>0
                                    if mod(d,2)==1
                                        if e==d+1
                                            xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e),xin_path1(cha(2,e)+2:end)];
                                            tag=1;
                                        else
                                            xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        end
                                    else
                                        xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                    end
                                    if tag==1
                                        for f=1:length(path_che)
                                            if f==fix((d+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                    elseif tag==0
                                        for f=1:length(path_che)
                                            if f==fix((d+1)/2)
                                                path=[path,xin_path1];
                                            elseif f==fix((e+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                    end
                                    path_store{end+1}=path;
                                end
                            end
                        end
                        for d=1:tag_charge*2-2
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            path=[];
                            for f=1:length(path_che)
                                if f==fix((d+1)/2)
                                    path=[path,xin_path1];
                                else
                                    path=[path,path_che{f}{1}];
                                end
                            end
                            path_store{end+1}=path;
                        end
                    elseif tag_chargeplace<=cha(2,tag_charge*2)&&tag_chargeplace>=cha(2,tag_charge*2-1)
                        for d=1:tag_charge*2-1
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            for e=d+1:size(cha,2)
                                xin_path2=[];path=[];tag=0;
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        if mod(d,2)==1
                                            if e==d+1
                                                xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e)+200,xin_path1(cha(2,e)+2:end)];
                                                tag=1;
                                            else
                                                xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                            end
                                        else
                                            xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        end
                                        if tag==1
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        elseif tag==0
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path1];
                                                elseif f==fix((e+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                            end
                        end
                        for d=1:tag_charge*2-2
                            xin_path1=[];
                            if cha(1,d)>0
                                if ismember(cha(3,d),Chargingindex{1,2})
                                     xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d)+200,path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                                else
                                    continue
                                end
                            else
                                continue
                            end
                            for e=d+1:tag_charge*2-1
                                xin_path2=[];path=[];tag=0;
                                if cha(1,e)>0
                                    if mod(d,2)==1
                                        if e==d+1
                                            xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e),xin_path1(cha(2,e)+2:end)];
                                            tag=1;
                                        else
                                            xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        end
                                    else
                                        xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                    end
                                    if tag==1
                                        for f=1:length(path_che)
                                            if f==fix((d+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                    elseif tag==0
                                        for f=1:length(path_che)
                                            if f==fix((d+1)/2)
                                                path=[path,xin_path1];
                                            elseif f==fix((e+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                    end
                                    path_store{end+1}=path;
                                end
                            end
                        end
                        for d=1:tag_charge*2-1
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            path=[];
                            for f=1:length(path_che)
                                if f==fix((d+1)/2)
                                    path=[path,xin_path1];
                                else
                                    path=[path,path_che{f}{1}];
                                end
                            end
                            path_store{end+1}=path;
                        end
                    elseif tag_chargeplace>cha(2,tag_charge*2-1)&&tag_chargeplace>cha(2,tag_charge*2)
                        for d=1:tag_charge*2
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            for e=d+1:size(cha,2)
                                xin_path2=[];path=[];tag=0;
                                if cha(1,e)>0
                                    if ismember(cha(3,e),Chargingindex{1,2})
                                        if mod(d,2)==1
                                            if e==d+1
                                                xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e)+200,xin_path1(cha(2,e)+2:end)];
                                                
                                                tag=1;
                                            else
                                                xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                            end
                                        else
                                            xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e)+200,path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        end
                                        if tag==1
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        elseif tag==0
                                            for f=1:length(path_che)
                                                if f==fix((d+1)/2)
                                                    path=[path,xin_path1];
                                                elseif f==fix((e+1)/2)
                                                    path=[path,xin_path2];
                                                else
                                                    path=[path,path_che{f}{1}];
                                                end
                                            end
                                        end
                                        path_store{end+1}=path;
                                    end
                                end
                            end
                        end
                        for d=1:tag_charge*2-1
                            xin_path1=[];
                            if cha(1,d)>0
                                if ismember(cha(3,d),Chargingindex{1,2})
                                    xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d)+200,path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                                else
                                    continue
                                end
                            else
                                continue
                            end
                            for e=d+1:tag_charge*2
                                xin_path2=[];path=[];tag=0;
                                if cha(1,e)>0
                                    if mod(d,2)==1
                                        if e==d+1
                                            xin_path2=[xin_path1(1:cha(2,e)+1),cha(3,e),xin_path1(cha(2,e)+2:end)];
                                            
                                            tag=1;
                                        else
                                            xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                        end
                                    else
                                        xin_path2=[path_che{cha(1,e)}{1}(1:cha(2,e)),cha(3,e),path_che{cha(1,e)}{1}(cha(2,e)+1:end)];
                                    end
                                    if tag==1
                                        for f=1:length(path_che)
                                            if f==fix((d+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                    elseif tag==0
                                        for f=1:length(path_che)
                                            if f==fix((d+1)/2)
                                                path=[path,xin_path1];
                                            elseif f==fix((e+1)/2)
                                                path=[path,xin_path2];
                                            else
                                                path=[path,path_che{f}{1}];
                                            end
                                        end
                                    end
                                    path_store{end+1}=path;
                                end
                            end
                        end
                        for d=1:tag_charge*2
                            xin_path1=[];
                            if cha(1,d)>0
                                xin_path1=[path_che{cha(1,d)}{1}(1:cha(2,d)),cha(3,d),path_che{cha(1,d)}{1}(cha(2,d)+1:end)];
                            else
                                continue
                            end
                            path=[];
                            for f=1:length(path_che)
                                if f==fix((d+1)/2)
                                    path=[path,xin_path1];
                                else
                                    path=[path,path_che{f}{1}];
                                end
                            end
                            path_store{end+1}=path;
                        end
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
              Distance=distance(nowNode,Chargingindex{1,2})+distance(Chargingindex{1,2},nextNode);
              index5=find(Distance==min(Distance));
              insert_position(end+1)=b1;dis(end+1)=Distance(index5(1));cs(end+1)=Chargingindex{1,2}(index5(1));
          end
          y=[insert_position;cs;dis]';
          yy=sortrows(y,3,"ascend");
          path2=[path2(1:yy(1,1)),yy(1,2)+200,path2(yy(1,1)+1:end)];
          path_store1{end+1}=path2;
        end
        if ~isempty(path_store)
              for bb=1:length(path_store)
                  path_store1{end+1} =path_store{bb};
              end
        end
        path_fit=ones(3,length(path_store1))*0;
        if length(path_store1)==0
              path_new=path_cut(i,:);
              path_new(cellfun(@isempty,path_new))=[];
              path22=[];
              for dd=1:length(path_new)
                  path22=[path22,path_new{dd}{1}];
              end
              path_cha{end+1}=path22;
              continue
        end
        path_new=path_cut(i,:);
          path_new(cellfun(@isempty,path_new))=[];
          path22=[];
          for dd=1:length(path_new)
              path22=[path22,path_new{dd}{1}];
          end
        path_store1{end+1}=path22;
        for ii=1:length(path_store1)
              [fit]=computeV2Gnew2(path_store1{ii},distance,Requirement,Servicetime,parameter,price,time_period,Chargingindex);
               if fit.V2Gshouyi>0&&fit.fangelecost>0&&fit.fangtime>0
                  path_fit(1,ii)=fit.profit;
                  path_fit(2,ii)=fit.chargecost;
                  path_fit(3,ii)=fit.chargecost;
               else
                   continue
               end
        end
        jiancha=[];
        indexx=find(path_fit(1,:)>0);
          if isempty(indexx)
              path_cha{end+1}=path1{i};
          else
              for c=1:size(path_fit,2)
                jiancha(end+1)=path_fit(1,c)-path_fit(2,c);
              end
              index9=find(jiancha==max(jiancha));
              if jiancha(index9(1))>0
                path_cha{end+1}=path_store1{index9(1)};
              else
                  index10=find(path_fit(2,:)==min(path_fit(2,:)));
                  index11=find(path_store1{index10(1)}>200);
                  if isempty(index11)
                      path_cha{end+1}=path_store1{index10(1)};
                  else
                      pathnew=path_store1{index10(1)}(path_store1{index10(1)}<200);
                      path_cha{end+1}=pathnew;
                  end
              end
          end
    end
end