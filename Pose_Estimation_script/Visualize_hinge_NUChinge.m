close all
clear all
clc
color_cell={[0.5 0.1 0.1],[0.5 1 0.5],[0.1 0.1 0.5], 'c', 'm', 'k','y','w'};
exp_name='Hinge';
root_dir='D:\OneDrive - The Ohio State University'
% root_dir='C:\OneDrive\OneDrive - The Ohio State University';
if strcmp(exp_name,'NUC')
    dir=strcat(root_dir,'\IMGDATA\Code\Pose_Estimation_script\Data\');
    truth_table=readtable(strcat(dir,'GT\NUC_GT_nDFSA.csv'));
    prediction_table=readtable(strcat(dir,'Prediction\NUC_prediction_nDFSA.csv'));
    imds=imageDatastore('C:\SimMetaD\posev2\Dataset_NUC\Cutted_nDFSA');
elseif strcmp(exp_name,'Hinge')
    dir=strcat(root_dir,'\IMGDATA\Code\Pose_Estimation_script\Data\');
    truth_table=readtable(strcat(dir,'GT\nDFSB1000test_YWlabled.csv'));
    prediction_table=readtable(strcat(dir,'Prediction\test_012model.csv'));
%     imds=imageDatastore('C:\SimMetaD\posev2\Dataset_mega\testset_nDFSB_R3');
end

truth_cell=cell(height(truth_table),1);
prediction_cell=cell(height(prediction_table),1);
prediction_conf_cell=cell(height(prediction_table),1);

for i=1:length(prediction_cell)
    if strcmp(exp_name,'NUC')
        truth_cell{i}=[truth_table{i,4},truth_table{i,5};...
            truth_table{i,6},truth_table{i,7};...
            truth_table{i,8},truth_table{i,9};...
            truth_table{i,10},truth_table{i,11}];
        %         prediction_cell{i}=[prediction_table{i,4},prediction_table{i,5};...
        %             prediction_table{i,7},prediction_table{i,8};...
        %             prediction_table{i,10},prediction_table{i,11};...
        %             prediction_table{i,13},prediction_table{i,14};...
        %             ];
        prediction_cell{i}=[prediction_table{i,2},prediction_table{i,3};...
            prediction_table{i,5},prediction_table{i,6};...
            prediction_table{i,8},prediction_table{i,9};...
            prediction_table{i,11},prediction_table{i,12};...
            ];
    elseif strcmp(exp_name,'Hinge')
        truth_cell{i}=[truth_table{i,2},truth_table{i,3};...
            truth_table{i,4},truth_table{i,5};...
            truth_table{i,6},truth_table{i,7}];
        prediction_cell{i}=[prediction_table{i,2},prediction_table{i,3};...
            prediction_table{i,5},prediction_table{i,6};...
            prediction_table{i,8},prediction_table{i,9}];
        prediction_conf_cell{i}=prediction_table{i,4};
        %     prediction_cell{i}=[prediction_table{i,4},prediction_table{i,5};...
        %         prediction_table{i,7},prediction_table{i,8};...
        %         prediction_table{i,10},prediction_table{i,11}];
    end
end
p_stock_nolabel=cell(16,1);
filter_NUCtest=0;
overlap_filter=0;
conf_filter=1;
if overlap_filter==1      %two tips may overlap in prediction
    load("test1000_outlier_idx.mat");
    truth_cell=truth_cell(~outlier_idx);
    prediction_cell=prediction_cell(~outlier_idx);
    prediction_cell(260)=[];
    truth_cell(260)=[];
end
if conf_filter==1
    conf_array=cell2mat(prediction_conf_cell);
    outlier_idx=conf_array<0.92;
    truth_cell=truth_cell(~outlier_idx);
    prediction_cell=prediction_cell(~outlier_idx);
    
end
if filter_NUCtest==1
    test_idx=[10    40    48    71    88    89   118   173   193   194   196   212   243   252   278   293   310
        ];
    truth_cell=truth_cell(test_idx);
    prediction_cell=prediction_cell(test_idx);
end

for i=1:length(truth_cell)
    %     if ~isempty(prediction_cell{i})
    e_tipl_x(i)=prediction_cell{i}(1,1)-truth_cell{i}(1,1);
    e_tipl_y(i)=prediction_cell{i}(1,2)-truth_cell{i}(1,2);
    e_tipv_x(i)=prediction_cell{i}(2,1)-truth_cell{i}(2,1);
    e_tipv_y(i)=prediction_cell{i}(2,2)-truth_cell{i}(2,2);
    e_tipr_x(i)=prediction_cell{i}(3,1)-truth_cell{i}(3,1);
    e_tipr_y(i)=prediction_cell{i}(3,2)-truth_cell{i}(3,2);
    if strcmp(exp_name,'NUC')
        e_NUC_x(i)=prediction_cell{i}(4,1)-truth_cell{i}(4,1);
        e_NUC_y(i)=prediction_cell{i}(4,2)-truth_cell{i}(4,2);
    end
    %     e_tipC_x(i)=prediction_cell{i}(4,1)-truth_cell{i}(4,1);
    %     e_tipC_y(i)=prediction_cell{i}(4,2)-truth_cell{i}(4,2);
    %     end
    %     e_tipl(i)=sqrt(()^2+()^2);
    %     e_tipr(i)=sqrt((prediction_cell{i}(2,1)-truth_cell{i}(2,1))^2+(prediction_cell{i}(2,2)-truth_cell{i}(2,2))^2);
    %     e_vertex(i)=sqrt((prediction_cell{i}(3,1)-truth_cell{i}(3,1))^2+(prediction_cell{i}(3,2)-truth_cell{i}(3,2))^2);
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
if strcmp(exp_name,'NUC')
    point_name='Nucleosome';
    errorplot_style_YW(e_NUC_x./scalebar,e_NUC_y./scalebar,point_name)
end

% std_tipl=std2([e_tipl_x./scalebar,e_tipl_y./scalebar])
std_tipl_v=std2([e_tipv_x./scalebar,e_tipv_y./scalebar]);

% name='Tip L';
% errorplot_style_YW(e_tipl_x./scalebar,e_tipl_y./scalebar,name)
% name='Vertex L';
% errorplot_style_YW(e_tipr_x./scalebar,e_tipr_y./scalebar,name)
% name='Vertex R';
% errorplot_style_YW(e_tipv_x./scalebar,e_tipv_y./scalebar,name)
% name='Tip R';
% errorplot_style_YW(e_tipC_x./scalebar,e_tipC_y./scalebar,name)

%% prepare labeled hinge images and combine into montage
sw=0;
if sw==1
    f=figure;
    A=1:1:1000;
    A_f=A(~outlier_idx);
    for i=1:16
        
        % for i=1:1
        I=readimage(imds,A_f(i));
        p_stock_nolabel{i}=I;
        %     I=imadjust(I,[0.3 0.7]);
        imshow(I)
        hold on
        for p=1:3
            plot(truth_cell{i}(p,1),truth_cell{i}(p,2),'x','MarkerSize',30,'LineWidth',1,'Color',color_cell{p})
            hold on
            plot(prediction_cell{i}(p,1),prediction_cell{i}(p,2),'.','MarkerSize',30,'Color',color_cell{p})
            hold on
        end
        %         plot(prediction_cell{i}(1:3,1),prediction_cell{i}(1:3,2),'--k','LineWidth',2)
        %     pause
        exportgraphics(gcf,strcat('Data\HingePoseImgResult_both\',num2str(i,'%09.f'),'.png'),'Resolution',300)
        clf
    end
    
    p_ds=imageDatastore('C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\Code\Angle_scr\Data\HingePoseImgResult_both');
    p_stock=cell(16,1);
    for i=1:length(p_ds.Files)
        I=readimage(p_ds,i);
        I=imcrop(I,[10,10,490,490]);
        p_stock{i}=I;
    end
    out = imtile(p_stock,'ThumbnailSize',[200,200],'GridSize',[2,8]);
    out2 = imtile(p_stock_nolabel,'ThumbnailSize',[200,200]);
    figure
    imshow(out)
    figure
    imshow(out2)
end



%% prepare NUC image and combine
sw=0;
if sw==1
    f=figure;
    A=1:1:321;
    %     A_f=test_idx;
    A_f=1:79;
    c=0;
    %     A_f=A(~outlier_idx)
    for i=A_f
        c=c+1;
        % for i=1:1
        I=readimage(imds,i);
        p_stock_nolabel{c}=I;
        %     I=imadjust(I,[0.3 0.7]);
        imshow(I)
        hold on
        for p=1:4
            plot(truth_cell{c}(p,1),truth_cell{c}(p,2),'x','MarkerSize',30,'LineWidth',1,'Color',color_cell{p})
            hold on
            plot(prediction_cell{c}(p,1),prediction_cell{c}(p,2),'.','MarkerSize',30,'Color',color_cell{p})
            hold on
        end
        %         plot(prediction_cell{i}(1:3,1),prediction_cell{i}(1:3,2),'--k','LineWidth',2)
        %     pause
        exportgraphics(gcf,strcat('Data\NUCPoseImgResult_both\',num2str(i,'%09.f'),'.png'),'Resolution',300)
        clf
    end
    
    p_ds=imageDatastore('C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\Code\Angle_scr\Data\NUCPoseImgResult_both');
    p_stock=cell(16,1);
    for i=1:length(p_ds.Files)
        I=readimage(p_ds,i);
        I=imcrop(I,[10,10,490,490]);
        p_stock{i}=I;
    end
    out = imtile(p_stock,'ThumbnailSize',[200,200],'GridSize',[2,8]);
    out2 = imtile(p_stock_nolabel,'ThumbnailSize',[200,200],'GridSize',[2,8]);
    figure
    imshow(out)
    figure
    imshow(out2)
end



%% mean error cal

% sqrt((mean(abs(e_NUC_x./scalebar)))^2+(mean(abs(e_NUC_y./scalebar)))^2)



% point_name='Tip B';
% errorplot_style_YW(e_tipr_x./scalebar,e_tipr_y./scalebar,point_name)
% point_name='Vertex';
% errorplot_style_YW(e_tipv_x./scalebar,e_tipv_y./scalebar,point_name)

