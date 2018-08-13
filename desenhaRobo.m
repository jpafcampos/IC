function [  ] = desenhaRobo( q, L, xd, Obs, cor)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    xmax = sum(L);
    ymax = sum(L);
    m = length(q);
    plot(0,0);
    hold on;
    qc = cumsum(q);
    x(1) = 0;
    y(1) = 0;
    for j = 1:m
        x(j+1) = L(1:j)*cos(qc(1:j));
        y(j+1) = L(1:j)*sin(qc(1:j));
        plot([x(j) x(j+1)], [y(j) y(j+1)], cor, 'linewidth', 2); 
        plot(x(j+1),y(j+1),'ob','markersize',6)
        plot(xd(1),xd(2),'x');
    end
    
    %plota os obstaculos
    for j = 1:length(Obs)
        Obs(j).desenha('black');
    end
    axis([0 xmax 0 ymax]);
    hold off;
end

