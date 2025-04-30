function weights = helperComputeClassWeights(filedatastore,numClasses)
% helperComputeClassWeights computes weights of each class in the point cloud.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
weights = zeros(1,numClasses);

for i = 1:size(filedatastore.Files,1)
    lasReader = lasFileReader(filedatastore.Files{i});
    for j=1:numClasses
        try
            weights(j) = weights(j) + lasReader.ClassificationInfo.("Number of Points by Class")(lasReader.ClassificationInfo.("Classification Value") == j);
        catch
            continue
        end
    end
end

maxWeight = max(weights);
weights = sqrt(maxWeight./weights);
end