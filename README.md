# **Predict Living and Dead Crown Boundary Heights of Norway Spruce and Scots Pine**

This demo project contains source code for:

  1. Training of a deep learning RandLA-Net (https://arxiv.org/abs/1911.11236) segmentation model (MATLAB code in train.mlx).

  2. Predicting point classes—stem, living crown, and dead crown—for cleaned Norway spruce or Scots pine point clouds (MATLAB code in predict.mlx).

  3. Post-processing the segmented point clouds and extracting predicted heights of the living and dead crowns (Python code in the Jupyter notebook GetCrownBoundaries.ipynb).

The project includes a set of Norway spruce point clouds for demonstration purposes. The source code includes instructions and scripts for package installation.

Dataset containing 100 manually annotated Scots pine and Norway spruce terrestrial laser scanning point clouds used for training and model validation can be found at:
https://zenodo.org/records/19328265
