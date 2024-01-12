function img = cutter(v, size_p, pos)
% cutter - funkcja do wycinania obszaru z obrazu kamery

% Pobranie migawki (snapshot) z kamery
snapshot = fliplr(getsnapshot(v));

% Obliczenie współrzędnych wycinanego obszaru
a = pos(1) - size_p / 2;
b = pos(2) - size_p / 2;

% Sprawdzenie, czy wycinany obszar nie wychodzi poza krawędzie obrazu
if (pos(1) > 1920 - size_p / 2)
    a = 1920 - size_p;
end
if (pos(1) < size_p / 2)
    a = 0;
end
if (pos(2) > 1080 - size_p / 2)
    b = 1080 - size_p;
end
if (pos(2) < size_p / 2)
    b = 0;
end

% Wycięcie obszaru z migawki
img = imcrop(snapshot, [a b size_p size_p]);
end