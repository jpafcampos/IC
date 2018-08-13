function [ Q ] = movimenta( q, L, xd, erro, fk, Omega, A, b, t, dt )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    count = 1;
    F = @(q) fk(q,L);
    
    for i = 0:dt:t
    
    x = fk(q, L);
  
    %adiciona à matriz A e ao vetor b a restrição passada como parametro:
    A = [eye(m); -eye(m); calcJac(Omega, q)]; 
    b = [b ones(2*m, 1); -eta*Omega(q)];
    
%     A = [A ; calcJac(Omega, q)]; 
%     b = [b ; -eta*Omega(q)];
    

    U = calc_velocidade(q, erro, fk, Omega, A, b);   
    
    q = q + U*dt;
    

    
    xh(count+1)=x(1);
    yh(count+1)=x(2);
    

    count = count + 1;
        if (abs(x-xd) < 0.01)
            disp('chegou');
            break;
        end
    end


end

