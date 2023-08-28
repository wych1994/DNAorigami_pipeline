%maybe just use it one time
%deletle agg and artifact class

clear all
close all
clc

dir='C:\SimMetaD\yoloproject\datasets\2class_TEM\labels\valid';
ttds = tabularTextDatastore(dir);

for i=1:length(ttds.Files)
txt_dir=ttds.Files{i};
A=readmatrix(txt_dir);

idx_excls=find(A(:,1)==1|A(:,1)==2);
A(idx_excls,:)=[];
idx_cls3=find(A(:,1)==3);
A(idx_cls3,1)=1;
writematrix(A,txt_dir,'Delimiter',' ')
end


