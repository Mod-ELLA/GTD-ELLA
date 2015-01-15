function feature = mountainClimbMapRBF2( t, state , action ,param )
% Some random radial basis functions to show implementation
% Assuming the number of features is 10



actions = getLegalActions(t);
 posBounds = param.posBounds;
 velBounds = param.velBounds;
pos=state(:,1);
vel=state(:,2);
minAction = min( actions );
maxAction = max( actions );
 nfeat = 5;
 %%
 frac=0.2;
 
%%
  rbf( 1, : ) = linspace( posBounds(1), posBounds(2), nfeat ) ; %[(-15:1:10);(-10:1:10);(-10:1:10)];%Random RBF in theta and thetadot space generated using randi
  rbf( 2, : ) = linspace( velBounds(1), velBounds(2), nfeat ) ;
 

%%
n_feat = size(rbf,2);

 n_states = size(state,1);
 feature = zeros(n_states,n_feat);


 for i=1:n_states
     feature(i,:) = exp( (-sqrt( (pos - rbf(1,:)).^2 + (vel - rbf(2,:)).^2 ))./(2*(1^2)) ) ;    
 end

end
