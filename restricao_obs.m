function [ omega_obs ] = restricao_obs( q, L, C, r )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    p = [];
    p = [0,0];
    p = p(:);
    omega_obs = [];
    m = length(L);
    n = length(C(1,:));
    for i = 1:m
        p = [p fk(q(1:i), L(1:i))];
    end
    
    for i = 1:m
        for j = 1:n
        omega_obs = [omega_obs -dist_semireta(p(:,i), p(:,i+1), C(:,j), r(j))];
        end
    end
    
    omega_obs = omega_obs(:);
end

