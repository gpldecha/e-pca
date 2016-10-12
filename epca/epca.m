function [U,hB] = epca(B,options)
%EPCA Exponential-PCA, finds a nonlinear projection to a latent space z,
% given orignal space x.
%
%   input ---------------------------------------------------------------
%
%       o B : (D x N), Data matrix 
%
%   output --------------------------------------------------------------
%
%       o U  : (D x l), projection matrix
%
%       o hB : (l x N), latent space Data matrix
%
%  commnet --------------------------------------------------------------
%
%           z = exp( U * x' )
%

[D,N] = size(B);


if ~exist('options','var'),options=[];end

if ~isfield(options,'l')
    options.l = N-1;
else
    if options.l > N-1
        options.l = N-1;
        warning('Numver of dimensions in latent space cannot be greater than N-1');
    end
end
if ~isfield(options,'regulisation'),    options.regulisation=1e-8;  end
if ~isfield(options,'bPrint'),          options.bPrint=false;       end
if ~isfield(options,'stop_threashod'),  options.stop_threashod=1e-4;end
if ~isfield(options,'MaxIter'),         options.MaxIter=25;         end



l              = options.l;
Il             = eye(l,l) .*  options.regulisation;
bPrint         = options.bPrint;
stop_threashod = options.stop_threashod;
MaxIter        = options.MaxIter;

% initialise U and hB randomely

ran = @(a,b,N,M)a + (b-a).* rand(N,M);

if ~isfield(options,'hB'),  options.hB = ran(-3,3,l,N);     end
if ~isfield(options,'U'),   options.U  = ran(-3,3,D,l);     end


% (l x N)
hB =  options.hB;%ran(-3,3,l,N);
% (S x l)
U   = options.U;%ran(-3,3,S,l);

it   = 1;
bRun = true;

epsilons = [];
delta_e  = Inf;

if bPrint, tic;end
if bPrint, disp('- start E-PCA -');end

disp(['U  : (' num2str(size(U,1))  ' x ' num2str(size(U,2)) ')']);
disp(['hB : (' num2str(size(hB,1)) ' x ' num2str(size(hB,2)) ')']);

while(bRun)
    % for each column of hB(.,j) compute new hB(:,j) using current estimate
    % from 26
    for j=1:N
        
        %(S x S) = (S x l) * (l x 1)
        Dj    = diag(exp(U * hB(:,j)));
        invDj = diag(1./(exp(U * hB(:,j)) + realmin ));
        
        % (l x S) * (S x S)  * (S x l)(l x 1) + (S x S)  ( (S x 1) - (S x l)(l x 1)  )
        % (l x S) * (S x 1) = (l x 1)
        %           (l x l)
        
        
                
         hB(isinf(Dj))    = ran(-1,1,1,1);
         hB(isinf(hB))    = ran(-1,1,1,1);
         hB(isinf(invDj)) = ran(-1,1,1,1);
        
        %          (1 x l) (l x l) = (1 x l)
        hB(:,j) = ((U'      *    Dj   * (U  * hB(:,j)   + invDj  * ( B(:,j) - exp(U*hB(:,j)))))' * pinv(U' * Dj * U + Il))';
        
    end
    
    % for each row in U(i,:) compute U(i,:) new using hB
    
    for i=1:D
        
        %   (N x N) = (1 x l)(l x N)
        Di    = diag(exp(U(i,:) * hB));
        invDi = diag(1./(exp(U(i,:) * hB)+realmin));
        
        % {(1 x l)(l x N)  + [(1 x N) - (1 x l)(l x N)] * (N x N)}
        %      [(1 x N)     +  (1 x N)]  * (N x N) * (N x l)
        %        (1 x N)(N x N)(N x l) = (1 x l)
        
        % (l x N)(N x N)(N x l) + (l x l) = (l x l)
        
         hB(isinf(Di))    = ran(-1,1,1,1);
         U(isinf(U))      = ran(-1,1,1,1);
         hB(isinf(invDi)) = ran(-1,1,1,1);

        
        U(i,:) =  ((U(i,:) * hB + (B(i,:) - exp(U(i,:) * hB))* invDi) * Di * hB') * pinv(hB * Di * hB' + Il);
        
    end
    
    epsilon  = lepca(B,U,hB);
    epsilons = [epsilons;epsilon];
    
    if size(epsilons,1) >= 2
        delta_e = abs(epsilons(it) - epsilons(it-1));
    end

    
    if bPrint
        disp(['it(' num2str(it) ') Loss: ' num2str(mean(epsilon)) ' delta_e: ' num2str(delta_e)]);
    end
    
    
    if size(epsilons,1) >= 2
       if delta_e < stop_threashod
          bRun = false;
          if bPrint, disp('termination condition reached');end
       end
    end
    
    if it >= MaxIter 
        bRun = false;
        if bPrint, disp(['termination MaxIter(' num2str(MaxIter) ') reached']);end
    end
    
    
     it = it + 1;
    
end

if bPrint, toc;end
if bPrint, disp('finished');end



end

