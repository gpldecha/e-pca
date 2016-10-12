function [ e_mean,e_std ] = lpca(X,hX)
%LPCA Loss function of Principal Component Analysis
%   PCA projectes a high dimensional vector to a low dimensional feature
%   vector through a linear transformation of the form  y = Ax
%
%   input ---------------------------------------------------------------
%
%       o X: (D x N), high dimensionial, D, data matrix of N samples.
%
%       o hX: (D x N), reprojected low dimensional data to high D
%
%   output --------------------------------------------------------------
%   
%       o e: (1 x 1), sum of square error between original data and
%                     reprojected data.
%
%
%   comment -------------------------------------------------------------
%
%       Loss = 1/N sum_i^N ||X(:,i) - hX(:,i)||^2,   average reconstruction error    
%
%         hX = A' * Y, low-dimensional samples Y projected back to high
%                      dimensional space.
%
%           
%


% (D x N) - (D x N)
e_mean = mean( sum(((X - hX).^2)) );
e_std  =  std( sum(((X - hX).^2)) );

end

