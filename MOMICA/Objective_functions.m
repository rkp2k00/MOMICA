function z= Objective_functions(x,~,~)

%      z = [];
%      for j=1:size(x,1)
%          z(j,:) = FON(x(j,:));
%      end
%     function y=FON(x)
%      n = length(x);
%      i = 1:n;
%      y(1) = 1-exp(-1*sum((x(i)-(1/(edpp.varDim).^0.5)).^(2)));
%      y(2) = 1-exp(-1*sum((x(i)+(1/(edpp.varDim).^0.5)).^2));
%     end
     z = [];
     for j=1:size(x,1)
         z(j,:) = Kursawe(x(j,:));
     end
    function y=Kursawe(x)
     n = length(x);
     i = 1:n-1;
     y(1) = sum(-10*exp(-0.2*sqrt(x(i).^2+x(i+1).^2)));
     i = 1:n;
     y(2) = sum(abs(x(i)).^(0.8)+5*sin(x(i).^(3)));
    end

%      g=zeros(size(x,1),1);
%      for i=1:length(x)  %%%%%% objective functions, will create seperate function file later.
%         for j = 2:edpp.varDim
%           g(i) = g(i) + x(i,j)^2 - 10.0*cos(4.0*pi*x(i,j));
%         end
%         g(i) = g(i) + 1.0 + 10.0*(edpp.varDim-1);
%         y(i,1) = x(i,1);
%         y(i,2) = g(i) * (1.0-sqrt(x(i,1)/g(i)));
%      
%      end
end