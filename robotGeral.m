%% Jo�o Pedro Campos
%Simula��o de Bra�o Rob�tico - Cinem�tica Inversa


clc
clear all
close all
warning off all
warning
options = optimset('Display', 'off');
m=4; %num de juntas


%obstaculos

%fenda
ub = 2;
lb = 1.2;
esq = 1.8;
dir = 2.0;
s1 = Semireta([esq 4], [esq ub]);
s2 = Semireta([dir 4], [dir ub]);
s3 = Semireta([esq 0], [esq lb]);
s4 = Semireta([dir 0], [dir lb]);
s5 = Semireta([esq ub], [dir ub]);
s6 = Semireta([esq lb], [dir lb]);

obstaculos = [s1, s2, s3, s4, s5, s6];

%circulo
% xc = [1.5];
% yc = [1.0];
% r  = [0.5];
% 
% C = Circulo(r, xc, yc);
% obstaculos = C;


L=ones(1,m);
Omega_lim = @(q) restricao(q,L);
Omega_col = @(q) autocol(q,L);
Omega_col = @(q) [];
Omega_obs = @(q) distanciaObstaculo(obstaculos, q, L);
%Omega_obs = @(q) [];

Omega = @(q) [Omega_lim(q); Omega_col(q); Omega_obs(q)]; 

q_limits = 5*ones(m,1);

q = (4).*rand(m,1) - 2;

while ~(prod(Omega(q)<=-0.1))
 q = (4).*rand(m,1) - 2;   
end

T = Trajetoria;
T.Q = q; %config. inicial
T.U = []; 
T.t = 0;
T.ultimo_indice = 1;

%ponto final desejado
%xd = [(1.5).*rand(1,1)+ 2.5;(1.5).*rand(1,1)];
xd = [3; 1];
erro = @(q) fk(q, L) - xd;

%ganho
k = 5;

eta = 0.1;

%restricoes

dt = 0.1 %passo
count = 1; %contador de iteracoes

%x = f(theta)
x = fk(q, L);
disp('ponto incial:');
disp(x);

qdot_limit = ones(m, 1);

A = @(q) [eye(m); -eye(m)];
b = @(q) [qdot_limit; qdot_limit];
f = @(q) calc_velocidade(q,erro, Omega, A, b);

V = @(q) norm(erro(q),2);

while ( norm(fk(q,L)-xd) > 0.2 )
   disp('Mais uma itera��o');    

        Tout = fextend(T.Q(:,end),f,20,dt);
        T = concatena(T, Tout);

    for i=T.ultimo_indice:size(T.Q,2)
        T.V(i) = V(T.Q(:,i));
        if(mod(i,2)==0)
           desenhaRobo (T.Q(:,i), L, xd, obstaculos,'b');   
           M = getframe();
        end
    end
    
    disp('criando RRT');
    v_atual = T.V(end);
    v_encontrados = v_atual + 1;
    
        tree = Arvore;
        tree.Nos = T.Q(:,end);
        tree.Pai = 0;
        tree.NaoEstendeu = 1;
        tree.Qualidade = 0;
    while(v_encontrados > 0.2*v_atual)


        tree = RRT(tree, V, @(q) -Omega(q), q_limits, 500);
        disp('terminei arvore');
        if rand()<=1 %0.7
        %Escolhe o n� com menor valor de fun��o de Lyapunov por dist�ncia � raiz para extend�-lo
        ind=find(tree.Qualidade.*tree.NaoEstendeu==max(tree.Qualidade.*tree.NaoEstendeu));
        ind=ind(1);
        else
         ind=randperm(size(tree.Nos,2));
         ind=ind(1);
        end
        q_extensao = tree.Nos(:,ind);
        tree.NaoEstendeu(ind)=0;


        Tout = fextend(q_extensao,f,20,dt);
        for j = 1: size(tree.Nos,2)
                cd(:,j) = fk(tree.Nos(:,j),L); %nos da arvore no espa�o de tarefas
                end


        for i=1:size(Tout.Q,2)

            if(mod(i,2)==0) 
               desenhaRobo (T.Q(:,i), L, xd, obstaculos,'b');   
               hold on;
               plot(cd(1,:),cd(2,:),'dk'); %plota os nos da arvore
               hold off;

               M = getframe();
            end
        end

        v_encontrados=V(Tout.Q(:,end));
        disp(['Valor de Lyapunov encontrado ' num2str(v_encontrados)]);
    end
    
    %Encontra todos os parentes
    Q_alvos=q_extensao;
    while tree.Pai(ind)~=0
      ind=tree.Pai(ind);
      Q_alvos = [Q_alvos tree.Nos(:,ind)];
    end
    Q_alvos(:,end)=[];
    Q_alvos=Q_alvos(:,end:-1:1);
    
Q_alvos = otimizacaminho(Q_alvos,@(q) -Omega(q),dt);
    
    for j = 1:size(Q_alvos,2)
        disp('Tentando chegar no pr�ximo ponto');
        fd = @(q) calcula_velocidade_alvo(q, Q_alvos(:,j), erro, Omega, A, b);
        Tout = fextend(T.Q(:,end), fd, 200, dt);
        T = concatena(T, Tout);
                
        for i=1:size(Tout.Q,2)

            if(mod(i,2)==0) 
               desenhaRobo (T.Q(:,i), L, xd, obstaculos,'b');   
               hold on;
               palvo=fk(Q_alvos(:,j),L);
               plot(palvo(1),palvo(2),'dk'); %plota os nos da arvore
               hold off;

               M = getframe();
            end
        end
    end
    
        
 end