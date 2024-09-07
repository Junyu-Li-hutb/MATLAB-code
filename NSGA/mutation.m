
function [newChrome_part,Chrome_wait]=mutation(pmnew,newChrome_cross,newChrome_part,distance)
    Chrome_wait={};
    for i=length(newChrome_part)
        if pmnew>=rand
            project=newChrome_part{i};len=length(project);num=randi([1,len]);
            for a=1:len
                project{a}(project{a}==1)=[];
                project{a}(project{a}>200)=[];
                project{a}(project{a}>1&project{a}<22)=[];
            end
            project_connect=[];
            for a=1:len
                if a~=num
                    project_connect=[project_connect,project{a}];
                end
            end
            project_aftermutaition=insert_lack(project_connect,project{num},distance);
            if length(project_aftermutaition)~=100
                project_connect=unique(project_connect,'stable');
                lack1=setdiff(22:121,project_connect);
                project_aftermutaition=insert_lack(project_connect,lack1,distance);
                Chrome_wait{end+1}=project_aftermutaition;
            else
                Chrome_wait{end+1}=project_aftermutaition;
            end
            newChrome_part{i}=[];
        end
    end
    newChrome_part(cellfun(@isempty,newChrome_part))=[];
    for i=1:length(newChrome_cross)
        if pmnew>=rand
            project=newChrome_cross{i};
            random=randperm(length(project));
            lack=project(random(1:floor(length(project)/2)));
            project=setdiff(project,lack);
            lack1=setdiff(22:121,project);
            project_aftermutaition=insert_lack(project,lack1,distance);
            Chrome_wait{end+1}=project_aftermutaition;
            if length(project_aftermutaition)~=100
                keyboard
            end
        else
            Chrome_wait{end+1}=newChrome_cross{i};
            if length(Chrome_wait{end})~=100
                if length(Chrome_wait{end})>100
                    path=Chrome_wait{end};
                    Chrome_wait{end}=path(1:100);
                else
                    path=Chrome_wait{end};
                    lack1=setdiff(22:121,path);
                    path=insert_lack(path,lack1,distance);
                    Chrome_wait{end}=path(1:100);
                end
            end
        end
    end
    Chrome_wait(cellfun(@isempty,Chrome_wait))=[];
end