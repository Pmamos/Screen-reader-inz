% Wczytanie danych treningowych z pliku mat
ld = load("gtruth_test_ocr2.mat");
gTruth_ocr = ld.gTruth_test_ocr2;

% Przygotowanie danych treningowych
labelName = "words";
attributeName = "text";
[imds, boxds, txtds] = ocrTrainingData(gTruth_ocr, labelName, attributeName);
cds_ocr = combine(imds, boxds, txtds);

% Ocena modelu bazowego (polski)
ocrResults = ocr(cds_ocr, Language="polish");
metrics = evaluateOCR(ocrResults, cds_ocr);
modelAccuracy = 100 * (1 - metrics.DataSetMetrics.WordErrorRate);
disp("Accuracy of the OCR model (base model - polish) = " + modelAccuracy + "%")

% Ocena modelu czarno-białego
outputModel = "C:\Users\Piotr Mamos\Desktop\Inzynierka\ocr\OCRModel_300\pulpit_icon_test.traineddata";
ocrResults = ocr(cds_ocr, Language=outputModel);
metrics = evaluateOCR(ocrResults, cds_ocr);
modelAccuracy = 100 * (1 - metrics.DataSetMetrics.WordErrorRate);
disp("Accuracy of the OCR model (black and white) = " + modelAccuracy + "%")

% Ocena modelu kolorowego
outputModel = "C:\Users\Piotr Mamos\Desktop\Inzynierka\ocr\OCRModel_300_bez_test\pulpit_icon.traineddata";
ocrResults = ocr(cds_ocr, Language=outputModel);
metrics = evaluateOCR(ocrResults, cds_ocr);
modelAccuracy = 100 * (1 - metrics.DataSetMetrics.WordErrorRate);
disp("Accuracy of the OCR model (color) = " + modelAccuracy + "%")

% Ocena modelu uwzględniającego wszystkie dane treningowe
outputModel = "C:\Users\Piotr Mamos\Desktop\Inzynierka\ocr\OCRModel_5_all\pulpit_icon.traineddata";
ocrResults = ocr(cds_ocr, Language=outputModel);
metrics = evaluateOCR(ocrResults, cds_ocr);
modelAccuracy = 100 * (1 - metrics.DataSetMetrics.WordErrorRate);
disp("Accuracy of the OCR model (all) = " + modelAccuracy + "%")