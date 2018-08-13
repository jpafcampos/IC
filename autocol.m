function [ omega ] = autocol( q, L )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    m = length(q);
    p = [0,0];
    p = p(:);
    
    for i = 1:m
        p = [p fk(q(1:i), L(1:i))];
    end
    
    j = 2;
    t = [];
    aux = [];
    for i = 1:m-1
        for j = i+1 : m
            A = [p(:,i) - p(:,i+1)];
            A = [A p(:,j+1) - p(:,j)];
            b = p(:,j+1) - p(:,i+1); 
            t = [t linsolve(A,b)];
        end
    end
    
    for i = 1 : ((m-1)*m)/2
        aux = [aux t(1,i)*(1-t(1,i)),t(2,i)*(1-t(2,i))]; 
    end
    
    %omega = vec2mat(aux, m);
    omega = aux(:);
end

