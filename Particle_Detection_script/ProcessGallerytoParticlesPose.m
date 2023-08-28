%input ImageJ *csv, gallery *.png
%output Pose dataset .csv

clear all
close all
clc
%% read data
% setDir='D:\OneDrive - The Ohio State University\IMGDATA\nDFS_Dataset';
setDir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\Dataset\nDFS_Dataset';
% setDir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\External_Dataset\SteriDyn_Dataset';
gallery_name='nDFSC5_g4';

% gallery_path=strcat(setDir,'\Gallery\',num2str(gallery_name),'.png');
gallery_path=strcat(setDir,'\Gallery\',num2str(gallery_name),'.png');
I=imread(gallery_path);

ImageJ_Measurement_path=strcat(setDir,'\Gallery\',num2str(gallery_name),'_ImageJ_Xin.csv');
% ImageJ_Measurement_path=strcat(setDir,'\ImageJinfo\',num2str(gallery_name),'.csv');

Pos=readmatrix(ImageJ_Measurement_path,'Range','C:D');
Pos=Pos(2:end,:);

crop_gallery=0;    % only if it is =1, then generate crop gallery
%% annotation trace for double check
sw=1;
if sw==1
    figure
    imshow(I)
    hold on
    plot(Pos(:,1),Pos(:,2),'r.','MarkerSize',5)
    
%     hold on
%     plot(Pos(:,1),Pos(:,2),'r--','LineWidth',0.1)
end
%% Transfer ImageJ measure into Pose annotation and Particles

n_particle=length(Pos)/3;
[img_sizeY,img_sizeX]=size(I);
particle_size=200;
n_X=img_sizeX/particle_size;
n_Y=img_sizeY/particle_size;

posedata=cell(n_particle,7);

%find local coordinates for each particles
for i=1:n_particle
    
    x1_global=Pos(i*3-2,1);
    y1_global=Pos(i*3-2,2);
    xcross_global=Pos(i*3-1,1);
    ycross_global=Pos(i*3-1,2);
    x2_global=Pos(i*3,1);
    y2_global=Pos(i*3,2);
    
    x1_local=x1_global;
    y1_local=y1_global;
    for ix=1:n_X
        
        if x1_local>0 && x1_local<particle_size
            xidx=ix;
            break;
        end
        x1_local=x1_local-particle_size;
    end
    for iy=1:n_Y
        
        if y1_local>0 && y1_local<particle_size
            yidx=iy;
            break;
        end
        y1_local=y1_local-particle_size;
    end
    
    
    xcross_local=xcross_global-(xidx-1)*particle_size;
    ycross_local=ycross_global-(yidx-1)*particle_size;
    x2_local=x2_global-(xidx-1)*particle_size;
    y2_local=y2_global-(yidx-1)*particle_size;
    
    
    % crop particles and save them
    J=imcrop(I,[(xidx-1)*particle_size,(yidx-1)*particle_size,particle_size,particle_size]);   
%         check local coordinates
%     figure(2)
%     imshow(J)
%     hold on
%     plot(x1_local,y1_local,'b.','MarkerSize',5)
%     hold on
%     plot(x2_local,y2_local,'b.','MarkerSize',50)
%     hold on
%     plot(xcross_local,ycross_local,'b.','MarkerSize',5)
%     hold on
%     plot([x1_local,xcross_local,x2_local],[y1_local,ycross_local,y2_local],'b-')
%     pause
    img_name=strcat(gallery_name,'_',num2str(i,'%09.f'),'.png');
    J=imresize(J,[200,200]);
    if crop_gallery==1
%     imwrite(J,strcat(setDir,'\Particles_UniBKG\',img_name));
    imwrite(J,strcat(setDir,'\Particles\',img_name));
    end

    %pose annotation data for each particels
    posedata{i,1}=strcat(gallery_name,'_',num2str(i,'%09.f'),'.png');
    posedata{i,2}=x1_local;
    posedata{i,3}=y1_local;
    posedata{i,4}=xcross_local;
    posedata{i,5}=ycross_local;
    posedata{i,6}=x2_local;
    posedata{i,7}=y2_local;
    %add angle info
    l1=sqrt((x1_local-xcross_local)^2+(y1_local-ycross_local)^2);
    l2=sqrt((x2_local-xcross_local)^2+(y2_local-ycross_local)^2);
    l_strut=sqrt((x1_local-x2_local)^2+(y1_local-y2_local)^2);
    posedata{i,8}=acosd((l1^2+l2^2-l_strut^2)/(2*l1*l2));
    
end

 %% save pose annotation data
 T = cell2table(posedata,...
    "VariableNames",["Image_indices" "x1" "y1" "cross1" "cross2" "x2" "y2" "Angle"]);
 writetable(T,strcat(setDir,'\Image Particle Dataset_Annotated\',num2str(gallery_name),'_Pose_Xin.csv'));




