function net = helperLoadRandLANet(numClasses,randla)
% helperLoadRandLANet function returns RandLANet network as dlnetwork.
% This dlnetwork is initialized with random weights.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
data = load(randla);
net = data.net;

if numClasses ~= 8
    FilterSize = [1 1];
    NumFilters = numClasses;
    NumChannels = 32;
    Weights = "he";
    lastLayer = convolution2dLayer(FilterSize,NumFilters,"NumChannels",NumChannels,"WeightsInitializer",Weights,"Name","FC4");
    net = replaceLayer(net,'FC4',lastLayer);
end
end