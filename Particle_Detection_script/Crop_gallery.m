clear all
close all
clc

% dir='C:\OneDrive\OneDrive - The Ohio State University\DNAorigami\Wolfgang\recycle\Refolding\Refold_nDFSC35\';
% dir='C:\OneDrive\OneDrive - The Ohio State University\TEM\SteriDyn_sup\';
dir='C:\OneDrive\OneDrive - The Ohio State University\TEM\Hinge_Control\'
filename='nDFSC35_X_v3';
last_raw_num=8;
fullname=strcat(dir,filename,'.tif');
% givenname='set4'

I=imread(fullname);
[img_sizex,img_sizey]=size(I);
particle_size=200;
n_row=img_sizex/200;
n_col=img_sizey/200;
%%
if floor(n_row)~=n_row || floor(n_col)~=n_col
    error('Particle number has to be integer, check again!')
end
foldername=strcat('particle-',filename);
mkdir(foldername)
ymin=0;
width=particle_size;
height=particle_size;
for i=1:n_row-1
    xmin=0;
    for j=1:n_col       
        I_crop=imcrop(I,[xmin ymin width height]);
        particle_name=strcat(foldername,'\',filename,'-',num2str(i,'%09.f'),'-',num2str(j,'%09.f'),'.png');
        imwrite(I_crop,particle_name);
        xmin=xmin+particle_size;
    end
    ymin=ymin+particle_size;
end
for i=n_row
xmin=0;
    for j=1:last_raw_num       
        I_crop=imcrop(I,[xmin ymin width height]);
        particle_name=strcat(foldername,'\',filename,'-',num2str(i,'%09.f'),'-',num2str(j,'%09.f'),'.png');
        imwrite(I_crop,particle_name);
        xmin=xmin+particle_size;
    end
    ymin=ymin+particle_size;
end   
    
    
    
    
    
    
    
    
    