function NC = GenerateNewCountry(Num,edpp)

    VarMinMatrix= repmat(edpp.varMin,Num,1);
    VarMaxMatrix= repmat(edpp.varMax,Num,1);
    NC = (VarMaxMatrix - VarMinMatrix).*rand(size(VarMinMatrix))+ VarMinMatrix;
    
end

