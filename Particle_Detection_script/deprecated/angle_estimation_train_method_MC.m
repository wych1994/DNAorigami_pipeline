% multi-class training for hinge angle

clear all
close all
clc

%% load dataset
imgsize=201;
angleinterval=30;
pred_angle_range=20:angleinterval:120;

dir='C:\OneDrive\OneDrive - The Ohio State University\IMGDATA\';

pose_table=readtable(strcat(dir,'Particles_annotation\nDFSB_R3_pred_Pose.csv'));
raw_angle=table2array(pose_table(:,8));
angleds=round( raw_angle / angleinterval ) * angleinterval;

imds=imageDatastore(strcat(dir,'Particles_UniBKG'));
imds.Labels= categorical(cellstr(num2str(angleds)));


% auimds = augmentedImageDatastore([50,50,1],imds);
%% resize imgs
% for i=1:length(imds.Files)
% I= readimage(imds,i);
% Ire=imresize(I,[227,227]);
% Ire(:,:,2)=Ire(:,:,1);
% Ire(:,:,3)=Ire(:,:,1);
% imwrite(Ire,imds.Files{i});
% end



%% split data
[train_ds,valid_ds,test_ds]=splitEachLabel(imds,0.8,0.1,'randomized');

% train_ds_aug=augmentedImageDatastore([200,200],train_ds);
% valid_ds_aug=augmentedImageDatastore([200,200],valid_ds);
%% preview training dataset
sw=0;
if sw==1
    figure
    numImages = length(train_ds.Files);
    perm = randperm(numImages,20);
    for i = 1:20
        subplot(4,5,i);
        imshow(train_ds.Files{perm(i)});
        title(train_ds.Labels{perm(i)})
        drawnow;
    end
end
%% modify layers
numClasses = numel(categories(imds.Labels));
net=alexnet;     


layers=net.Layers;
% layers(1) = imageInputLayer([200,200,1]);
layers(end-2)=fullyConnectedLayer(numClasses);
layers(end) = classificationLayer;

options = trainingOptions('adam', ...
    'MaxEpochs',200,...
    'InitialLearnRate',1e-2, ...
    'plots','training-progress',...
    'ValidationData',valid_ds);

net = trainNetwork(train_ds,layers,options);

YPred = classify(net,test_ds);
YTest = test_ds.Labels;

accuracy = sum(YPred == YTest)/numel(YTest)
confusionchart(YTest,YPred )



