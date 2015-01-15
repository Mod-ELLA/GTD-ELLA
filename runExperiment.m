%%
% Use of ELLA for Reinforcement Learning
% This function runs an experiment for reinforcement learning and stores
% the learnt parameters in a file fileName
% Input :
% fileName = name of the file where the learnt parameters have to be stored
% in. If not given it is stored in a file modelELLA.mat
%
%
% exp1 = It is just the expected error so that we can see that error is
% going down

%%
function [exp1,model] = runExperiment(task,ellaModelFile,d, lookUpTable)
close all;
clc;

%% Parse inputs

if exist('ellaModelFile','var')==0
    ellaModelFile = 'ellaModleFile.mat';
end

if exist('d','var')==0
    d = 10;
end

if exist('lookUpTable','var')==0
    lookUpTable{1}=-1;
end

%%
% Initialize the model for ELLA
model = initModelELLA(struct('k',1,...
    'd',d,...
    'mu',exp(-12),...
    'muRatio',Inf,...
    'lambda',exp(-16),...%exp(-10),...
    'ridgeTerm',exp(-16),...%,exp(-5),...
    'initializeWithFirstKTasks',true,...
    'lastFeatureIsABiasTerm',true,...
    'isRL',true));
%% Get the tasks
% Right now we have only mountain car RL tasks

count=1;
exp1={};
while true
    % A function which returns the current task can be calibrated for
    % different types of tasks
    if task{count}.t==-1
        break;
    end
    
    % Add the current task
    [model,exp1{count}] = addTaskELLA(model,task{count},lookUpTable);
    count = count + 1;
end
    save(ellaModelFile) %modelELLA.mat model task;
beep;
end
