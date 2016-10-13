# e-pca

Matlab implementation of E-PCA which is a non-linear dimensionality reduction method particularly suited for probability distribtions, see the paper [Exponential Family PCA for Belief Compression
in POMDPs](http://www.cs.cmu.edu/~ggordon/nickr-ggordon.nips02.pdf). The left figure illustrates a filtered 2D probability distribution of an agent's location in a square world with a red block (goal state) at its center. The right figure is the result of the probability density function being reconstructed after a latent lower dimensional space was leaned via E-PCA.

<p align="center">
<img src="./docs/original_belief.gif" alt="original_belief" height="300" > <img src="./docs/reconstructed_belief.gif" alt="reconstructed_belief" height="300">
</p>

In the above animation the origininal dimension of the probabilitiy distribution is 625 and the learned E-PCA latent space
has 8 dimensions. This is a very large compression, we went from 625 dimensions to 8 and as we can see the reconstructed probability distributions (right) are very similar to the original distributions (left).

The optimisation to find the latent space feature space is convex and can be solved though Newton's methods. The matalab implementation follows closely the aglorithm details given in the paper [Finding Approximate POMDP Solutions Through Belief
Compression](https://arxiv.org/pdf/1107.0053.pdf), see page 14.

# Installation 

After downlonading and extracting e-pca to your matlab workspace and you are in the matlab Command Window terminal 
make sure you are loacted outside the e-pca directory and run:

```matlab
>>> addpath(genpath('./e-pca'))
```

# Examples

Two examples are given [Example1.m](https://github.com/gpldecha/e-pca/blob/master/Example1.m), [Example2.m](https://github.com/gpldecha/e-pca/blob/master/Example2.m). The first example compares PCA vs E-PCA on a
auto-generated dataset of multi-modal probability distributions. The second example does the same but with 
a dataset of 2D probability distribtions.

## Example 1

<p align="center">
<img src="./docs/PCA_proj_5.gif" height="300" > <img src="./docs/EPCA_proj5.png" height="300">
</p>

## Example 2






