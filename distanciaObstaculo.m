function [ omegaObs ] = distanciaObstaculo( Obs, q, L )
%calcula a distancia até um objeto do tipo Obstaculo
    p = [];
    p = [0,0];
    p = p(:);
    omegaObs = [];
    m = length(L);
    n = length(Obs); %num de obstaculos
    for i = 1:m
        p = [p fk(q(1:i), L(1:i))];
    end
    
    for i = 1:m
        segmento = Semireta(p(:,i), p(:,i+1));
        for j = 1:n
            omegaObs = [omegaObs -Obs(j).calcdist(segmento)];
        end
    end
    
    omegaObs = omegaObs(:);
    
end

