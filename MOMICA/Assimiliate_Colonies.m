function Avg_D= Assimiliate_Colonies(Empire,edpp)%,ica)
       Avg_D=0;
       No_of_colonies = length(Empire.Colonies_position);
       for k=1:length(Empire.Colonies_position)
           for k=1:edpp.N_obj
               Avg_D=Avg_D+(Empire.Colonies_cost(k,k)-Empire.Imperialist_normalized_cost(k))^2;
           end
           Avg_D=Avg_D^0.5;
       end
       Avg_D=Avg_D/k;
       
%        if Avg_D > ica.d_max
%            sbx crossover operator between colonies
%        elseif Avg_D < ica.d_min
%            polynomial mutation between colonies
%        elseif Avg_D > ica.d_min && Avg_D < ica.d_max
%            normal assimiliation
%        end
%        
%        d= repmat(Empire.Imperialist_position,No_of_colonies,1) - Empire.Colonies_position;
%        Empire.Colonies_position = Empire.Colonies_position + ica.Assimiliation_coefficient*rand(size(d)).*d;
           
       
      
end
   

% function TheEmpire = Assimiliate_Colonies(TheEmpire,ica,ProblemParams)
% for i = 1:numel(Imperialists)
%     Imperialists{i}.Number_of_Colonies_matrix = [Imperialists{i}.Number_of_Colonies_matrix      Imperialists{i}.Number_of_Colonies];
% 
%     Imperialists_cost_matrix (i) = Imperialists{i}.cost_just_by_itself;
% 
%     Imperialists_position_matrix(i,:) = Imperialists{i}.position;
% c=ica.no_of_initial_Imperialist;
% for i=1:c
% 
%  NumOfColonies = size(TheEmpire.Colonies_position,1);
%  Vector = repmat(TheEmpire.Imperialist_position,NumOfColonies,1)-TheEmpire.Colonies_position;
%  MinVarMatrix = repmat(ProblemParams.varMin,NumOfColonies,1);
%  MaxVarMatrix = repmat(ProblemParams.varMax,NumOfColonies,1);
%  TheEmpire.Colonies_position=max(TheEmpire.Colonies_position,MinVarMatrix);
%  TheEmpire.Colonies_position=min(TheEmpire.Colonies_position,MaxVarMatrix);
% end
