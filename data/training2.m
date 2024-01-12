% Parametry treningu
imageSize = [201 201 3];
numClasses = 21;
miniBatchSize = 40;
numEpochs = 21;

% Augmentacja danych treningowych, walidacyjnych i testowych
[cds, cds_validate, cds_test] = augment_yolo(gTruth2, imageSize);

% Załadowanie architektury YOLOv2 na bazie ResNet50
lgraph = load("lgraph_resnet50.mat");
lgraph = lgraph.lgraph;

% Warstwa wyjściowa YOLOv2
featureLayer = 'activation_49_relu';

% Obliczenie anchor boxes
Anchors = anchors(gTruth2, 5);

% Dodanie warstw YOLOv2 do architektury ResNet50
lgraph = yolov2Layers(imageSize, numClasses, Anchors, lgraph, featureLayer);

% Obliczenie liczby iteracji na epokę
numIterationsPerEpoch = floor(numel(gTruth2.LabelDefinitions) / miniBatchSize);

% Opcje treningowe
options = trainingOptions('sgdm', ...
    'MiniBatchSize', miniBatchSize, ...
    'MaxEpochs', numEpochs, ...
    'InitialLearnRate', 1e-4, ...
    'Plots', 'training-progress', ...
    'ValidationData', cds_validate, ...
    'ValidationFrequency', numIterationsPerEpoch, ...
    'BatchNormalizationStatistics', "moving", ...
    'ResetInputNormalization', false, ...
    'VerboseFrequency', 30);

% Trening detektora YOLOv2
[detector, info] = trainYOLOv2ObjectDetector(cds, lgraph, options);

% Zapis detektora i informacji o treningu
save("gdetector2_wiecej_augmentation_21", "detector");
save("info2_augmentation_wiecej_21_relu50", "info");