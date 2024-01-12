py.importlib.import_module('pyautogui');
NET.addAssembly('System.Speech');
outputModel = "OCRModel_44_all\pulpit_icon.traineddata";
%Wczytanie sonifikacji
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;

interval = 1;

figure_cutter = figure;
hButton = uicontrol('Style', 'pushbutton', 'String', 'Zatrzymaj Timer', 'Callback', @(src, event) stopTimerCallback(t,kb));

global last_pos
last_pos = py.pyautogui.position();
% Konwertuj wynik na tablicę NumPy
last_pos = double(py.array.array('d', last_pos));

%Wczytanie detektora
detector = detector_choose(obj).detector;
detector_class = start_fun(obj,detector.ClassNames);
v = videoinput("winvideo", 2, "YUY2_1920x1080");
v.ReturnedColorspace = "rgb";


size_p = 200;

%Tworzenie timera
t = timer('ExecutionMode', 'fixedRate', 'Period', interval, 'TimerFcn', @(~,~) application(obj, v, size_p, figure_cutter, detector, detector_class, outputModel));
% Tworzymy event i listener do obsługi klawiatury
klawisz_event = event.listener(gcf, 'KeyPress', @klawiatura_callback);
% Tworzenie przycisku

pause(1)
start(t)