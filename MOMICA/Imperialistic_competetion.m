function Empires=Imperialistic_competetion(Empires)
    if rand > 0.11 
        return
    end
    if numel(Empires)<=1
        return;
    end
    
    TotalPowers = [Empires.Total_cost];
    [~, min_i] = min(TotalPowers);
    min_i = min_i(1);
    Possession_Probablity = TotalPowers / sum(TotalPowers);
    [~,max_i]= max(Possession_Probablity);
      
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


