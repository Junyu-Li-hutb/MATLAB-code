function [rankings_new,crowdingDis_new,newChrome_father]=newfather(rankings,crowdingDis,Chrome_fatherandson,chromenum)
    rankings=rankings';crowdingDis=crowdingDis';
    rankings_new=[];crowdingDis_new=[];newChrome_father={};
    while length(newChrome_father)<chromenum
        minrank=min(rankings);
        index=find(rankings==minrank);
        len=length(index);
        if length(newChrome_father)+len<=chromenum
            toRemove = false(size(rankings));
            toRemove(index) = true;
            rankings_new=[rankings_new,rankings(index)];
            crowdingDis_new=[crowdingDis_new,crowdingDis(index)];
            newChrome_father=horzcat(newChrome_father,Chrome_fatherandson(index));
            rankings(toRemove) = [];
            crowdingDis(toRemove) = [];
            Chrome_fatherandson(toRemove) = {[]};
            Chrome_fatherandson(cellfun(@isempty,Chrome_fatherandson))=[];
        else
            if chromenum-length(newChrome_father)==1
                crowdingDisrank=crowdingDis(index);
                index1=find(crowdingDisrank==max(crowdingDisrank));
                rankings_new=[rankings_new,rankings(index(index1(1)))];
                crowdingDis_new=[crowdingDis_new,crowdingDis(index(index1(1)))];
                newChrome_father=horzcat(newChrome_father,Chrome_fatherandson(index(index1(1))));
                rankings(index(index1(1)))=[];crowdingDis(index(index1(1)))=[];Chrome_fatherandson(index(index1(1)))={[]};
                Chrome_fatherandson(cellfun(@isempty,Chrome_fatherandson))=[];
            elseif chromenum-length(newChrome_father)==2
                crowdingDisrank=crowdingDis(index);
                index1=find(crowdingDisrank==max(crowdingDisrank));
                rankings_new=[rankings_new,rankings(index(index1))];
                crowdingDis_new=[crowdingDis_new,crowdingDis(index(index1))];
                newChrome_father=horzcat(newChrome_father,Chrome_fatherandson(index(index1)));
                rankings(index(index1))=[];crowdingDis(index(index1))=[];Chrome_fatherandson(index(index1))={[]};
                Chrome_fatherandson(cellfun(@isempty,Chrome_fatherandson))=[];
            else
                crowdingDisrank=crowdingDis(index);
                index1=find(crowdingDisrank==max(crowdingDisrank));
                rankings_new=[rankings_new,rankings(index(index1))];
                crowdingDis_new=[crowdingDis_new,crowdingDis(index(index1))];
                newChrome_father=horzcat(newChrome_father,Chrome_fatherandson(index(index1)));
                crowdingDisrank(index1)=[];
                neednum=chromenum-length(newChrome_father)-2;
                [~, indices]=sort(crowdingDisrank, 'descend');
                needindex=indices(1:neednum);
                rankings_new=[rankings_new,rankings(index(needindex))];
                crowdingDis_new=[crowdingDis_new,crowdingDis(index(needindex))];
                newChrome_father=horzcat(newChrome_father,Chrome_fatherandson(index(needindex)));
            end
        end
    end
end