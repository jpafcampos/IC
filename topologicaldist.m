function [D,v] = topologicaldist(q1,q2)

v = [cos(q1)-cos(q2); sin(q1)-sin(q2)]; 
D = norm(v);
end