function Empires=Unite_Empires(Empires,ica,edpp)
    
    Thereshold = ica.UnitingThreshold * norm(edpp.SearchSpace);
    No_of_Empires = numel(Empires);

    for i = 1:No_of_Empires-1
        for j = i+1:No_of_Empires
            
            AllCosts_1 = [];
            AllCosts_1(1:size(Empires(i).Imperialist_normalized_cost,1), :) = Empires(i).Imperialist_normalized_cost;
            AllCosts_1(end+1:end + size(Empires(i).Colonies_cost,1),:) = Empires(i).Colonies_cost;
            [front_1,ind1,~] = Non_dominated_sorting(AllCosts_1,ica,edpp.N_obj); % apply non-domination sorting...
            AllCosts_1= AllCosts_1(ind1,:);
            Empire_1= AllCosts_1(1:numel(front_1(1).pts(:,3)),:); % get the Empires in the first front...
            
            AllCosts_2 = [];
            AllCosts_2(1:size(Empires(j).Imperialist_normalized_cost,1), :) = Empires(j).Imperialist_normalized_cost;
            AllCosts_2(end+1:end + size(Empires(j).Colonies_cost,1),:) = Empires(j).Colonies_cost;
            [front_2,ind2,~]= Non_dominated_sorting(AllCosts_2,ica,edpp.N_obj); % apply non-domination sorting...
            AllCosts_2= AllCosts_2(ind2,:);
            Empire_2= AllCosts_2(1:numel(front_2(1).pts(:,3)),1:end); % get the Empires in the first front...
            
            L_solutions = Empire_1;
            M_solutions = Empire_2;
            if(size(Empire_1,1)>size(Empire_2,1))
                L_solutions = Empire_2;
                M_solutions = Empire_1;
            end

            d_min = zeros(1,min(size(Empire_1,1),size(Empire_2,1)));
            for k=1:min(size(Empire_1,1),size(Empire_2,1))
                d = zeros(1,max(size(Empire_1,1),size(Empire_2,1)));
                for m=1:max(size(Empire_1,1),size(Empire_2,1))
                    if(edpp.N_obj == 2)
                        d(m) = d(m) + sqrt((L_solutions(k, 1)-M_solutions(m, 1))^2+(L_solutions(k, 2)-M_solutions(m, 2))^2);
                    else
                        d(m) = d(m) + sqrt((L_solutions(k, 1)-M_solutions(m, 1))^2+(L_solutions(k, 2)-M_solutions(m, 2))^2+(L_solutions(k, 3)-M_solutions(m, 3))^2);
                    end

                end
                d_min(k) = min(d);
            end
            Dist = sum(d_min)/min(size(Empire_1,1),size(Empire_2,1));

            if Dist<=Thereshold
                Empires(i).Colonies_position = [Empires(i).Colonies_position
                                                Empires(j).Imperialist_position
                                                Empires(j).Colonies_position];

                Empires(i).ColoniesCost = [Empires(i).Colonies_cost
                                            Empires(j).Imperialist_normalized_cost
                                            Empires(j).Colonies_cost];
                
                Empires = Empires([1:j-1 j+1:end]);

                
                ColoniesCost = Empires(i).Colonies_cost;%% Recompute Imperilists from the newly created Empire's  %% population
                ColoniesPosition = Empires(i).Colonies_position;

                ColoniesCost(end+1: end+size(Empires(i).Imperialist_normalized_cost,1),:) = Empires(i).Imperialist_normalized_cost;
                ColoniesPosition(end+1:end+size(Empires(i).Imperialist_normalized_cost,1),:) = Empires(i).Imperialist_position;

                [front_3,sortInd,~] = Non_dominated_sorting(ColoniesCost,ica,edpp.N_obj); % apply non-domination sorting...
                AllColoniesPosition = ColoniesPosition(sortInd,:); % Sort the population with respect to their cost.
                AllColoniesCost = ColoniesCost(sortInd,:);
                Empires(i).Imperialist_normalized_cost = AllColoniesCost(1:numel(front_3(1).pts(:,3)),:);
                Empires(i).Imperialist_position = AllColoniesPosition(1:numel(front_3(1).pts(:,3)),:);

                Empires(i).ColoniesCost = AllColoniesCost(numel(front_3(1).pts(:,3))+1:end,:);
                Empires(i).ColoniesPosition = AllColoniesPosition(numel(front_3(1).pts(:,3))+1:end,:);

                %%Compute the Total Cost of an Empire...
                Empires_total_cost = [Empires(i).Imperialist_normalized_cost
                Empires(i).Colonies_cost];
                [frt,~,~] = Non_dominated_sorting(Empires_total_cost,ica,edpp.N_obj);
                Empires(i).Total_cost = numel(frt(1).pts(:,3));
                
                return;
                
            end
       end
    end
   
end
