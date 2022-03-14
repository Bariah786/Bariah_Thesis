clear all
Vcc=ones(9,12,31,8)*NaN;
Veps=ones(9,12,31,8)*NaN;
VTem=ones(9,12,31,8)*NaN;
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
  daysinmonth= max(days);
  SBC=5.670373*10^-8;
  Tm=zeros (1,8);
  TmK=zeros (1,8);
  LWDm= zeros (1,8);
  h= zeros(daysinmonth,8);
  H= zeros (daysinmonth,8);
  b=2;
  a=9.294*10^(-6);
  for i= 1:daysinmonth
   for j= 1:8
     hours=[0,3,6,9,12,15,18,21];
     obs_idx= find((days==i)&(hour==hours(j)));
     if length(obs_idx)>5
       h(j)= mean(hour(obs_idx(1:5)));
       Tm(j) = nanmean(T(obs_idx(1:5)));
       LWDm(j) = nanmean(LWD(obs_idx(1:5)));
       Veps(y,m,i,j)= nanmean(LWD(obs_idx(1:5))./(SBC.*(T(obs_idx(1:5))+273.15).^4)); 
     else
       Tm(j)= NaN;
        LWDm(j)= NaN;
       h(j)= NaN;
     end
     H(i,j)= h(j);
     TmK(i,j)= Tm(j)+273;
     Veps2(y,m,i,j)= nanmean(LWDm(j)./(SBC.*(TmK(j).^4))); 
     VTem(y,m,i,j)= nanmean(TmK(j)); 
     end
  end
 end
end

for y=2010:2018
 for m= 01:012
  datafiles= sprintf('GVN_SYNOP_%4d-%02d.tab',y,m);
  fid = fopen(datafiles,'rt');
  for i =1:34
    fgetl(fid);
  end
  c= textscan(fid,'%4d-%2d-%2dT%2d:%2d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s','Delimiter','\t');
  year1  = c{1};
  month1 = c{2};
  days1  = c{3};
  LMC    = c{22};
  hour2  = c{4};
  daysinmonth= max(days1);
  lmc= zeros(daysinmonth,8);
  h2 = zeros(daysinmonth,8);
  H2 = zeros(daysinmonth,8);
  lmc2 = zeros(daysinmonth,8);
  for i= 1:daysinmonth
   for j= 1:8
      hours=[0,3,6,9,12,15,18,21];
      obs_idx= find((days1==i)&(hour2==hours(j)));
      if (length(obs_idx)>1)
          keyboard
      end
      Vcc(y,m,i,j)=nanmean(LMC(obs_idx));
   end
  end
 end
end
s0= Veps(find(Vcc==0));
s1= Veps(find(Vcc==1));
s2= Veps(find(Vcc==2));
s3= Veps(find(Vcc==3));
s4= Veps(find(Vcc==4));
s5= Veps(find(Vcc==5));
s6= Veps(find(Vcc==6));
s7= Veps(find(Vcc==7));
s8= Veps(find(Vcc==8));
y= {s0'; s1'; s2'; s3'; s4'; s5'; s6'; s7'; s8'};
binrange= 0.5:0.02:1.2;
counts= zeros(9,36);

for k = 1:size(y,1)
    counts(k,:) = histc(y{k}, binrng);
end

bar(binrng,counts', 'stacked' )

legend('Observed cloud cover= 0 Okta', 'Observed cloud cover= 1 Okta', 'Observed cloud cover= 2 Okta', 'Observed cloud cover= 3 Okta', 'Observed cloud cover= 4 Okta', 'Observed cloud cover= 5 Okta', 'Observed cloud cover= 6 Okta', 'Observed cloud cover= 7 Okta', 'Observed cloud cover= 8 Okta')
set(gca,'FontSize',20)
xlim([0.5 1.3])
xlabel('Estimated emissivity', 'Fontsize' , 23)
ylabel('Frequency', 'Fontsize' , 23)

