classdef (Abstract) Obstaculo
   %classe abstrata obstaculo
    properties
    end
    
    methods (Abstract)
        dist = calcdist(obj, obs); %funcao a ser herdada pelas subclasses concretas
        
        [] = desenha(obj);
    
    end
end

