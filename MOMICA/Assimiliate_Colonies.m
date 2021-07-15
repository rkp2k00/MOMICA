function [Avg_D,TheEmpire] = Assimiliate_Colonies(TheEmpire,edpp,ica,Empires,r)
     
      Avg_D=0;
    %if size(TheEmpire.Colonies_position)>2
      for i=1:size(TheEmpire.Colonies_position,1)
         sum=0;
         for k=1:edpp.varDim
             sum=sum +(TheEmpire.Imperialist_position(1,k)-TheEmpire.Colonies_position(i,k))^2;
         end
         Avg_D= Avg_D + sqrt(sum);
      end
      Avg_D=Avg_D/i;

      if Avg_D>ica.d_max
            TheEmpire=crossover(TheEmpire,ica,edpp);
      elseif Avg_D<ica.d_min
            TheEmpire=mutation(TheEmpire,ica,edpp);
      end
    
   %%%%%% phase 2 general assimiliation
     
      if ica.d_min < Avg_D <ica.d_max
          All_Imperialist_position=[];
          All_Imperialist_cost=[];
          for i=1:numel(Empires)
              All_Imperialist_position(end+1:end+size(Empires(i).Imperialist_position,1),:)=Empires(i).Imperialist_position;
              All_Imperialist_cost(end+1:end+size(Empires(i).Imperialist_position,1),:)= Empires(i).Imperialist_normalized_cost;
          end
          
          [front_imp,Index,~]= Non_dominated_sorting(All_Imperialist_cost,ica,edpp.N_obj);
          All_Imperialist_position = All_Imperialist_position(Index,:);
          Front_1_Imp= All_Imperialist_position(1:numel(front_imp(1).pts(:,3)),:);
          
          Num=size(TheEmpire.Colonies_position,1);
          R=randi(size(Front_1_Imp,1),1);
          d= repmat(Front_1_Imp(R,:),Num,1) - TheEmpire.Colonies_position;
  
          a=0;
          if edpp.N_obj==2 && rand()>0.5
            b=5;
          else
            b=2;
          end 
          gamma= a+(b-a)*rand(); 
         
          TheEmpire.Colonies_position = TheEmpire.Colonies_position + gamma*rand(size(d)).*d;
          %final = TheEmpire.Colonies_position; %TheEmpire.Colonies_position;
          % Economic changes operation is applied with 20% probability
          if rand() > 0.8
               gamma = (edpp.varMax - edpp.varMin);
               w = zeros(size(gamma));
               for i=1:numel(gamma)
                 w(i) = (edpp.varMax(i)*rand())^(rand()/gamma(i)) - (abs(edpp.varMin(i))*rand())^(rand()/gamma(i));
               end
               TheEmpire.Colonies_position = TheEmpire.Colonies_position .* repmat(w,size(TheEmpire.Colonies_position,1),1);   
   
          end
      end
      
%end
      No_of_colonies=size(TheEmpire.Colonies_position,1);
% below steps are done to keep the parameters within the boundary limit.
      %if size(TheEmpire.Colonies_position,1)>2
         MinVarMatrix = repmat(edpp.varMin,No_of_colonies,1);
         MaxVarMatrix = repmat(edpp.varMax,No_of_colonies,1);
         TheEmpire.Colonies_position=max(TheEmpire.Colonies_position,MinVarMatrix);
         TheEmpire.Colonies_position=min(TheEmpire.Colonies_position,MaxVarMatrix);
      %end

end
function TheEmpire=crossover(TheEmpire,ica,edpp)
    %Params
%       N = size(TheEmpire.Colonies_position,1);
%       n = size(TheEmpire.Colonies_position,2);
%       % Crossover
%       cross_index = rand(N,1) < ica.crossover_distribution_index;
%       cross_index = find(cross_index);
%       for c = 1:1:length(cross_index)
%          selected = randi(N,1,1);
%          while selected == c
%              selected = randi(N,1,1);
%          end
%          cut = randi(n,1,1);
%          TheEmpire.Colonies_position(c,:) = [TheEmpire.Colonies_position(c,1:cut),...
%                       TheEmpire.Colonies_position(selected,cut+1:n)];
%        end

      if size(TheEmpire.Colonies_position,1)>=3
         parent_1= TheEmpire.Colonies_position(1:2:length(TheEmpire.Colonies_position),:);
         parent_2= TheEmpire.Colonies_position(2:2:length(TheEmpire.Colonies_position),:);
      elseif size(TheEmpire.Colonies_position,1)==2
          parent_1=TheEmpire.Colonies_position(1,:);
          parent_2=TheEmpire.Colonies_position(2,:);
      elseif size(TheEmpire.Colonies_position,1)==1
          return 
          
      end
      
      if size(parent_1,1)~=size(parent_2,1)
        parent_1(end,:)=[];
        tmp=1;
        v=TheEmpire.Colonies_position(end,:);
      else
          tmp=0;
      end
     
      u=rand(size(parent_1,1),edpp.varDim);
      t=max(abs(parent_2-parent_1),1e-6);
      beta = 1+ (2*min(min(parent_1,parent_2)-edpp.varMin,edpp.varMax-max(parent_1,parent_2))./t); 
      alpha = 2 - beta.^(-ica.crossover_distribution_index-1);
      betaq= (alpha.*u).^(1/(ica.crossover_distribution_index+1)).*(u <= 1./alpha) + (1./(2-alpha.*u)).^(1/(ica.crossover_distribution_index+1)).*(u > 1./alpha);
      % the mutation is performed 
      betaq = beta.*(-1).^randi([0,1],size(parent_1,1),edpp.varDim);
      betaq(rand(size(parent_1,1) ,edpp.varDim)>0.5) = 1;
      
      offspring_1= 0.5*((parent_1+parent_2) - betaq.*( parent_2-parent_1));
      offspring_2= 0.5*((parent_1+parent_2) + betaq.*( parent_2-parent_1));
     
      if tmp==1
        final = [offspring_1;offspring_2;v];
      else
        final = [offspring_1;offspring_2];  
      end
     TheEmpire.Colonies_position= final;

end

     function TheEmpire=mutation(TheEmpire,ica,edpp)
      % Mutation population 
      N = size(TheEmpire.Colonies_position,1);
      n = size(TheEmpire.Colonies_position,2);
      mutated_Population = TheEmpire.Colonies_position + 0.05.*repmat(edpp.varMax-edpp.varMin,N,1).*randn(N,n);

      mut_idx = rand(N,n) < ica.mutation_distribution_index;
      TheEmpire.Colonies_position(mut_idx) = mutated_Population(mut_idx);
    end


