function [  ] = desenhaRobo( q, L )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    x = fk(q,L);
    point1 = [L(1)*cos(q(1)) ; L(2)*sin(q(1))]; %primeiro segmento
    point2 = point1 + [L(2)*cos(theta1+theta2);L(2)*sin(theta1+theta2)]; %segundo segmento
    
    plot([0,point1(1)],[0,point1(2,1)])
    hold on
    plot([point1(1),point2(1)],[point1(2,1),point2(2,1)])
    plot([point2(1),x(1)],[point2(2,1),x(2,1)])
    plot(x(1),x(2),'o')
    plot(xd(1),xd(2),'x');
     axis([-3 3 -3 3])
    axis square
    hold off
    m = getframe();
end

