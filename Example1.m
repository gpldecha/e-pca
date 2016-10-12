%  Example1
%
%   Make sure inside that you are outside the e-pca directory in the 
%   Command Window. The run the following command:
%
%   addpath(genpath('./e-pca'))
%
%   In this example we will compare E-PCA and PCA on the ability to find a latent space
%   of a set of 1D probability density functions.
%
%   [1] Generate a data set consisting of probability distribtions.
%
%   [2] Find latent space given by PCA and evaluate it in terms of the
%       reconstruction error and KL-divergence.
%
%   [3] Same as [2] but for E-PCA 
%

%% Generate a set of beliefs [1]

nbGMMs = 250;

xs = linspace(-20,180,200);
B  = zeros(200,nbGMMs);

for i=1:nbGMMs
    
a = 1; b = 10;
K = floor(a + (b-a).*rand);

tmp = zeros(3,K);

tmp(1,:) = ones(1,K)./K;

a = 10;
b = 100;
tmp(2,:) =(a + (b-a).*rand(1,K));

tmp(3,:) = ones(1,K);

a = 100; b = 200;
for k=1:K
    tmp(3,k) = tmp(3,k) * (a + (b-a).*rand);
end
B(:,i) =  gmm_pdf(xs,tmp(1,:),tmp(2,:),tmp(3,:));

end
%% Plot GMMs [1]

close all;
figure;
hold on;
for i=1:size(B,2)
   plot(xs,B(:,i),'Color',rand(1,3));   
end

%% Evalute PCA [2]
U              = pca(B'); 

options.bPrint = false;
options.metric = 'L2';
basis_range    = 1:10;

L_pca          = eval_pca(B,U,basis_range,options);

options.metric = 'KL';
KL_pca         = eval_pca(B,U,basis_range,options);



%% Evaluate E-PCA [3]


epca_options.regulisation    = 1e-8;
epca_options.bPrint          = false;
epca_options.stop_threashod  = 1e-4;

options.bPrint               = true;

[L_epca,KL_epca]             = eval_epca(B,basis_range,epca_options,options);


%% Plot results of PCA and E-PCA evaluation

close all;
hf = figure;

subplot(1,2,1); hold on;
errorbar(basis_range,L_pca(:,1),L_pca(:,2),'LineWidth',1.5);
errorbar(basis_range,L_epca(:,1),L_epca(:,2),'LineWidth',1.5);


legend('PCA','E-PCA');
xlabel('Eigen-vectors');
ylabel('Reconstruction error');
xlim([basis_range(1),basis_range(length(basis_range))]);
set(gca,'XTick',basis_range);
set(gca,'XTickLabel',cellfun(@num2str, num2cell(basis_range), 'UniformOutput', false))

grid on; box on;
set(gca,'FontSize',12);

axis square;

subplot(1,2,2); hold on;
errorbar(basis_range,KL_pca(:,1),KL_pca(:,2),'LineWidth',1.5);
errorbar(basis_range,KL_epca(:,1),KL_epca(:,2),'LineWidth',1.5);


legend('PCA','E-PCA');
xlabel('Eigen-vectors');
ylabel('KL divergence');
xlim([basis_range(1),basis_range(length(basis_range))]);
set(gca,'XTick',basis_range);
set(gca,'XTickLabel',cellfun(@num2str, num2cell(basis_range), 'UniformOutput', false))

axis square;

grid on; box on;
set(gca,'FontSize',12);

%% Save plot results

print(hf,'./e-pca/docs/PCA_EPCA.svg','-dsvg');


%% Reproject PCA

U          = pca(B'); 
num_bases  = 5;
B_proj     = U(:,1:num_bases) * (U(:,1:num_bases)' * B);

min_p = min(B_proj);
max_p = max(B_proj);

for j=1:size(B_proj,2)
    B_proj(:,j) = rescale(B_proj(:,j),min_p(j),max_p(j),0,max_p(j));
    B_proj(:,j) =  B_proj(:,j)./sum( B_proj(:,j) );
end


%% Plot re-porjection PCA


id           = 2;
[e_mu,e_std] = lpca(B,B_proj);
KL           = kl_divergence(B(:,id),B_proj(:,id));

close all;
hf = figure; hold on;
plot(xs,B(:,id),'-b','LineWidth',2);
plot(xs,B_proj(:,id),'--r','LineWidth',2);

legend('original','project');
title(['PCA Belief(' num2str(id) ')']);

str = {['#basis :   ' num2str(num_bases)],['SE : ' num2str(e_mu)],['KL: ' num2str(KL)]};

ha = annotation('textbox', [0.15,0.8,0.1,0.1],'String', str);

set(gca,'FontSize',12);
box on; grid on;

%% Save plot results

print(hf,['./e-pca/docs/PCA_proj_' num2str(num_bases) '.svg'],'-dsvg');


%% Re-project E-PCA

eoptions.l               = 5;
eoptions.regulisation    = 1e-10;
eoptions.bPrint          = true;
eoptions.stop_threashod  = 1e-5;

[U,hB]                   = epca(B,eoptions);

B_proj = exp(U*hB);

%% Plot reprojection E-PCA

id   = 2;
SE   = sum((B(:,id) - B_proj(:,id)).^2);
KL   = kl_divergence(B(:,id),B_proj(:,id));

close all;
hf = figure; hold on;
plot(xs,B(:,id),'-b','LineWidth',2);
plot(xs,B_proj(:,id),'--r','LineWidth',2);

legend('original','project');
title(['E-PCA Belief(' num2str(id) ')']);

str = {['#basis :   ' num2str(eoptions.l)],['SE : ' num2str(SE)],['KL: ' num2str(KL)]};

ha = annotation('textbox', [0.15,0.8,0.1,0.1],'String', str);

set(gca,'FontSize',12);
box on; grid on;



%% Save plot results

print(hf,['./e-pca/docs/EPCA_proj' num2str(eoptions.l) '.svg'],'-dsvg');







