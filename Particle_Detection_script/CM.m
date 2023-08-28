clear all
close all
clc


% pred_dir='C:\SimMetaD\yoloproject\yolov5-master\runs\detect\yolov5n_pred_TEM_conf03\BBF_labels';
% pred_dir='C:\SimMetaD\yoloproject\yolov5-master\runs\detect\train9_conf047\BBF_labels\';
pred_dir='C:\SimMetaD\yoloproject\yolov5-master\runs\detect\yolov5n_10_03\labels\';
pred_dir_BBF='C:\SimMetaD\yoloproject\yolov5-master\runs\detect\yolov5n_10_03\BBF_labels\';

truth_dir='C:\SimMetaD\yoloproject\datasets\Hinge_TEM_v2\labels\test';
test_img_dir='C:\SimMetaD\yoloproject\datasets\Hinge_TEM_v2\images\test';
pred_ds=tabularTextDatastore(pred_dir_BBF);
truth_ds=tabularTextDatastore(truth_dir);

visualize_sw=0;
tp_sum=0;
fp_sum=0;
fn_sum=0;
truth_total=0;
figure
for i=1:30
    
    if visualize_sw==1
        [~,image,~]=fileparts(truth_ds.Files{i});
        I=imread(strcat(test_img_dir,'\',image,'.jpg'));
        label=readmatrix(strcat(truth_dir,'\',image,'.txt'));
        label_pred=readmatrix(strcat(pred_dir,'\',image,'.txt'));
        label_pred_BBF=readmatrix(strcat(pred_dir_BBF,'\',image,'.txt'));
        imgsize=960;
        imshow(I)
        title(image)
        hold on
        for iii=1:length(label)
            rec_dim=[label(iii,2)*960-25,label(iii,3)*960-25,50,50];
            rectangle('Position',rec_dim,...
                'LineWidth',2,'LineStyle','-','EdgeColor','g')
            %     text_dim=rec_dim./960;
            %     text_dim(2)=text_dim(2)+10/960;
            %     annotation('textbox',text_dim,'String','123','FitBoxToText','on')
            hold on
        end
        for iii=1:length(label_pred)
            rec_dim=[label_pred(iii,2)*960-25,label_pred(iii,3)*960-25,label_pred(iii,4)*960,label_pred(iii,5)*960];
            rectangle('Position',rec_dim,...
                'LineWidth',2,'LineStyle','--','EdgeColor','b')
            %     text_dim=rec_dim./960;
            %     text_dim(2)=text_dim(2)+10/960;
            %     annotation('textbox',text_dim,'String','123','FitBoxToText','on')
            hold on
        end
        for iii=1:length(label_pred_BBF)
            rec_dim=[label_pred_BBF(iii,2)*960-25,label_pred_BBF(iii,3)*960-25,50,50];
            rectangle('Position',rec_dim,...
                'LineWidth',2,'LineStyle','-','EdgeColor','r')
            %     text_dim=rec_dim./960;
            %     text_dim(2)=text_dim(2)+10/960;
            %     annotation('textbox',text_dim,'String','123','FitBoxToText','on')
            hold on
        end
        pause
    end




    %find tp fp  pred(1) test truth(1)(2)...(n)
    pred_img_label=readmatrix(pred_ds.Files{i});
    truth_img_label=readmatrix(truth_ds.Files{i});
    ispredfindtarget=zeros(length(pred_img_label),1);

    truth_total=truth_total+length(truth_img_label);
    for j=1:length(pred_img_label)
        x=pred_img_label(j,2);
        y=pred_img_label(j,3);

        for k=1:length(truth_img_label)
            x_target=truth_img_label(k,2);
            y_target=truth_img_label(k,3);

            IoU=cal_IoU(x*960,y*960,x_target*960,y_target*960);
            if IoU>=0.3
                ispredfindtarget(j)=1;
                break
            end
        end
    end

%     istruthfindtarget=zeros(length(truth_img_label),1);
%     for j=1:length(truth_img_label)
%         x=truth_img_label(j,2);
%         y=truth_img_label(j,3);
% 
%         for k=1:length(pred_img_label)
%             x_target=pred_img_label(k,2);
%             y_target=pred_img_label(k,3);
% 
% 
%             if abs(x_target-x)<20/960 && abs(y_target-y)<20/960
%                 istruthfindtarget(j)=1;
%             end
%         end
%     end

    tp=length(find(ispredfindtarget==1));
    fp=length(find(ispredfindtarget==0));


%     tp2=length(find(istruthfindtarget==1));
%     fn=length(find(istruthfindtarget==0));
% 
%     if tp~=tp2
%         i
%     end
    tp_sum=tp_sum+tp;
    fp_sum=fp_sum+fp;
%     fn_sum=fp_sum+length(truth_img_label)-tp;

end
fn_sum=truth_total-tp_sum;
p=tp_sum/(tp_sum+fp_sum);
r=tp_sum/(tp_sum+fn_sum);
f1=2*(p*r)/(p+r)