function [ d ] = dist_semireta( pi, pf, pc, r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    v1 = pf - pi;
    v2 = pc - pi;
    v1n = v1/norm(v1);
    v3 = v2 - (v2'*v1n)*v1n;
    v4 = v2 - v3;
    
    if(norm(v4) < norm(v1))
        d = norm(v3) - r;
    else
        d = min(norm(pc - pf) - r, norm(pc - pi) - r);
    end

end

