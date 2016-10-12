function dist = kl_divergence( P,Q )
%   KL_DIVERGENCE 
%
%   input --------------------------------------------
%
%       o P  : ( D x N ) , N probabilies of the pdf evalueated of at each of
%                          the D states.
%
%       o Q  : ( D x N ) , second probability distribution 
%

P = P + realmin;
Q = Q + realmin;
D = size(P,1);
P = P./repmat(sum(P,1),D,1);
Q = Q./repmat(sum(Q,1),D,1);

dist = sum(P .* (log(P) - log(Q)),1);

end

