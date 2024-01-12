% Ustalenie rozmiaru obrazu, liczby klas, wielkości mini-batch, liczby epok
imageSize = [201 201 3];
numClasses = 21;
miniBatchSize = 20;
numEpochs = 21;

% Estymacja anchor boxes przy użyciu funkcji anchors
Anchors = anchors(gTruth2, 5);

% Augmentacja danych treningowych, walidacyjnych i testowych
[cds, cds_validate, cds_test] = augment_yolo(gTruth2, imageSize);

% Warstwa wejściowa
inputLayer = imageInputLayer(imageSize, 'Name', 'input', 'Normalization', 'none');

% Warstwy środkowe sieci konwolucyjnej
filterSize = [3 3];
middleLayers = [
    convolution2dLayer(filterSize, 16, 'Padding', 1, 'Name', 'conv_1', 'WeightsInitializer', 'narrow-normal')
    batchNormalizationLayer('Name', 'BN1')
    reluLayer('Name', 'relu_1')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'maxpool1')
    convolution2dLayer(filterSize, 32, 'Padding', 1, 'Name', 'conv_2', 'WeightsInitializer', 'narrow-normal')
    batchNormalizationLayer('Name', 'BN2')
    reluLayer('Name', 'relu_2')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'maxpool2')
    convolution2dLayer(filterSize, 64, 'Padding', 1, 'Name', 'conv_3', 'WeightsInitializer', 'narrow-normal')
    batchNormalizationLayer('Name', 'BN3')
    reluLayer('Name', 'relu_3')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'maxpool3')
    convolution2dLayer(filterSize, 128, 'Padding', 1, 'Name', 'conv_4', 'WeightsInitializer', 'narrow-normal')
    batchNormalizationLayer('Name', 'BN4')
    reluLayer('Name', 'relu_4')
    ];

% Wybór warstwy cechowej
featureLayer = 'relu_4';

% Warstwy sieci YOLOv2
layers = [
    inputLayer
    middleLayers
    fullyConnectedLayer(numClasses, 'WeightLearnRateFactor', 20, 'BiasLearnRateFactor', 20)
    softmaxLayer
    classificationLayer];

% Utworzenie grafu warstw
lgraph = layerGraph(layers);
lgraph = yolov2Layers(imageSize, numClasses, Anchors, lgraph, featureLayer);

% Ustalenie liczby iteracji na epokę
numIterationsPerEpoch = floor(numel(gTruth2.LabelDefinitions) / miniBatchSize);

% Ustalenie opcji treningu
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

% Trenowanie detektora YOLOv2
[detector, info] = trainYOLOv2ObjectDetector(cds, lgraph, options);

% Zapis detektora i informacji o treningu
save("gdetector_v2_wlasne_augmentation_21_wiecej", "detector")
save("info_wlasne_augmentation_21_wiecej", "info")