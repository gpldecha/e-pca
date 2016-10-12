function [ L ] = eval_pca(B,U,basis_range,options)
%COMPUTE_LSE Computes the reconstruction error as a function of the number
%of retained eigenvectors.
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
%       o SE : (M x 2), sum of square error average and standard deviation
%
%

if ~exist('options','var'), options = [];end
if ~isfield(options,'metric'),options.metric='L2';end
if ~isfield(options,'bPrint'),options.bPrint=false;end

bPrint  = options.bPrint;

if strcmp(options.metric,'L2')
    
    M  = size(basis_range,2);
    L = zeros(M,1);
    for i=1:M
        
        if bPrint,disp(['eval_it:' num2str(i) '/' num2str(M)]);end
        
        
        num_bases = basis_range(i);
        hB         =  U(:,1:num_bases) * (U(:,1:num_bases)' * B);
        
        [e_mu,e_std] = lpca(B,hB);
        
        L(i,1) = e_mu;
        L(i,2) = e_std;
        
    end
    
elseif strcmp(options.metric,'KL')
    
    M  = size(basis_range,2);
    L = zeros(M,2);
    for i=1:M
        
        if bPrint,disp(['eval_it:' num2str(i) '/' num2str(M)]);end
        
        
        num_bases = basis_range(i);
        
        % (D X N)
        hB     =  U(:,1:num_bases) * (U(:,1:num_bases)' * B);
        
        min_p = min(hB);
        max_p = max(hB);
        
        for j=1:size(hB,2)
            hB(:,j) = rescale(hB(:,j),min_p(j),max_p(j),0,max_p(j));
            hB(:,j) =  hB(:,j)./sum( hB(:,j) );
        end
        
        kl     = kl_divergence(B,hB);
        L(i,1) = mean(kl);
        L(i,2) = std(kl);
        
    end
    
else
    
    error(['no such metric: ' options.metric ' defined']);
    
end





end

