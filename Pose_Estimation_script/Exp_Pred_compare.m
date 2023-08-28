clear all
close all
clc
%% Load data

% GT=load("GTref.mat");
% uni_Pred=load("UNIBKGModel.mat");
% gen_Pred=load("generalModel.mat");

GT=load("nDFSB1000GT.mat");
load("nDFSB1000GT_f.mat");       %GT filtered from pred outliers
gen_Pred=load("nDFSB1000Pred_trainingsize644.mat");

GT=GT.GT;
% uni_Pred=uni_Pred.Pred;
gen_Pred=gen_Pred.Pred;

% [GT.T,GT.anglemid]=cal_T(GT.angle);
% % [uni_Pred.T,Pred.anglemid]=cal_T(uni_Pred.angle);
% [gen_Pred.T,gen_Pred.anglemid]=cal_T(gen_Pred.angle);

[GT.G,GT.anglemid]=cal_G(GT.angle);
% [uni_Pred.T,Pred.anglemid]=cal_T(uni_Pred.angle);
[gen_Pred.G,gen_Pred.anglemid]=cal_G(gen_Pred.angle);

%% Plot angle histogram and energy comparison

figure;
tiledlayout(2,1,"TileSpacing","none","Padding","compact")
nexttile
NUCPLOT2(GT.angle,gen_Pred.angle)
ylabel('P')
yticks([0 0.025 0.05])
xticklabels({''})
xlabel('')
nexttile
set(gcf,'Color',[1 1 1])
plot(GT.anglemid,GT.G-min(GT.G),'b--','linewidth',3)
hold on
% plot(uni_Pred.anglemid,uni_Pred.T,'-','linewidth',3)
% hold on
idx=find(gen_Pred.anglemid>35&gen_Pred.anglemid<115);
plot(gen_Pred.anglemid(idx),gen_Pred.G(idx)-min(gen_Pred.G(idx)),'-','linewidth',3)
hold on
xlabel('\theta (^o)'), ylabel({'\Delta G','(k_BT)'})
xlim([0 180])
ylim([-0.5,4])
yticklabels({'0','2','4','6'})
set(gca,'FontSize',18,'FontWeight','bold')
ax = gca;
ax.LineWidth = 3;
% legend('Ground Truth','Model Predication','Location','best')
% legend('Ground Truth','Background-specific Model','General Model','Location','best')
%% r-thetra error analysis
r1_error_stock=zeros(length(GT_f.vertex),1);
theta1_error_stock=zeros(length(GT_f.vertex),1);
r2_error_stock=zeros(length(GT_f.vertex),1);
theta2_error_stock=zeros(length(GT_f.vertex),1);
scalebar=101/70;  %pix/nm
for i=1:length(GT_f.vertex)
    x0=GT_f.vertex(i,1);
    y0=GT_f.vertex(i,2);
    x1=GT_f.tipl(i,1);
    y1=GT_f.tipl(i,2);
    x2=GT_f.tipr(i,1);
    y2=GT_f.tipr(i,2);
    x1p=gen_Pred.tipl(i,1);
    y1p=gen_Pred.tipl(i,2);
    x2p=gen_Pred.tipr(i,1);
    y2p=gen_Pred.tipr(i,2);

    r1=[x1-x0,y1-y0];
    r2=[x2-x0,y2-y0];
    r1p=[x1p-x0,y1p-y0];
    r2p=[x2p-x0,y2p-y0];

    r1_error=abs(norm(r1)-norm(r1p))./scalebar;
    r1_error_stock(i)=r1_error;
    r2_error=abs(norm(r2)-norm(r2p))./scalebar;
    r2_error_stock(i)=r2_error;
    theta1_error=rad2deg(subspace(r1',r1p'));
    theta1_error_stock(i)=theta1_error;
    theta2_error=rad2deg(subspace(r2',r2p'));
    theta2_error_stock(i)=theta2_error;


end

figure
tiledlayout(2,2)
nexttile
histogram(r1_error_stock)
xlabel('Unit (nm)')
ylabel('N')
title('e_{r1}')
xlim([0 80])
ylim([0,250])
nexttile
histogram(r2_error_stock)
xlabel('Unit (nm)')
ylabel('N')
title('e_{r2}')
xlim([0 80])
ylim([0,250])
nexttile
histogram(theta1_error_stock,'BinWidth',1)
xlabel('Unit (deg)')
ylabel('N')
title('e_{\theta1}')
xlim([0 80])
ylim([0,400])
nexttile
histogram(theta2_error_stock,'BinWidth',1)
xlabel('Unit (deg)')
ylabel('N')
title('e_{\theta2}')
xlim([0 80])
ylim([0,400])
%% Statistical Test
sw=0;
if sw==1

Test_data_1=GT.angle;
Test_data_2=gen_Pred.angle;

% [h,p,k2stat]=kstest2(Test_data_1,Test_data_2)
[h,p,test,df]=chi2test2(Test_data_1,Test_data_1,0.05)
end