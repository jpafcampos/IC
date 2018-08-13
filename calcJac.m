function [ J ] = calcJac( G, q )
   
    m = length(q);
    J = [];
    dt = 0.001;
    for j = 1:m
        deltaq = zeros(m,1);
        deltaq(j) = dt;
        J = [J (G(q+deltaq)-G(q-deltaq))/(2*dt)];                 
    end
 end
    
    
            
            
          

