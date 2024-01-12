function [ocrBBoxes,text] = readText(img, outputModel)

% Ustal środek obrazu
centerX = size(img, 2) / 2;
centerY = size(img, 1) / 2;

% Określ obszar wokół środka obrazu
radius = 30;
roi = [centerX - 2*radius, centerY - radius, 4 * radius, 2 * radius];

% Wytnij ROI z obrazu
roiImg = imcrop(img, roi);


% Przeprowadź OCR na ROI
results = ocr(roiImg, 'Language', outputModel);

% Pobierz wyniki
ocrBBoxes = results.WordBoundingBoxes;
text = results.Words;
end