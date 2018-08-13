classdef Circulo < Obstaculo
    properties
        Raio
        Xc %
        Yc %coordenadas do centro
    end
    
    
    methods
        function thisCirculo = Circulo(raio, xc, yc) %construtor
            if 3 == nargin
                thisCirculo.Raio = raio;
                thisCirculo.Xc = xc;
                thisCirculo.Yc = yc;
            end
        end

        function [dist] = calcdist(obj, obs)
            %distancia de segmento ate o circulo
            if strcmp(class(obs), 'Circulo')
                c1 = [obj.Xc, obj.Yc];
                c2 = [esfera.Xc, esfera.Yc];
                v = c2 - c1;

                dist = norm(v) - obj.Raio - esfera.Raio;
                
            end
            
            if strcmp(class(obs), 'Semireta')
                dist = obs.calcdist(obj);
            end

            
        end
        
        function [] = desenha(obj, cor)
            xc = obj.Xc;
            yc = obj.Yc;
            r = obj.Raio;
            plot (xc + r*cos(0:0.1:2*pi), yc + r*sin(0:0.1:2*pi));
        end
    end
end