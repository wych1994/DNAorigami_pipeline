clear all
close all
clc
dir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\Code\Pose_Estimation_script\Data';
% dir='D:\OneDrive - The Ohio State University\IMGDATA\Code\Angle_scr\Data';
% dir='D:\OneDrive - The Ohio State University\IMGDATA\Code\Angle_scr\Data';
dataname='nDFSB1000test_YWlabled';
% dataname='nDFSC20_g2_Pose';
% testdataname1='DLC_resnet50_TEM_angleOct30shuffle1_50000-snapshot-50000_size=0p95';
testdataname1='test_012model';

% testdataname='test_particlesDLC_resnet50_TEM_angleOct30shuffle1_50000.csv';

% sw=0;
% if sw==1
% learning_log=readtable("learning_stats_095split.csv");
% figure
% plot(table2array(learning_log(:,1)),table2array(learning_log(:,2)))
% xlabel('Epoch')
% ylabel('Loss')
% end

% GroundTruth=readtable('nDFSB_R3_pred_Pose_YWlabeled.csv');
GroundTruth=readtable(strcat(dir,'\GT\',dataname));

% Predication=readtable('DLC_resnet50_TEM_angleOct30shuffle1_50000-snapshot-50000');
Predication=readtable(strcat(dir,'\Prediction\',testdataname1));

GT.tipl=table2array(GroundTruth(:,2:3));
GT.vertex=table2array(GroundTruth(:,4:5));
GT.tipr=table2array(GroundTruth(:,6:7));
% Pred.tipl=table2array(Predication(:,4:5));
% Pred.vertex=table2array(Predication(:,7:8));
% Pred.tipr=table2array(Predication(:,10:11));
Pred.tipl=table2array(Predication(:,2:3));
Pred.vertex=table2array(Predication(:,5:6));
Pred.tipr=table2array(Predication(:,8:9));


GT.angle=calangle(GT);
Pred.angle=calangle(Pred);
%apply outlier filter
filter=1;
if filter==1
    GT_f=GT;
outlier_idx=Pred.angle<5;
Pred.angle(outlier_idx)=[];
Pred.tipl=Pred.tipl(~outlier_idx,:);
Pred.vertex=Pred.vertex(~outlier_idx,:);
Pred.tipr=Pred.tipr(~outlier_idx,:);
GT_f.angle(outlier_idx)=[];
GT_f.tipl=GT_f.tipl(~outlier_idx,:);
GT_f.vertex=GT_f.vertex(~outlier_idx,:);
GT_f.tipr=GT_f.tipr(~outlier_idx,:);
end

tipl_rmse=mean(sqrt((GT_f.tipl(:,1)-Pred.tipl(:,1)).^2+(GT_f.tipl(:,2)-Pred.tipl(:,2)).^2));
vertex_rmse=mean(sqrt((GT_f.vertex(:,1)-Pred.vertex(:,1)).^2+(GT_f.vertex(:,2)-Pred.vertex(:,2)).^2));
tipr_rmse=mean(sqrt((GT_f.tipr(:,1)-Pred.tipr(:,1)).^2+(GT_f.tipr(:,2)-Pred.tipr(:,2)).^2));
angle_abse=abs(GT_f.angle-Pred.angle);
figure
NUCPLOT2(GT_f.angle,Pred.angle)
legend('Ground Truth','Model Prediction')
figure
NUCPLOT(angle_abse)
xlabel('Abs Angle Error \theta (\circ)');
ylabel('Probability Density')
% set(gca,'FontSize',18)
% ax = gca;
% ax.LineWidth = 3;
set(gca,'FontSize',18,'FontWeight','bold')

mean(angle_abse)
