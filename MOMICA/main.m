clc; clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% problem paramters
% BRAKE DESIGN PROBLEM

edpp.Costfunction = 'Objective_Function';  %edpp - engineering design problem parameters.
edpp.varDim = 4;                           % variables total
edpp.varMin=[55 75 1000 2];                % min variable bound
edpp.varMax=[80 110 3000 20];              % max variable bound
edpp.N_obj= 2;                             % No of Objective 

if numel(edpp.varMin)==1
    edpp.varMin= repmat(edpp.varMin,1,edpp.varDim);
    edpp.varMax= repmat(edpp.varMax,1,edpp.varDim,1);
end

edpp.SearchSpace= edpp.varMax-edpp.varMin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm paramters

ica.no_of_countries= 100;
ica.no_of_initial_Imperialist= 8;
ica.no_of_colonies= ica.no_of_countries - ica.no_of_initial_Imperialist;
ica.no_of_decades = 1e+4;
ica.d_max = 2;
ica.d_min = 1.5;
ica.RevolutionRate = 0.25;

Initial_countries = GenerateNewCountry(ica.no_of_countries,edpp);
Initial_cost = Objective_functions(Initial_countries,ica,edpp);

[front,sort_index,Solutions]= Non_dominated_sorting(Initial_cost,ica,edpp.N_obj);     % did non dominated sorting to using dominance method and also to get diversiffies solutions
Initial_countries = Initial_countries(sort_index,:); 
Initial_cost= Initial_cost(sort_index,:);

[Empires,n] = createInitialEmpires(ica,edpp,Initial_countries,Initial_cost);
    
for i=1:ica.no_of_decades
    disp(i)
    for j=1:numel(Empires)
     
     [Avg_D,Empires(j)] = Assimiliate_Colonies(Empires(j),edpp,ica,Empires);
     Empires(j) = Revolve_Colonies(Empires(j),edpp,ica);
            
     Empires(j).Colonies_cost= Objective_functions(Empires(j).Colonies_position,ica,edpp);
     
     Empires(j)= permuted(Empires(j),edpp,ica);
     
     Total_cost(j,:) = Empires(j).Imperialist_normalized_cost +...
                             rand(1)*mean(Empires(j).Colonies_cost);
                
    end
    
    Empires= Imperialistic_competetion(Empires,Total_cost);
    if numel(Empires)<=1
        break
    end
    numel(Empires)
end


















 