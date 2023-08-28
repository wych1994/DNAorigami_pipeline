function  NUCPLOT(data)
[CdfF,CdfX] = ecdf(data,'Function','cdf');
BinInfo.rule = 5;
BinInfo.width = 1;
BinInfo.placementRule = 1;
[~,BinEdge] = internal.stats.histbins(data,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor',[0.8500 0.3250 0.0980],'EdgeColor','none',...
    'LineStyle','-', 'LineWidth',2,'FaceAlpha',0.7);  %orange
set(gca,'FontSize',18)
xlabel('Angle \theta (\circ)');
ylabel('Probability Density')
% xlim([0,])
% ylim([0,0.06])
ax = gca;
ax.LineWidth = 3;
end