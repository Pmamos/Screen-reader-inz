% Importowanie modułu pyautogui z języka Pythona
py.importlib.import_module('pyautogui');

% Dodanie biblioteki do obsługi mowy w języku C#
NET.addAssembly('System.Speech');

% Ścieżka do pliku treningowego dla modelu OCR
outputModel = "OCRModel_44_all\pulpit_icon.traineddata";

% Wczytanie sonifikacji
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;

% Interwał timera w sekundach
interval = 0.01;

% Utworzenie nowego okna do przechwytywania obrazu z kamery
figure_cutter = figure;
set(figure_cutter, 'Position', [1 1 100 100]);

% Utworzenie przycisku do zatrzymywania timera
hButton = uicontrol('Style', 'pushbutton', 'String', 'Zatrzymaj Timer', 'Callback', @(src, event) stopTimerCallback(t,kb));

% Inicjalizacja globalnej zmiennej przechowującej ostatnią pozycję kursora myszy
global last_pos
last_pos = py.pyautogui.position();
% Konwersja wyniku na tablicę NumPy
last_pos = double(py.array.array('d', last_pos));

% Wczytanie detektora obiektów (ResNet-50 lub własny)
detector = detector_choose(obj).detector;

% Wybór klasy obiektów do detekcji
detector_class = start_fun(obj,detector.ClassNames);

% Utworzenie obiektu do przechwytywania obrazu z kamery
v = videoinput("winvideo", 2, "YUY2_1920x1080");
v.ReturnedColorspace = "rgb";

% Rozmiar obszaru do wycięcia z kamery
size_p = 200;

% Utworzenie timera do cyklicznego wywoływania funkcji application
t = timer('ExecutionMode', 'fixedRate', 'Period', interval, 'TimerFcn', @(~,~) application(obj, v, size_p, figure_cutter, detector, detector_class, outputModel));

% Utworzenie eventu i listenera do obsługi klawiatury
klawisz_event = event.listener(gcf, 'KeyPress', @klawiatura_callback);

% Pauza przed rozpoczęciem timera
pause(1)

% Uruchomienie timera
start(t)