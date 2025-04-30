function [out,possibility] = helperPreprocessTestData(blockPtCloudSparse,tree,possibility,exeEnv)
% The helperPreprocessTestData function processes the input point cloud 
% test data to fit the input requirements of RandLANet.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
numPoints = 45056;

% Use helperCropPointCloud function, attached to this example as a
% supporting file, to crop out fixed number of points.
[pc,selectedIndices,possibility] = helperCropPointCloud(blockPtCloudSparse,tree,numPoints,possibility);

% Use helperComputeInputs function, attached to this example as a
% supporting file, to extract input required by network.
out = helperComputeInputs(pc,exeEnv,selectedIndices,[],'test');

end