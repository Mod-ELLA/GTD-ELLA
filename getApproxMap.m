function [ ApproxMap ] = getApproxMap(type)
% This function returns the mapping function according to the type of the
% reinforcement learning problem. (like RBFs)

% For mountain car
 if strcmpi(type,'mc')==1
     % Choose this if you want a equispaced RBF whose number of RBFs can be
     % changed
      ApproxMap = @mountainClimbMapFCC;
%       ApproxMap = @mountainClimbMapRBFMesh;

     % Choose this if you want only velocity and position
%      ApproxMap = @mountainClimbMapSimple;
 end
end
%%

%%
