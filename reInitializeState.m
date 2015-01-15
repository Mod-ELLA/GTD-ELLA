function [state] = reInitializeState(type, param, lookUpTable, episode)
% This function is used to reinitialize an RL problem to a random initial
% state.
% Input :
% type : type of the RL problem whihc is a string such as 'mc' for mountain car
% param : contains the parameters of the RL problem

% If mountain car
%%

if strcmpi(type,'mc') ==1
%     if exist('lookUpTable')
%         state = lookUpTable{episode};
%     else 
       
    posBounds = param.posBounds;
    velBounds = param.velBounds;
    posGoal = param.posGoal;
    
    posRand = unifrnd(posBounds(1),posGoal); % a random initial state
    velRand = unifrnd(velBounds(1),velBounds(2));
    state = [posRand , velRand] ;
%     end
end
end