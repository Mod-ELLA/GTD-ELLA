function feature = mountainClimbMapRBF(type, state  ,param, d , action)
% Some random radial basis functions to show implementation
% Assuming the number of features is 10

if nargin ==2
d=5;
end

posBounds = param.posBounds;
velBounds = param.velBounds;
pos=state(:,1);
vel=state(:,2);
nfeat = d;
actions=getLegalActions(type);
 
%%
  rbf( 1, : ) = linspace( posBounds(1), posBounds(2), nfeat ) ; 
  rbf( 2, : ) = linspace( velBounds(1), velBounds(2), nfeat ) ;
  rbf( 3, : ) = linspace( min(actions), max(actions), nfeat ) ;
 

%%
n_feat = size(rbf,2);

 n_states = size(state,1);
 feature = zeros(n_states,n_feat);


 for i=1:n_states
     feature(i,:) = exp( (-sqrt( (pos - rbf(1,:)).^2 + (vel - rbf(2,:)).^2 + (action-rbf(3,:)).^2 ))./(2*(1)) ) ;    
 end

end
