function  [r,stateNext] = doAction(type,state,action, param)

    if strcmpi(type,'mc')==1
        
        [r,stateNext] = next_state_mc(state,action,param.posBounds,param.posGoal,param.velBounds,param.slope,param.rewardMult);
    end

end