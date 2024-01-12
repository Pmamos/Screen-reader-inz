function [selected_detector] = detector_choose(obj)
detector1 = "Detektor ResNet-50";
detector2 = "Detektor własny";
last_odp = "";
% Wybór domyślnego detektora
selected_detector = detector1;
Speak(obj, selected_detector);
while true
    % Odczytaj wciśnięty klawisz
    k = waitforbuttonpress;
    value = double(get(gcf,'CurrentCharacter'));

    if value == 29 || value== 28 || value== 30 || value== 31 % Kod klawisza dla strzałki w prawo lub lewo
        selected_detector = toggle_detector(selected_detector, detector1, detector2);
        % Sprawdź, czy to klawisz Enter
    elseif value == 13  % Kod klawisza dla Enter
        break;  % Wyjdź z pętli
    end

    % Aktualizuj tekst i mów
    if last_odp ~= selected_detector
        Speak(obj, selected_detector);
        last_odp = selected_detector;
    end
    pause(0.1);
end
if selected_detector == detector1
    fprintf('Wybrano detektor: %s\n', selected_detector);

    selected_detector = load ("gdetector2_resnet50_wiecej_augmentation_40.mat");
else

    fprintf('Wybrano detektor: %s\n', selected_detector);
    selected_detector = load ("gdetector_v2_wlasne_augmentation_40_wiecej.mat");
end
end

function selected_detector = toggle_detector(current_detector, detector1, detector2)
% Funkcja do przełączania pomiędzy detektorami
if strcmp(current_detector, detector1)
    selected_detector = detector2;
else
    selected_detector = detector1;
end
end