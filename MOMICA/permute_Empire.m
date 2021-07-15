function TheEmpire= permute_Empire(TheEmpire,edpp,ica)

  global_position= TheEmpire.Colonies_position;
  global_cost = TheEmpire.Colonies_cost;
  global_position(end+1:end+size(TheEmpire.Imperialist_position,1),:)= TheEmpire.Imperialist_position;
  global_cost(end+1:end+size(TheEmpire.Imperialist_position,1),:)=TheEmpire.Imperialist_normalized_cost;
  
  [front_imp,ind,~]=Non_dominated_sorting(global_cost,ica,edpp.N_obj);
  global_position = global_position(ind,:);
  global_cost = global_cost(ind,:);
  
  TheEmpire.Imperialist_position = global_position(1:numel(front_imp(1).pts(:,3)),:);
  TheEmpire.Imperialist_normalized_cost=global_cost(1:numel(front_imp(1).pts(:,3)),:);
   
  TheEmpire.Colonies_position= global_position(numel(front_imp(1).pts(:,3))+1:end,:);
  TheEmpire.Colonies_cost= global_cost(numel(front_imp(1).pts(:,3))+1:end,:);
  
  totalImp = size(TheEmpire.Imperialist_normalized_cost, 1);
  totalPop = size(global_cost, 1);
  
  if ica.ImperialistPercentage <= (totalImp/totalPop)
    
    NumOfRevolvingImperialists = totalImp - round(ica.ImperialistPercentage*totalPop);
    NumberOfImp = totalImp-NumOfRevolvingImperialists;
    
    TheEmpire.Colonies_cost=[TheEmpire.Colonies_cost;TheEmpire.Imperialist_normalized_cost(NumberOfImp+1:end,:)];
    TheEmpire.Colonies_position=[TheEmpire.Colonies_position;TheEmpire.Imperialist_position(NumberOfImp+1:end,:)];  
    TheEmpire.Imperialist_normalized_cost = TheEmpire.Imperialist_normalized_cost(1:NumberOfImp,:);
    TheEmpire.Imperialist_position =  TheEmpire.Imperialist_position(1:NumberOfImp,:);
   
  end
  
end


