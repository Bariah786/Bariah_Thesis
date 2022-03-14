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
cc_class_idx=cell(10,6);
LoLim=[200 240 250 260 270];
HiLim=[240 250 260 270 300];
for i=1:10
   for j=1:5	
     cc_class_idx{i,j}=find((Vcc==(i-1)) & (VTem>LoLim(j)) & (VTem<=HiLim(j)));
   end
   cc_class_idx{i,6}=find(Vcc==(i-1) & (VTem>200));
end

figure(1)
% emissivity for periods where observed cloud cover == 0
clf 
hold
scatter(VTem(cc_class_idx{1,6}),Veps(cc_class_idx{1,6}),12,'filled')
xc=-45:.1:5; %temperature in degree Celsius
x=xc+273.15; %temperature in Kelvin
sat=.75;
psat=sat*exp(34.494-(4924.99./(xc+237.1)))./((abs(xc)+105).^1.57).*(xc>=0)+sat*(exp(43.494-(6545.8./(xc+278)))./((xc+868).^2).*(xc<0))
h1=plot(x,0.7248*x./x,'LineWidth',2)                                   %Maykut
h2=plot(x,9.294e-6*((x).^2),'LineWidth',2)                             %Swinbank 
h3=plot(x,1-.2811*(exp(-3.523E-4*(273-x).^2)),'LineWidth',2)           %Idso
set(gca,'FontSize',22)
legend([h1,h2,h3],'Maykut & Church(1973)','Swinbank(1963)','Idso & Jackson(1969)','Location','NorthEast')

xlabel('Temperature (K)','Fontsize',23)
ylabel('Emissivity','Fontsize',23)
eps_class=zeros(10,6)
for i=1:10
  for j = 1:6
     eps_class(i,j)=nanmean(Veps(cc_class_idx{i,j}));	  
  end
end
figure(2)
%mean emissivity in temperature classes as a function of cloud cover
clf
hold
h1=plot(0:8,eps_class(1:9,6),'k','LineWidth',4)
h2=plot(0:8,eps_class(1:9,1),'b','LineWidth',2)
h3=plot(0:8,eps_class(1:9,2),'c','LineWidth',2)
h4=plot(0:8,eps_class(1:9,3),'g','LineWidth',2)
h5=plot(0:8,eps_class(1:9,4),'m','LineWidth',2)
h6=plot(0:8,eps_class(1:9,5),'r','LineWidth',1)
xlabel('Cloud cover (Okta)','Fontsize',23)
ylabel('Emissivity', 'Fontsize',23)
set(gca,'FontSize',22)
legend('all values','T<=240K','240K<T<=250K','250K<T<=260K','260K<T<=270K','270K<T','Location','NorthWest')
grid