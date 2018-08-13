function [x] = fk( q, L )
    
    n = length(q);
    if (n ~= length(L))
        return;
        disp("erro: vetores de tamanhos diferentes");
    end
    x1 = 0;
    x2 = 0;
    for i = 1:n
        x1 = x1 + L(i)*cos(sum(q(1:i))); %x1 = L1*cos(q1) + L2*cos(q1+q2) + ... + LN*cos(q1+q2+...+qN) 
        x2 = x2 + L(i)*sin(sum(q(1:i)));
    end
    
    x = [x1, x2];
    x = x(:);
    

end

