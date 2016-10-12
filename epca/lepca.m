function e = lepca(B,U,hB)
% LEPCA Loss function of E-PCA
%
%   input ---------------------------------------------------------
%
%       o B  : (S x N), Data matrix of S features (dimensions) and N
%                      samples.
%       o U  : (S x l), Projection matrix
%
%       o hB : (l x N), latent space Data matrix
%


   % (S x N) - (S x N) (S x l)(l x N)
   % (S x N) -  (S x N) .* (S x N)
   % (S x N)
   % e = (1 x N)
   e     = sum((exp(U * hB) - B .* (U * hB)));
   e     = mean(e);

end