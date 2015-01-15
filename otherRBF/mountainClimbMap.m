function feature = mountainClimbMap( t, state , action ,param )
% Some random radial basis functions to show implementation
% Assuming the number of features is 10


% rbf=[(-15:1:10);(-10:1:10);(-10:1:10)];%Random RBF in theta and thetadot space generated using randi
% n_feat = size(rbf,2);

%Assumed pos boundary = [-10, 10]
%Assumed vel boundary = [-10, 10]
pos=state(:,1);
vel=state(:,2);
n_states = size(state,1);
% feature = zeros(n_states,n_feat);

feature = [pos vel action]; %todo

% for i=1:n_feat
%     feature(:,i) = sqrt( ( pos - rbf(1,i) ).^2 + ( vel - rbf(2,i)).^2 + ( action - rbf(3,i)).^2 );
%    
% end
end
