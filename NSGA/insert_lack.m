function project_aftercross=insert_lack(project_connect,lack,distance)
    project_aftercross=project_connect;
    while ~isempty(lack)
        displus=[];
        for i=1:length(project_aftercross)
            if i==length(project_aftercross)
                plus=distance(project_aftercross(i),lack(1));
                displus(end+1)=plus;
            else
                plus=distance(project_aftercross(i),lack(1))+distance(project_aftercross(i+1),lack(1))-distance(project_aftercross(i+1),project_aftercross(i));
                displus(end+1)=plus;
            end
        end
        index=find(displus==min(displus));
        if index(1)==length(displus)
            project_aftercross=[project_aftercross,lack(1)];
        else
            project_aftercross=[project_aftercross(1:index(1)),lack(1),project_aftercross(index(1)+1:end)];
        end
        lack(1)=[];
    end
end