function make_sound2()
fs = 44100; % Częstotliwość próbkowania (domyślnie dla większości systemów)
duration = 2; % Długość sygnału w sekundach
t = 0:1/fs:duration; % Wektor czasu

% Zwiększenie częstotliwości dźwięku do 1800 Hz
frequency = 1800; % Częstotliwość dźwięku w Hz

% Tworzenie sygnału sinusoidalnego o zwiększonej częstotliwości
signal = sin(2*pi*frequency*t);

% Dodanie przerw do sygnału
signal_with_breaks = [signal(1:round(fs/4)) zeros(1, round(fs/8)) signal(round(fs/4)+1:round(fs/2)) zeros(1, round(fs/8)) signal(round(fs/2)+1:round(3*fs/4)) zeros(1, round(fs/8)) signal(round(3*fs/4)+1:end)];

% Odtwarzanie sygnału dźwiękowego z przerwami
sound(signal_with_breaks, fs);
end