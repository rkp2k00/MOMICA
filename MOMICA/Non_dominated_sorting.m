function [Front,sort_ind,Solutions]= Non_dominated_sorting(Initial_cost,ica)
 
 sort_ind=1;
 Front(1).pts=[];
 k=0;
 for i=1:length(Initial_cost)
     
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
         Front(1).pts(k,1)= p(1);
         Front(1).pts(k,2)= p(2);
     end
     
     Solutions(i).dominated_by_p(1,:)=[];
     
 end

 %  stage 2
 i=1;
 while ~isempty(Front(1).pts)
     Front(i+1).pts =[];
     m=0;
     for j=1:length(Front(1).pts)
         p=Front(1).pts(j,:);
         for k=1:ica.no_of_countries
             if Solutions(k).dominating_p~=0
                 Solutions(k).dominating_p = Solutions(k).dominating_p - 1;
                 if ((Solutions(k).dominating_p)-1)==0
                     Solutions(k).rank =i+1;
                     m=m+1;
                     %Front(i+1).pts(m,:)= Initial_cost( Solutions(k).dominated_by_p,:);
                 end
             end
         end
         
     end
     i=i+1;
 end
 
end
