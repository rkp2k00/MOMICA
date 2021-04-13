function [Front,s,Solutions]= Non_dominated_sorting(Initial_cost,ica)
 
 Front(1).pts=[]; 
 k=0;
 for i=1:ica.no_of_countries
     
     p= Initial_cost(i,:);
     Solutions(i).dominated_by_p=[0];
     Solutions(i).dominating_p=0;
     for j=1:length(Initial_cost)
       if i~=j
           q= Initial_cost(j,:);
           if p(1)<q(1) && p(2)<q(2)
              Solutions(i).dominated_by_p = union(Solutions(i).dominated_by_p,j,'rows');
           elseif p(1)>= q(1) && p(2)>= q(2)
              Solutions(i).dominating_p = Solutions(i).dominating_p+1;
           end
       end
     end
     if Solutions(i).dominating_p==0
         k=k+1;
         Solutions(i).rank = 1;  
         Front(1).pts(k,1)= p(1);   % objective -1- front-1
         Front(1).pts(k,2)= p(2);   % objective -2- front-1
         Front(1).pts(k,3)=i;       % index from the Initial cost
     end
     
     Solutions(i).dominated_by_p(1,:)=[];
     
 end
 
 %  stage 2
 i=1;
 while ~isempty(Front(i).pts)
     Front(i+1).pts =[];
     m=0;
     x=Front(i).pts(:,3);
     for j=1:length(x)
         y=Solutions(x(j)).dominated_by_p;
         for k=1:length(y)
             Solutions(y(k)).dominating_p= Solutions(y(k)).dominating_p - 1;
             if Solutions(y(k)).dominating_p==0
                 r= Initial_cost(y(k),:);
                 m=m+1;
                 Solutions(y(k)).rank=i+1;
                 Front(i+1).pts(m,1)=r(1);    % objective -1- front-i+1
                 Front(i+1).pts(m,2)=r(2);    % objective -2- front-i+1
                 Front(i+1).pts(m,3)=y(k);    
             end
         end
     end
     i=i+1;
     
 end
 %%%%% crowded distance algorithm

 for i=1:(length(Front)-1)
     a=Front(i).pts(:,3);
     for j=1:length(a)
         Solutions(a(j)).crowded_distance = 0;
         Solutions(a(j)).f_value= Initial_cost(a(j),:);
     end
     for j=1:length(a)
         b_1(j,1)=Solutions(a(j)).f_value(1);
         c_1(j,1)=a(j);  
         b_2(j,1)=Solutions(a(j)).f_value(2);
         c_2(j,1)=a(j); 
                  
     end
     [b_1,s_ind]=sort(b_1);
     c_1=c_1(s_ind,1);
     [b_2,s_ind]=sort(b_2);
     c_2=c_2(s_ind,1);
%    disp(c_1);
%    disp(c_2);   
     Solutions(c_1(1)).crowded_distance= -log(0);    %%%%  assigning infinity to the end solution
     Solutions(c_1(end)).crowded_distance= -log(0); 
     Solutions(c_2(1)).crowded_distance= -log(0);
     Solutions(c_2(end)).crowded_distance= -log(0); 
     
     for i=2:length(a)-1
         Solutions(c_1(i)).crowded_distance= Solutions(c_1(i)).crowded_distance + (Solutions(c_1(i+1)).f_value(1)-Solutions(c_1(i-1)).f_value(1))/(b_1(length(a)-1)-b_1(1));
     end
     for i=2:length(a)-1
         Solutions(c_2(i)).crowded_distance= Solutions(c_2(i)).crowded_distance + (Solutions(c_2(i+1)).f_value(2)-Solutions(c_2(i-1)).f_value(2))/(b_2(length(a)-1)-b_2(1));
     end
 end
 
 %%%% to find out the sort_ind using crowded binary selection operator;
 
 current_index=0;
 s=[];
 for i=1:length(Front)-1
   
     a=Front(i).pts(:,3);
     for j=1:length(a)
         Front(i).pts(j,4)=Solutions(a(j)).crowded_distance;
     end
     [Front(i).pts(:,4),s_ind]=sort(Front(i).pts(:,4));
     for k=1:length(a)
         s(k+current_index,1) = Front(i).pts(s_ind(k,1),3);
     end
     current_index=current_index+length(a);
 end
  
end
