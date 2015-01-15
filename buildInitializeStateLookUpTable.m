function [ lookUpStates ] = buildInitializeStateLookUpTable(  lookUpTableFile, nEpisodes , type,param )



%%


lookUpStates = cell(1,nEpisodes);
if strcmpi(type,'mc') ==1
        
        posBounds = param.posBounds;
        velBounds = param.velBounds;
        posGoal = param.posGoal;
    for i=1:nEpisodes

        posRand = unifrnd(posBounds(1),posGoal); % a random initial state
        velRand = unifrnd(velBounds(1),velBounds(2));
        lookUpStates{i} = [posRand , velRand] ;
    end
end
save(lookUpTableFile);
end

