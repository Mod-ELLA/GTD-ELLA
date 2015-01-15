function actions = getLegalActions(t)
% This function returns the legal actions for a reinforcement problem.
% If the problem is mountain car
if strcmpi(t,'mc')==1
    actions=[-1,0,1];
end
end