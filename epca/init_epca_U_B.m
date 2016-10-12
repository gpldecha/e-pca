function [hB,U] = init_epca_U_B(l,S,N)
%INIT_EPCA_U_B Summary of this function goes here
%   Detailed explanation goes here
ran = @(a,b,N,M)a + (b-a).* rand(N,M);

hB = ran(-1,1,l,N);
U  = ran(-1,1,S,l);

end

