function [ e ] = erro( q, fk, xd )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    e = fk(q) - xd;

end

