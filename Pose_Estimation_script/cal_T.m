function [T1,anglemid]=cal_T(data)


%generate histogram
[CdfF,CdfX] = ecdf(data,'Function','cdf');
BinInfo.rule = 5;
BinInfo.width = 5;
BinInfo.placementRule = 1;
[~,BinEdge] = internal.stats.histbins(data,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);

%calculate free energy
X=BinCenter;
P=BinHeight;
n=length(find(P<10^(-8)));
for i=1:n
zt=find(P<10^(-8));
P(zt(1))=[];
X(zt(1))=[];
end
U=-log(P);

%fit the free energy by spline
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.00408450753266581;
pf=fit(X',U', ft, opts);

%cut off data by threshold
pheight_treshold=0.001;
for i=1:length(BinHeight)
    if BinHeight(i)>pheight_treshold
        mina=BinEdge(i);
        break;
    end
end
for i=length(BinHeight):-1:round(length(BinHeight)/2)
    if (BinHeight(i)>pheight_treshold) && (BinHeight(i-1)>pheight_treshold) && (BinHeight(i-2)>pheight_treshold) 
        maxa=BinEdge(i);
        break;
    end
end

angle=linspace(mina,maxa,1000);
% angle=linspace(10,100,1000);
fitp=pf(angle);

%smoothed free energy
kT=4.14*10^(-21);
G=fitp*kT;

%calculate torque by differentiation of energy
T=zeros(length(angle)-1,1);
anglemid=zeros(length(angle)-1,1);        %bin center
angleR=angle*pi/180;                      %angle in radain
for iii=1:length(T)
    T(iii)=((G(iii+1)-G(iii))/(angleR(iii+1)-angleR(iii)));
    anglemid(iii)=(angle(iii+1)+angle(iii))/2;
end

%% 
r=32:1:180;                               %distance away from hinge vertex [bp]
r=r*0.34*10^(-9);                         %[m]
F=zeros(length(anglemid),length(r)); 
for i=1:length(anglemid)
    for j=1:length(r)
        F(i,j)=T(i)/r(j);
    end
end

F=F*10^12;
r=r*10^9;

% figure
% plot(angle,G)

T1 = T*1e21;
% figure


% c_Tfit = polyfit(anglemid,T1,1);
% angle_fit = 5:1:130;
% T_fit = c_Tfit(1)*angle_fit + c_Tfit(2);
% plot(angle_fit,T_fit,'linewidth',2)

% for i=1:length(angle_fit)
%     for j=1:length(r)
%         F1(i,j)=T_fit(i)/r(j);
%     end
% end

% figure
% %translate polar information into cartisian for plot
% [x,y,z] = pol2cart(anglemid/180*pi,r,F);
% contourf(x,y,z,500,'LineStyle','None')
% colorbar
% caxis([-10 5])
% axis([-40 70 0 80])
% axis square
% 
% title('nDFS.B')
% colormap('jet')
% keyboard

% figure
% set(gcf,'Color',[1 1 1])
% %translate polar information into cartisian for plot
% [x1,y1,z1] = pol2cart(angle_fit'*pi/180,r,F1);
% contourf(x1,y1,z1,500,'LineStyle','None')
% colorbar
% % caxis([-10 5])
% axis equal
% axis([-40 70 0 70])
% xlabel('X (nm)','FontSize',16), ylabel('Y (nm)','FontSize',16)
% set(gca,'FontSize',20)
% 
% title('nDFS.B')
% colormap('jet')