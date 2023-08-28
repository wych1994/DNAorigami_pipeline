clear all
close all
clc

imgsize=960;
boxsize=50;
% boxsize=80;
dir='C:\SimMetaD\yoloproject';

label_ds=tabularTextDatastore(strcat(dir,'\yolov5-master\runs\detect\train9_conf047\labels'));
% label_ds=tabularTextDatastore(strcat(dir,'\datasets\Hinge_TEM\labels\validv2'));
% label_ds=tabularTextDatastore(strcat(dir,'\yolov5-master\runs\detect\singleclass_optimized\labels'));

img_ds=imageDatastore(strcat(dir,'\datasets\Hinge_TEM\images\validv2'));
% img_ds=imageDatastore(strcat(dir,'\datasets\Highmag\images'));
num_imgs_detected=length(label_ds.Files);

img_label_stock=cell(num_imgs_detected,3);

box_stock=[];
size_filter=0;


particle_stock={};
for i=1:num_imgs_detected
% for i=1:1
    [~,img_name,~]=fileparts(label_ds.Files{i});
    img_label_stock{i,1}=img_name;
    img_label=readmatrix(label_ds.Files{i});
    img_label_stock{i,2}=img_label(:,2)*imgsize;   %x
    img_label_stock{i,3}=img_label(:,3)*imgsize;   %y
    box_ind_stock=img_label(:,4:5)*imgsize;   %w,h
%     box_avg=sum(box_ind_stock,2)/2;
    
if size_filter==1
%filter out box <40 or >60
%     filter_w=box_ind_stock(:,1)>40&box_ind_stock(:,1)<60;
%     filter_h=box_ind_stock(:,2)>40&box_ind_stock(:,2)<60;
%     filter=filter_w&filter_h;
ar=box_ind_stock(:,1)./box_ind_stock(:,2);
filter=ar<1.5;
    img_label_stock{i,2}=img_label_stock{i,2}(filter);
    img_label_stock{i,3}=img_label_stock{i,3}(filter);


   box_ind_stock=box_ind_stock(filter,:);
end
    box_stock=[box_stock;box_ind_stock];
    num_box=size(img_label_stock{i,2},1);
    I=readimage(img_ds,i);

    particle_stock_perimg=cell(num_box,1);

    for j=1:num_box
        xmin=img_label_stock{i,2}(j)-boxsize/2;
        ymin=img_label_stock{i,3}(j)-boxsize/2;
        if size_filter==1
        h=boxsize;
        w=boxsize;
        else
        w=box_ind_stock(j,1);
        h=box_ind_stock(j,2);
        end
        particle_stock_perimg{j}=imcrop(I,[xmin,ymin,w,h]);
%         particle_stock_perimg{j}=imresize(particle_stock_perimg{j},[50,50]);
        [m,n]=size(particle_stock_perimg{j});
        %remove particles with wrong size
        if size_filter==1
        if m<(boxsize+1) || n<(boxsize+1)
            particle_stock_perimg{j}=[];
        end
        end
    end
    second_filter=find(~cellfun(@isempty,particle_stock_perimg));
    particle_stock_perimg = particle_stock_perimg(cellfun(@isempty, particle_stock_perimg) == 0);
    particle_stock=[particle_stock;particle_stock_perimg];

    %write out BBF label file
%     img_label=readmatrix(label_ds.Files{i});  %read again just in case
%     img_label=img_label(filter,:);
%     img_label=img_label(second_filter,:);
%     writematrix(img_label,strcat('C:\SimMetaD\yoloproject\yolov5-master\runs\detect\train9_conf047\BBF_labels\',...
%         img_name,'.txt'),'Delimiter','space')
end

figure
subplot(1,3,1)
histogram(box_stock(:,1))
xlabel('Width (pix)')
ylabel('N')
subplot(1,3,2)
histogram(box_stock(:,2))
xlabel('Height (pix)')
ylabel('N')
subplot(1,3,3)
histogram(box_stock(:,1)./box_stock(:,2))
xlabel('AR (pix)')
ylabel('N')


out = imtile(particle_stock,'ThumbnailSize',[200,200]);
figure
imshow(out)
% imwrite(out,'nDFS_test_YW.png')
% % 
% for i=1:length(particle_stock)
%     I=particle_stock{i};
%     I=imresize(I,[200,200]);
%     imwrite(I,strcat('C:\SimMetaD\posev2\Dataset\nDFS_test_YW\','YW-',num2str(i,'%09.f'),'.png'))
% end

