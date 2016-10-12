%% Example 2: 2D belief compression
%
%   Make sure inside that you are outside the e-pca directory in the 
%   Command Window. The run the following command:
%
%   addpath(genpath('./e-pca'))
%
clear all;

%% Load probababilities
%
%   First you will load a dataset, B, consisting of 2D probability
%   distributions. Each column corresponds to a probability distribution
%   and each row to the values of state.
%
%

load('./e-pca/parameters/B.mat','B');

% B : dimensions x number of samples.

%% Print Original data

close all;

set(0,'defaulttextinterpreter','latex')


if ~exist('hf1_pos','var'), hf(1) = figure; else hf(1) = figure('Position',hf1_pos);end
set(gcf,'color','w');set(gca,'FontSize',18);


id              = 15;

nbSamples       = 25;
xs              = linspace(-12,12,nbSamples);
ys              = linspace(-12,12,nbSamples);
[X,Y]           = meshgrid(xs,ys);
grid_pts        = [X(:),Y(:)];

X               = reshape(grid_pts(:,1),25,[]);
Y               = reshape(grid_pts(:,2),25,[]);
w               = rescale(B(:,id),min(B(:,id)),max(B(:,id)),0,1);


contourf(X,Y,reshape(w,25,[]));
rectangle('Position',[-10 -10 20 20]);
rectangle('Position',[-1 -1 2 2],'FaceColor',[1 0 0],'EdgeColor','k','LineWidth',2);
axis([-15 15 -15 15]);
set(gca,'XTick',[-12,0,12]);
set(gca,'YTick',[-12,0,12]);
title(['Original belief(' num2str(id) ')'],'FontSize',20);
xlabel('$x_1$','FontSize',20);
ylabel('$x_2$','FontSize',20,'Rotation',360);
axis square;
c = colorbar;
ylabel(c,'$P(x_1,x_2)$','FontSize',16,'Interpreter','Latex');

%% Save figure

print(hf(1),['./e-pca/docs/pdf_' num2str(id) '.svg'],'-dsvg');

%% E-PCA
%   
%  RUn E-PCA on the data set B until termination (this might take a lot of
%  time depending on your computer. If taking too long you just load the
%  parameters -> see %% Load E-PCA parametrs [1]
%

eoptions.l               = 25;
eoptions.regulisation    = 1e-4;
eoptions.bPrint          = true;
eoptions.stop_threashod  = 1e-10;
eoptions.MaxIter         = 100;

[U,hB]                   = epca(B(:,1:5:end),eoptions);

load('B.mat','B');


%% Save E-PCA parameters

save('./e-pca/parameters/U.mat','U');
save('./e-pca/parameters/hB.mat','hB');

%% Load E-PCA parameters [1]
clear all;

load('./e-pca/parameters/B.mat','B');
load('./e-pca/parameters/U.mat');
load('./e-pca/parameters/hB.mat');

%% Check Reconstruction
%
%   To evaluate the quality of the basis found by E-PCA we are going to
%   visually inspect the reconstruction of B from the low dimensional
%   represetnation.
%

el_options                = [];
el_options.MaxIter        = 2000;
el_options.stop_threashod = 1e-100;
el_options.regulisation   = 0;

id                        = 20; % which belief we want to reconstruction
hb                        = epca_lw(B(:,id),U,el_options);
B_proj                    = exp(U*hb);


%% Get figure pos handles

hf1_pos = get(hf(1),'Position');
hf2_pos = get(hf(2),'Position');

%% Plot Original vs Projected Belief 


close all;

nbSamples       = 25;
xs              = linspace(-12,12,nbSamples);
ys              = linspace(-12,12,nbSamples);
[X,Y]           = meshgrid(xs,ys);
grid_pts        = [X(:),Y(:)];


% ------------ Plot Original Belief ------------ %

if ~exist('hf1_pos','var'), hf(1) = figure; else hf(1) = figure('Position',hf1_pos);end
set(gcf,'color','w');


X = reshape(grid_pts(:,1),25,[]);
Y = reshape(grid_pts(:,2),25,[]);
w = rescale(B(:,id),min(B(:,id)),max(B(:,id)),0,1);

contourf(X,Y,reshape(w,25,[]));
rectangle('Position',[-10 -10 20 20]);
rectangle('Position',[-1 -1 2 2],'FaceColor',[1 0 0],'EdgeColor','k','LineWidth',2);
set(gca,'XTick',[-12,0,12]);
set(gca,'YTick',[-12,0,12]);
title(['Original belief(' num2str(id) ')'],'FontSize',20);
xlabel('$x_1$','FontSize',20);
ylabel('$x_2$','FontSize',20,'Rotation',360);
axis square;
colorbar;

title(['Original belief('  num2str(id) ')']);

% ------------ Plot Reconstruction ---------------- %

if ~exist('hf3_pos','var'), hf(2) = figure; else hf(2) = figure('Position',hf2_pos);end
set(gcf,'color','w');

w = rescale(B_proj,min(B_proj),max(B_proj),0,1);

contourf(X,Y,reshape(w,25,[]));
rectangle('Position',[-10 -10 20 20]);
rectangle('Position',[-1 -1 2 2],'FaceColor',[1 0 0],'EdgeColor','k','LineWidth',2);
set(gca,'XTick',[-12,0,12]);
set(gca,'YTick',[-12,0,12]);
title(['Original belief(' num2str(id) ')'],'FontSize',20);
xlabel('$x_1$','FontSize',20);
ylabel('$x_2$','FontSize',20,'Rotation',360);
axis square;
colorbar;

title(['Projected (2) Belief(' num2str(id) ')']);

%% Save figure

print(hf(1),['./e-pca/docs/original_pdf_' num2str(id) '.svg'],'-dsvg');
print(hf(1),['./e-pca/docs/reconstructed_pdf_' num2str(id) '.svg'],'-dsvg');

