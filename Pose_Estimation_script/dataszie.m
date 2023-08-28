clear all
close all
clc


x=round([2,5,12,25,50,95].*5372/100);
% y=[5.4170,4.3869,5.0210,3.7935,2.6208];
y=[6.6786,4.6020,3.9077,3.5934,3.8920,3.3942];
c=3.0470;
figure
plot(x,y,'o-','LineWidth',3)
% % semilogx(x,y,'o-','LineWidth',3)
hold on
plot(linspace(0,6000,2),ones(2,1)*c,'--','Color','#0072BD','LineWidth',2)
ylim([0 10])



set(gca,'FontSize',18,'FontWeight','bold')
xlabel('Particle Amount');
ylabel('Mean Angle Error (deg)')
% xlim([0,])
ylim([2,8])
ax = gca;
ax.LineWidth = 3;

