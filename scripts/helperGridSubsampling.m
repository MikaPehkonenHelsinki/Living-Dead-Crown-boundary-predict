function [pointSparse,labelsSparse] = helperGridSubsampling(ptCloud,labels,gridSize)
% helperGridSubsampling returns downsampled points and corresponding
% labels. The input point cloud is divided into grid boxes of size specified
% by gridSize. Points within each grid box are merged by averaging their
% locations and labels with highest frequency.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
points = ptCloud.Location;
N = size(points,1);

minCorner = min(points);
maxCorner = max(points);
originCorner = floor(minCorner./gridSize)*gridSize;

sampleNX = floor((maxCorner(1)-originCorner(1))/gridSize)+1;
sampleNY = floor((maxCorner(2)-originCorner(2))/gridSize)+1;

combinedArray = zeros(N,5);

for i = 1:N
    iX = floor((points(i,1) - originCorner(1)) / gridSize);
    iY = floor((points(i,2) - originCorner(2)) / gridSize);
    iZ = floor((points(i,3) - originCorner(3)) / gridSize);
    Idx = iX + sampleNX*iY + sampleNX*sampleNY*iZ;

    combinedArray(i,:) = [Idx, points(i,:), double(labels(i,1))];

end

IdxValues = combinedArray(:,1);
uniqueIdxs = unique(IdxValues);

sz = size(uniqueIdxs,1);
pointSparse = zeros(sz,3);
labelsSparse = zeros(sz,1);

if canUseParallelPool
    parfor i = 1:sz
        currentIdxPoints = combinedArray(IdxValues == uniqueIdxs(i),:);
        pointSparse(i,:) = mean(currentIdxPoints(:,2:4),1);
        labelsSparse(i,:) = mode(currentIdxPoints(:,5),"all");
    end
else
    for i = 1:sz
        currentIdxPoints = combinedArray(IdxValues == uniqueIdxs(i),:);
        pointSparse(i,:) = mean(currentIdxPoints(:,2:4),1);
        labelsSparse(i,1) = mode(currentIdxPoints(:,5),"all");
    end
end

end

