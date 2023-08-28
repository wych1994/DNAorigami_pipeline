function  NUCPLOT2(data1,data2)
[CdfF,CdfX] = ecdf(data1,'Function','cdf');
BinInfo.rule = 5;
BinInfo.width =2;
BinInfo.placementRule = 1;
[~,BinEdge] = internal.stats.histbins(data1,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor',[0.8500 0.3250 0.0980],'EdgeColor','none',...
    'LineStyle','-', 'LineWidth',2,'FaceAlpha',0.7);  %orange
hold on
%plot2
[CdfF,CdfX] = ecdf(data2,'Function','cdf');
BinInfo.rule = 5;
BinInfo.width =2;
BinInfo.placementRule = 1;
[~,BinEdge] = internal.stats.histbins(data2,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none',...
    'LineStyle','-', 'LineWidth',2,'FaceAlpha',0.7);   %grey
set(gca,'FontSize',18,'FontWeight','bold')
xlabel('Angle (deg)');
ylabel('Probability Density')
xlim([0,180])
ylim([0,0.06])
ax = gca;
ax.LineWidth = 3;
end