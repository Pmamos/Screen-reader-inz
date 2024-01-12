function [ocrBBoxes,text] = whichText(ind,img, bboxes, outputModel)
% Wybierz bbox dla danego indeksu
bbox = bboxes(ind, :);

% Określ obszar zainteresowania (ROI) wokół dolnej części bbox
roiY = bbox(2) + bbox(4); % Dolna krawędź bbox
size_img = size(img);
roi = [bbox(1), roiY, bbox(3), size_img(1) - roiY];

% Jeśli ROI jest puste, zwróć pusty tekst
if any(roi == 0)
    text = '';
else
    % Wytnij ROI z obrazu
    roiImg = imcrop(img, roi);

    % Przeprowadź OCR na ROI
    results = ocr(roiImg,Language=outputModel);

    % Pobierz wyniki
    ocrBBoxes = results.WordBoundingBoxes;
    text = results.Words;

    % Sprawdź, czy napis jest wystarczająco blisko oryginalnego obiektu
    distanceThreshold = 50; % Dopuszczalna odległość pionowa między obiektem a napisem

    % Filtruj wyniki na podstawie odległości od dolnej krawędzi oryginalnego bbox
    validIndices = find(ocrBBoxes(:,2) <= distanceThreshold);

    % Wybierz tylko te wyniki, które spełniają kryteria
    ocrBBoxes = ocrBBoxes(validIndices, :);
    text = text(validIndices);
end

end