clc; clear
k=4.9*10^(-5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% problem paramters
% BRAKE DESIGN PROBLEM

edpp.Costfunction = 'BenchMarkFunction';  %edpp - engineering design problem parameters
edpp.varDim = 4;
edpp.varMin=[55 75 1000 2];
edpp.varMax=[80 110 3000 20];
edpp.N_obj= 2;

if numel(edpp.varMin)==1
    edpp.varMin= repmat(edpp.varMin,1,edpp.varDim);
    edpp.varMax= repmat(edpp.varMax,1,edpp.varDim,1);
end

edpp.SearchSpace= edpp.varMax-edpp.varMin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithmic paramters

ica.no_of_countries= 200;
ica.no_of_initial_Imperialist= 8;
ica.no_of_colonies= ica.no_of_countries - ica.no_of_initial_Imperialist;

Initial_countries = GenerateNewCountry(ica.no_of_countries,edpp);
Initial_cost = zeros(ica.no_of_countries,1);

for i=1:size(Initial_countries)
    
    Initial_cost(i)= k*((Initial_countries(i,2))^2-(Initial_countries(i,1))^2)*(Initial_countries(i,4)-1);
    
end

[final_cost,ind,Solutions]= sort(Initial_cost);     % did non dominated sorting to get best population with diversty
Initial_countries = Initial_countries(ind,:); 

[Empires,n] = createInitialEmpires(ica,Initial_countries,Initial_cost);















 
