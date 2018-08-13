function Q_alvos=caminhoml(q0,Vml,P,obstacle,N_sphr_robot,pos_ref)

P_simul = Parametro;
P_simul=P;
P_simul.dt=2*P.dt;
%Tenta sair do mínimo local
    Arvore.Nos =q0;
    Arvore.Pai = 0;
    Arvore.NaoEstendeu=1;
    Arvore.Qualidade = 0;
   
    %Aumenta a árvore RRT
    V_extensao=Vml+1;
    
    while V_extensao>0.7*Vml
    disp('Aumentando árvore RRT');    
    Arvore =  RRT(Arvore,P.V,P.Obs,P.q_limit,100);

    if rand()<=0.7
    %Escolhe o nó com menor valor de função de Lyapunov por distância à raiz para extendê-lo
    ind=find(Arvore.Qualidade.*Arvore.NaoEstendeu==max(Arvore.Qualidade.*Arvore.NaoEstendeu));
    ind=ind(1);
    else
     ind=randperm(size(Arvore.Nos,2));
     ind=ind(1);
    end
    q_extensao = Arvore.Nos(:,ind);
    Arvore.NaoEstendeu(ind)=0;
    
    disp('Estendendo um nó, tentando encontrar um valor de função de Lyapunov menor');
    Tout = estrategiaREDUZV(q_extensao,P_simul,50); 
    anima(Tout.Q,obstacle,N_sphr_robot,pos_ref,P.R_per,'g',Arvore.Nos,[],q_extensao);
    V_extensao=P.V(Tout.Q(:,end));
    
        
    end
    
    disp(['Consegui achar um ponto de função Lyapunov menor, ' num2str(V_extensao) ' otimizando caminho...']);
    
    
    %Encontra todos os parentes
    Q_alvos=q_extensao;
    while Arvore.Pai(ind)~=0
      ind=Arvore.Pai(ind);
      Q_alvos = [Q_alvos Arvore.Nos(:,ind)];
    end
    Q_alvos(:,end)=[];
    Q_alvos=Q_alvos(:,end:-1:1);
    
    Q_alvos = otimizacaminho(Q_alvos,P.Obs,P.dt);
    
end