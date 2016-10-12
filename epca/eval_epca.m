function [L,KL ] = eval_epca(B,basis_range,epca_options,options )
%EVAL_EPCA Evaluate the performance of E-PCA
%
%   input ---------------------------------------------------------------
%
%       o B  : (D x N), set of N beliefs of dimension D
%
%       o U  : (D x N-1), set of N-1 eigenvectors
%
%       o basis_range: (1 x M), range of eigenvectors to retain in the
%                               dimensionality reduction transformation.
%
%   output -------------------------------------------------------------
%
% 


if ~exist('options','var'), options = [];end
if ~isfield(options,'metric'),options.metric='L2';end
if ~isfield(options,'bPrint'),options.bPrint=false;end

bPrint = options.bPrint;

M  = size(basis_range,2);
L  = zeros(M,2);
KL = zeros(M,2);

hB = [];
U  = [];

[S,N] = size(B);

for i=1:M
    
    if bPrint,disp(['eval_it:' num2str(i) '/' num2str(M)]);end
    
    
    epca_options.l       = basis_range(i);
    epca_options.bPrint  = true;
    
    [hB_init,U_init] = init_epca_U_B(epca_options.l,S,N);

    
%     if ~isempty(U)    
%         U_init(:,1:end-1)  = U;
%        hB_init(1:end-1,:) = hB;
%     end

    epca_options.U  = U_init;
    epca_options.hB = hB_init;
    
    [U,hB]      = epca(B,epca_options);
    B_proj      = exp(U * hB);

    e           = sum(((B - B_proj).^2));

    L(i,1)      = mean(e);
    L(i,2)      = std(e);
    
       kl       = kl_divergence(B,B_proj);
   KL(i,1)      = mean(kl);
   KL(i,2)      = std(kl);

end




end

