# e-pca

Matlab implementation of E-PCA which is a non-linear dimensionality reduction method particularly suited for probability distribtions, see the paper [Exponential Family PCA for Belief Compression
in POMDPs](http://www.cs.cmu.edu/~ggordon/nickr-ggordon.nips02.pdf). The left figure illustrates a filtered 2D probability distribution of an agent's location in a square world with a red block (goal state) at its center. The right figure is the result of the probability density function being reconstructed after a latent lower dimensional space was leaned via E-PCA.

<p align="center">
<img src="./docs/original_belief.gif" alt="original_belief" height="300" > <img src="./docs/reconstructed_belief.gif" alt="reconstructed_belief" height="300">
</p>

The optimisation to find the latent space feature space is convex and can be solved though Newton's methods. The matalab implementation follows closely the aglorithm details given in the paper [Finding Approximate POMDP Solutions Through Belief
Compression](https://arxiv.org/pdf/1107.0053.pdf), see page 14.

# Installation 

After downlonading and extracting e-pca to your matlab workspace and you are in the matlab Command Window terminal 
make sure you are loacted outside the e-pca directory and run:

```matlab
>>> addpath(genpath('./e-pca'))
```
