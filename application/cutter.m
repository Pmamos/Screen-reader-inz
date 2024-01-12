function img = cutter(v, size_p, pos)
snapshot = fliplr(getsnapshot(v));
a = pos(1)-size_p/2;
b = pos(2)-size_p/2;
if(pos(1)> 1920-size_p/2)
    a = 1920-size_p;
end
if(pos(1) < size_p/2)
    a = 0;
end

if(pos(2)> 1080-size_p/2)
    b = 1080-size_p;
end
if(pos(2) < size_p/2)
    b = 0;
end

img = imcrop(snapshot,[a b size_p size_p]);
end