function NewCountry = GenerateNewCountry(Num,edpp)

    VarMinMatrix= repmat(edpp.varMin,Num,1);
    VarMaxMatrix= repmat(edpp.varMax,Num,1);
    
    NewCountry = (VarMaxMatrix - VarMinMatrix).*rand(size(VarMinMatrix))+ VarMinMatrix;
   
end

