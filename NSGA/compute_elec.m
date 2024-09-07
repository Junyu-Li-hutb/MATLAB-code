function [electricity]=compute_elec(path,distance,Requirement,parameter,index)
  Battery=parameter.B;
  Content=parameter.L;
  for i=1:length(path)-1
      nextNode=path(i+1);
      eij1=energy(parameter,Content,distance,path(i),nextNode);
      if nextNode>=2&&nextNode<=21
          Battery=Battery-eij1;
          Content1=Content;
          total_eij=0;
          for b3=index(1):length(path)-1
                eij2=energy(parameter,Content1,distance,path(b3),path(b3+1));
                Content1=Content1-Requirement(path(b3+1));
                total_eij=total_eij+eij2;
          end
          electricity=total_eij-Battery;
      else
          Battery=Battery-eij1;
          Content=Content-Requirement(nextNode);
      end
  end
end