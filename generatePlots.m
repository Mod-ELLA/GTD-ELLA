%% Script for generating plot where we start with GTD and where we start 
% with ELLA. 
%%
% Get the tasks and save them in a file
saveFile = 'mcEllaLearn.mat';
loadFile = 'tasks.mat';
nTrainEp = 10000;
nTrainEpInitState =10000;
lookUpTableFile = 'mcInitState.mat';
%%
count =1;
while true
    % A function which returns the current task can be calibrated for
    % different types of tasks
    task{count} =getTask( count, nTrainEp, nTrainEpInitState );
    if task{count}.t==-1
        break;
    end
    t=task{count}.t;
    
    % Add the current task
    
    count = count + 1;
end
save('tasks.mat');

%% Build Initializing Table Mountain Car

nEpisodes=100; % todo
type = 'mc';
param = task{1}.param;

[ state ] = buildInitializeStateLookUpTable(  lookUpTableFile, nEpisodes , type,param );

%% ELLA


% Get the tasks and save them in a file
saveFile = 'mcEllaLearn.mat';

dimensions =10;
%% Learn ELLA save and save it in a file

[e,model]=runExperiment([task(1:30) task(end)] ,saveFile,dimensions, state);

%%
nTasks=50;
nTestEp=100;
load(lookUpTableFile);

%%
rGT=cell(1,nTasks);
thetaGT =cell(1,nTasks);
RLParamsGT =cell(1,nTasks);
epRewGT= cell(1,nTasks);


rE=cell(1,nTasks);
thetaE =cell(1,nTasks);
RLParamsE =cell(1,nTasks);
epRewE =cell(1,nTasks);

%% Run the tasks and find out the rewards
nTasks=10;
for i =51:75%nTasks
    fprintf('\nTaskrE: %d' , i);
    [rE{i}, epRewE{i},thetaE{i}, RLParamsE{i},expE{i}] = GTD(model,task{i}, 'ELLA', lookUpStates,nTrainEp, nTestEp);
    [rGT{i}, epRewGT{i},thetaGT{i},RLParamsGT{i},expGT{i}] = GTD(model,task{i},  'taskTheta', lookUpStates,nTrainEp, nTestEp);
    
end
%%
numE = cellfun(@numel,[expGT(51:75) expE(51:75)]);
minNumE = min(numE);

numEpisodes = minNumE;
avgRewGT=zeros(1,numEpisodes);
avgRewE=zeros(1,numEpisodes);

%%
for i=1:numEpisodes
    
    for j=51:75
        avgRewGT(i)= avgRewGT(i)+expGT{j}(i);
         avgRewE(i) = avgRewE(i)+expE{j}(i);
    end
end

avgRewGT = avgRewGT/25;
avgRewE = avgRewE/25;
%%

plot(avgRewGT,'r-','LineWidth',2)
hold on; plot(avgRewE,'g-','LineWidth',2)
grid on;
set(gcf,'color','white')
legend('J for GTD','J for ELLA-GTD');
title('Loss Function J for GTD vs ELLA GTD','FontSize',17);
xlabel('No of Iterations','FontSize',14)
ylabel('Average Loss over tasks','FontSize',14)
