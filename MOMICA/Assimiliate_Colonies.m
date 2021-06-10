function [Avg_D,TheEmpire] = Assimiliate_Colonies(TheEmpire,edpp,ica,Empires)

    Avg_D=0;
    if size(TheEmpire.Colonies_position,1)>3
      No_of_colonies = length(TheEmpire.Colonies_position);
      for i=1:length(TheEmpire.Colonies_position)
        for i=1:edpp.N_obj
          Avg_D=Avg_D+(TheEmpire.Colonies_cost(i,i)-TheEmpire.Imperialist_normalized_cost(i))^2;
        end
      Avg_D=Avg_D^0.5;
      end
      Avg_D=Avg_D/i;
    end
     
    %%%%%%%%%%%%  SBX OPERATOR -----------------------------
    if Avg_D >ica.d_max && size(TheEmpire.Colonies_position,1)>3
      
      parent_1= TheEmpire.Colonies_position(1:2:length(TheEmpire.Colonies_position),:);
      parent_2= TheEmpire.Colonies_position(2:2:length(TheEmpire.Colonies_position),:);
    
      if size(parent_1,1)~=size(parent_2,1)
        parent_1(end,:)=[];
        tmp=1;
        v=TheEmpire.Colonies_position(end,:);
      else
          tmp=0;
      end
     
      dis_n=20 ;  %%% the distribution index for crossover operation ;
      u=rand(size(parent_1,1),edpp.varDim);
      t=max(abs(parent_2-parent_1));
      beta = 1+ (2*min(min(parent_1,parent_2)-edpp.varMin,edpp.varMax-max(parent_1,parent_2))./t); 
      alpha = 2 - beta.^(-dis_n-1);
      beta = (alpha.*u).^(1/(dis_n+1)).*(u <= 1./alpha) + (1./(2-alpha.*u)).^(1/(dis_n+1)).*(u > 1./alpha);
      % the mutation is performed 
      beta = beta.*(-1).^randi([0,1],size(parent_1,1),edpp.varDim);
      beta(rand(size(parent_1,1) ,edpp.varDim)>0.5) = 1;
      
      offspring_1= 0.5*((parent_1+parent_2) - beta.*( parent_2-parent_1));
      offspring_2= 0.5*((parent_1+parent_2) + beta.*( parent_2-parent_1));
     
      if tmp==1
        final = [offspring_1;offspring_2;v];
      else
        final = [offspring_1;offspring_2];  
      end
     TheEmpire.Colonies_position= final;
    end
    %---------------------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%  POLYNOMIAL MUTATION.
    if Avg_D < ica.d_min && size(TheEmpire.Colonies_position,1)>3
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
        TheEmpire.Colonies_position = TheEmpire.Colonies_position + detaq.*(edpp.varMax - edpp.varMin);
       
    end
    %____________________________________________________________________________________
    %%%%%% phase 2 general assimiliation
     
    if Avg_D > ica.d_min && Avg_D < ica.d_max && size(TheEmpire.Colonies_position,1)>3
      
          All_Imperialist_position=[];
          All_Imperialist_cost=[];
          for i=1:numel(Empires)
              All_Imperialist_position(i,:)=Empires(i).Imperialist_position;
              All_Imperialist_cost(i,:)= Empires(i).Imperialist_normalized_cost;
          end
          
          [~,Index,~]= Non_dominated_sorting(All_Imperialist_cost,ica,edpp.N_obj);
          All_Imperialist_position = All_Imperialist_position(Index);
          All_Imperialist_cost =   All_Imperialist_cost(Index);
          
          R=randi(size(All_Imperialist_position,1),1);
          d= repmat(All_Imperialist_position(R,:),No_of_colonies,1) - TheEmpire.Colonies_position;
  
          a=0;
          if edpp.N_obj==2 && rand()>0.5
            b=5;
          else
            b=2;
          end 
          gamma= a+(b-a)*rand(); 
         
          TheEmpire.Colonies_position = TheEmpire.Colonies_position + gamma*rand(size(d)).*d;
          final = TheEmpire.Colonies_position; %TheEmpire.Colonies_position;
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
    
% below steps are done to keep the parameters within the boundary limit.
if size(TheEmpire.Colonies_position,1)>3
MinVarMatrix = repmat(edpp.varMin,No_of_colonies,1);
MaxVarMatrix = repmat(edpp.varMax,No_of_colonies,1);
TheEmpire.Colonies_position=max(TheEmpire.Colonies_position,MinVarMatrix);
TheEmpire.Colonies_position=min(TheEmpire.Colonies_position,MaxVarMatrix);
end

end



