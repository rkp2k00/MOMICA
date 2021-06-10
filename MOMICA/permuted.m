function TheEmpire= permuted(TheEmpire,edpp,ica)

  colonies_position= TheEmpire.Colonies_position;
  colonies_cost = TheEmpire.Colonies_cost;
  colonies_position(end+1,:)= TheEmpire.Imperialist_position;
  colonies_cost (end+1,:)=TheEmpire.Imperialist_normalized_cost;
  
  [~,ind,~]=Non_dominated_sorting(colonies_cost,ica,edpp.N_obj);
  colonies_position = colonies_position(ind,:);
  colonies_cost = colonies_cost(ind,:);
  
  TheEmpire.Imperialist_position = colonies_position(1,:);
  TheEmpire.Imperialist_normalized_cost=colonies_cost(1,:);
   
  TheEmpire.Colonies_position= colonies_position(2:end,:);
  TheEmpire.Colonies_cost= colonies_cost(2:end,:);
 
end
