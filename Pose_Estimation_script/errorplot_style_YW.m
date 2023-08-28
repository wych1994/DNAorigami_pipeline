function errorplot_style_YW(xlist,ylist,name)
f1=figure;
f1.Position = [100 100  227 227];


x_range=-100:1:100;
y_range=-100:1:100;
% x_range=-20:1:20;
% y_range=-20:1:20;
bc={x_range y_range};
N=hist3([xlist;ylist]',bc);
N_pcolor = N'./max(max(N));

% N_pcolor(size(N_pcolor,1)+1,size(N_pcolor,2)+1) = 0;
xl = linspace(min(xlist),max(xlist),size(N_pcolor,2)); % Columns of N_pcolor
yl = linspace(min(ylist),max(ylist),size(N_pcolor,1)); % Rows of N_pcolor

h = pcolor(x_range,y_range,N_pcolor);
% xlim([-100 100])
% ylim([-100 100])
xlim([-20 20])
ylim([-20 20])
colormap('jet') % Change color scheme 
set(h, 'EdgeColor', 'none');

% colorbar % Display colorbar
colorbar('southoutside')
% h.ZData = -max(N_pcolor(:))*ones(size(N_pcolor));
% ax = gca;
% ax.ZTick(ax.ZTick < 0) = [];

% histogram2(xlist,ylist,nbins)
% scatterhist(xlist,ylist,'Location','NorthEast','Direction','out','marker','.','Kernel','on','MarkerSize',3)
xlabel(strcat(name,' Error x'))
ylabel(strcat(name,' Error y'))

std_pose=std2([xlist,ylist]);
title(strcat('Std2=',num2str(std_pose)))
% xlim([-20 20])
% ylim([-20 20])
set(gcf,'color',[1 1 1])