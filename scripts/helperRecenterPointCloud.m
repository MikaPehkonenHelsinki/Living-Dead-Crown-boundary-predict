function [point] =  helperRecenterPointCloud(point)
% helperRecenterPointCloud returns point recentered to origin.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
dim = [1 2];
meanPtCloud = mean(point);
point(:,dim) = point(:,dim) - meanPtCloud(dim);

end