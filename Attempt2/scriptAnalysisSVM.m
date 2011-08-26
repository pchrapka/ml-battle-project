%% Script to analyze data generated by the SVM classifier

close all;

%% Load the data

data1 = load('C:\Users\Phil\Documents\School\Masters\ECE 739 - Neural Networks\Project\SVM\BatchSimulation_20110804_091422\svm_simulation_20110804_00001.mat');
data2 = load('C:\Users\Phil\Documents\School\Masters\ECE 739 - Neural Networks\Project\SVM\BatchSimulation_20110824_200440\svm_simulation_20110825_00001.mat');
data3 = load('C:\Users\Phil\Documents\School\Masters\ECE 739 - Neural Networks\Project\SVM\BatchSimulation_20110804_091422\svm_simulation_20110806_00003.mat');

%% Plot all three performance metrics

xAxis = 1:data1.simObj.NumEpochs;
plot(...
    xAxis,100*(1-data1.simObj.Performance),...
    xAxis,100*(1-data2.simObj.Performance),...
    xAxis,100*(1-data3.simObj.Performance));
legend(...
    ['C = ' num2str(data1.simObj.BoxConstraint)],...
    ['C = ' num2str(data2.simObj.BoxConstraint)],...
    ['C = ' num2str(data3.simObj.BoxConstraint)]);

ylim([0 20]);
title('SVM Performance');
ylabel('Error Rate (%)');
xlabel('Epochs');

%% Get final performance and figures

data1.simObj.PlotPerformance = true;
data1.simObj.NumTestPoints = 1000;
perf1 = getPerformanceSVM(data1.simObj);

data2.simObj.PlotPerformance = true;
data2.simObj.NumTestPoints = 1000;
perf2 = getPerformanceSVM(data2.simObj);

data3.simObj.PlotPerformance = true;
data3.simObj.NumTestPoints = 1000;
perf3 = getPerformanceSVM(data3.simObj);
    