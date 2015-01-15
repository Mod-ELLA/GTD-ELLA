%% This is the function that adds or generates new task, right now it
% generates random mountain car tasks with different slopes. Takes in the
% number of the required task and returns a structure task with the
% following parameters.
%         task.isRL - Is the task RL
%         task.t - Task ID
%         task.gamma - Discount factor
%         task.epsilon - Exploration rate
%         task.type='mc' - What type of RL problem
%         'mc' - Mountain car
%
%         task.param = param; - parameters of the particular task
%         task.nEpisodes - no of episodes to run
%         task.testEpisodes - no episodes where exploration stops and the
%         learning state starts at the initial state
%         Parameters of mountain car : -
%         param.posBounds - Position boundaries
%         param.velBounds - Velocity boundaries
%         param.posGoal - Goal Position
%         param.slope - Slope
%         task.state - Initial state and test state


function [task] = getTask( count, nEpisodes, testEpisodes, nTasks )
% Change nTasks for the number of tasks needed
if exist('nTasks','var')==0
    nTasks = 100;
end
if count <=nTasks
    task.isRL =true;
    task.t=count;
    task.gamma =0.9;
    task.epsilon =0.2;
    task.type='mc';
    
    posBounds = [  -1.3, +0.6  ];
    posGoal = 0.5;
    velBounds = [ -0.07, +0.07 ];
    
    param.posBounds = posBounds;
    param.velBounds = velBounds;
    param.posGoal = posGoal;
    param.rewardMult = 1;%(rand);
    param.slope=unifrnd(2.6,3.3);
    
    % For slopes greater than 3.3 the goal
    %cant be reached
    
    task.param = param;
    
    if exist('nEpisodes')
        task.nEpisodes = nEpisodes;
    else
        task.nEpisodes = 10; 
    end
    if exist('testEpisodes')
        task.testEpisodes=testEpisodes;    
    else
    task.testEpisodes=9;
    end
    task.maxIter=2000;
    % Finding the valley position
    syms x;
    y= cos(param.slope*x);
    valley = -double(solve(y==0));
%     pause(0.3)
    task.state=[valley,0];
    
end


if count ==nTasks+1
    task.t=-1;
end
end