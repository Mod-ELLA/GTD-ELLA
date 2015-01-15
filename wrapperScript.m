% wrapper script 
% This script will generate the type of task.
% mountain car, passed in the number of tasks, will learn the model.

% Get the tasks and save them in a file
taskFile = 'tasks.mat';

% No of train episodes
nTrainEp = 100;

% Episodes after which random action are stopped and the agent starts at
% the initial start test state like the valley of the mountain
testEpisodeStart =99;

%No of tasks 
nTask = 40;

%%
count =1;
while true
    % A function which returns the current task can be calibrated for
    % different types of tasks
    task{count} =getTask( count, nTrainEp, testEpisodeStart ,nTask);
    if task{count}.t==-1
        break;
    end
    t=task{count}.t;
    
    % Add the current task
    
    count = count + 1;
end
save(taskFile);

%% Build Initializing Table Mountain Car
% In the case where you would like to train multiple tasks and test them
% you might want them all to start at the same start state for example you
% may want to see the number of iterations to the solution at the end of an
% episode as an average, if each task starts at a different random point
% then the average is going to be a random number. So create a lookuptable
% for the initial state for all the tasks to learn from.


nEpisodes=nTrainEp; 
type = 'mc';
param = task{1}.param;
lookUpTableFile = 'mcInitState.mat';

[ lookUpTable ] = buildInitializeStateLookUpTable(  lookUpTableFile, nEpisodes , type,param );

%% ELLA Learning the model
% Get the tasks and save them in a file

%File where the learnt models and everything computed is stored
ellaModelFile = 'mcEllaLearn.mat';
% The number of dimensions of theta
dimensions =15;


%% Learn ELLA save and save it in a file
% You can take only a few task to model ELLA first (train L )

[e,model]=runExperiment([task(1:30) task(end)] ,ellaModelFile,dimensions, lookUpTable);
% the expected error
%%
nTasks=50;
nTestEp=100;
load(lookUpTableFile);

% Reward theta episodic rewards GTD 
rGT=cell(1,nTasks);
thetaGT =cell(1,nTasks);
RLParamsGT =cell(1,nTasks);
epRewGT= cell(1,nTasks);

% Reward theta episodic rewards 
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
