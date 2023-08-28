close all
clear all
clc
color_cell={[0.5 0.1 0.1],[0.5 1 0.5],[0.1 0.1 0.5], 'c', 'm', 'k','y','w'};
exp_name='Hinge';
% root_dir='D:\OneDrive - The Ohio State University'
root_dir='C:\OneDrive\OneDrive - The Ohio State University';

dir=strcat(root_dir,'\IMGDATA\Dataset\nDFS_Dataset\Image Particle Dataset_Annotated\');
truth_table=readtable(strcat(dir,'Yuchen_Pose.csv'));
prediction_table=readtable(strcat(dir,'Xin_Pose.csv'));
% imds=imageDatastore('C:\SimMetaD\posev2\Dataset_NUC\Cutted_nDFSA');

truth_table=truth_table(1:616,:);
truth_cell=cell(height(truth_table),1);
prediction_cell=cell(height(prediction_table),1);
prediction_conf_cell=cell(height(prediction_table),1);

for i=1:length(prediction_cell)
    truth_cell{i}=[truth_table{i,2},truth_table{i,3};...
        truth_table{i,4},truth_table{i,5};...
        truth_table{i,6},truth_table{i,7}];
    prediction_cell{i}=[prediction_table{i,2},prediction_table{i,3};...
        prediction_table{i,4},prediction_table{i,5};...
        prediction_table{i,6},prediction_table{i,7}];
end
% p_stock_nolabel=cell(16,1);
ppp=0;
for i=1:length(truth_cell)
    
    dist_TATAp=sqrt((prediction_cell{i}(1,1)-truth_cell{i}(1,1))^2+(prediction_cell{i}(1,2)-truth_cell{i}(1,2))^2);
    dist_TBTBp=sqrt((prediction_cell{i}(3,1)-truth_cell{i}(3,1))^2+(prediction_cell{i}(3,2)-truth_cell{i}(3,2))^2);

    dist_TATBp=sqrt((prediction_cell{i}(3,1)-truth_cell{i}(1,1))^2+(prediction_cell{i}(3,2)-truth_cell{i}(1,2))^2);
    dist_TBTAp=sqrt((prediction_cell{i}(1,1)-truth_cell{i}(3,1))^2+(prediction_cell{i}(1,2)-truth_cell{i}(3,2))^2);

    if abs(dist_TATAp+dist_TBTBp)>abs(dist_TATBp+dist_TBTAp)
        ppp=ppp+1;
        [prediction_cell{i}(1,1),prediction_cell{i}(3,1)]=swap(prediction_cell{i}(1,1),prediction_cell{i}(3,1));
        [prediction_cell{i}(1,2),prediction_cell{i}(3,2)]=swap(prediction_cell{i}(1,2),prediction_cell{i}(3,2));
    end
        
        
end


for i=1:length(truth_cell)
    %     if ~isempty(prediction_cell{i})
    e_tipl_x(i)=prediction_cell{i}(1,1)-truth_cell{i}(1,1);
    e_tipl_y(i)=prediction_cell{i}(1,2)-truth_cell{i}(1,2);
    e_tipv_x(i)=prediction_cell{i}(2,1)-truth_cell{i}(2,1);
    e_tipv_y(i)=prediction_cell{i}(2,2)-truth_cell{i}(2,2);
    e_tipr_x(i)=prediction_cell{i}(3,1)-truth_cell{i}(3,1);
    e_tipr_y(i)=prediction_cell{i}(3,2)-truth_cell{i}(3,2);
    e_angle(i)=abs(prediction_table{i,8}-truth_table{i,8});
end
%%
scalebar=101/70;  %pix/nm
close all
point_name='Tip A';
errorplot_style_YW(e_tipl_x./scalebar,e_tipl_y./scalebar,point_name)
point_name='Tip B';
errorplot_style_YW(e_tipr_x./scalebar,e_tipr_y./scalebar,point_name)
point_name='Vertex';
errorplot_style_YW(e_tipv_x./scalebar,e_tipv_y./scalebar,point_name)


mean(e_angle)






function [b, a] = swap(a, b)
end