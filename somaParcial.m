function [ sum ] = somaParcial( x , n )
%retorna a soma das entradas 1 até n do vetor x
%ex: somaParcial ( [1,2,3], 2 ) == 3
    sum = 0;
    for i=1:n
        sum = sum + x(i);
    end
end

