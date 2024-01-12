function [preprocessedTrainingData, dsVal, dsTest] = augment_yolo(gTruth, inputSize)
    % Funkcja do augmentacji danych treningowych, walidacyjnych i testowych dla YOLOv2

    % Pobranie danych treningowych z obiektu gTruth
    [imds, bxds] = objectDetectorTrainingData(gTruth);
    
    % Ustalenie indeksów dla zbiorów walidacyjnego i testowego
    idx = 1:height(imds.Files);
    mod5 = mod(idx, 5);
    mod19 = mod(idx, 19);
    validationIdx = 5:5:length(idx);
    testIdx = 19:19:length(idx);
    trainingIdx = idx(mod5 ~= 0 & mod19 ~= 0);
    
    % Utworzenie zestawu danych dla zbioru treningowego
    combinedDatastore = combine(imds, bxds);
    dsTrain = subset(combinedDatastore, trainingIdx);
    dsVal = subset(combinedDatastore, validationIdx);
    dsTest = subset(combinedDatastore, testIdx);
    
    % Augmentacja danych treningowych
    augmentedTrainingData = transform(dsTrain, @augmentData);
    augmentedTrainingData = combine(augmentedTrainingData, dsTrain, ReadOrder = "sequential");

    % Przygotowanie danych treningowych
    preprocessedTrainingData = transform(augmentedTrainingData, @(data) preprocessData(data, inputSize));
end

function B = augmentData(A)
    % Funkcja do augmentacji danych treningowych

    B = cell(size(A));
    I = A{1};
    sz = size(I);
    
    % Losowa skalowanie obrazu
    tform = randomAffine2d("Scale", [0.2, 1.4]);
    rout = affineOutputView(sz, tform, 'BoundsStyle', 'CenterOutput');
    B{1} = imwarp(I, tform, 'OutputView', rout);

    % Sanitizacja bounding boxes, jeśli wymagane
    A{2} = helperSanitizeBoxes(A{2});

    % Zastosowanie tego samego przekształcenia do bounding boxes
    [B{2}, indices] = bboxwarp(A{2}, tform, rout, 'OverlapThreshold', 0.25);
    B{3} = A{3}(indices);

    % Zwrócenie oryginalnych danych, jeśli wszystkie bounding boxes zostaną usunięte przez przekształcenie
    if isempty(indices)
        B = A;
    end
end

function data = preprocessData(data, targetSize)
    % Przeskalowanie obrazu i bounding boxes do rozmiaru docelowego

    sz = size(data{1}, [1 2]);
    scale = targetSize(1:2) ./ sz;
    data{1} = imresize(data{1}, targetSize(1:2));

    % Sanitizacja bounding boxes, jeśli wymagane
    data{2} = helperSanitizeBoxes(data{2});

    % Przeskalowanie bounding boxes do nowego rozmiaru obrazu
    data{2} = bboxresize(data{2}, scale);
end

function boxes = helperSanitizeBoxes(boxes, ~)
    % Funkcja do usunięcia niepoprawnych bounding boxes

    persistent hasInvalidBoxes;
    valid = all(boxes > 0, 2);
    if any(valid)
        if ~all(valid) && isempty(hasInvalidBoxes)
            % Wygenerowanie jednorazowego ostrzeżenia o usunięciu niepoprawnych bounding boxes
            hasInvalidBoxes = true;
            warning('Usuwanie danych bounding box z wartościami <= 0.')
        end
        boxes = boxes(valid, :);
    end
end