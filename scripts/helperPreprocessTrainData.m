function out = helperPreprocessTrainData(ptCloud,labels,classNames)
% helperPreprocessTrainData function returns the input data that is
% compatible with network input layer. This function crops a fixed number
% of points in the input point cloud from a center point and extracts the
% network input data
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
points = ptCloud.Location;
labels = labels{1};
N = size(points,1);
numPoints = 45056;

% Create kd-tree object for KNN.
kdtreeObject = vision.internal.Kdtree();
kdtreeObject.index(points);

% Crop a point cloud of fixed number of points, numPoints around a
% randomly selected center point i.e., centerPoint.
centerIdx = randperm(N,1);
centerPoint = points(centerIdx,:);

if (N < numPoints)
    diff = numPoints - N;
    idxs = 1:N;
    temp = [randi(N,1,diff)];
    idxs = [idxs, temp];
else
    idxs = kdtreeObject.knnSearch(centerPoint,numPoints);
end

% To shuffle idxs.
indices = randperm(numPoints);
idxs = idxs(indices);

% Get cropped points and corresponding labels.
selectedIdxs = idxs;
pc = points(idxs,:);
labels = labels(selectedIdxs);
labels = onehotencode(labels,2,'ClassNames',classNames);

% Use helperComputeInputs function, attached to this example as a supporting file,
% to extract input required by network.
out = helperComputeInputs(pc,[],[],labels,'train');

end