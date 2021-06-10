  function [Empires,n]= createInitialEmpires(ica,edpp,Initial_countries,Initial_cost)

   empires_positions= Initial_countries(1:ica.no_of_initial_Imperialist,:); % ica.no_of_Imperialistx edpp.N_varDim
   empires_cost= Initial_cost(1:ica.no_of_initial_Imperialist,:);  % ica.no_of_Imperialist x edpp.N_obj
  
   colonies_countries_positions = Initial_countries(ica.no_of_initial_Imperialist+1:end,:); % ica.no_of_colonies x edpp.N_varDim
   colonies_cost  = Initial_cost(ica.no_of_initial_Imperialist+1:end,:);  % ica.no_of_colonies x edpp.N_obj
   
   if (size(find(max(empires_cost)>0),2) == edpp.N_obj)
    NormalizedCost_Imperialist = 1.3 * repmat(max(empires_cost),size(empires_cost,1),1)-empires_cost;
   else                                                             
    NormalizedCost_Imperialist = 0.7 * repmat(max(empires_cost),size(empires_cost,1),1) - empires_cost;
   end                                                                                                  
   power_of_Imperialist = (NormalizedCost_Imperialist)/(sum(NormalizedCost_Imperialist)); % ica.no_of_Imperialist x edpp.N_obj
   
   n = round(power_of_Imperialist*ica.no_of_colonies); % ica.no_of_Imperialist x edpp.N_obj, n = Initial_no_of_colony_possesed by Imp
   n(end) = ica.no_of_countries - sum(n(1:end-1));
   Random_index=  randperm(ica.no_of_countries - ica.no_of_initial_Imperialist);                            % num of captured colony is proportional to pow_imp and no_Colony
   s=0;
    
   for k=1:ica.no_of_initial_Imperialist
      
       Empires(k).Imperialist_position= empires_positions(k,:);
       Empires(k).Imperialist_normalized_cost= NormalizedCost_Imperialist(k,:);
       
       Empires(k).Colonies_position= colonies_countries_positions( Random_index(1,s+1:s+n(k,1)),:);
       Empires(k).Colonies_cost = colonies_cost( Random_index(1,s+1:s+n(k,1)),:);
   end
end

