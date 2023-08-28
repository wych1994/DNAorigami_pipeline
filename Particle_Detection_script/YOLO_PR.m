clear all
close all
clc
newcolors = [


0 0.4470 0.7410

0.8500 0.3250 0.0980

0.9290 0.6940 0.1250

0.4940 0.1840 0.5560

0.4660 0.6740 0.1880

0.3010 0.7450 0.9330

0.6350 0.0780 0.1840
];
newcolors=[newcolors;rand(3,3)];

         
colororder(newcolors)


% dir='C:\SimMetaD\yoloproject\yolov5-master\runs\train\old\';
% model={'yolov5n_train10','yolov5s_model_TEM','yolov5m_model_TEM','yolov5n_model_TEM_epoch600_evolved'};

dir='C:\SimMetaD\yoloproject\yolov5-master\runs\val\IoU03\';
model={'yolov5n_train1',...
    'yolov5n_train2',...
    'yolov5n_train3',...
    'yolov5n_train4',...
    'yolov5n_train5',...
    'yolov5n_train6',...
    'yolov5n_train7',...
    'yolov5n_train8',...
    'yolov5n_train9',...
    'yolov5n_train10',...
    };

% model={'yolov5n_model_DarkTEM'};
% model={
%     'yolov5n_1',...
%     'yolov5n_2',...
%     'yolov5n_3',...
%     'yolov5n_4',...
%     'yolov5n_5',...
%     'yolov5n_6',...
%     'yolov5n_7',...
%     'yolov5n_8',...
%     'yolov5n_9',...
%     'yolov5n_10'
%     };

N_model=length(model);


for i=1:N_model
    prdata_loc=strcat(dir,model{i},'\pr data.txt');
    T=readtable(prdata_loc);
    T=table2array(T);
    Precision(:,i)=T(:,1);
    Recall(:,i)=T(:,2);
    Conf(:,i)=linspace(0,1,1000);
    F1(:,i)=2*(Precision(:,i).*Recall(:,i))./(Precision(:,i)+Recall(:,i));
    AP05(i)=-trapz(Recall(:,i),Precision(:,i));
end
figure(1)
colororder(newcolors)
plot(Recall,Precision,'lineWidth',3)
plotYWstyle()
xlabel('Recall')
ylabel('Precision')

figure(2)
colororder(newcolors)
plot(Conf,Precision,'lineWidth',3)
plotYWstyle()
xlabel('Confidence')
ylabel('Precision')

figure(3)
colororder(newcolors)
plot(Conf,Recall,'lineWidth',3)
plotYWstyle()
xlabel('Confidence')
ylabel('Recall')

figure(4)
colororder(newcolors)
plot(Conf,F1,'lineWidth',3)
plotYWstyle()
xlabel('Confidence')
ylabel('F1 Score')

% figure(5)
% tiledlayout(2,1,"TileSpacing","loose")
% nexttile
% plot(Recall,Precision,'lineWidth',3)
% plotYWstyle()
% xlabel('Recall')
% ylabel('Precision')
% ylim([0 1])
% nexttile
% plot(Conf,F1,'lineWidth',3)
% plotYWstyle()
% xlabel('Confidence')
% ylabel('F1 Score')
% ylim([0 1])

figure(6)
plot([1,2,3,4,5,6,7,8,9,10],max(F1),'-o','LineWidth',3)
set(gca,'FontSize',18,'FontWeight','bold')
ax = gca;
ax.LineWidth = 3;
ylim([0 1])
xlabel('# of Training Image(s)')
ylabel('F1 Score')