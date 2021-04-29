function Avg_D= Assimiliate_Colonies(TheEmpire,edpp,ica)
    Avg_D=0;
    No_of_colonies = length(TheEmpire.Colonies_position);
    for k=1:length(TheEmpire.Colonies_position)
      for k=1:edpp.N_obj
          Avg_D=Avg_D+(TheEmpire.Colonies_cost(k,k)-...
          TheEmpire.Imperialist_normalized_cost(k))^2;
      end
      Avg_D=Avg_D^0.5;
    end
    Avg_D=Avg_D/k;
       
    if Avg_D >ica.d_max
      parent_1= TheEmpire.Colonies_position(1:2:length(TheEmpire.Colonies_position),:);
      parent_2= TheEmpire.Colonies_position(2:2:length(TheEmpire.Colonies_position),:);
      if length(parent_1)~=length(parent_2)
        parent_1(end,:)=[];
      end
      dis_n=1;  %%% the distribution index of crossover ;
      
      t=max(abs(parent_2-parent_1));
      beta_lower_bound = ( parent_1 + parent_2 - 2*(repmat(edpp.varMin,length(parent_1),1)))/t;
      beta_upper_bound = (-parent_1 - parent_2 + 2*(repmat(edpp.varMax,length(parent_1),1)))/t;
      %disp(beta_lower_bound)
      %disp(beta_upper_bound)
      prob_beta=zeros(length(beta_lower_bound),2);
      for i=1:length(beta_lower_bound)
          if beta_lower_bound(i,1)<=1 
            prob_beta(i,1)= 0.5*(dis_n+1)*(beta_lower_bound(i,1)^dis_n);
          elseif beta_lower_bound(i,1)>1
            prob_beta(i,1)= 0.5*(dis_n)*(1/beta_lower_bound(i,1)^(dis_n+2));
          end
      end           
      for j=1:length(beta_lower_bound)      
          if beta_upper_bound(i,1)<=1 
            prob_beta(j,2)= 0.5*(dis_n+1)*(beta_upper_bound(j,1)^(dis_n));
          elseif beta_upper_bound(i,1)>1
            prob_beta(j,2)= 0.5*(dis_n)*(1/beta_upper_bound(j,1)^(dis_n+2));
          end
      end
      %disp(prob_beta)
      beta_v=[];
      for j=1:2
      u=rand(length(parent_1),1);
        for i=1:length(beta_lower_bound)
          if u(i)<=0.5
            beta_v(i,j)= ((2*u(i))^(dis_n+1))/prob_beta(i,j);
          elseif u(i)>0.5
            beta_v(i,j)= ((1/(2*(1-u(i))))^(1/(dis_n+1)))/prob_beta(i,j);
          end
        end
      end
      disp(beta_v)
      offspring_1= 0.5*((parent_1+parent_2)-beta_v(:,1).*( parent_2-parent_1));
      offspring_2= 0.5*((parent_1+parent_2)+beta_v(:,2).*( parent_2-parent_1));
      disp(offspring_1)
      disp(offspring_2)
%   d= repmat(Empire.Imperialist_position,No_of_colonies,1) -Empire.Colonies_position;
%   Empire.Colonies_position = Empire.Colonies_position + ica.Assimiliation_coefficient*rand(size(d)).*d;
           
    end
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
