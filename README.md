# e-pca

Matlab implementation of E-PCA which is a non-linear dimensionality reduction method particularly suited for probability distribtions, see [Exponential Family PCA for Belief Compression
in POMDPs](http://www.cs.cmu.edu/~ggordon/nickr-ggordon.nips02.pdf). The left figure illustrates a filtered 2D probability distribution of an agent's location in a square world with a red block (goal state) at its center. The right figure is the result of the probability density function being reconstructed after a latent lower dimensional space was leaned via E-PCA.

<p align="center">
<img src="./docs/original_belief.gif" alt="original_belief" height="300" > <img src="./docs/reconstructed_belief.gif" alt="reconstructed_belief" height="300">
</p>
