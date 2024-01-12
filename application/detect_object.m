function [bboxes, scores, labels, detectedImg] = detect_object(img, detector,detector_class)
[bboxes, scores, labels] = detect(detector,img);
if find(detector_class ~= "wszystko")
    class_indices = find(labels == detector_class);
    bboxes = bboxes(class_indices, :);
    scores = scores(class_indices);
    labels = labels(class_indices);
end
detectedImg = insertObjectAnnotation(img,'rectangle',bboxes,labels);
end
