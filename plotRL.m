function [] = plotRL(iter, delta, theta , Tend, position )
% This function plots the parameters of RL.
% Input :
% iter is the total number of iterations so far 
% delta is the error of TD 
% theta is the parameter vector 
% Tend is the iteration in the current episode
% position is the position of the mountain car.
% If no argument is passed the function returns without performing any
% operation
% if iter > 0 plots errors (delta) and theta
% if Tend > 0 plots the position

% If no input
if nargin == 0
    return
end
% Parse the number of items to be plotted
if iter >=1 && Tend >=1
    subR = 2;
    subC = 2;
elseif Tend>=1
    subR = 1;
    subC = 1;
elseif iter>=1
    subR = 1;
    subC = 2;
else
    return
end

plotPos =1; % Plotting position for the current plot in the subplot
figure(1);
% Plot the error and thetas
if iter>=1
    subplot(subR,subC,plotPos);
    plotPos = plotPos+1;
    hold on
    plot (iter,delta,'rx');
    title('Error');
    xlabel('Total Iterations');
    ylabel('Delta')
    drawnow;
    subplot(subR,subC,plotPos);
    plotPos = plotPos+1;
    hold on;
    for i=1:numel(theta)
    plot(iter, theta(i));
    end
    title('Thetas');
    xlabel('Total Iterations');
    ylabel('Theta')
    drawnow();
end
% Plot the position
if Tend>=1
    hold on;
    subplot(subR,subC,plotPos);
    plot(Tend,position,'mo');
    title('Position vs Current Iterations');
    xlabel('Total Iterations');
    ylabel('Position')
    drawnow();
end
end
%% Additional plotting not used
%      h2=subplot(1,1,1);
%      hold on;
%      plot(Tend,state(1),'ro');
%      title('Position vs Total Iterations');
%      xlabel('Total Iterations');
%      ylabel('Position')
%      drawnow();
%      h1=subplot(1,1,1);
%
% %
%    try delete(h1);
%    catch
%    end
%    if (mod(episode,20)==0)
%        try delete(h2);
%        catch
%        end
%    end