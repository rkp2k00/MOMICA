function Initial_cost= Objective_functions(Initial_countries,ica,edpp)
     Initial_cost = zeros(ica.no_of_countries,edpp.N_obj);
     
     for i=1:size(Initial_countries)  %%%%%% objective functions, will create seperate function file later.
    
        Initial_cost(i,1)= 4.9*10^(-5)*((Initial_countries(i,2))^2-(Initial_countries(i,1))^2)*(Initial_countries(i,4)-1);
        Initial_cost(i,2)= (9.82*10^6*(Initial_countries(i,2)^2 - Initial_countries(i,1)^2))/(Initial_countries(i,3)*Initial_countries(i,4)*(Initial_countries(i,2)^3 - Initial_countries(i,1)^3));
        %Initial_cost(i,3)= 5.9*10^(-5)*((Initial_countries(i,2))^2-(Initial_countries(i,4))^2)*(Initial_countries(i,1)-1);
     end
     
end
