close;
clear;
clc;
tic;
final_solution=[];

for i=1:30
    disp(strcat('ITERATION------',num2str(i),' out of 30'));
    s= main(i);
    size(s(i).values,1)
    final_solution(end+1:end+size(s(i).values,1),1:2)=s(i).values;   

end
disp('####Loading for final solution ......');

[f,ind,~]=Non_dominated_sorting(final_solution,5,2);
final_solution=final_solution(ind,:);
final_solution=final_solution(1:numel(f(1).pts(:,3)),:);

load('Kursawe.mat');
ica.truePF=PF;
h_fig = figure(2);
h_par=scatter(final_solution(:,1),final_solution(:,2),20,'filled', 'markerFaceAlpha',0.3,'MarkerFaceColor',[58 193 209]./255); hold on;
h_rep = plot(final_solution(:,1),final_solution(:,2),'ok'); hold on;
if(isfield(ica,'truePF'))
          try delete(h_pf); end
          h_pf = plot(ica.truePF(:,1),ica.truePF(:,2),'.','color',0.8.*ones(1,3)); hold on;
    end
    grid on; xlabel('f1'); ylabel('f2');
    drawnow;
    axis square;

s=0;
l=[];
d=[];
d_avg=0;
dmin=[];

for i=1:length(final_solution)
    l=repmat(final_solution(i,:),length(PF),1)-PF;
    d= sqrt(l(1:end,1).^2 + l(1:end,2).^2);
    d_avg=d_avg+min(d);
    s=s+min(d);
    dmin(i)=min(d);
    l=[];
    d=[];
end
d_avg=d_avg/length(final_solution);
value=0;
for i=1:length(final_solution)-1
    value=value+sum(abs(dmin(i)-d_avg));
end
[~,ind]=sort(final_solution(:,1));
final_solution=final_solution(ind,:);
l=final_solution(1,:)-final_solution(end,:);
d_i= sqrt(l(1,1)^2 + l(1,2)^2);

[~,ind1]=sort(PF(:,1));
PF=PF(ind1,:);
l=PF(1,:)-PF(end,:);
d_f= sqrt(l(1,1)^2 + l(1,2)^2);

convergence_metric = s/length(final_solution);
divergence_metric = (d_f+d_i+value)/(d_f+d_i+(length(final_solution)-1)*d_avg);
disp('done');