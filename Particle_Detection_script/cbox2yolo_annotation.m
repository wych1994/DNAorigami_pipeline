% transfer cbox info into yolo version
%1 class
%2 x_center/imgsize
%3 y_center/imgsize
%4 width/imgsize
%5 height/imgsize


clear all
close all
clc
%%
% 
% boxname_stock={'1','10','11','12','13','14','15','38','39','40'};
% boxname_stock={'2','3','4','5','6','7','8','9','16','17','18','19','20','21','22','23','24',...
%     '25','26','27','28','29','30','31','32','33','34','35','36','37'};
boxname_stock={'41','42','43','44','45','46','47','48','49','50'};
% boxname='1';
% ds=dir('C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\nDFS_Dataset\ADD\test_annot\CBOX');
% ds.
for boxidx=1:length(boxname_stock)
% for boxidx=1:31
    boxname=boxname_stock{boxidx};
%     boxname=ds(boxidx+2).name;
%     boxname=boxname(1:end-5);
    warning off
    root_dir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\';
%     annotation_dir=strcat(root_dir,'nDFS_Dataset\ADD\R3_annotation_N=200\CBOX\');
    annotation_dir=strcat(root_dir,'nDFS_Dataset\Raw\nDFSB_R3\v2\valid_annot\CBOX\');
    at_fullname=strcat(annotation_dir,boxname,'.cbox');


    opts = delimitedTextImportOptions("NumVariables", 11);
    opts.DataLines = [1, Inf];
    opts.Delimiter = " ";
    opts.VariableNames = ["x", "y", "z", "width", "height", "depth", "EstWidth", "EstHeight", "Conf", "#Box", "Angle"];
    opts.VariableTypes = ["string", "double", "categorical", "double", "double", "double", "categorical", "categorical", "double", "double", "categorical"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.LeadingDelimitersRule = "ignore";

    at_cbox=readtable(at_fullname,opts);

    at_data=table2cell(at_cbox(20:end-5,:));

    at_data_matrix=parsecbox(at_data);
    at_data_matrix=at_data_matrix./848.*960;
    imgsize=960;
    boxsize=50;
% x_c=x_c/848*960;
% y_c=y_c/848*960;
%     x_c=at_data_matrix(:,1)/848*960+boxsize/2;
%     y_c=at_data_matrix(:,2)/848*960+boxsize/2;
    x_c=at_data_matrix(:,1)+boxsize/2;
    y_c=at_data_matrix(:,2)+boxsize/2;
    % x_c=at_data_matrix(:,1);
    % y_c=at_data_matrix(:,2);
    img_path=strcat(root_dir,'nDFS_Dataset\Raw\nDFSB_R3');
    I=imread(strcat(img_path,'\',boxname,'.tif'));
    I=imresize(I,[960,960]);
%     figure
%     imshow(I)
%     hold on
%     % plot(at_data_matrix(:,1),960-at_data_matrix(:,2),'x')
%     
% %     for i=1:size(at_data_matrix,1)
%         plot(x_c,imgsize-y_c,'o')
% %          hold on
% %     end
%     pause



    %% write into yolo txt files
%     imgsize=848;
    sw=1;
    if sw==1

        class_idx=0;
        x_c=x_c./imgsize;
        y_c=y_c./imgsize;
        %     y_c=y_c;
        w=boxsize/imgsize;
        h=boxsize/imgsize;
        %     tar_dir=strcat(root_dir,'\ADD\R3_annotation_N=200\yolobox\');
        tar_dir=strcat('C:\SimMetaD\yoloproject\datasets\Hinge_TEM_v2\labels\valid10\');
        yolobox_name=strcat(tar_dir,boxname,'.txt');
        fileID = fopen(yolobox_name,'w');


        for i=1:length(x_c)
            x_c_val=x_c(i);
            y_c_val=(1-y_c(i));
            fprintf(fileID,num2str(class_idx));
            %         fprintf(fileID,' ');
            fprintf(fileID,' %1.5f',x_c_val);
            fprintf(fileID,' %1.5f',y_c_val);
            fprintf(fileID,' %1.5f',w);
            fprintf(fileID,' %1.5f\n',h);

        end
        fclose(fileID);
    end




end


