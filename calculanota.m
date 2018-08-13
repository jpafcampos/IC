function Nota = calculanota(Arvore,V,ind)

%Calcula a nota do índice ind

D=0;
for i = 1: size(Arvore,2)
  if Arvore.NaoEstendeu(i)==0
    D = D+ topologicaldist(Arvore.Nos(:,ind),Arvore.Nos(:,i))^2;  
  end
end
Nota=D/(V(Arvore.Nos(:,ind))+0.01);

end