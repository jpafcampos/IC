function result = caminholivre(qinit,qfinal,Obs,dt)
%Descobre se o caminho é livre entre dois pontos

 q_atual=qinit;

  while (min(Obs(q_atual))>0)&&( topologicaldist(q_atual,qfinal) >=dt)
     q_atual = q_atual + dt*(qfinal-qinit); 
  end
  
  if topologicaldist(q_atual,qfinal)<=0.1
    result=1;  
  else
    result = 0;  
  end

  
end