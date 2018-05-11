%% João Pedro Campos
%Simulação de Braço Robótico - Cinemática Inversa


clc
clear all
close all

%
%angulos iniciais
theta1 = pi/4;
theta2 = pi/6;
theta3 = 0;

%ponto final desejado
xd = [-1;0]

dt = 0.001 %passo
count = 0; %contador de iteracoes

%x = f(theta)
x = [cos(theta1)+cos(theta1+theta2)+cos(theta1+theta2+theta3);...
sin(theta1)+sin(theta1+theta2)+sin(theta1+theta2+theta3)]

for i = 0:dt:2
    
    point1 = [cos(theta1) ; sin(theta1)]; %primeiro segmento
    point2 = point1 + [cos(theta1+theta2);sin(theta1+theta2)]; %segundo segmento
    
    if(mod(count,10)==0) %a cada 10 iteracoes
   
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
    %pause(.1)
    
    
    end   
    
    
    J = [-sin(theta1)-sin(theta1+theta2)-sin(theta1+theta2+theta3),...
    -sin(theta1+theta2)-sin(theta1+theta2+theta3),...
    -sin(theta1+theta2+theta3);...
    cos(theta1)+cos(theta1+theta2)+cos(theta1+theta2+theta3),...
    cos(theta1+theta2)+cos(theta1+theta2+theta3),...
    cos(theta1+theta2+theta3)];

    pseudoinv = pinv(J);

    G = pseudoinv*5*(xd - x);

    theta1 = theta1 + G(1)*dt;
    theta2 = theta2 + G(2,1)*dt;
    theta3 = theta3 + G(3,1)*dt;

    x = [cos(theta1)+cos(theta1+theta2)+cos(theta1+theta2+theta3);...
    sin(theta1)+sin(theta1+theta2)+sin(theta1+theta2+theta3)];
    count = count + 1;
    if(i==0)
    disp(J);
    disp(pinv(J));
    end
 end