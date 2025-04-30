function preprocessedInput = helperComputeInputs(pc,ExecutionEnvironment,selectedIdxs,labels,mode)
% helperComputeInputs returns input data that is compatible with
% network input layer.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
% The computeInputs function computes inputs required by RandLANet.
pc = helperRecenterPointCloud(pc);

% Number of encoding-decoding layers
numLayers = 4;

% Ratio by which point cloud will be downsampled after each layer
% i.e., (N --> N/4 --> N/16 --> N/64 --> N/256)
subSamplingRatio = [4 4 4 4];

% store x,y,z coords of point cloud for 4 encoding layers
inputPoints = cell(1,numLayers);
% store indices of k neighbour points for each points in inputPoints
inputNeighbors = cell(1,numLayers);
% store indices of the points that are subsampled at each encoding layer
inputPools = cell(1,numLayers);
% store indices of the points that will be used for interpolation at
% each decoding layer
inputUpSample = cell(1,numLayers);

features = single(pc);

% Create kd-tree object for KNN
kdtreeObject = vision.internal.Kdtree();
kdtreeObject.index(pc);

for i = 1:numLayers
    % Calculate neighbor indices
    K = 16; % No. of nearest neighbors
    neighbourIdx = transpose(kdtreeObject.knnSearch(pc, K));

    subPoints = pc(1:floor((size(pc,1))/subSamplingRatio(i)),:);
    poolIdx = neighbourIdx(1:floor((size(pc,1))/subSamplingRatio(i)),:);

    % Calculate upsample indices
    if kdtreeObject.needsReindex(subPoints)
        kdtreeObject.index(subPoints)
    end
    K = 1;  % No. of nearest neighbors
    upIdx = transpose(kdtreeObject.knnSearch(pc, K));

    inputPoints{i} = single(pc);
    inputNeighbors{i} = int64(neighbourIdx-1);
    inputPools{i} = int64(poolIdx-1);
    inputUpSample{i} = int64(upIdx-1);
    pc = subPoints;
end

if strcmp(mode,'train')
    % reshape the input for RandLANet network input layer
    func = @(x)reshape(single(x),size(x,1),1,size(x,2));
    coords = cellfun(func,inputPoints,'UniformOutput',false);
    features = func(features);
    labels = func(labels);
    func = @(x)reshape(single(x),size(x,1),size(x,2));
    neighbourIndices = cellfun(func,inputNeighbors,'UniformOutput',false);
    interpIndices = cellfun(func,inputUpSample,'UniformOutput',false);
    subIndices = cellfun(func,inputPools,'UniformOutput',false);

    preprocessedInput = {features, ...
        neighbourIndices{1},coords{1},neighbourIndices{1},neighbourIndices{1},subIndices{1}, ...
        neighbourIndices{2},coords{2},neighbourIndices{2},neighbourIndices{2},subIndices{2}, ...
        neighbourIndices{3},coords{3},neighbourIndices{3},neighbourIndices{3},subIndices{3}, ...
        neighbourIndices{4},coords{4},neighbourIndices{4},neighbourIndices{4},subIndices{4}, ...
        interpIndices{4},interpIndices{3},interpIndices{2},interpIndices{1},labels};

else
    % store indices of cropped point cloud
    pointIdxs = int64(selectedIdxs);
    if (strcmp(ExecutionEnvironment,'auto') && canUseGPU) || strcmp(ExecutionEnvironment,'gpu')
        func = @(x)gpuArray(x);
        inputPoints = cellfun(func,inputPoints,'UniformOutput',false);
        inputNeighbors = cellfun(func,inputNeighbors,'UniformOutput',false);
        inputPools = cellfun(func,inputPools,'UniformOutput',false);
        inputUpSample = cellfun(func,inputUpSample,'UniformOutput',false);
        features = gpuArray(features);
        pointIdxs = gpuArray(pointIdxs);
    end
    preprocessedInput = {inputPoints,inputNeighbors,inputPools,inputUpSample,features,pointIdxs};
end

end