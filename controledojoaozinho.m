clc;
clear all;

dt=0.2;
eta_e=1;
eta_obs=0.2;
u_limit = ones(8,1);        %Manipulator speed limit
q_limit = [3;3;30; pi/2*ones(5,1)];       %Base configuration limit

T=Trajetoria;
T.Q = zeros(8,1);
T.Q(1) = -2.5;
T.Q(2) = 0;
T.Q(3) = 2*pi*rand();
T.t=0;
rho = 0.1; %curvatura máxima
R_per = 1; %Raio de percepção
kp=2;


%Número de esferas no robô
N_sphr_robot = 1;          
sphr_robot = [];
for i=1:N_sphr_robot
    sphr_robot = [sphr_robot;sphr];
end

%Inicialização dos obstáculos
N_obst = 8;                 %Number of obstacles in the enviroment
obstacle = [];              %Obstacle spheres vector
for i=1:N_obst
    obstacle = [obstacle;sphr];
end
obstacle(1).radius  = 0.3;
obstacle(2).radius  = 0.3;
obstacle(3).radius  = 0.3;
obstacle(4).radius  = 0.5;
obstacle(5).radius  = 0.5;
obstacle(6).radius  = 0.5;
obstacle(7).radius  = 0.5;
obstacle(8).radius  = 0.8;

obstacle(1).center  = [-1.5 0 0]';
obstacle(2).center  = [-2.5 -1 0]';
obstacle(3).center  = [-2.5 1 0]';
obstacle(4).center  = [0 0 0]';
obstacle(5).center  = [0 -2 0]';
obstacle(6).center  = [-1.5 -1 0]';
obstacle(7).center  = [-1.5 2 0]';
obstacle(8).center  = [1 2 0]';

[R,C] = Points_Sphere(T.Q,N_sphr_robot);
    
    for i=1:N_sphr_robot
        sphr_robot(i).radius = R(i);
        sphr_robot(i).center = C(:,i);
    end
    

    
[x1,y1,z1] = sphere;        %Used in plotting
[x2,y2,z2] = sphere;        %Used in plotting

%Posição e orientação desejada
ori_ref = [0 0 0]; 
pos_ref = [-q_limit(1) + 2*q_limit(1)*rand(1)  -q_limit(2) + 2*q_limit(2)*rand(1) 0.4];    
distmin=1000;
for i = 1: length(obstacle)
   distmin = min(distmin,norm(pos_ref(1:2)-obstacle(i).center)-obstacle(i).radius-0.4);  
end

while  distmin<0
pos_ref = [-q_limit(1) + 2*q_limit(1)*rand(1)  -q_limit(2) + 2*q_limit(2)*rand(1) 0.4];    
distmin=1000;
for i = 1: length(obstacle)
   distmin = min(distmin,norm(pos_ref(1:2)-obstacle(i).center)-obstacle(i).radius-0.4);  
end    
end
pos_ref = [-2 -2 0.4];
%Pose desejada
Xd = [pos_ref ori_ref]';    
Rx = [1             0           0;...
      0             cos(Xd(4))  -sin(Xd(4));...
      0             sin(Xd(4))  cos(Xd(4))];
Ry = [cos(Xd(5))    0           sin(Xd(5));...
      0             1           0;...
      -sin(Xd(5))   0           cos(Xd(5))];
Rz = [cos(Xd(6))    -sin(Xd(6)) 0;...
      sin(Xd(6))    cos(Xd(6))  0;...
      0             0           1];
Xd = [[Rx*Ry*Rz pos_ref'];0 0 0 1];




%Função de tarefa
e = @(q) [RoboJoaozinho(q,1)-Xd(1:3,4); norm(RoboJoaozinho(q,2)-Xd(1:3,1:3))];
%Função de Lyapunov
V = @(q) e(q)'*eta_e*e(q);
%Função de obstáculo
Obs = @(q) [CalcDistancia(q,N_sphr_robot,obstacle) ; q_limit-q; q_limit+q];
%Matriz de restrições de velocidade (holonômica e não holonômica)
n_holo = @(q) [-sin(q(3)) cos(q(3)) zeros(1,6)];
r1 = @(q) [-rho*cos(q(3)) -rho*sin(q(3)) 1 zeros(1,5)];
r2 = @(q) [-rho*cos(q(3)) -rho*sin(q(3)) -1 zeros(1,5)];
A = @(q) [eye(size(q_limit,1)); -eye(size(q_limit,1))];
b = @(q) [u_limit; u_limit];
A_hol = @(q) [eye(size(q_limit,1)); -eye(size(q_limit,1)); n_holo(q); -n_holo(q)];
b_hol = @(q) [u_limit; u_limit; 0; 0];

%Função de plotar
terminou=0;
T.t=0;
V_Lyap=[];
T.U=[];
Q_ant=1000+T.Q;

last_index=1;
Q_node=[];
Q_extend=[];



%Parâmetros
P=Parametro;
P.e=e;
P.Obs=Obs;
P.A=A;
P.b=b;
P.A_hol=@(q) [-sin(q(3)) cos(q(3)) zeros(1,size(q,1)-2)];
P.eta_e=eta_e;
P.eta_obs=eta_obs;
P.R_per=R_per;
P.rho=rho;
P.dt=dt;
P.V=V;
P.q_limit=q_limit;



T.V=P.V(T.Q);

while ~terminou
    
    
    %Roda a estratégia 1
    disp('Tentando minimizar a função de Lyapunov');
    Tout = estrategiaREDUZV(T.Q(:,end),P,20);
    T=concatena(T,Tout);
    
    %Anima
    anima(T.Q(:,T.ultimo_indice:end),obstacle,N_sphr_robot,pos_ref,R_per,'b',[],[],[]);
    disp('Caí em um mínimo local... tentando sair');
    disp([ 'Valor da função de Lyapunov: ' num2str(T.V(end))]);
    
    %Vê se chegou no alvo
      if T.V(end)<=0.1
       break;
      end
      
    %Não chegou no mínimo local... tenta sair. Gera um caminho que diminuí
    %a função de Lyapunov
    Q_alvos=caminhoml(T.Q(:,end),T.V(end),P,obstacle,N_sphr_robot,pos_ref);
    
    %Tenta ir até lá
    disp(['Tentando percorrer o caminho... ' num2str(size(Q_alvos,2)) ' pontos']);
    i=1;
    terminousemconseguir=0;
    while (i <= size(Q_alvos,2)) && (terminousemconseguir==0)
      disp(['Ponto ' num2str(i)]);
      Tout = estrategiaCHEGAGOAL(T.Q(:,end),Q_alvos(:,i),P,30);
      T = concatena(T,Tout);
       
      anima(T.Q(:,T.ultimo_indice:end),obstacle,N_sphr_robot,pos_ref,R_per,'b',[],[],Q_alvos(:,i));
     
      
       [D,v]=topologicaldist(T.Q([1:2 4:size(T.Q,1)],end), Q_alvos([1:2 4:size(T.Q,1)],min(i,size(Q_alvos,2)))  );
       if ( D >=dt)
         terminousemconseguir=1; 
         disp(D);
       end
       i=i+1;
    end
    
    
    %Executando o caminho final
    if terminousemconseguir==0
    disp('Executando o caminho final');
    Tout = estrategiaREDUZV(T.Q(:,end),P,30);
    T = concatena(T,Tout);

    anima(T.Q(:,T.ultimo_indice:end),obstacle,N_sphr_robot,pos_ref,R_per,'b',[],[],[]);
    
    else
    disp('Não conseguiu executar todo caminho... continua');    
    end
    
    %Vê se chegou no alvo
     if V(T.Q(:,end))<=0.1
       break;
      end
    
  
    
     
   
end

disp('Terminou execução');

