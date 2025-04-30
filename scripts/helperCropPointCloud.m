function [pc,idxs,possibility] = helperCropPointCloud(ptCloud,kdtree,numPoints,possibility)
% The helperCropPointCloud function crop out fixed number of points (numPoints)
% with center point as point with lowest possibility. This process is
% iterated to make sure all points were tested.

% Copyright 2023 The MathWorks, Inc.

% Pick point with lowest probability as the center point each time
% during inference.
[~,pickIdx] = min(possibility);
pc = ptCloud.Location;
centerPoint = pc(pickIdx,:);

% A fixed number of points are selected based on Kd-tree
if (size(pc,1) < numPoints)
    diff = numPoints - size(pc,1);
    idxs = 1:size(pc,1);
    temp = [randi(size(pc,1),1,diff)];
    idxs = [idxs, temp];
else
    idxs = kdtree.knnSearch(centerPoint,numPoints);
end

% to shuffle idxs
indices = randperm(numPoints);
idxs = idxs(indices);
pc = pc(idxs,:);

% Increase the possibility (i.e. probability) of the selected point,
% this value is calculated based on the distance of the center point.
dists = sum((pc-centerPoint).^2,2);
delta = (1-(dists/max(dists))).^2;

if size(possibility,1)==1
    % To avoid infite while loop for ptCloud.Count = 1
    possibility = 0.6;
else
    possibility(idxs) = possibility(idxs) + delta;
end

end