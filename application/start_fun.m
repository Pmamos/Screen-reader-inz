function klas = start_fun(obj, classNames)
num_klas = 1;
num_odp = 1;
labels = ["wszystko",string(classNames)];
odp_moz = ["Nie", "Tak"];
last_odp = "Nie";
odp = '';
Speak(obj, "Czy poszukujesz konkretnego objektu")
Speak(obj, last_odp);
while true
    % Odczytaj wciśnięty klawisz
    k = waitforbuttonpress;
    value = double(get(gcf,'CurrentCharacter'));

    % Sprawdź, czy to strzałka w prawo lub lewo
    if value == 29 || value== 28 || value== 30 || value== 31 % Kod klawisza dla strzałki w prawo lub lewo
        num_odp = mod(num_odp, 2) + 1;
        % Sprawdź, czy to klawisz Enter
    elseif value == 13  % Kod klawisza dla Enter
        odp = odp_moz(num_odp);
        break;  % Wyjdź z pętli
    end

    % Aktualizuj tekst i mów
    odp = odp_moz(num_odp);
    if last_odp ~= odp
        Speak(obj, odp);
        last_odp = odp;
    end

    pause(0.1);
end
if(odp == "Tak")
    Speak(obj, "Jakiej klasy obiektu poszukujesz")
    last_klas = "";
    klas = labels(1);
    Speak(obj, klas)
    while true
        k = waitforbuttonpress;
        value = double(get(gcf,'CurrentCharacter'));
        if value == 29 || value== 30 % Kod klawisza dla strzałki w prawo lub góra
            num_klas = mod(num_klas, numel(classNames)+1) + 1;
        elseif value == 28 || value== 31 % Kod klawisza dla strzałki w lewo lub dół
            num_klas = mod(num_klas-2, numel(classNames)+1) + 1;
            % Sprawdź, czy to klawisz Enter
        elseif value == 13  % Kod klawisza dla Enter
            klas = labels(num_klas);
            break;  % Wyjdź z pętli
        end

        % Aktualizuj tekst i mów
        klas = labels(num_klas);
        if last_klas ~= klas
            Speak(obj, klas);
            last_klas = klas;
        end
        pause(0.1)
    end
else
    klas = labels(1);
    fprintf('Wybrana klasa: %s\n', klas);
end
end