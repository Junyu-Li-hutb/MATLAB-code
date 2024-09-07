
function [newChrome_cross]=cross(Chrome_remain,pcnew,distance)
    newChrome_cross={};
    customer=22:121;
    for i=1:2:length(Chrome_remain)-1
        if pcnew>=rand
            project1=Chrome_remain{i};project2=Chrome_remain{i+1};
            len1=length(project1);len2=length(project2);
            for a=1:len1
                project1{a}(project1{a}==1)=[];
                project1{a}(project1{a}>200)=[];
                project1{a}(project1{a}>1&project1{a}<22)=[];
            end
            for b=1:len2
                project2{b}(project2{b}==1)=[];
                project2{b}(project2{b}>200)=[];
                project2{b}(project2{b}>1&project2{b}<22)=[];
            end
            num1=randi([1,len1]);num2=randi([1,len2]);
            crosspart1=project1{num1};crosspart2=project2{num2};
            project1_remain=setdiff(1:len1,num1);project2_remain=setdiff(1:len2,num2);
            project11=cell(1,length(project1));
            project22=cell(1,length(project2)); 
            for c=1:length(project1_remain)
                project11{c}=setdiff(project1{project1_remain(c)},crosspart2);
            end
            for d=1:length(project2_remain)
                project22{d}=setdiff(project2{project2_remain(d)},crosspart1);
            end
            project_connect1=[];project_connect2=[];
            for e=1:len1
                if e==num1
                    project_connect1=[project_connect1,crosspart2];
                else
                    project_connect1=[project_connect1,project11{e}];
                end
            end
            for f=1:len2
                if f==num2
                    project_connect2=[project_connect2,crosspart1];
                else
                    project_connect2=[project_connect2,project22{f}];
                end
            end
            lack1=setdiff(customer,project_connect1);lack2=setdiff(customer,project_connect2);
            if length(lack2)==100
                project_aftercross2=randperm(100)+21;
            else
                project_aftercross2=insert_lack(project_connect2,lack2,distance);
            end
            if length(lack1)==100
                project_aftercross1=randperm(100)+21;
            else
                project_aftercross1=insert_lack(project_connect1,lack1,distance);
            end
            if length(project_aftercross1)~=100||length(project_aftercross2)~=100
                if length(project_aftercross1)>100
                    project_aftercross1=unique(project_aftercross1, 'stable');
                end
                if length(project_aftercross2)>100
                    project_aftercross2=unique(project_aftercross2, 'stable');
                end
                if length(project_aftercross1)<100||length(project_aftercross2)<100
                    keyboard
                end
                newChrome_cross{end+1}=project_aftercross1;
                newChrome_cross{end+1}=project_aftercross2;
            else
                newChrome_cross{end+1}=project_aftercross1;
                newChrome_cross{end+1}=project_aftercross2;
                
            end
        else
            project1=Chrome_remain{i};project2=Chrome_remain{i+1};
            projectnew1=[];projectnew2=[];
            for g=1:length(project1)
                projectnew1=[projectnew1, project1{g}];
            end
            projectnew1(projectnew1==1)=[];projectnew1(projectnew1>200)=[];projectnew1(projectnew1>1&projectnew1<22)=[];
            newChrome_cross{end+1}=projectnew1;
            for h=1:length(project2)
                projectnew2=[projectnew2, project2{h}];
            end
            projectnew2(projectnew2==1)=[];projectnew2(projectnew2>200)=[];projectnew2(projectnew2>1&projectnew2<22)=[];
            newChrome_cross{end+1}=projectnew2;
        end
    end
end