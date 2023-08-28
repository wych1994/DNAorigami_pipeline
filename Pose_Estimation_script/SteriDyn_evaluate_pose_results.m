clear all
close all
clc
dir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\Code\Angle_scr\Data';

% dir='D:\OneDrive - The Ohio State University\IMGDATA\Code\Angle_scr';
dataname='SteriDyn_YW';
% dataname='nDFSC20_g2_Pose';
testdataname1='DLC_resnet50_TEM_SteriDynOct30shuffle1_50000-snapshot-50000';
% testdataname1='testset_nDFSB_R3DLC_resnet50_TEM_angle_varyBKGOct30shuffle1_50000';

% testdataname='test_particlesDLC_resnet50_TEM_angleOct30shuffle1_50000.csv';

sw=0;
if sw==1
learning_log=readtable("learning_stats_095split.csv");
figure
plot(table2array(learning_log(:,1)),table2array(learning_log(:,2)))
xlabel('Epoch')
ylabel('Loss')
end

% GroundTruth=readtable('nDFSB_R3_pred_Pose_YWlabeled.csv');
GroundTruth=readtable(strcat(dir,'\GT\',dataname));

% Predication=readtable('DLC_resnet50_TEM_angleOct30shuffle1_50000-snapshot-50000');
Predication=readtable(strcat(dir,'\Prediction\',testdataname1));

GT.lt=table2array(GroundTruth(:,4:5));
GT.lvertex=table2array(GroundTruth(:,6:7));
GT.rvertex=table2array(GroundTruth(:,8:9));
GT.rt=table2array(GroundTruth(:,10:11));
Pred.lt=table2array(Predication(:,4:5));
Pred.lvertex=table2array(Predication(:,7:8));
Pred.rvertex=table2array(Predication(:,10:11));
Pred.rt=table2array(Predication(:,13:14));

% Pred.tipl=table2array(Predication(:,2:3));
% Pred.vertex=table2array(Predication(:,5:6));
% Pred.tipr=table2array(Predication(:,8:9));


[GT.l_angle,GT.r_angle]=calv2angle(GT);
[Pred.l_angle,Pred.r_angle]=calv2angle(Pred);
%apply outlier filter
filter=0;
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


l_angle_abse=abs(GT.l_angle-Pred.l_angle);
r_angle_abse=abs(GT.r_angle-Pred.r_angle);
figure
subplot(1,2,1)

NUCPLOT2(GT.l_angle,Pred.l_angle)
legend('Ground Truth','Prediction')
title('Left Angle')
subplot(1,2,2)
NUCPLOT2(GT.r_angle,Pred.r_angle)
legend('Ground Truth','Prediction')
title('Right Angle')

figure
subplot(1,2,1)
NUCPLOT(l_angle_abse)
xlabel('Abs Angle Error \theta (\circ)');
ylabel('Probability Density')
xlim([0,100])
set(gca,'FontSize',18,'FontWeight','bold')
subplot(1,2,2)
NUCPLOT(r_angle_abse)
xlabel('Abs Angle Error \theta (\circ)');
ylabel('Probability Density')
xlim([0,100])
set(gca,'FontSize',18,'FontWeight','bold')


mean(l_angle_abse)
mean(r_angle_abse)
