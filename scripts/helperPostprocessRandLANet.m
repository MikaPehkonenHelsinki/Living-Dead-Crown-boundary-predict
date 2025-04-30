function [oriPredLabels,flag,predLabels] = helperPostprocessRandLANet(out,predLabels,possibility,pointInds,projInds,flag)
% The helperPostprocessRandLANet function post processes the output of
% RandLANet network.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
results = squeeze(out);
endThreshold = 0.5;

% Update the network output probability and
% predicted labels.
result = dlarray(results,'SC');
probs = softmax(result);
probs = extractdata(probs);
[~,labels] = max(probs,[],2);
labels = int64(labels);
inds = int64(transpose(pointInds));
predLabels(inds) = labels;

oriPredLabels=[];
if size(possibility(possibility > endThreshold),1) == size(possibility,1)
    flag = false;
    oriPredLabels = predLabels(projInds,:);
end
end