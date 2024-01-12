function anchoresBoxes = anchors(gTruth, num_anchors)
% Funkcja do estymacji anchor boxes dla danej tablicy Ground Truth

% Przygotowanie danych treningowych w formie boxLabelDatastore
trainingData = boxLabelDatastore(gTruth.LabelData);

% Estymacja anchor boxes przy użyciu funkcji estimateAnchorBoxes
[anchoresBoxes, meanIoU] = estimateAnchorBoxes(trainingData, num_anchors);
end
