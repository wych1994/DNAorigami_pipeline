clear all
close all
clc

YW_sample=readmatrix("data/nDFS_test_YWangle1036.csv");
YOLO_sample=readmatrix("data/nDFS_test_YOLOangle1151.csv");

YW_angle=YW_sample(:,6);
YOLO_angle=YOLO_sample(:,6);

figure
NUCPLOT2(YW_angle,YOLO_angle)

legend('Sampling from Experiment','Sampling from YOLOv5n')



