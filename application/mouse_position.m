
function [pos, ind_start, ind_end, queue, movementDirection, komunikat12] = mouse_position(queue,ind_start, ind_end, flaga_object)
% Wywołaj funkcję Pythona do odczytu położenia myszy
pos = py.pyautogui.position();

% Konwertuj wynik na tablicę NumPy
pos = double(py.array.array('d', pos));
if (pos(1) > 1920 || pos(1) < 0 || pos(2) > 1080 || pos(2)<0)
    make_sound2()
end
%Zapisanie do kolejki obecnej pozycji myszy
queue(:, ind_start) = pos;


%Obliczenie w jaką stronę się zbliżasz
% Obliczenie kierunku ruchu myszy
direction = queue(:, ind_start) - queue(:, ind_end);

% Wyświetlenie kierunku (przykład, możesz dostosować)

ratio1 = abs(direction(2)) / abs(direction(1)) < 0.2;
ratio2 = abs(direction(1)) / abs(direction(2)) < 0.2;
movementDirection = zeros(1,2);

if direction(1) > 0 && ratio1
    movementDirection(2) = 1; % Prawo
elseif direction(1) < 0 && ratio1
    movementDirection(2) = -1; % Lewo
elseif direction(2) > 0 && ratio2
    movementDirection(1) = -1; % Dół
elseif direction(2) < 0 && ratio2
    movementDirection(1) = 1; % Góra
elseif direction(1) > 0 && direction(2) > 0
    movementDirection(1) = -1;
    movementDirection(2) = 1;% Prawo-dół
elseif direction(1) > 0 && direction(2) < 0
    movementDirection = ones(1,2); % Prawo-góra
elseif direction(1) < 0 && direction(2) > 0
    movementDirection = -ones(1,2); % Lewo-dół
elseif direction(1) < 0 && direction(2) < 0
    movementDirection(1) = 1;
    movementDirection(2) = -1; % Lewo-góra
else
    movementDirection = zeros(1,2); % Stoi
end


ind_start = mod(ind_start, 2) + 1;
ind_end = mod(ind_end, 2) + 1;

komunikat12 = '';
if (~flaga_object)
    if (pos(1) < (1920/3))
        komunikat1 = "lewym";
        if(pos(1)<10)
            komunikat12 = " w lewym krańcu ekranu";
        end
    elseif (pos(1) > (1920*2/3))
        komunikat1 = "prawym";
        if(pos(1)>1910)
            komunikat12 = " w prawym krańcu ekranu";
        end
    else
        komunikat1 = "centralnym";
    end

    if (pos(2) < (1080/3))
        komunikat2 = "górnym";
        if(pos(2)<10)
            komunikat12 = " w górnym krańcu ekranu";
        end
    elseif (pos(2) > (1080*2/3))
        komunikat2 = "dolnym";
        if(pos(2)>1070)
            komunikat12 = " w dolnym krańcu ekranu";
        end
    else
        komunikat2 = "centralnym";
    end
    if (komunikat1 == "centralnym" && komunikat2 == "centralnym")
        komunikat12 = " na środku ekranu";
    elseif (isempty(komunikat12))
        komunikat12 = " w "+komunikat1+" "+komunikat2+" rogu ekranu";
    end
end
end