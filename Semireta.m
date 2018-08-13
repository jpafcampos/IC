classdef Semireta < Obstaculo
    properties
        P1
        P2
    end
    
    methods
        function thisSemireta = Semireta(p1, p2)
            if 2 == nargin
                thisSemireta.P1 = p1(:);
                thisSemireta.P2 = p2(:);
            end
        end
        
        function dist = calcdist(obj, obs)
                
            if strcmp(class(obs), 'Circulo')
                pc = [obs.Xc; obs.Yc];
                r = obs.Raio;
                v1 = obj.P2 - obj.P1;
                v2 = pc - obj.P1;
                v1n = v1/norm(v1);
                v3 = v2 - (v2'*v1n)*v1n;
                v4 = v2 - v3;

                if(norm(v4) < norm(v1))
                    dist = norm(v3) - r;
                else
                    dist = min(norm(pc - obj.P2) - r, norm(pc - obj.P1) - r);
                end
            end
            
            if strcmp(class(obs), 'Semireta')
                a1 = obj.P1;
                b1 = obj.P2;
                a2 = obs.P1;
                b2 = obs.P2;
                
                M = [(b1 - a1) -(b2 - a2)];
                n = a2 - a1;
                
                t = (    M'*M+0.001*eye(2)    ) \  (   M'*n    );
                
                t_til = min(max(t,0), 1);
                dist = norm(M*t_til - n);
                
            end
        end
        
        function [] = desenha(obj, cor)
                    P1 = obj.P1;
                    P2 = obj.P2;
                    plot([P1(1) P2(1)], [P1(2) P2(2)], cor, 'linewidth', 2);
        end
                
    end
end

