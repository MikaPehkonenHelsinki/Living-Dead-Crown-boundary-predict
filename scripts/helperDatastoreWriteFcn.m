function helperDatastoreWriteFcn(data,writeInfo,~)
% helperDatastoreWriteFcn write the preprocessed data to the disk.
%
% This is an example helper function that is subject to change or removal
% in future releases.

% Copyright 2023 MathWorks, Inc.
persistent num
if isempty(num)
    num = 0;
end

pointCloudFolder = fullfile(writeInfo.Location,"PointCloud");
if ~exist(pointCloudFolder,'dir')
    mkdir(pointCloudFolder)
end
labelFolder = fullfile(writeInfo.Location,"Labels");
if ~exist(labelFolder,'dir')
    mkdir(labelFolder)
end

fileName = erase(writeInfo.SuggestedOutputName,writeInfo.Location);

for idx=1:size(data,2)
    xyzPoints = data{idx}(:,1:3);
    ptCloud = pointCloud(xyzPoints);
    label = data{idx}(:,4);
    ptCloudSavePath = fullfile(pointCloudFolder,sprintf('%03d.pcd',num+idx));
    labelSavePath = fullfile(labelFolder,sprintf('%03d.png',num+idx));
    pcwrite(ptCloud,ptCloudSavePath);
    imwrite(uint8(label),labelSavePath);
end

% Display message to show a particular file has been processed.
msg = sprintf('Processing done for file: %s',fileName);
if num~=0
    msgLength = strlength(msg);
    formatSpec = [repmat('\b',1,msgLength) '%s'];
else
    formatSpec = '%s';
end
fprintf(1,formatSpec, msg);
num = num + size(data,2);
end