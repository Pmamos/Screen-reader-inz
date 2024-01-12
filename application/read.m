function [previousScreenPart, komunikat_obiekt] = read (obj, currentScreenPart, previousScreenPart,obiekt, flaga_zblizanie, komunikat_end, text,last_obj)
% Inicjalizacja komunikatu o obiekcie
komunikat_obiekt = '';

% Jeśli komunikat_end nie jest pusty i komunikat_obiekt jest pusty
if(~isempty(komunikat_end) && isempty(komunikat_obiekt))

    % Jeśli komunikat_end jest równy "w"
    if (komunikat_end == "w")

        % Utwórz komunikat, że użytkownik znajduje się na obiekcie
        komunikat_obiekt = " znajdujesz się na " + obiekt +' '+ text;
        % Jeśli obiekt i tekst są równe last_obj
        if (komunikat_obiekt == last_obj)
            % Dodaj do komunikatu instrukcje dotyczące interakcji z obiektem
            komunikat_obiekt = komunikat_obiekt + " Żeby podjąć akcje kliknij lewy przycisk myszy Jeśli chcesz skorzystać z innych opcji kliknij prawy przycisk myszy";
        end

    else
        % Jeśli flaga_zblizanie jest prawdziwa
        if(flaga_zblizanie)

            % Utwórz komunikat, że użytkownik zbliża się do obiektu
            komunikat_obiekt = "Zbiżasz się do "+ obiekt +' '+ text;
        else
            % W przeciwnym razie utwórz komunikat, że obiekt znajduje się w określonym miejscu
            komunikat_obiekt = obiekt+ ' '+ text + " znajduje się " + komunikat_end;
        end
    end
end

% Jeśli komunikat_obiekt jest pusty
if(isempty(komunikat_obiekt))
    % Ustaw readPosition na 1
    readPosition = 1;
    % Jeśli tekst nie jest pusty
    if(~isempty(text))
        % Wywołaj funkcję Speak, aby odczytać tekst
        Speak(obj,string(text))
        % Ustaw prawdopodobieństwo fałszywe na 0.8
        probability_of_false = 0.8;  % Przykładowa wartość, dostosuj według potrzeb

        % Ustaw readPosition na wartość logiczną, czy losowa liczba jest większa niż probability_of_false
        readPosition = rand() > probability_of_false;
    end
    % Jeśli previousScreenPart nie jest równy currentScreenPart i readPosition jest prawdziwe
    if(previousScreenPart ~= currentScreenPart && readPosition)
        % Ustaw previousScreenPart na currentScreenPart
        previousScreenPart =  currentScreenPart;
        % Utwórz komunikat o pozycji
        komunikat_position = "Znajdujesz się " + currentScreenPart;
        % Wywołaj funkcję Speak, aby odczytać komunikat o pozycji
        Speak(obj,string(komunikat_position))
    end
else
    % W przeciwnym razie wywołaj funkcję Speak, aby odczytać komunikat_obiekt
    Speak(obj,string(komunikat_obiekt))
end

end