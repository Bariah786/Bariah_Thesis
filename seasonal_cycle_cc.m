clear all
for y=2010:2018
 for m=01:12
  datafiles= sprintf('GVN_radiation_%4d-%02d.tab',y,m);
  fid = fopen(datafiles,'rt');
  for i=1:27
     fgetl(fid);
  end
  c= textscan(fid,'%4d-%2d-%2dT%2d:%2d%f%f%f%f%f%f%f%f%f%f','Delimiter','\t');
year= c{1};
month= c{2};
days=c{3};
cloud= c{22};
cloud(find(cloud>=9))= NaN;
daysinmonth= max(days);
CC=zeros (1,daysinmonth);
for i= 1:daysinmonth
    dayindex= find(days==i);
    CC(i)= nanmean(cloud(dayindex));
end
a= nanmean(CC);
eval(sprintf('cc_%02d= [a]', m))
end
allvalues=[cc_01,cc_02,cc_03,cc_04,cc_05,cc_06,cc_07,cc_08,cc_09,cc_10,cc_11,cc_12];
txt = [num2str(y)];
plot(allvalues,'-s','DisplayName',txt)
hold all
hold on
h=legend('Location','southeast');

xlabel('Months', 'Fontsize' , 23)
ylabel('Cloud Cover [Okta]', 'Fontsize' , 23)
end