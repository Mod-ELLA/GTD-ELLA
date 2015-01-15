function [rew,stp1] = next_state_mc(st,ai,pos_bnds,mcar_goal_position,vel_bnds,slope,rewardMult)
% NEXT_STATE - Returns the next state stating in state st and taking action ai
%   
% Note that this is specialized somewhat for the mountain example from Sutton's book
% 
% Written by:
% -- 
% John L. Weatherwax                2008-02-19
% 
% email: wax@alum.mit.edu
% 
% Please send comments and especially bug reports to the
% above email address.
% 
%-----

stp1 = st; 
stp1(2) = stp1(2) + (ai)*0.001 + cos(slope*st(1))*(-0.0025); 
if( stp1(2) > vel_bnds(2) ) stp1(2) = vel_bnds(2); end; 
if( stp1(2) < vel_bnds(1) ) stp1(2) = vel_bnds(1); end; 

stp1(1) = stp1(1) + stp1(2); 
if( stp1(1) > pos_bnds(2) ) stp1(1) = pos_bnds(2); end; 
if( stp1(1) < pos_bnds(1) ) stp1(1) = pos_bnds(1); end; 
if( (stp1(1)==pos_bnds(1)) && (stp1(2)<0) ) stp1(2) = 0.0; end %Inelastic collision
rew=-1*rewardMult;
if( stp1(1) >= mcar_goal_position )
  rew =  0*rewardMult;
 elseif stp1(1)<=pos_bnds(1)
   rew = -1*rewardMult; 
end