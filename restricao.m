function [ omega ] = restricao( q, L )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    qc = cumsum(q);
    x(1,1) = 0;
    y(1,1) = 0;
    m = length(q);
    for j = 1:m
        x(j+1,1) = L(1:j)*cos(qc(1:j));
        y(j+1,1) = L(1:j)*sin(qc(1:j));
    end
    
    omega = [-x-0.1; -y-0.1];

end

