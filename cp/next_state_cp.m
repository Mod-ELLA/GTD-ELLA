function [rew,xn]=next_state_cp(x,u,param)
commonD=param.I*(param.mc+param.mp)+param.mc*param.mp*param.l^2;


A=[0 1 0 0;
   0 -((param.I+param.mp*param.l^2)*param.d)./commonD param.mp^2*param.g*param.l^2 0;
    0 0 0 1;
    0 -(param.mp*param.l*param.d)./commonD  (param.mp*param.g*param.l*(param.mc+param.mp))./commonD 0];



b=[0;(param.I+param.mp*param.l^2)./commonD;0;(param.mp*param.l)./commonD];
xn=A*x+b*u;
rew = cos(x(3));

