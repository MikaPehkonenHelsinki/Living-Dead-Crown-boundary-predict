function out = helperTransformTrainData(lasReader, size, removeClasses)

[ptCloud, attr] = readPointCloud(lasReader, "Attributes", "Classification");
labels = attr.Classification;

% Remove specified classes
mask = ~ismember(labels, removeClasses);
ptCloud = select(ptCloud, mask);
labels = labels(mask);

% Use the helperGridSubsampling helper function to downsample
gridSize = size;
[pointsSparse, labelsSparse] = helperGridSubsampling(ptCloud, labels, gridSize);

xyzAndLabelsSparse = [pointsSparse, labelsSparse];
out{1,1} = xyzAndLabelsSparse;

end
