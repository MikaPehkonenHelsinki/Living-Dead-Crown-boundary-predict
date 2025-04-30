function out = helperPredictRandLANet(net,X)
% The helperPredictRandLANet function is used to get output predictions from
% RandLANet dlnetwork.

% Copyright 2023 MathWorks, Inc.
%net = initialize(net);
% Convert inputs to dlarray
coords1 = dlarray(single(reshape(X{1,1}{1,1},[],1,3)),'SSCB');
coords2 = dlarray(single(reshape(X{1,1}{1,2},[],1,3)),'SSCB');
coords3 = dlarray(single(reshape(X{1,1}{1,3},[],1,3)),'SSCB');
coords4 = dlarray(single(reshape(X{1,1}{1,4},[],1,3)),'SSCB');
neighborIdx1 = dlarray(single(reshape(X{1,2}{1,1},[],16)),'SSCB');
neighborIdx2 = dlarray(single(reshape(X{1,2}{1,2},[],16)),'SSCB');
neighborIdx3 = dlarray(single(reshape(X{1,2}{1,3},[],16)),'SSCB');
neighborIdx4 = dlarray(single(reshape(X{1,2}{1,4},[],16)),'SSCB');
subIdx1 = dlarray(single(reshape(X{1,3}{1,1},[],16)),'SSCB');
subIdx2 = dlarray(single(reshape(X{1,3}{1,2},[],16)),'SSCB');
subIdx3 = dlarray(single(reshape(X{1,3}{1,3},[],16)),'SSCB');
subIdx4 = dlarray(single(reshape(X{1,3}{1,4},[],16)),'SSCB');
interpIdx1 = dlarray(single(X{1,4}{1,1}),'SSCB');
interpIdx2 = dlarray(single(X{1,4}{1,2}),'SSCB');
interpIdx3 = dlarray(single(X{1,4}{1,3}),'SSCB');
interpIdx4 = dlarray(single(X{1,4}{1,4}),'SSCB');
features = dlarray(single(reshape(X{1,5},[],1,3)),'SSCB');


out = predict(net,features, ...
    neighborIdx1,coords1,neighborIdx1,neighborIdx1,subIdx1, ...
    neighborIdx2,coords2,neighborIdx2,neighborIdx2,subIdx2, ...
    neighborIdx3,coords3,neighborIdx3,neighborIdx3,subIdx3, ...
    neighborIdx4,coords4,neighborIdx4,neighborIdx4,subIdx4, ...
    interpIdx4,interpIdx3,interpIdx2,interpIdx1);

end