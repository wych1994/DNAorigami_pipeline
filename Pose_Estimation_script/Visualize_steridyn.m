close all
clear all
clc
color_cell={[0.5 0.1 0.1],[0.5 1 0.5],[0.1 0.1 0.5], 'c', 'm', 'k','y','w'};
exp_name='SteriDyn';
if exp_name=='SteriDyn'
    dir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\Code\Angle_scr\Data\';
    truth_table=readtable(strcat(dir,'GT\SteriDyn_YW.csv'));
    prediction_table=readtable(strcat(dir,'Prediction\DLC_resnet50_TEM_SteriDynOct30shuffle1_40000-snapshot-40000.csv'));
    imds=imageDatastore('C:\SimMetaD\posev2\Dataset_SteriDyn\labeled-data\m4s1');
end

truth_cell=cell(height(truth_table),1);
prediction_cell=cell(height(prediction_table),1);
prediction_conf_cell=cell(height(prediction_table),1);

for i=1:length(prediction_cell)
    if exp_name=='SteriDyn'
        truth_cell{i}=[truth_table{i,4},truth_table{i,5};...
            truth_table{i,6},truth_table{i,7};...
            truth_table{i,8},truth_table{i,9};...
            truth_table{i,10},truth_table{i,11}];
        prediction_cell{i}=[prediction_table{i,4},prediction_table{i,5};...
            prediction_table{i,7},prediction_table{i,8};...
            prediction_table{i,10},prediction_table{i,11};...
            prediction_table{i,13},prediction_table{i,14};...
            ];
    end

end
p_stock_nolabel=cell(16,1);
filter_testset=1;
% overlap_filter=0;
% conf_filter=0;
% if overlap_filter==1      %two tips may overlap in predication
%     load("test1000_outlier_idx.mat");
%     truth_cell=truth_cell(~outlier_idx);
%     prediction_cell=prediction_cell(~outlier_idx);
%     prediction_cell(260)=[];
%     truth_cell(260)=[];
% end
% if conf_filter==1
%     conf_array=cell2mat(prediction_conf_cell);
%     outlier_idx=conf_array<0.92;
%     truth_cell=truth_cell(~outlier_idx);
%     prediction_cell=prediction_cell(~outlier_idx);
% 
% end
if filter_testset==1
    Training_index=readmatrix("Data\SteriDyn_test_results\training_indices_SteriDyn.csv");
    Total_index=transpose(0:4469-1);
    test_idx=setdiff(Total_index,Training_index)+1;
%     test_idx=[10    40    48    71    88    89   118   173   193   194   196   212   243   252   278   293   310
%         ];
    truth_cell=truth_cell(test_idx);
    prediction_cell=prediction_cell(test_idx);
end

for i=1:length(truth_cell)
    %     if ~isempty(prediction_cell{i})
    e_tipl_x(i)=prediction_cell{i}(1,1)-truth_cell{i}(1,1);
    e_tipl_y(i)=prediction_cell{i}(1,2)-truth_cell{i}(1,2);
    e_vertexl_x(i)=prediction_cell{i}(2,1)-truth_cell{i}(2,1);
    e_vertexl_y(i)=prediction_cell{i}(2,2)-truth_cell{i}(2,2);
    e_vertexr_x(i)=prediction_cell{i}(3,1)-truth_cell{i}(3,1);
    e_vertexr_y(i)=prediction_cell{i}(3,2)-truth_cell{i}(3,2);
    e_tipr_x(i)=prediction_cell{i}(4,1)-truth_cell{i}(4,1);
    e_tipr_y(i)=prediction_cell{i}(4,2)-truth_cell{i}(4,2);
    %     e_tipC_x(i)=prediction_cell{i}(4,1)-truth_cell{i}(4,1);
    %     e_tipC_y(i)=prediction_cell{i}(4,2)-truth_cell{i}(4,2);
    %     end
    %     e_tipl(i)=sqrt(()^2+()^2);
    %     e_tipr(i)=sqrt((prediction_cell{i}(2,1)-truth_cell{i}(2,1))^2+(prediction_cell{i}(2,2)-truth_cell{i}(2,2))^2);
    %     e_vertex(i)=sqrt((prediction_cell{i}(3,1)-truth_cell{i}(3,1))^2+(prediction_cell{i}(3,2)-truth_cell{i}(3,2))^2);
end
%%
scalebar=83.6454/57;  %pix/nm
close all
point_name='Tip L';
errorplot_style_YW(e_tipl_x./scalebar,e_tipl_y./scalebar,point_name)
point_name='Vertex L';
errorplot_style_YW(e_vertexl_x./scalebar,e_vertexl_y./scalebar,point_name)
point_name='Vertex R';
errorplot_style_YW(e_vertexr_x./scalebar,e_vertexr_y./scalebar,point_name)
point_name='Tip R';
errorplot_style_YW(e_tipr_x./scalebar,e_tipr_y./scalebar,point_name)

% std_tipl=std2([e_tipl_x./scalebar,e_tipl_y./scalebar])
% std_tipl_v=std2([e_tipv_x./scalebar,e_tipv_y./scalebar]);

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
    A=test_idx;
    for i=1:16

        I=readimage(imds,A(i));
        p_stock_nolabel{i}=I;
        %     I=imadjust(I,[0.3 0.7]);
        imshow(I)
        hold on
        for p=1:4
            plot(truth_cell{i}(p,1),truth_cell{i}(p,2),'x','MarkerSize',30,'LineWidth',1,'Color',color_cell{p})
            hold on
            plot(prediction_cell{i}(p,1),prediction_cell{i}(p,2),'.','MarkerSize',30,'Color',color_cell{p})
            hold on
        end
        %         plot(prediction_cell{i}(1:3,1),prediction_cell{i}(1:3,2),'--k','LineWidth',2)
        %     pause
        exportgraphics(gcf,strcat('Data\SteriDyn_test_results\','labeled',num2str(i,'%09.f'),'.png'),'Resolution',300)
        clf
    end

    p_ds=imageDatastore('Data\SteriDyn_test_results');
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
%% 
idx_x=abs(e_tipr_x)<100;
idx_y=abs(e_tipr_y)<100;
idx=and(idx_x,idx_y);
e_tipr_x_corrected=e_tipr_x(idx);
e_tipr_y_corrected=e_tipr_y(idx);

sqrt((mean(abs(e_tipl_x./scalebar)))^2+(mean(abs(e_tipl_y./scalebar)))^2)
sqrt((mean(abs(e_tipr_x_corrected./scalebar)))^2+(mean(abs(e_tipr_y_corrected./scalebar)))^2)
sqrt((mean(abs(e_vertexl_x./scalebar)))^2+(mean(abs(e_vertexl_y./scalebar)))^2)
sqrt((mean(abs(e_vertexr_x./scalebar)))^2+(mean(abs(e_vertexr_y./scalebar)))^2)

