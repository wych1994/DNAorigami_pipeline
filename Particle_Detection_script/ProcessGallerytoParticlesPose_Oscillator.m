%input ImageJ *csv, gallery *.png
%output Pose dataset .csv

clear all
close all
clc
%% read data
% setDir='D:\OneDrive - The Ohio State University\IMGDATA\External_Dataset\Oscillator_Dataset\';
setDir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\External_Dataset\Oscillator_Dataset\';

gallery_name='7bpmontage';

gallery_path=strcat(setDir,num2str(gallery_name),'.tif');
I=imread(gallery_path);
I=I(:,:,1);
% test_name='nDFSBmononuc1';
ImageJ_Measurement_path=strcat(setDir,num2str(gallery_name),'_ImageJ.csv');
Pos=readmatrix(ImageJ_Measurement_path,'Range','C:D');
Pos=Pos(2:end,:);

crop_gallery=0;    % only if it is =1, then generate crop gallery
%% annotation trace for double check
sw=0;
if sw==1
    figure
    imshow(I)
    hold on
    plot(Pos(:,1),Pos(:,2),'r.','MarkerSize',5)
    pause
   
%     hold on
%     plot(Pos(:,1),Pos(:,2),'r--','LineWidth',0.1)
end

%% Transfer ImageJ measure into Pose annotation and Particles

n_particle=length(Pos)/9;
[img_sizeY,img_sizeX]=size(I);
particle_size=120;
n_X=img_sizeX/particle_size;
n_Y=img_sizeY/particle_size;

posedata=cell(n_particle,18);

%find local coordinates for each particles
for i=1:n_particle
    
    x_global=Pos(i*9-8:i*9,1);
    y_global=Pos(i*9-8:i*9,2);
   
    
    x1_local=x_global(1);
    y1_local=y_global(1);
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
    
    
    x_local=x_global-(xidx-1)*particle_size;
    y_local=y_global-(yidx-1)*particle_size;
    

    x_local=x_local/particle_size*200;
    y_local=y_local/particle_size*200;

    % crop particles and save them
    J=imcrop(I,[(xidx-1)*particle_size,(yidx-1)*particle_size,particle_size,particle_size]);   
%         check local coordinates
%     figure(2)
%     imshow(J)
%     hold on
%     plot(x_local,y_local,'b.','MarkerSize',5)
%     pause

    img_name=strcat(gallery_name,'_',num2str(i,'%09.f'),'.png');
    J=imresize(J,[200,200]);
    if crop_gallery==1
%     imwrite(J,strcat(setDir,'\Particles_UniBKG\',img_name));
    imwrite(J,strcat(setDir,'\Particles\',img_name));
    end

    %pose annotation data for each particels
    posedata{i,1}=strcat(gallery_name,'_',num2str(i,'%09.f'),'.png');
    for k=1:9
    posedata{i,2*k}=x_local(k);
    posedata{i,2*k+1}=y_local(k);
    end


    
end

 %% save pose annotation data
 T = cell2table(posedata,...
    "VariableNames",["Image_indices" "p1x" "p1y" "p2x" "p2y" "p3x" "p3y" ...
    "p4x" "p4y" "p5x" "p5y" "p6x" "p6y" ...
    "p7x" "p7y" "p8x" "p8y" "p9x" "p9y" ]);
 writetable(T,strcat(setDir,'\Annotation\',num2str(gallery_name),'_Pose.csv'));




