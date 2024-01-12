% Nazwa Ground Truth
name = "test_ocr2";

% Zapis Ground Truth do pliku MAT
save("gtruth_" + name + ".mat", "gTruth_" + name);

% Zapis tabeli Ground Truth do pliku MAT
save(name + "_table", "gTruth_" + name + "_table");