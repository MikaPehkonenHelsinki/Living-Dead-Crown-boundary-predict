function out = helperTransformTrainDataOther(lasReader,size)
    % Read point cloud and classification attributes.
    [ptCloud, attr] = readPointCloud(lasReader, "Attributes", "Classification");
    labels = attr.Classification;

    % Combine labels 0 and 4 into 1, and labels 1, 2, and 3 into 2.
    labels(labels == 0 | labels == 4) = 0; %other tree and ground
    labels(labels == 1 | labels == 2 | labels == 3) = 2; %stem, dead and living
    labels(labels == 0) = 1;

    % Use the helperGridSubsampling helper function to downsample the point cloud and labels.
    gridSize = size;
    [pointsSparse, labelsSparse] = helperGridSubsampling(ptCloud, labels, gridSize);

    % Create output matrix with downsampled points and labels.
    xyzAndLabelsSparse = [pointsSparse, labelsSparse];
    out{1,1} = xyzAndLabelsSparse;
end

