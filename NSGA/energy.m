function eij=energy(parameter,nowLoad,distance,Node1,Node2)
   eij=(1/3600000)*(1/parameter.efficiency)*(parameter.aij*(parameter.W+nowLoad)*distance(Node1,Node2)+(0.5*parameter.Cd*parameter.S*parameter.density)*parameter.v*parameter.v...
     *distance(Node1,Node2))+(1/parameter.efficiency)*(1/3600)*(parameter.A*(distance(Node1,Node2)/parameter.v));
end