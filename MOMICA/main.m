function s=main(i)

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% problem paramters
 load('Kursawe.mat');
 edpp.Costfunction = 'Objective-function';  %edpp - engineering design problem parameters.
 edpp.varDim = 3;                           % variables total
 edpp.varMin=repmat(-5,1,edpp.varDim);      % min variable bound
 edpp.varMax=repmat(5,1,edpp.varDim);       % max variable bound
 edpp.N_obj= 2;                             % no of Objective 
 r=i;
 if numel(edpp.varMin)==1
    edpp.varMin= repmat(edpp.varMin,1,edpp.varDim);
    edpp.varMax= repmat(edpp.varMax,1,edpp.varDim,1);
 end

 edpp.SearchSpace= edpp.varMax-edpp.varMin;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm paramters
 
 ica.no_of_countries = 100;   %%% ica - imperialistic competetive algorithm
 ica.no_of_initial_Imperialist = 10;
 ica.no_of_colonies = ica.no_of_countries - ica.no_of_initial_Imperialist;
 ica.no_of_decades = 1e+3;
 ica.d_max = 2.2;             %%% assimiliation d_max parameter
 ica.d_min = 1.5;             %%% assimiliation d_min parameter
 ica.RevolutionRate = 0.3;
 
 if r<16
   ica.crossover_distribution_index = 15;
   ica.mutation_distribution_index= 0.1;
 else
   ica.crossover_distribution_index = 0.5;
   ica.mutation_distribution_index= 20;
 end
 
 ica.truePF=PF;
 ica.ImperialistPercentage=0.3;
 ica.UnitingThreshold=0.02;
 Initial_countries = GenerateNewCountry(ica.no_of_countries,edpp);
 Initial_cost = Objective_functions(Initial_countries,ica,edpp);

 [~,sort_index,~]= Non_dominated_sorting(Initial_cost,ica,edpp.N_obj);     % did non dominated sorting to using dominance method and also to get diversiffies solutions
 Initial_countries = Initial_countries(sort_index,:); 
 Initial_cost= Initial_cost(sort_index,:);
 
 [Empires,~] = createInitialEmpires(ica,edpp,Initial_countries,Initial_cost);

 %%%%%display setting for initial solutions;
%  h_fig = figure(1);
%  h_par=scatter(Initial_cost(:,1),Initial_cost(:,2),20,'filled', 'markerFaceAlpha',0.3,'MarkerFaceColor',[108 103 219]./255); hold on;
%  h_rep = plot(Initial_cost(:,1),Initial_cost(:,2),'ok'); hold on;
%  grid on; xlabel('f1'); ylabel('f2');
%  drawnow;
%  axis square;    

 pareto_solutions=[];
 pareto_positions=[];
 pareto_index=1;
 for i=1:ica.no_of_decades
     %%%%%%%%%%%%%%%%%%%%%%%%%% display to check the generation
    disp(strcat('Generation---',num2str(i)));
    for j=1:numel(Empires)
     
     [~,Empires(j)] = Assimiliate_Colonies(Empires(j),edpp,ica,Empires,r);
     Empires(j) = Revolve_Colonies(Empires(j),edpp,ica);
            
     Empires(j).Colonies_cost= Objective_functions(Empires(j).Colonies_position,ica,edpp);
     
     Empires(j)= permute_Empire(Empires(j),edpp,ica);
 
     Empire_total_cost = [Empires(j).Imperialist_normalized_cost
                    Empires(j).Colonies_cost];
     [frt,~,~] = Non_dominated_sorting(Empire_total_cost,ica,edpp.N_obj);
     Empires(j).Total_cost = numel(frt(1).pts(:,3));
                
    end  
        
    Empires= Unite_Empires(Empires,ica,edpp);
    Empires= Imperialistic_competetion(Empires);
    if numel(Empires)<=1
        break
    end
    
    All_cost=[];
    All_position=[];
    for m=1:numel(Empires)
      All_cost(end+1:end+size(Empires(m).Imperialist_normalized_cost,1),:)= Empires(m).Imperialist_normalized_cost;
      All_position(end+1:end+size(Empires(m).Imperialist_position,1),:)= Empires(m).Imperialist_position;
    end
    %%% non dominated sorting for ALL_Imp_cost;  
    [front,ind,~]=Non_dominated_sorting(All_cost,ica,edpp.N_obj);
    All_cost=All_cost(ind,:);
    All_position=All_position(ind,:);
    pareto_solutions(end+1:end+numel(front(1).pts(:,3)),:)=All_cost(1:numel(front(1).pts(:,3)),:);
    pareto_positions(end+1:end+numel(front(1).pts(:,3)),:)=All_position(1:numel(front(1).pts(:,3)),:);

 end
 disp('Loading...');
 [front_p,ind,~]=Non_dominated_sorting(pareto_solutions,ica,edpp.N_obj);
 pareto_solutions = pareto_solutions(ind,:);
 pareto_positions = pareto_positions(ind,:);
 s(r).values=pareto_solutions(1:numel(front_p(1).pts(:,3)),:);
 [s(r).values,~]=unique(s(r).values,'rows');
 %s(r).values=ND_solutions(s(r).values,ica,edpp.N_obj);
 solution_positions=pareto_positions(1:numel(front_p(1).pts(:,3)),:);

 %dlmwrite('Solutions.mat',solution(1).values,'delimiter','\t','precision', '%.12f');

end


 























 