function application(obj, v, size_p, figure_cutter, detector, detector_class, outputModel)
global last_pos center_pos;
persistent queue ind_start ind_end previousScreenPart pos last_obj;

if isempty(queue)
    % Inicjalizacja kolejki i pozostałych zmiennych
    pos = py.pyautogui.position();
    pos = double(py.array.array('d', pos));
    
    % Inicjalizacja dwóch niezależnych kolejek
    queue1 = pos(1) * ones(1, 2);
    queue2 = pos(2) * ones(1, 2);
    
    % Połączenie kolejek w jedną macierz
    queue = [queue1; queue2];
    ind_start = 1;
    ind_end = 2;
    previousScreenPart = 'a';
    last_obj = '';
end

last_pos = pos;

% Pobranie nowej pozycji myszy i aktualizacja kolejki
[pos, ind_start, ind_end, queue, movementDirection, currentScreenPart] = mouse_position(queue, ind_start, ind_end);

% Przygotowanie obrazu i detekcja obiektów
img = cutter(v, size_p, pos);
[bboxes, ~, labels, ~] = detect_object(img, detector, detector_class);

% Odtworzenie dźwięku, jeśli wykryto obiekt
if(~isempty(bboxes))
    make_sound();
end

% Sprawdzenie, czy jesteśmy wewnątrz obiektu
[min_ind, flaga_zblizanie, komunikat_end, center_pos] = inObject(bboxes, size_p, pos, movementDirection);

% Rozpoznawanie tekstu na obrazie
if min_ind > 0
    [~, text] = whichText(min_ind, img, bboxes, outputModel);
    text = strjoin(text, ' ');
    obiekt = string(labels(min_ind));
else
    [~, text] = readText(img, outputModel);
    text = strjoin(text, ' ');
    obiekt = " ";
end

% Wyświetlenie obrazu z oznaczonymi obiektami
figure(figure_cutter);
set(figure_cutter, 'Position', [1 1 100 100]);

% Wywołanie funkcji do obsługi odczytanego tekstu i aktualizacja zmiennych
[previousScreenPart, komunikat_obiekt] = read(obj, currentScreenPart, previousScreenPart, obiekt, flaga_zblizanie, komunikat_end, text, last_obj);
last_obj = komunikat_obiekt;
end

% Funkcja obsługująca zatrzymywanie timera po kliknięciu przycisku
function stopTimerCallback(timerObj)
stop(timerObj);
delete(timerObj);
disp('Timer zatrzymany.');
end