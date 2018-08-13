function [ U ] = calcula_velocidade_alvo( q, q_d, erro, Omega, A, b )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    eta = 0.2;
    k = 1;
    jacOmega = calcJac(Omega, q);
    q_dot_d = -k*(q-q_d);
    H = 2*(eye(length(q)));
    f = -2*q_dot_d;
    b_omega = [-eta*(Omega(q)+0.1)];
    b_til = [b(q); b_omega];
    A_til = [A(q); jacOmega];
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
    U = quadprog(H, f, A_til, b_til,[],[],[],[],[],[], options);

end


