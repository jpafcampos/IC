function Q_otm = otimizacaminho(Q,Obs,dt)


Q_otm = Q;
indatual=1;


while indatual<size(Q_otm,2)
n=size(Q_otm,2);

ok=0;
while (ok==0) & (n>indatual)
 ok=caminholivre(Q_otm(:,indatual),Q_otm(:,n),Obs,dt);
 n=n-1;
end
  Q_otm(:,indatual+1:n-1)=[];
  indatual=indatual+1;
end
  
end