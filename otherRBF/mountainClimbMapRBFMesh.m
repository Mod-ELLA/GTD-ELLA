function feature = mountainClimbMapRBFMesh(type, state  ,param, d , action)
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
[rbfp,rbfv,rbfa] = meshgrid(linspace( posBounds(1), posBounds(2), nfeat ),...
    linspace( velBounds(1), velBounds(2), nfeat ),...
    linspace( min(actions), max(actions), nfeat ));

rbfp=rbfp(:)';
rbfv=rbfv(:)';
rbfa=rbfa(:)';

%%
n_feat = size(rbfa,2);

 n_states = size(state,1);
 feature = zeros(n_states,n_feat);


 for i=1:n_states
     feature(i,:) = exp( (-sqrt( (pos - rbfp(1,:)).^2 + (vel - rbfv(1,:)).^2 + (action-rbfa(1,:)).^2 ))./(2*(1)) ) ;    
 end

end
