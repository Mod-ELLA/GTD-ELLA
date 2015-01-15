
function [s, theta, D, taskSpecific, T, RLParams,exp] = encodeTaskELLARL(model, task, lookUpTable)


%% Variables
maxIterations = 2000;%task.maxIter; 
RLParams = model.RLParams; 
%RLParams contains
%         RLParams.u = cell(T,1);
%         RLParams.iter = cell(T,1);
%         RLParams.expectation = cell(T,1);
%         RLParams.avgIteration = cell(T,1);


gamma = task.gamma;
epsilon = task.epsilon; 
d = model.d;
state = task.state; 
t = task.t;
type = task.type;
param =task.param; 
nEpisodes = task.nEpisodes; % no of episodes to run for this task

actions = getLegalActions(type); % get the legal actions for this type of
% RL problem
ApproxMap = getApproxMap(type); % get the state mapping functions or RBFs
nActions = numel(actions); % the number of actions
featureCheck = ApproxMap( type, state, param, d, actions(1)) ;
featureSize = numel (featureCheck); % Get the number of features

testEpisodes=task.testEpisodes; % no of episodes after which epsilon is set
% to zero and state is reinitialized to the initial state
TendHist = zeros(1,nEpisodes); % History of the number of iterations in
% each episode for diagnostic purposes

%%
fprintf('Task: %d \n',task.t);

% check if new task
if isNewTask(t, model.T)
    T = model.T + 1;
    RLParams.iter{t}=1;
    theta = zeros(featureSize,1);
    RLParams.u{t}=0;
    RLParams.expectation{t} = 0;
    
else
    T=model.T;
    theta = model.theta{t};
end

iter = RLParams.iter{t}; 
firstTimeFlag = 1; % If first time flag
uHist = zeros(featureSize,nEpisodes); % History of u vector
thetaHist = zeros(featureSize,nEpisodes); % history theta values
errHist = zeros(1,nEpisodes); % delta history

sume=0;
%% Run the episodes
for episode=1:nEpisodes
    
    if mod(episode,10)==0
    episode
    end
    
    if ~firstTimeFlag
        if exist('lookUpTable','var')==0
         state =task.state;    
        else
         reInitializeState(type,param,lookUpTable,episode);
        end
    end
    firstTimeFlag=0;
    
    if episode == testEpisodes
        state = task.state;
        epsilon=0;
    end
    Tend=0; 
    prevActionMax=mean(actions);
    while Tend<maxIterations
    if Tend==2
       lemon=1; 
    end
        Tend=Tend+1;
        [~,actionMax] = getValue(type, theta, state,ApproxMap ,param, d);
        
        randomActionProb = rand;
        
        if randomActionProb < epsilon
            actionDone = randi( nActions );
            actionMax = actions( actionDone ) ;
        end
        
        [r,stateNext] = doAction(type,state,actionMax, param);
        if Tend==maxIterations 
            r=-2;
        end
        
        %%
        
        phi = ApproxMap( type,  state , param, d , prevActionMax)';
        phiPrime = ApproxMap(  type, stateNext , param , d, actionMax)';
        
        delta = r + gamma * ( theta' * phiPrime) - ( theta' * phi);
        errHist(episode) = delta;
        if iter>inf
            RLParams.alphaK =1/iter; 
            RLParams.betaK =1/iter; 
        else
             RLParams.alphaK =.1;
            RLParams.betaK =.1;   
        end
       
        
        RLParams.u{t} = RLParams.u{t} + RLParams.betaK * ( ( delta * phi ) - RLParams.u{t} );
        uHist(:,episode) = RLParams.u{t};
        theta = theta + RLParams.alphaK * ( phi - gamma*phiPrime ) * (phi'  *  RLParams.u{t});
        iter = iter + 1;
        
        RLParams.expectation{t} = RLParams.expectation{t} + ( phi * ( phi  - gamma*phiPrime )' );
        
 
        if isTerminal(type,stateNext,param)
            break;
        end
        
        sume = sume+(delta*phi)'*(delta*phi);
        exp(iter)=sume/iter;
        state =stateNext;
        
        %% Plotting
         plotRL();
         prevActionMax=actionMax;
    end
    TendHist(episode) = Tend;
    if mod(episode,50)==0
        lenone=1;
    end
    
end
TendHist = TendHist(testEpisodes:nEpisodes);
%%
RLParams.iter{t} = iter;
expectation = RLParams.expectation{t} / iter;
RLParams.expectation{t}=expectation;
RLParams.avgIteration{t} = sum(TendHist)/length(TendHist);
model.RLParams = RLParams;
%% The D matrix
D = 2 * ( expectation * expectation' );
[s, taskSpecific] = sparseEncode(model,theta,D);
end


%%

function [bool] = isNewTask(t, T)
% This function checks if the task is a new task. t is the current task and
% T is the total number of tasks
bool = t>T;

end



