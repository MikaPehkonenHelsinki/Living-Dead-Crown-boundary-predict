function loss = helperLossFunction(ypred,yactual,weights)

% Apply softmax on prediction.
ypred = softmax(ypred);

% Compute weighted cross-entropy loss.
loss = crossentropy(ypred,yactual,weights,WeightsFormat="UC",Reduction="none");
loss = mean(mean(sum(loss,3),1),4);

end