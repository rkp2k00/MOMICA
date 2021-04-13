function [Front,sort_index,Solutions]= Non_dominated_sorting(Initial_cost,ica,edpp)
 
 Front(1).pts=[]; 
 N_obj=edpp.N_obj;
 k=0;
 t_1=0;
 t_2=0; 
 for i=1:ica.no_of_countries
     p= Initial_cost(i,:);
     Solutions(i).dominated_by_p=[0];
     Solutions(i).dominating_p=0;
     for j=1:length(Initial_cost)
       if i~=j
           q= Initial_cost(j,:);
           for x=1:N_obj
             if p(x)<=q(x)
                 t_1=t_1+1;
             elseif p(x)>q(x)
                 t_2=t_2+1;
             end
           end
           if t_1==N_obj
             Solutions(i).dominated_by_p = union(Solutions(i).dominated_by_p,j,'rows');
           elseif t_2==N_obj
             Solutions(i).dominating_p = Solutions(i).dominating_p+1;
           end
           t_1=0;
           t_2=0;
       end
     end
     if Solutions(i).dominating_p==0
         k=k+1;
         Solutions(i).rank = 1;  
         for y=1:N_obj
            Front(1).pts(k,y)= p(y);   % objective -n- front-1
         end
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
                 for n=1:N_obj
                 Front(i+1).pts(m,n)=r(n);    % objective -n- front-i+1
                 end
                 Front(i+1).pts(m,3)=y(k);    
             end
         end
     end
     i=i+1;
 end
%%%%%% crowded distance algorithm
for i=1:(length(Front)-1)
     a=Front(i).pts(:,3);
     for j=1:length(a)
         Solutions(a(j)).crowded_distance = 0;
         Solutions(a(j)).f_value= Initial_cost(a(j),:);
     end
     for k=1:N_obj
       for n=1:length(a)
          b(n,1)=Solutions(a(n)).f_value(k);
          c(n,1)=a(n);
       end
       [b,s_ind]=sort(b);
       c=c(s_ind,1);
     
       Solutions(c(1)).crowded_distance= -log(0);    %%%%  assigning infinity to the end solution
       Solutions(c(end)).crowded_distance= -log(0); 
            
       for p=2:length(a)-1
         Solutions(c(p)).crowded_distance= Solutions(c(p)).crowded_distance + (Solutions(c(p+1)).f_value(k)-Solutions(c(p-1)).f_value(k))/(b(length(a)-1)-b(1));
       end
     end
 end 
%%%%% to find out the sort_ind using crowded binary selection operator;
 current_index=0;
 sort_index=[];
 for i=1:length(Front)-1
   
     a=Front(i).pts(:,3);
     for j=1:length(a)
         Front(i).pts(j,4)=Solutions(a(j)).crowded_distance;
     end
     [Front(i).pts(:,4),s_ind]=sort(Front(i).pts(:,4));
     for k=1:length(a)
         sort_index(k+current_index,1) = Front(i).pts(s_ind(k,1),3);
     end
     current_index=current_index+length(a);
 end
  
end