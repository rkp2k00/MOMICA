function [Avg_D,final] = Assimiliate_Colonies(TheEmpire,edpp,ica,~)
    Avg_D=0;
    No_of_colonies = length(TheEmpire.Colonies_position);
    for i=1:length(TheEmpire.Colonies_position)
      for i=1:edpp.N_obj
          Avg_D=Avg_D+(TheEmpire.Colonies_cost(i,i)-TheEmpire.Imperialist_normalized_cost(i))^2;
      end
      Avg_D=Avg_D^0.5;
    end
    Avg_D=Avg_D/i;
     
    %%%%%%%%%%%%  SBX operator -----------------------------
    if Avg_D >ica.d_max
        
      parent_1= TheEmpire.Colonies_position(1:2:length(TheEmpire.Colonies_position),:);
      parent_2= TheEmpire.Colonies_position(2:2:length(TheEmpire.Colonies_position),:);
      
      if length(parent_1)~=length(parent_2)
        parent_1(end,:)=[];
      end
      dis_n=20 ;  %%% the distribution index for crossover operation ;
      u=rand(length(parent_1),edpp.varDim);
      t=max(abs(parent_2-parent_1));
      beta_lower_bound = ( parent_1 + parent_2 - 2*(repmat(edpp.varMin,length(parent_1),1)))./t;
      beta_upper_bound = (-parent_1 - parent_2 + 2*(repmat(edpp.varMax,length(parent_1),1)))./t;
      
      %disp(beta_lower_bound)
      %disp(beta_upper_bound)
      alpha_lb = 2 - beta_lower_bound.^(-dis_n-1);
      alpha_ub = 2 - beta_upper_bound.^(-dis_n-1);
      beta_lb = (alpha_lb.*u).^(1/(dis_n+1)).*(u <= 1./alpha_lb) ...
          + (1./(2-alpha_lb.*u)).^(1/(dis_n+1)).*(u > 1./alpha_lb);
      beta_ub = (alpha_ub.*u).^(1/(dis_n+1)).*(u <= 1./alpha_ub) ...
          + (1./(2-alpha_ub.*u)).^(1/(dis_n+1)).*(u > 1./alpha_ub);
      % the mutation is performed 
      beta_lb = beta_lb.*(-1).^randi([0,1],length(parent_1),edpp.varDim);
      beta_lb(rand(length(parent_1),edpp.varDim)>0.5) = 1;
      beta_ub = beta_ub.*(-1).^randi([0,1],length(parent_2),edpp.varDim);
      beta_ub(rand(length(parent_2),edpp.varDim)>0.5) = 1;
      
      offspring_1= 0.5*((parent_1+parent_2)-beta_lb.*( parent_2-parent_1));
      offspring_2= 0.5*((parent_1+parent_2)+beta_ub.*( parent_2-parent_1));
      
      final=[offspring_1;offspring_2];
      if length(parent_1)~=length(parent_2)
         TheEmpire.Colonies_position = [final;TheEmpire.Colonies_position(2*length(parent_1)+1,:)];
      else
          TheEmpire.Colonies_position= final;
      end
      TheEmpire.Colonies_cost=Objective_functions(TheEmpire.Colonies_position,ica,edpp);
    end
    %disp(beta)
    %disp(beta_lower_bound)
    %disp(beta_upper_bound)  
    
    %---------------------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%  POLYNOMIAL MUTATION STARTS.
    if Avg_D < ica.d_min
        dis_m= 1;            % distribution index for mutation process
        pro_m = 1/edpp.varDim;
        rand_var = rand( length(TheEmpire.Colonies_position),edpp.varDim);
        u  = rand(length(TheEmpire.Colonies_position),edpp.varDim);
        deta = min(TheEmpire.Colonies_position - edpp.varMin, ...
            edpp.varMax - TheEmpire.Colonies_position )./(edpp.varMax-edpp.varMin);
        detaq = zeros(length(TheEmpire.Colonies_position),edpp.varDim);
        position1 = rand_var<=pro_m & u<=0.5;
        position2 = rand_var<=pro_m & u>0.5;
        detaq(position1) = ((2*u(position1) + (1-2*u(position1)).*(1-deta(position1)).^(dis_m+1)).^(1/(dis_m+1))-1); 
        detaq(position2) = (1 - (2*(1-u(position2))+2*(u(position2)-0.5).*(1-deta(position2)).^(dis_m+1)).^(1/(dis_m+1)));
        final = TheEmpire.Colonies_position + detaq.*(edpp.varMax - edpp.varMin);
        TheEmpire.Colonies_position= final;
        
        TheEmpire.Colonies_cost=Objective_functions(TheEmpire.Colonies_position,ica,edpp);
        
    end
    %____________________________________________________________________________________
    
    %%%%%% phase 2 general assimiliation
    
    if Avg_D > ica.d_min && Avg_D < ica.d_max
        
          d= repmat(TheEmpire.Imperialist_position,No_of_colonies,1) - TheEmpire.Colonies_position;
          a=0;
          if edpp.N_obj==2 && rand()>0.5
            b=5;
          else
            b=2;
          end
          r= a+(b-a)*rand();
         
          TheEmpire.Colonies_position = TheEmpire.Colonies_position + r*rand(size(d)).*d;
          final = TheEmpire.Colonies_position; %TheEmpire.Colonies_position;
          % Economic changes operation is applied with 20% probability
          if rand() > 0.8
               r = (edpp.varMax - edpp.varMin);
               w = zeros(size(r));
               for i=1:numel(r)
                 w(i) = (edpp.varMax(i)*rand())^(rand()/r(i)) - (abs(edpp.varMin(i))*rand())^(rand()/r(i));
               end
               TheEmpire.Colonies_position = TheEmpire.Colonies_position .* repmat(w,size(TheEmpire.Colonies_position,1),1);   
    
          end
          TheEmpire.Colonies_cost=Objective_functions(TheEmpire.Colonies_position,ica,edpp);
    end
   %------------------------------------------------------------------------------------------------ 
end

   
%___________________________________________________________________



% function Avg_D= Assimiliate_Colonies(TheEmpire,edpp,ica)
%     Avg_D=0;
%     No_of_colonies = length(TheEmpire.Colonies_position);
%     for k=1:length(TheEmpire.Colonies_position)
%       for k=1:edpp.N_obj
%           Avg_D=Avg_D+(TheEmpire.Colonies_cost(k,k)-...
%           TheEmpire.Imperialist_normalized_cost(k))^2;
%       end
%       Avg_D=Avg_D^0.5;
%     end
%     Avg_D=Avg_D/k;
       
%     if Avg_D >ica.d_max
%       parent_1= TheEmpire.Colonies_position(1:2:length(TheEmpire.Colonies_position),:);
%       parent_2= TheEmpire.Colonies_position(2:2:length(TheEmpire.Colonies_position),:);
%       if length(parent_1)~=length(parent_2)
%         parent_1(end,:)=[];
%       end
%       dis_n=1;  %%% the distribution index of crossover ;
      
%       t=max(abs(parent_2-parent_1));
%       beta_lower_bound = ( parent_1 + parent_2 - 2*(repmat(edpp.varMin,length(parent_1),1)))/t;
%       beta_upper_bound = (-parent_1 - parent_2 + 2*(repmat(edpp.varMax,length(parent_1),1)))/t;
%       %disp(beta_lower_bound)
%       %disp(beta_upper_bound)
%       prob_beta=zeros(length(beta_lower_bound),2);
%       for i=1:length(beta_lower_bound)
%           if beta_lower_bound(i,1)<=1 
%             prob_beta(i,1)= 0.5*(dis_n+1)*(beta_lower_bound(i,1)^dis_n);
%           elseif beta_lower_bound(i,1)>1
%             prob_beta(i,1)= 0.5*(dis_n)*(1/beta_lower_bound(i,1)^(dis_n+2));
%           end
%       end           
%       for j=1:length(beta_lower_bound)      
%           if beta_upper_bound(i,1)<=1 
%             prob_beta(j,2)= 0.5*(dis_n+1)*(beta_upper_bound(j,1)^(dis_n));
%           elseif beta_upper_bound(i,1)>1
%             prob_beta(j,2)= 0.5*(dis_n)*(1/beta_upper_bound(j,1)^(dis_n+2));
%           end
%       end
%       %disp(prob_beta)
%       beta_v=[];
%       for j=1:2
%       u=rand(length(parent_1),1);
%         for i=1:length(beta_lower_bound)
%           if u(i)<=0.5
%             beta_v(i,j)= ((2*u(i))^(dis_n+1))/prob_beta(i,j);
%           elseif u(i)>0.5
%             beta_v(i,j)= ((1/(2*(1-u(i))))^(1/(dis_n+1)))/prob_beta(i,j);
%           end
%         end
%       end
%       disp(beta_v)
%       offspring_1= 0.5*((parent_1+parent_2)-beta_v(:,1).*( parent_2-parent_1));
%       offspring_2= 0.5*((parent_1+parent_2)+beta_v(:,2).*( parent_2-parent_1));
%       disp(offspring_1)
%       disp(offspring_2)
% %   d= repmat(Empire.Imperialist_position,No_of_colonies,1) -Empire.Colonies_position;
% %   Empire.Colonies_position = Empire.Colonies_position + ica.Assimiliation_coefficient*rand(size(d)).*d;
           
%     end
% end

   

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
