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
hour=c{4};
minutes= c{5};
T= c{13};
LWD= c{10};
daysinmonth= max(days);
SBC=5.670373*10^-8;
Tm=zeros (1,8);
TmK=zeros (1,8);
LWDm= zeros (1,8);
cloud= ones(daysinmonth,8)*NaN;
cloud_n= ones(daysinmonth,8)*NaN;
 e3h= zeros(daysinmonth,8);           %3 hourly emissivity
 
 for i= 1:daysinmonth
for j= 1:8
    hours=[0,3,6,9,12,15,18,21];
  dayindex= find((days==i)&(hour==hours(j)));
 
  if length(dayindex)>5
      h(j)= mean(hour(dayindex(1:5)));
  Tm(j) = mean(T(dayindex(1:5)));
     LWDm(j) = mean(LWD(dayindex(1:5)));
 else
     Tm(j)= NaN;
     LWDm(j)= NaN;
     h(j)= NaN;
  end
  H(i,j)= h(j);
TmK(j)= Tm(j)+273;
e3h(i,j)= (LWDm(j)./(SBC.*(TmK(j).^4))); 
 
%Clear Sky Emissivity Calculated Either
 e_cl= zeros(daysinmonth,8);
%by Maykut and Church (1973)
a=0.7248;
e_cl(i,j)= a;
          %Or
%by Swinbank (1963)
a=9.294*10^(-6);
b=2;
e_cl(i,j)=(a*TmK(j).^b);
           %Or
%by Idso and Jackson (1969)
a=0.2811;
b= -3.523*10^-4;
e_cl(i,j)= 1-a*(exp(b*(273-TmK(j)).^2));

end 
 end
 
 %Cloud Cover using Both Limits Calculated Either
 Cloud_estimate = zeros (daysinmonth,8);

%by linear parameterization
e3h=min(max(e_cl,e3h),(1));          %Limit 1
cloud_n(:) = ((e3h-e_cl)./(1-e_cl)); 

 idx1= find((e3h>=e_cl) & (e3h<=1));  %Limit 2
cloud(idx1) = ((e3h(idx1)-e_cl(idx1))./(1-e_cl(idx1)));  
                    %Or
% by König-Langlo and Augstein (1994) 
e3h= min(max(e_cl,e3h),(e_cl+0.2176));   %Limit 1
cloud_n(:)= ((e3h-e_cl)./(0.2176)).^(1/1.5);   

idx1= find((e3h>=e_cl) & (e3h<=(e_cl+0.2176))); %Limit 2
 cloud(idx1) = ((e3h(idx1)-e_cl(idx1))./(0.2176)).^(1/1.5); 
 
eval(sprintf('cn_%02d= [cloud_n(:)]', m)); 
eval(sprintf('cc_%02d= [cloud(:)]', m));
 end
 allvalues= vertcat(cn_01,cn_02,cn_03,cn_04,cn_05,cn_06,cn_07,cn_08,cn_09,cn_10,cn_11,cn_12); 
allvalues1= vertcat(cc_01,cc_02,cc_03,cc_04,cc_05,cc_06,cc_07,cc_08,cc_09,cc_10,cc_11,cc_12);  
eval(sprintf('cn_%4d = [allvalues]',y));
eval(sprintf('cc_%4d = [allvalues1]',y));
end
cn_vector= vertcat(cn_2010,cn_2011,cn_2012,cn_2013,cn_2014,cn_2015,cn_2016,cn_2017,cn_2018);
cn_vector1=(cn_vector*8);
cc_vector= vertcat(cc_2010,cc_2011,cc_2012,cc_2013,cc_2014,cc_2015,cc_2016,cc_2017,cc_2018);
cc_vector1=(cc_vector*8);

for y=2010:2018
 for m= 01:012
  datafiles= sprintf('GVN_SYNOP_%4d-%02d.tab',y,m);
  fid = fopen(datafiles,'rt');
  for i =1:34
    fgetl(fid);
  end
  c= textscan(fid,'%4d-%2d-%2dT%2d:%2d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s','Delimiter','\t');
  year1= c{1};
month1= c{2};
days1=c{3};
LMC= c{22};                      %Low and middle cloud
hour2= c{4};
daysinmonth= max(days1);
lmc= zeros(daysinmonth,8);
lmc2 = zeros(daysinmonth,8);
for i= 1:daysinmonth
    for j= 1:8
    hours=[0,3,6,9,12,15,18,21];
  dayindex2= find((days1==i)&(hour2==hours(j)));
    lmc(j) =nanmean(LMC(dayindex2));
     lmc2(i,j) = lmc(j);
    end   
end
 idx2=find(lmc2==9);
 lmcn= lmc2;
lmcn(idx2)=NaN; 
eval(sprintf('LMcc_%02d= [lmc2(:)]', m));
eval(sprintf('LMcn_%02d= [lmcn(:)]', m));
 end
 allvalues2= vertcat(LMcc_01,LMcc_02,LMcc_03,LMcc_04,LMcc_05,LMcc_06,LMcc_07,LMcc_08,LMcc_09,LMcc_10,LMcc_11,LMcc_12);
allvalues3= vertcat(LMcn_01,LMcn_02,LMcn_03,LMcn_04,LMcn_05,LMcn_06,LMcn_07,LMcn_08,LMcn_09,LMcn_10,LMcn_11,LMcn_12);
eval(sprintf('LMcc_%4d = [allvalues2]',y));
eval(sprintf('LMcn_%4d = [allvalues3]',y));
end 
LMcc_vector= vertcat(LMcc_2010,LMcc_2011,LMcc_2012,LMcc_2013,LMcc_2014,LMcc_2015,LMcc_2016,LMcc_2017,LMcc_2018);
LMcn_vector= vertcat(LMcn_2010,LMcn_2011,LMcn_2012,LMcn_2013,LMcn_2014,LMcn_2015,LMcn_2016,LMcn_2017,LMcn_2018);

d = cc_vector1-LMcc_vector;        %difference between calculated and observed cloud cover values

%Errors
CRC= corr(cc_vector1,LMcc_vector,'rows','pairwise');    %corelation coefficient 
RMSE= sqrt(mean((d).^2,'omitnan'));                     %root mean square error
MBE= (nansum(d))/(length(d));                           %mean bias error
 
