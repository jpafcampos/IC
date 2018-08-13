%This function calculates the numerical jacobian for a given configuration
%Inputs:    - the function handle;
%           - the configuration;
%           - the choosen configuration (if necessary)
%Outputs: the jacobian

function [J] = CalcJacobiano(f,q,j)
    m = size(q,1);                      %Dimension of configuration vector
    dt = 0.0001;                        %Derivative interval

    if nargin == 2
        J = [];
        for i=1:m
            dq = zeros(m,1);
            dq(i) = dt;
            C = (f(q+dq) - f(q-dq))/(2*dt);
            J = [J C];
        end
    else
        dq = zeros(m,1);
        dq(j) = dt;
        J = (f(q+dq) - f(q-dq))/(2*dt);
    end
end