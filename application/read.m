function previousScreenPart = read (obj, currentScreenPart, previousScreenPart,obiekt, flaga_zblizanie, komunikat_end, text,last_obj)

komunikat_obiekt = '';


if(~isempty(komunikat_end) && isempty(komunikat_obiekt))


    if (komunikat_end == "w")

        komunikat_obiekt = " znajdujesz się na " + obiekt +' '+ text;
        if ((obiekt +' '+ text) == last_obj)
            komunikat_obiekt = komunikat_obiekt + " Żeby podjąć akcje kliknij lewy przycisk myszy Jeśli chcesz skorzystać z innych opcji kliknij prawy przycisk myszy";
        end

    else
        if(flaga_zblizanie)

            komunikat_obiekt = "Zbiżasz się do "+ obiekt +' '+ text;
        else
            komunikat_obiekt = obiekt+ ' '+ text + " znajduje się " + komunikat_end;
        end
    end
end
if(isempty(komunikat_obiekt))
    readPosition = 1;
    if(~isempty(text))
        Speak(obj,string(text))
        probability_of_false = 0.8;  % Przykładowa wartość, dostosuj według potrzeb

        readPosition = rand() > probability_of_false;
    end
    if(previousScreenPart ~= currentScreenPart && readPosition)
        previousScreenPart =  currentScreenPart;
        komunikat_position = "Znajdujesz się " + currentScreenPart;
        Speak(obj,string(komunikat_position))
    end
else
    Speak(obj,string(komunikat_obiekt))
end

end