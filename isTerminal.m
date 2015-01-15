function [ bool ] = isTerminal(type,state,param)
 if strcmpi(type,'mc')==1
     bool= state(1)>param.posGoal;
 end
 
end

