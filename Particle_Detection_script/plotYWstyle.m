function plotYWstyle()
set(gca,'FontSize',18,'FontWeight','bold')
ax = gca;
ax.LineWidth = 3;
legend('1','2','3','4', ...
 '5','6','7','8','9','10','Location','best','NumColumns',2)
ylim([0 1])
% legend('n','s','m', 'n-evolved','Location','best')
