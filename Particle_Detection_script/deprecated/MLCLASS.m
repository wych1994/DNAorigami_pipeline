%% ML ...as bad as random guess

function MLCLASS(C_idx,particle_stock_labeled)

%augmentation
badhinge_idx_stock=find(C_idx==0);
aug_particle_stock_labeled={};
for i=1:length(badhinge_idx_stock)
    bad_idx=badhinge_idx_stock(i);
    I=particle_stock_labeled{bad_idx,1};
    I_aug1=imrotate(I,90);
    I_aug2=imrotate(I,180);
    I_aug3=imrotate(I,270);
    aug_particle_stock_labeled=[aug_particle_stock_labeled;[{I_aug1},{'bad'}];[{I_aug2},{'bad'}];[{I_aug3},{'bad'}]];
end


aug_particle_stock_labeled=[particle_stock_labeled; aug_particle_stock_labeled];


P = randperm(length(aug_particle_stock_labeled));
aug_particle_stock_labeled_shuffled= aug_particle_stock_labeled(P,:);

aug_label=categorical(aug_particle_stock_labeled_shuffled(:,2));



%reformate dataset
DataSet=zeros(50,50,1,length(aug_particle_stock_labeled_shuffled));
num_imgs=size(DataSet,4);
for i=1:num_imgs
    DataSet(:,:,1,i)=aug_particle_stock_labeled_shuffled{i,1};
end
%split data into train,valid,and test
cv1 = cvpartition(num_imgs,'HoldOut',0.2);
test_idx = cv1.test;
cv2 = cvpartition(cv1.TrainSize,'HoldOut',0.33);
val_idx= cv2.test;

TrainwVSet = DataSet(:,:,1,~test_idx);
TestSet  = DataSet(:,:,1,test_idx);

TrainSet = TrainwVSet(:,:,1,~val_idx);
ValidSet  = TrainwVSet(:,:,1,val_idx);


DataSetLabel=aug_label;

TrainwVSetLabel=DataSetLabel(~test_idx);
TestSetLabel=DataSetLabel(test_idx);

TrainSetLabel=TrainwVSetLabel(~val_idx);
ValidSetLabel=TrainwVSetLabel(val_idx);


%network architechure
layers = [
    imageInputLayer([50 50 1])
	
    convolution2dLayer(3,16)
    batchNormalizationLayer
    reluLayer	
    maxPooling2dLayer(2,'Stride',2)
	dropoutLayer(0.5)
%     convolution2dLayer(3,64)
% %     batchNormalizationLayer
%     reluLayer
% 	
%     maxPooling2dLayer(2,'Stride',2)
	
%     convolution2dLayer(3,64,'Padding',1)
%     batchNormalizationLayer
%     reluLayer
    flattenLayer
	dropoutLayer(0.5)
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

miniBatchSize = 64;
options = trainingOptions( 'sgdm',...
    'MiniBatchSize', miniBatchSize,...
    'Plots', 'training-progress',...
    MaxEpochs=300,...
    ValidationData={ValidSet,ValidSetLabel});
net = trainNetwork(TrainSet, TrainSetLabel, layers, options);	



%test accuracy
predLabelsTest = net.classify(TestSet);
accuracy = sum(predLabelsTest == TestSetLabel) / numel(TestSetLabel)
confusionchart(TestSetLabel,predLabelsTest  )
end