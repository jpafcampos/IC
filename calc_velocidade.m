function [ U ] = calc_velocidade( q, erro, Omega, A, b )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    eta = 0.2;
    k = 1;
    jacOmega = calcJac(Omega, q);
    J = calcJac(erro, q);
    H = 2*J'*J+0.01*eye(size(q,1));
    f = 2*J'*k*erro(q);
    b_omega = [-eta*(Omega(q)+0.1)];
    b_til = [b(q); b_omega];
    A_til = [A(q); jacOmega];
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
    U = quadprog(H, f, A_til, b_til,[],[],[],[],[],[], options);

end



