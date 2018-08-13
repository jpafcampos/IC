function T3=concatena(T1,T2)
             T3.Q=[T1.Q T2.Q];
             T3.U=[T1.U T2.U];
             T3.t=[T1.t T2.t+T1.t(end)];   
             T3.V=[T1.V T2.V];
             T3.ultimo_indice=size(T1.Q,2);
end