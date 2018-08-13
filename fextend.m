function T= fextend(q0,f,tmax,dt)

T=Trajetoria;
T.Q=[q0];
T.U=[];
T.t=0;
q=q0;
terminou=0;


while ~terminou
k1=f(q);
k2=f(q+dt*k1/2);
k3=f(q+dt*k2/2);

k4=f(q+dt*k3);
qant=q;
u=(k1+2*k2+2*k3+k4)/6;
T.U=[T.U u];


if norm(u)>=1
  dt_n=dt/norm(u);  
else
  dt_n=dt;
end


q = q+dt_n*u;
%[~] = plothandle();

T.Q=[T.Q q];
T.t = [T.t T.t(end)+dt_n];

 %Terminou por tempo máximo
 if T.t(end)> tmax
    terminou=1; 
 end
 
 %Terminou pois convergiu
 if topologicaldist(q,qant)<=0.04*dt
    terminou=1; 
 end
 
 
end





  

end