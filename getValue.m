%% This function returns the best action and the value function for the 
% action by checking each action and value function of the new state 
function [value,action_max,Q] = getValue(type, theta, state,ApproxMap , param , d)

actions=getLegalActions(type);
n_actions = numel(actions);
Q=zeros(n_actions,1);
for i=1:n_actions
    % gets the next state of mountain car
Q(i) = ApproxMap( type, state,  param , d , actions(i)) * theta;

end
% If all value functions are same for all actions pick a random action
if all(Q==max(Q))
    ind=randi(n_actions); 
    value=Q(ind);
else
% Else pick the best action    
[value,ind] = max(Q);

end
action_max=actions(ind);

end