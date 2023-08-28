%input ImageJ roiset
%output ImageJ *csv

clear all
close all
clc


Gallery_name='nDFSC5_g4';
% Dir='D:\OneDrive - The Ohio State University\IMGDATA\External_Dataset\Osillator_Dataset';
Dir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\Dataset\Xin_Annotation';

x=[];
y=[];
A= ReadImageJROI(strcat(Dir,'\',Gallery_name,'_RoiSet_Xin.zip'));
for i=1:length(A)
x=[x;A{1, i}.mnCoordinates(:,1)];
y=[y;A{1, i}.mnCoordinates(:,2)];
end

%vis check
sw=1;
if sw==1
I=imread(strcat(Dir,'\',Gallery_name,'.png'));
figure
imshow(I)
hold on
plot(x,y,'b.','MarkerSize',20)
hold on
plot(x,y,'r--','LineWidth',1)
end

Data=cell(length(x),4);
for i=1:length(x)
    Data{i,1}=i;
    Data{i,3}=x(i);
    Data{i,4}=y(i);
end

T = cell2table(Data,  'VariableNames',{'Idx' 'Area' 'X' 'Y'});
% cvsname=strcat('..\..\Gallery\',Gallery_name,'_ImageJ.csv');
cvsname=strcat(Gallery_name,'_ImageJ_Xin.csv');
writetable(T,cvsname);