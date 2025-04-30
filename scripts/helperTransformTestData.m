function out= helperTransformTestData(ptCloud,size)
% helperTransformTestData function applies the following transformations on
% test data:
% 1. Downsample the point clouds using grid subsampling to equalize the
% density of point cloud.
% 2. Find 1-nearest neighbors in downsampled point cloud to each point in
% dense point cloud for interpolation of labels in postprocessing.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
% Block the input point cloud.
%numGridsX = round((diff(ptCloud.XLimits)+eps)/blocksize(1));
%numGridsY = round((diff(ptCloud.YLimits)+eps)/blocksize(2));
%[~, ~, ~, indx, indy] = histcounts2(ptCloud.Location(:,1), ptCloud.Location(:,2), ...
%    [numGridsX,numGridsY],'XBinLimits', ptCloud.XLimits, 'YBinLimits', ptCloud.YLimits);

% Initialize blockIdx to save indices of blocked point cloud.
%blockIdx = zeros(size(ptCloud.Location, 1), 1,'logical');

%ind = sub2ind([numGridsX,numGridsY], indx, indy);
%out = cell(1,numGridsX*numGridsY);
%for num=1:numGridsX*numGridsY
    %idx = ind==num;
    
    % Blocked point cloud.
    ptCloudDense = ptCloud;

    % Use helperPointCloudNormalization function, attached to this example as a
    % supporting file, to normalize the point cloud to range [0,1].
    ptCloudNormalized = ptCloudDense%helperPointCloudNormalization(ptCloudDense);

    % Downsample the point cloud.
    gridSize = size;
    ptCloudSparse = pcdownsample(ptCloudNormalized,'gridAverage',gridSize);

    % Create Kd-tree for sparsed point cloud.
    kdtree = vision.internal.Kdtree();
    kdtree.index(ptCloudSparse.Location);

    % Searches for 1-nearest neighbors in sparse point cloud to each point
    % in original point cloud.
    projectedIndices = kdtree.knnSearch(ptCloudNormalized.Location,1);

    %blockIdx = blockIdx|idx;

    out = {ptCloudSparse,kdtree,projectedIndices};
%end

end