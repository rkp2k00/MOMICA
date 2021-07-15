    function TheEmpire = Revolve_Colonies(TheEmpire,edpp,ica)
 if rand() > 0.5
    No_of_Revolving_Colonies = size(TheEmpire.Colonies_cost,1);
    New_Colonies = zeros(No_of_Revolving_Colonies,edpp.varDim );
    for i=1:No_of_Revolving_Colonies
        P1 = randi(size(TheEmpire.Imperialist_position,1), 1);
        parent_1 = TheEmpire.Imperialist_position(P1, :);
        
        if size(TheEmpire.Imperialist_position,1) > 1
            P2 = randi(size(TheEmpire.Imperialist_position,1), 1);
            while P1 == P2
                P2 = randi(size(TheEmpire.Imperialist_position,1), 1);
            end
            parent_2 = TheEmpire.Imperialist_position(P2, :);
        else
           parent_2 = GenerateNewCountry(1,edpp); 
        end
        
        Point1=randi(edpp.varDim,1);
        Point2=Point1;
        while Point2==Point1
            Point2=randi(edpp.varDim,1);
        end
        if Point2<Point1
            Tmp=Point1;
            Point1=Point2;
            Point2=Tmp;
        end
        New_Colonies(i,1:Point1)=parent_1(1:Point1);
        New_Colonies(i,Point1+1:Point2)=parent_2(Point1+1:Point2);
        New_Colonies(i,Point2+1:edpp.varDim) = parent_1(Point2+1:edpp.varDim);
    end
    
    R = randperm(size(TheEmpire.Colonies_cost,1));
    R = R(1:No_of_Revolving_Colonies);
    TheEmpire.Colonies_position(R,:) = New_Colonies;
else
No_of_Revolving_Colonies = round( ica.RevolutionRate * size(TheEmpire.Colonies_cost,1));
New_Colonies = zeros(No_of_Revolving_Colonies,edpp.varDim);
a=-1;
b=1;

for j=1:No_of_Revolving_Colonies
    P1 = randi(size(TheEmpire.Imperialist_position,1), 1);
    v = (a + (b-a)*rand(1, edpp.varDim))/10;
    New_Colonies(j,:) = TheEmpire.Imperialist_position(P1, :) + v;
end
R = randperm(size(TheEmpire.Colonies_cost,1));
R = R(1:No_of_Revolving_Colonies);
TheEmpire.Colonies_position(R,:) = New_Colonies;
%_________________________________________________________________

MinVarMatrix = repmat(edpp.varMin,No_of_Revolving_Colonies,1);
MaxVarMatrix = repmat(edpp.varMax,No_of_Revolving_Colonies,1);
TheEmpire.Colonies_position(R,:)=max(TheEmpire.Colonies_position(R,:),MinVarMatrix);
TheEmpire.Colonies_position(R,:)=min(TheEmpire.Colonies_position(R,:),MaxVarMatrix);
end
end
