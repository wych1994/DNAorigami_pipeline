%input all predicted particles
%output only true positive


clear all
close all
clc

%% read labeled pos
setDir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA';
gallery_name='nDFSB_R3_pred';

gallery_path=strcat(setDir,'\Gallery\',num2str(gallery_name),'.png');
I=imread(gallery_path);

ImageJ_Measurement_path=strcat(setDir,'\Gallery\',num2str(gallery_name),'_ImageJ.csv');
Pos=readmatrix(ImageJ_Measurement_path,'Range','C:D');
Pos=Pos(2:end,:);

%% determine labeled particle idx

gallery_w_num=8400/200;
gallery_h_num=8400/200;
C_idx=zeros(gallery_w_num*gallery_h_num,1);   %label catagory
for i=1:gallery_w_num
    for j=1:gallery_h_num

        A=find(Pos(:,1)>(i-1)*200&Pos(:,1)<i*200&Pos(:,2)>(j-1)*200&Pos(:,2)<j*200);
        if length(A)==3
            C_idx(gallery_w_num*(j-1)+i)=1;
        end
    end
end

%remove empty black image
C_idx(1742:end)=[];
P=length(C_idx);
TP=length(find(C_idx==1));
precision=TP/P;
%% load unfiltered_pred_img with each label of them
load("unfiltered_pred.mat")
% for i=1:length(particle_stock)
%     I=particle_stock{i};
%     Ire=imresize(I,[50,50]);
%     particle_stock{i}=Ire;
% end
C_idx_cell=cellstr(num2str(C_idx));
for i=1:1741
    if C_idx_cell{i}=='1'
        C_idx_cell{i}='good';
    else
        C_idx_cell{i}='bad';
    end
end
particle_stock_labeled=[particle_stock,C_idx_cell];


%% particle genaration
% for i=1:length(particle_stock_labeled)
%     I=particle_stock_labeled{i,1};
%     imwrite(I,strcat(setDir,'\Paricles_UniBKG_unfiltered\',num2str(i,'%09.f'),'.png'))
% end
%% binarize filter
prev=0;
if prev==1
    
    for pppp=1:1000
        imgidx=randperm(1741,16);
        figure(1)
        tiledlayout(4,4,'TileSpacing','compact','Padding','compact');
        for i=1:8

            I=particle_stock_labeled{imgidx(i),1};
            nexttile
            imshow(I)
            BW = imbinarize(I,'adaptive','Sensitivity',0.5);
            BW2 = bwareaopen(BW, 5);
            nexttile
            imshow(BW2)
            title(particle_stock_labeled{imgidx(i),2})
        end
        pause
        clf
    end
end

binarized_stock_labeled=cell(length(particle_stock_labeled),2);
for i=1:length(particle_stock_labeled)
    I=particle_stock_labeled{i,1};
    BW = imbinarize(I,'adaptive','Sensitivity',0.5);
    BW2 = bwareaopen(BW, 5);
    binarized_stock_labeled{i,1}=BW2;
    binarized_stock_labeled{i,2}=particle_stock_labeled{i,2};
%     binarized_stock_array(i)=binarized_stock_labeled{i,2};
end
% figure
% histogram(binarized_stock_array(find(C_idx==0)))
% figure
% histogram(binarized_stock_array(find(C_idx==1)))
%% ML


MLCLASS(C_idx,binarized_stock_labeled)
%% play ground fft?
% figure
% tiledlayout(1,2,'TileSpacing','none','Padding','compact');
% for i=1:100
% imdata=particle_stock_labeled{i,1};
% nexttile
% imshow(imdata)
% title(num2str(particle_stock_labeled{i,2}))
% F = fft2(imdata);
% % Fourier transform of an image
% S = abs(F);
% %get the centered spectrum
% Fsh = fftshift(F);
% %apply log transform
% S2 = log(1+abs(Fsh));
% nexttile
% imshow(S2,[])
% title(num2str(particle_stock_labeled{i,2}))
% pause(1)
% clf
% end



