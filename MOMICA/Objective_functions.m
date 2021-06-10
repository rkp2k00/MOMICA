function y= Objective_functions(x,~,edpp)
     y = zeros(size(x,1),edpp.N_obj);
     
     for i=1:size(x)  %%%%%% objective functions, will create seperate function file later.
    
        y(i,1)= 4.9*10^(-5)*((x(i,2))^2-(x(i,1))^2)*(x(i,4)-1);
        y(i,2)= (9.82*10^6*(x(i,2)^2 - x(i,1)^2))/(x(i,3)*x(i,4)*(x(i,2)^3 - x(i,1)^3));
        %Initial_cost(i,3)= 5.9*10^(-5)*((Initial_countries(i,2))^2-(Initial_countries(i,4))^2)*(Initial_countries(i,1)-1);
     end
     
end
