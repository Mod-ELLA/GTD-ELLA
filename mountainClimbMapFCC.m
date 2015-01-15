function feat = mountainClimbMapFCC(type, state  ,param, nfeat , action)
% Some random radial basis functions to show implementation
% Assuming the number of features is 10

actions=getLegalActions(type);

xmin = param.posBounds(1);
xmax = param.posBounds(2);
xmid = ( xmax - xmin ) / 2;

vmin = param.velBounds(1);
vmax = param.velBounds(2);
vmid = ( vmax - vmin ) / 2;

amin = min(actions);
amax = max(actions);
amid = ( amax - amin ) / 2;

X = [state(1);
    state(2);
    action];

mu = [ xmin, vmin, amin;
       xmax, vmin, amin;
       xmax, vmax, amin;
       xmin, vmax, amin;
       xmin, vmin, amax;
       xmax, vmin, amax;
       xmax, vmax, amax;
       xmin, vmax, amax; 
       
       xmid, vmid, amid;
       
       xmid, vmid, amin;
       xmax, vmid, amid;
       xmin, vmid, amid;
       xmid, vmax, amid;
       xmid, vmid, amax;
       xmid, vmin, amid]';


%%
sigma = zeros(3);
sigma(1,1) =  ( (xmax - xmin)/3 )^2;
sigma(2,2) =  ( (vmax - vmin)/3 )^2;
sigma(3,3) =  ( (amax - amin)/3 )^2;


%%

nRBF = size(mu,2);
feat = zeros(1,nRBF);

for i= 1:nRBF
    feat(i) = (X - mu(:,i))' * sigma * (X - mu(:,i));
end

end
