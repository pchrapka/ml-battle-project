%% Script for running a batch of tests using the EKF MLP
clear all;
clc;
close all;

%% Initialize the MLPConfig objects
% 2 hidden layers
config1 = MLPConfig();
config1.NumHiddenLayers = 2;
config1.NumHiddenNodes = [24 8];
config1.SimFunc = @simMLP2Layer;

%% Set all parameters to go through
parameters{1} = {'DesiredOutputValue',[10],'',0};
parameters{2} = {'q',[0.1 0.01 0.001],'',0};
parameters{3} = {'DoAnnealing',[true false],'',0};
parameters{4} = {'r',[10 100 200 500 700 900],'',0};
parameters{5} = {'MLPConfigObj',...
    [config1],'',0};
parameters{6} = {'p',[10 100 1000 10000],'',0};

%% Create a folder

saveFolder = 'C:\Users\Phil\Documents\School\Masters\ECE 739 - Neural Networks\Project\EKF MLP\';
dateString = datestr(now,'yyyymmdd_HHMMSS');
saveFolder = [saveFolder 'BatchSimulation_' dateString];
if(exist(saveFolder,'dir')~=7)
    mkdir(saveFolder);
end

%% Write the simulation script
counterIndex = 97;
fid = fopen('scriptGeneratedScript.m','w+');
fprintf(fid,'simNumber = 1;\n');
for i=1:length(parameters)
    fprintf(fid,'for %c=1:%d\n',...
        char(counterIndex),length(parameters{i}{2}));
    parameters{i}{3} = char(counterIndex);
    counterIndex = counterIndex + 1;
end
% Create a MLPSimulationConfig object
fprintf(fid,'%% Create a MLPSimulationConfig object\n');
fprintf(fid,'simObj = MLPSimulationConfig();\n');
% Initialize variables
fprintf(fid,'%% Initialize variables\n');
fprintf(fid,'simObj.NumEpochs = 500;\n');
fprintf(fid,'simObj.NumPointsPerEpoch = 200;\n');
fprintf(fid,'simObj.PlotPerf = false;\n');
%fprintf(fid,'simObj.p = 100;\n');
% Initialize the MLPSimulationConfig object
fprintf(fid,'%% Initialize the MLPSimulationConfig object\n');
fprintf(fid,'simObj = simObj.Init();\n');
% Write the meat of the script
fprintf(fid,'%% Initialize the simulation parameters\n');
fprintf(fid,'for A=1:length(parameters)\n');
fprintf(fid,'simObj.(parameters{A}{1}) = parameters{A}{2}(eval(parameters{A}{3}));\n');
fprintf(fid,'end\n');
fprintf(fid,'disp([''Simulation '' num2str(simNumber)]);\n');
fprintf(fid,'try\n');
fprintf(fid,'%% Run the simulation\n');
fprintf(fid,'simObj = runEKFMLPSimulation(simObj);\n');
fprintf(fid,'catch ex\n');
fprintf(fid,'%% Catch an exception if it occurs\n');
fprintf(fid,'disp(''Caught an exception'');\n');
fprintf(fid,'disp(ex);\n');
fprintf(fid,'simObj.Exception = ex;\n');
fprintf(fid,'end\n');
fprintf(fid,'%% Save the workspace variables\n');
fprintf(fid,'dateString = datestr(now,''yyyymmdd'');\n');
fprintf(fid,'fileName = [''mlpekf_simulation'' dateString ''_'' num2str(simNumber,''%%5.5d'')];\n');
fprintf(fid,'save([saveFolder filesep fileName],''simObj'');\n');
fprintf(fid,'simNumber = simNumber + 1;\n');
for i=1:length(parameters)
    fprintf(fid,'end\n');
end
fclose(fid);

%% Run the generated script
scriptGeneratedScript