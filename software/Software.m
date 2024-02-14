%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   JJ TENSTESTER v1.0 by Jakub Jasiejko                                  %
%                                                                         %
%                                                                         %
%   gitHubLink: https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0.git   %
%                                                                         %
%                                                                         %
%   august 2023                                                           %
%                                                                         %
%   Project licensed by MIT License                                       %
%                                                                         %
%                                                                         %
%   MATLAB Software for control tester device and analyzing data          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close all;

figure;

% Tworzenie i konfigurowanie interfejsu użytkownika (GUI)
uiPanel = uipanel('Title', 'Konfiguracja Portu COM', 'Position', [0.1 0.3 0.8 0.4]);

% Tworzenie pola tekstowego do wprowadzenia numeru portu COM
comPortEdit = uicontrol(uiPanel, 'Style', 'edit', 'Position', [150 60 100 30]);
uicontrol(uiPanel, 'Style', 'text', 'Position', [30 60 120 30], 'String', 'Numer Portu COM:');

% Tworzenie przycisku do zatwierdzania
confirmButton = uicontrol(uiPanel, 'Style', 'pushbutton', 'Position', [280 60 80 30], 'String', 'Zatwierdź', 'Callback', @confirmCallback);

% Callback function do przycisku "Zatwierdź"
function confirmCallback(~, ~)
    comPortEdit = findobj('Style', 'edit'); % Znalezienie pola tekstowego
    comPort = get(comPortEdit, 'String'); % Pobranie wprowadzonego numeru portu COM
    % Usunięcie "COM" z wprowadzonej wartości, jeśli istnieje
    comPort = regexprep(comPort, '[^\d]+', ''); % Usunięcie wszystkich znaków innych niż cyfry
    
    % Inicjalizacja komunikacji z urządzeniem przy użyciu wprowadzonego numeru portu COM
    Device = serialport(['COM', char(comPort)], 9600, 'Timeout', 1e9);
    
    % Wywołanie funkcji Control i przekazanie wartości comPort oraz Device
    Control(comPort, Device);
end

function Control(comPort, Device)
    crossSectionalArea = 0;
    initialLength = 0;

    % initial menu
    figure;
    button1 = uicontrol('Style', 'pushbutton', 'String', 'EXECUTE TEST', 'Position', [10 200 100 30], 'Callback', @startSlowTest);
    button2 = uicontrol('Style', 'pushbutton', 'String', 'SET VALUES', 'Position', [10 160 100 30], 'Callback', @Control);
    button3 = uicontrol('Style', 'pushbutton', 'String', 'UPWARD JOG MOVEMENT', 'Position', [10 120 140 30], 'Callback', @startYoungModulusTest);
    button4 = uicontrol('Style', 'pushbutton', 'String', 'DOWNWARD JOG MOVEMENT', 'Position', [10 80 120 30], 'Callback', @startUpwardMovement);
    button5 = uicontrol('Style', 'pushbutton', 'String', 'RESET PLOTS', 'Position', [10 40 140 30], 'Callback', @startDownwardMovement);
    

    %values menu
    fig = figure('Position', [100, 100, 600, 450], 'Name', 'Enter values', 'NumberTitle', 'off', 'MenuBar', 'none');

    prompt1 = uicontrol('Style', 'text', 'Position', [20, 350, 200, 20], 'String', 'first side length [mm]:');
    edit1 = uicontrol('Style', 'edit', 'Position', [220, 350, 100, 20]);

    prompt2 = uicontrol('Style', 'text', 'Position', [20, 300, 200, 20], 'String', 'second side length [mm]:');
    edit2 = uicontrol('Style', 'edit', 'Position', [220, 300, 100, 20]);

    prompt3 = uicontrol('Style', 'text', 'Position', [20, 270, 200, 20], 'String', 'initial length [mm]:');
    edit3 = uicontrol('Style', 'edit', 'Position', [220, 270, 100, 20]);

    % Dodatkowe zmienne
    prompt4 = uicontrol('Style', 'text', 'Position', [20, 240, 200, 20], 'String', 'velocity [mm/s]:');
    edit4 = uicontrol('Style', 'edit', 'Position', [220, 240, 100, 20]);

    prompt5 = uicontrol('Style', 'text', 'Position', [20, 210, 200, 20], 'String', 'test lenght [mm/s]:');
    edit5 = uicontrol('Style', 'edit', 'Position', [220, 210, 100, 20]);

    confirmButton = uicontrol('Style', 'pushbutton', 'Position', [100, 0, 100, 30], 'String', 'Confirm', 'Callback', @confirmCallback);

    resultText = uicontrol('Style', 'text', 'Position', [20, 380, 400, 60], 'String', '', 'HorizontalAlignment', 'left');

    measurmentData = [];
    displacementData = [];
    maxForceValue = 0;

    function confirmCallback(~, ~)
        % Pobieranie wartości z pól edycji GUI
        a = str2double(get(edit1, 'String')); % Pierwsza długość boku [mm]
        b = str2double(get(edit2, 'String')); 
        c = str2double(get(edit3, 'String')); 

        % Dodatkowe zmienne
        velocity = str2double(get(edit4, 'String'));
        testLenght = str2double(get(edit5, 'String')); 


        % Sprawdzanie, czy wprowadzone wartości są poprawne
        if ~isnan(a) && ~isnan(b) && ~isnan(c) && ~isnan(fastTestVelocity) && ~isnan(slowTestVelocity) && ~isnan(youngModulusFirstPart) && ~isnan(youngModulusSecondPart) && ~isnan(testLength)  && ~isnan(lengthFirstPartModulusTest) && ~isnan(lengthSecondPartModulusTest)
            % Przypisywanie wartości do zmiennych w kodzie
            sideLengthA = a;
            sideLengthB = b;
            initialLength = c;
            crossSectionalArea = a * b;

            % Wyświetlanie przypisanych wartości
            disp(['A side length: ', num2str(sideLengthA), ' [mm]']);
            disp(['B side length: ', num2str(sideLengthB), ' [mm]']);
            disp(['Initial length: ', num2str(initialLength), ' [mm]']);
            disp('Cross-sectional area:');
            disp(num2str(crossSectionalArea));
            disp('[mm^2]');

            disp(['test velocity: ', num2str(velocity), ' [mm/s]']);
            disp(['test lenght: ', num2str(testLenght), ' [mm/s]']);
            

            % Zamykanie okna GUI
            close(fig);
        else
            % Wyświetlanie komunikatu o błędzie
            errordlg('Wprowadź poprawne wartości liczbowe.', 'Błąd', 'modal');
        end

   
%%MACHINE VALUES: 

 dane = [slowTestVelocity, fastTestVelocity, youngModulusFirstPart, youngModulusSecondPart, testLength, lengthFirstPartModulusTest, lengthSecondPartModulusTest]; % Zastąp tym danymi, które chcesz wysłać

% Wysyłanie danych
for i = 1:7
    fprintf(Device, '%d\n', dane(i));
end
    end

    % Funkcje dla przycisków
    function startSlowTest(~, ~)
        write(Device, "M11", 'string');
    end

    function startFastTest(~, ~)
        write(Device, "M12", 'string');
    end

    function startYoungModulusTest(~, ~)
        write(Device, "M13", 'string');
    end

    function startUpwardMovement(~, ~)
        write(Device, "M1", 'string');
    end

    function startDownwardMovement(~, ~)
        write(Device, "M2", 'string');
    end

    % Funkcja do resetowania wykresu
    function resetPlot(~, ~)
        measurmentData = [];
        displacementData = [];
        maxForceValue = 0;
        clf(2,"reset"); % Wyczyszczenie aktualnego wykresu
        figure(2); % Przełączenie się do nowego okna
    end

    function turnOff(~, ~)
        fclose('Device');
        clc; clear; close all;
    end

    while true
        data = readline(Device);
        data = str2double(strsplit(data, ','));
        measurement = data(1);
        displacement = data(2);

        measurmentData = [measurmentData, measurement];
        displacementData = [displacementData, displacement];

        figure;
        plot(displacementData , measurmentData);
        title("FORCE TO DISPLACEMENT DIAGRAM");
        xlabel("dispacement [mm]");
        ylabel("force [N]");

        % Aktualizacja największej wartości siły
        maxForceValue = max(maxForceValue, max(measurmentData));

        maxTensStrenght = maxForceValue / crossSectionalArea;

        text(0.7, 0.9, ['Max Force: ' num2str(maxForceValue)], 'Units', 'normalized');
        text(0.7, 0.8, ['Tensile strength: ' num2str(maxTensStrenght)], 'Units', 'normalized');
        drawnow; % Aktualizacja wykresu

        tensStrenght = measurmentData / crossSectionalArea;
        elongation = (displacementData / initialLength) * 100; %%PERCENT

        figure;
        plot(elongation, tensStrenght);
        title("TENSION TO ELONGATION DIAGRAM");
        xlabel("elongation [%]");
        ylabel("tension [MPa]");
    end
end