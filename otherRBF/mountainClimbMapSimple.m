function feature = mountainClimbMapSimple(  state ,param , d, valley )
% return the position and the velocity as parameters.

pos=state(1);
vel=state(2);
feature(1,:) = [(pos-valley(1)) vel];  
    
 end
