function [bboxes, scores, labels, detectedImg] = detect_object(img, detector, detector_class)
% detect_object - funkcja do detekcji obiektów na obrazie

% Wywołanie funkcji detect z detektorem
[bboxes, scores, labels] = detect(detector, img);

% Sprawdzenie, czy użytkownik wybrał konkretne klasy obiektów
if find(detector_class ~= "wszystko")
    % Znalezienie indeksów obiektów z wybranej klasy
    class_indices = find(labels == detector_class);
    
    % Ograniczenie wyników do obiektów z wybranej klasy
    bboxes = bboxes(class_indices, :);
    scores = scores(class_indices);
    labels = labels(class_indices);
end

% Wstawienie adnotacji do obrazu z zaznaczonymi bounding boxami
detectedImg = insertObjectAnnotation(img, 'rectangle', bboxes, labels);
end