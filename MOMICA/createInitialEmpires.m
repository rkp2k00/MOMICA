function [Empires,n]= createInitialEmpires(ica,Initial_countries,Initial_cost)

   empires_positions= Initial_countries(1:ica.no_of_initial_Imperialist,:);  % 8x4
   empires_cost= Initial_cost(1:ica.no_of_initial_Imperialist,1);            % 8x1
  
   colonies_countries_positions = Initial_countries(ica.no_of_initial_Imperialist+1:end,:); % 192x4
   colonies_cost  = Initial_cost(ica.no_of_initial_Imperialist+1:end,1);         % 192x1
   
   NormalizedCost_Imperialist=  repmat(max(empires_cost),ica.no_of_initial_Imperialist,1)-empires_cost; % 8x1
   power_of_Imperialist = (NormalizedCost_Imperialist)/(sum(NormalizedCost_Imperialist));               % 8x1
   
   n = round(power_of_Imperialist*ica.no_of_colonies);      % 8x1 , n = Initial_no_of_colony_possesed by Imp
   Random_index=  randperm(192);
   s=0;
   
   for k=1:ica.no_of_initial_Imperialist
      
       Empries(k).Imperialist_position= empires_positions(k,:);
       Empires(k).Imperialist_normal_cost= NormalizedCost_Imperialist(k,1);
       
       if k==1
        Empires(k).Colonies_position= colonies_countries_positions( Random_index(1,1:n(1,1)),:);
        Empires(k).Colonies_cost = colonies_cost( Random_index(1,1:n(1,1)),1);
       else
        s= s + n(k-1,1);
        Empires(k).Colonies_position= colonies_countries_positions( Random_index(1, s+1:s+n(k,1)),:);
        Empires(k).Colonies_cost = colonies_cost( Random_index(1, s+1:s+n(k,1)),1);
        
       end
   end
end

