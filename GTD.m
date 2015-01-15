
function [rHist, epRew, theta,  RLParams,exp] = GTD(model, task, mode, lookUpTable,episodeLearning, nTestEpisodes)

rHist=-1;
%% Variables
maxIterations = 5000;%task.maxIter; 
RLParams = model.RLParams; 

gamma = task.gamma; % discount
epsilon = task.epsilon; % exploration rate
d = model.d;
state = task.state; % initial state
t = task.t; % task number
type = task.type; % type of task usually a string like = 'mc' for mountain car
param =task.param; % task parameters
nEpisodes = nTestEpisodes; % no of episodes to run for this task

actions = getLegalActions(type); % get the legal actions for this type of
% RL problem
ApproxMap = getApproxMap(type); % get the state mapping functions or RBFs
nActions = numel(actions); % the number of actions
featureCheck = ApproxMap( state, param, d) ;
featureSize = numel (featureCheck); % Get the number of features

testEpisodes=task.testEpisodes; % no of episodes after which epsilon is set
% to zero and state is reinitialized to the initial state
TendHist = zeros(1,nEpisodes); % History of the number of iterations in
% each episode for diagnostic purposes

%%
fprintf('Task: %d \n',task.t);

if strcmpi(mode,'ELLA')
    theta = model.L*model.S(:,t);
    elseif strcmpi(mode,'taskTheta')
    theta = zeros(d,1);%model.theta{t};
end
ctr=1;


 T = model.T + 1;
    % The number of total iteration in this task
    RLParams.iter{t}=1;
    % Theta for this task
    % The u vector for this task GTD algorithm
    RLParams.u{t}=0;
    % Expectation of the matrix $1/k \sum_{i=1}^k \phi_i (\phi_i - gamma
    % \phi')^{T}$ where k is the number of iterations for this task so far
    RLParams.expectation{t} = 0;


iter = RLParams.iter{t}; % number of iterations
firstTimeFlag = 1; % If first time flag
uHist = zeros(featureSize,nEpisodes); % History of u vector
thetaHist = zeros(featureSize,nEpisodes); % history theta values
errHist = zeros(1,nEpisodes); % delta history
% rHist = zeros(1,nEpisodes);
cnt =1;
epRew = zeros(1,nEpisodes); % delta history
sume=0;
    rewSum =0;
exp = inf(5000);
%% Run the episodes
for episode=1:100%nTestEpisodes
    % if not the first episode randomly initialize the starting state
    % within the legal values
    if ~firstTimeFlag
        % a random initial state
        state = reInitializeState(type,param,lookUpTable,episode);
    end
    firstTimeFlag=0;
    
    % If you reach the testEpisodes run the task for the theta learnt so
    % far
%     if episode == testEpisodes
%         state = task.state;
%         epsilon=0;
%     end
    Tend=0; % reset the iteration 
    while Tend<maxIterations
        %%
        % copy the thetas to history
        thetaHist(:,episode) = theta; 
        Tend=Tend+1;
        %get the best action
        [~,actionMax] = getValue(type, theta, state,ApproxMap ,param, d);
        
        % With some random probability do some random action
        randomActionProb = rand;
        
        if randomActionProb < epsilon
            actionDone = randi( nActions );
            actionMax = actions( actionDone ) ;
        end
        
        % Do the best action and get the next state
        [r,stateNext] = doAction(type,state,actionMax, param);
        
        
        %%
        
        % Map the states to the feature vectors
        phi = ApproxMap(  state , param, d)';
        phiPrime = ApproxMap(  stateNext , param , d)';
        
        % delta error 
        delta = r + gamma * ( theta' * phiPrime) - ( theta' * phi);
        errHist(episode) = delta;
        
        % Right now randomly setting the step sizes to 0.1 todo changing it
            RLParams.alphaK =0.01; %todo
            RLParams.betaK =0.01; %todo
            
        
        
        % updating the u vector
        RLParams.u{t} = RLParams.u{t} + RLParams.betaK * ( ( delta * phi ) - RLParams.u{t} );
        uHist(:,episode) = RLParams.u{t};
        % update theta
        theta = theta + RLParams.alphaK * ( phi - gamma*phiPrime ) * (phi'  *  RLParams.u{t});
        % increment the total number of iterations
        iter = iter + 1;
        
        
        % If we plot out the actions
%                  fprintf('\nPos : %d  Action: %d ',(stateNext(1))>task.state(1), actionMax);
        
        % check if the terminal state has been reached
        if isTerminal(type,stateNext,param)
            break;
        end
        
        % set the next state to the current state
        
        sume = sume+(delta*phi)'*(delta*phi);
        exp(ctr)=sume/ctr;
        % set the next state to the current state
        state =stateNext;
        ctr=ctr+1;
        
        %% Plotting
         plotRL(-1, -1, -1 , Tend, state(1) );


    end
    TendHist(episode) = Tend;
            rHist(cnt)=r;
        rewSum=rewSum+r;
                epRew(cnt)=rewSum/cnt;
        cnt=cnt+1;
        if iter>9000
            break;
        end
end
TendHist = TendHist(testEpisodes:nEpisodes);
%%
RLParams.iter{t}=iter;
RLParams.avgIteration{t} = sum(TendHist)/length(TendHist);
exp(exp==Inf)=[];

end



