function [hB] = epca_lw(B,U,options)
%EPCA_LW Gets low dimensional space representation of vector B given
% transformation matrix U. This is for E-PCA.
%
%   input ----------------------------------------------------------------
%
%       o B : (S x 1), Original high dimensional point.
%
%       o U : (S x l), Projection matrix obtained through E-PCA
%                      optimisation.
%
%   output ---------------------------------------------------------------        
%
%       o hB: (l x 1), Low dimensional projection of B
%
%   
%


if ~exist('options','var'),options=[];end
if ~isfield(options,'regulisation'),    options.regulisation   =1e-8;  end
if ~isfield(options,'MaxIter'),         options.MaxIter        =50;    end
if ~isfield(options,'stop_threashod'),  options.stop_threashod =1e-8;  end



l     = size(U,2);
ran   = @(a,b,N,M)a + (b-a).* rand(N,M);
hB    = ran(-1,1,l,1);
hBtmp = hB;

Il             = eye(l,l) .*  options.regulisation;
stop_threashod = options.stop_threashod;
MaxIter        = options.MaxIter;


it   = 1;
bRun = true;
while(it <= MaxIter && bRun)    
    
    if sum(isnan(hB))
            hB    = ran(-1,1,l,1);
            hBtmp = hB;
            MaxIter = 100;
            Il             = eye(l,l) .* 1e-5;
    end
    
  
    Dj = diag(exp(U * hB));
    tmp = U' * Dj * U;
    
    part1 = (U' * Dj * (U  * hB   + diag(1./diag(Dj))  * ( B - exp(U*hB))));
    
   % hB = 
   % hB = (part1' * inv(tmp + Il))';
    hB = (part1' / (tmp + Il))';
    it = it + 1;
    
    if( mean((hB - hBtmp).^2) <= stop_threashod)
        bRun = false;
    end
    
    hBtmp = hB;
end





end

