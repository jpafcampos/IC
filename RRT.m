function   new_Tree =  RRT(old_Tree,V,Obs,q_limits,num_nos)

new_Tree =old_Tree;

for i = 1: num_nos

    ok=0;
    
    while ok==0
     q_rand1= -q_limits + 2*q_limits.*rand(length(q_limits),1);
     q_rand2 = q_rand1 + 0.5*randn(size(q_rand1));
     D1=min(Obs(q_rand1));
     D2=min(Obs(q_rand2));
     if (D1>0) &&  (D2<=0)
        q_rand=q_rand1;
        ok=1;
     end
     
     
     if (D2>0) &&  (D1<=0)
        q_rand=q_rand2;
        ok=1;
     end
     
    end
    
     
    if rand()<=0.87
        %Encontra o nó mais próximo de Q_rand

         for i = 1: size(new_Tree.Nos,2)
           D(i)=-topologicaldist(new_Tree.Nos(:,i),q_rand);
         end

    else
    %Pega o com a maior qualidade
      D=new_Tree.Qualidade;
    end

    ind = find(D==max(D)); %pega o indice de D tal que D(ind) é o melhor
    ind=ind(1);
    q_escolhido = new_Tree.Nos(:,ind);


    %Calcula um alvo
    q_alvo = q_escolhido + (0.3+0.3*rand())*(q_rand-q_escolhido);

    %Tenta ligar

      result = caminholivre(q_escolhido,q_alvo,Obs,0.1);

      if result==1
        new_Tree.Nos(:,size(new_Tree.Nos,2)+1) = q_alvo;
        new_Tree.Pai(:,length(new_Tree.Pai)+1) = ind; 
        new_Tree.NaoEstendeu(length(new_Tree.NaoEstendeu)+1) = 1;    
        new_Tree.Qualidade(length(new_Tree.Qualidade)+1) =   calculanota(new_Tree,V,size(new_Tree.Nos,2)); 
      end


end



end