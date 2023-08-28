function [G,angle]=cal_G(data)


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
G=fitp;




