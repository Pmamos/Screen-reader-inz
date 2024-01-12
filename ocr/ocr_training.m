% Przygotowanie danych treningowych
gTruth_ocr = gTruth_ocr_end;

labelName = "words";
attributeName = "text";
[imds, boxds, txtds] = ocrTrainingData(gTruth_ocr, labelName, attributeName);
cds_ocr = combine(imds, boxds, txtds);

% Ustawienie ziarna liczby losowej dla reprodukowalności wyników.
rng(0);

% Obliczenie liczby próbek treningowych i walidacyjnych.
fracTrain = 0.9; % Procent danych treningowych

cv = cvpartition(size(gTruth_ocr.LabelData, 1), 'HoldOut', fracTrain);
validateTestGroundTruth = ...
    groundTruth(groundTruthDataSource(gTruth_ocr.DataSource.Source(cv.training, :)), ...
    gTruth_ocr.LabelDefinitions, ...
    gTruth_ocr.LabelData(cv.training, :));
trainGroundTruth = ...
    groundTruth(groundTruthDataSource(gTruth_ocr.DataSource.Source(cv.test, :)), ...
    gTruth_ocr.LabelDefinitions, ...
    gTruth_ocr.LabelData(cv.test, :));
validateGroundTruth = validateTestGroundTruth;

% Przygotowanie danych treningowych i walidacyjnych
[imds, boxds, txtds] = ocrTrainingData(trainGroundTruth, labelName, attributeName);
cds = combine(imds, boxds, txtds);

[imds_validate, bxds_validate, txtds_validate] = ocrTrainingData(validateGroundTruth, labelName, attributeName);
cds_validate = combine(imds_validate, bxds_validate, txtds_validate);

% Ustalenie ścieżki wyjściowej
outputDir = "OCRModel_5_all";
if ~exist(outputDir, "dir")
    mkdir(outputDir);
end
checkpointsDir = "Checkpoints";
if ~exist(checkpointsDir, "dir")
    mkdir(checkpointsDir);
end

% Opcje trenowania modelu OCR
ocrOptions = ocrTrainingOptions(GradientDecayFactor=0.9, ...
    InitialLearnRate=30e-4, MaxEpochs=5, VerboseFrequency=200, ...
    CheckpointPath=checkpointsDir, ...
    ValidationData=cds_validate, ...
    OutputLocation=outputDir);

% Trenowanie modelu OCR
outputModelName = "pulpit_icon";
baseModel = "polish";
outputModel = trainOCR(cds, outputModelName, baseModel, ocrOptions);
% Zapis modelu (jeśli potrzebny)
% save("ocr_model2_bez_test","outputModel")