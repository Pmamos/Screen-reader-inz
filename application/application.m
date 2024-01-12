
function application(obj, v, size_p, figure_cutter, detector, detector_class, outputModel)
global last_pos center_pos;
persistent queue   ind_start  ind_end previousScreenPart pos last_obj;
flaga_object = 0;
if isempty(queue)
    % Wywołaj funkcję Pythona do odczytu położenia myszy
    pos = py.pyautogui.position();

    % Konwertuj wynik na tablicę NumPy
    pos = double(py.array.array('d', pos));
    % Initialize two independent queues
    queue1 = pos(1) * ones(1, 2);
    queue2 = pos(2) * ones(1, 2);

    % Combine the queues into a single matrix
    queue = [queue1; queue2];
    ind_start = 1;
    ind_end = 2;
    previousScreenPart = 'a';
    last_obj = '';
end
last_pos = pos;
[pos, ind_start, ind_end, queue, movementDirection, currentScreenPart] = mouse_position(queue,ind_start, ind_end, flaga_object);
img = cutter(v, size_p, pos);

[bboxes, ~, labels, ~] = detect_object(img, detector, detector_class);
if(~isempty(bboxes))
    make_sound()
end
[min_ind, flaga_zblizanie, komunikat_end, center_pos] = inObject(bboxes,size_p,pos, movementDirection);


% ocrResults = ocr(img,Language=outputModel);
if min_ind > 0
    [~,text] = whichText(min_ind,img, bboxes, outputModel);
    text = strjoin(text, ' ');
    obiekt = string(labels(min_ind));
else
    [~,text] = readText(img, outputModel);
    text = strjoin(text, ' ');
    obiekt = " ";
end
% imgName = insertObjectAnnotation(detectedImg,"rectangle",ocrResults.WordBoundingBoxes,ocrResults.Words);
figure(figure_cutter)



previousScreenPart = read(obj, currentScreenPart, previousScreenPart,obiekt, flaga_zblizanie, komunikat_end, text,last_obj);
last_obj = obiekt +' '+ text;
end

% Funkcja obsługująca zatrzymywanie timera po kliknięciu przycisku
function stopTimerCallback(timerObj)
stop(timerObj);
delete(timerObj);
disp('Timer zatrzymany.');
end

