function make_sound()
    % Tworzenie sygnału dźwiękowego
    fs = 44100; % Częstotliwość próbkowania (domyślnie dla większości systemów)
    duration = 0.15; % Długość sygnału w sekundach
    t = 0:1/fs:duration; % Wektor czasu
    
    % Tworzenie sygnału sinusoidalnego o częstotliwości 440 Hz (A4)
    frequency = 600; % Częstotliwość dźwięku w Hz
    signal = sin(2*pi*frequency*t);
    
    % Odtwarzanie sygnału dźwiękowego
    sound(signal, fs);
end