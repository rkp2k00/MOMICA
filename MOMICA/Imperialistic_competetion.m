function Empires=Imperialistic_competetion(Empires,Total_cost)
    if rand > 0.11 
        return
    end
    if numel(Empires)<=1
        return;
    end
    for i=1:numel(Empires)
      Normalized_cost(i,:)= max(Total_cost)-Empires(i).Imperialist_normalized_cost;
    end
    Possession_Probablity = Normalized_cost/(sum(Normalized_cost));
    [~,max_i]= max(Possession_Probablity);
    [~,min_i]= min(Possession_Probablity);
      
    i = size((Empires(min_i).Colonies_cost),1);
    
    if(i == 0)
        Empires(max_i).Colonies_position = [Empires(max_i).Colonies_position
                                                       Empires(min_i).Imperialist_position];
                                                   
        Empires(max_i).Colonies_cost = [Empires(max_i).Colonies_cost
                                                   Empires(min_i).Imperialist_normalized_cost];
        Empires=Empires([1:min_i-1 min_i+1:end]);
    else
        j = randi(i,1);
        Empires(max_i).Colonies_position = [Empires(max_i).Colonies_position
                                                       Empires(min_i).Colonies_position(j,:)];
        Empires(max_i).Colonies_cost = [Empires(max_i).Colonies_cost
                                                   Empires(min_i).Colonies_cost(j,:)];
        Empires(min_i).Colonies_position = Empires(min_i).Colonies_position([1:j-1 j+1:end],:);
        Empires(min_i).Colonies_cost = Empires(min_i).Colonies_cost([1:j-1 j+1:end],:);
        
       
        k = numel(Empires(min_i).Colonies_cost);
        if k<=1
            Empires(max_i).Colonies_position = [Empires(max_i).Colonies_position
                                                           Empires(min_i).Imperialist_position
                                                           Empires(min_i).Colonies_position
                                                           ];
            Empires(max_i).Colonies_cost = [Empires(max_i).Colonies_cost
                                                       Empires(min_i).Imperialist_normalized_cost
                                                       Empires(min_i).Colonies_cost];
            Empires=Empires([1:min_i-1 min_i+1:end]);
        end
    end
end


