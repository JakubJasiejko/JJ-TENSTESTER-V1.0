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
    button1 = uicontrol('Style', 'pushbutton', 'String', 'SLOW TEST', 'Position', [10 200 100 30], 'Callback', @startSlowTest);
    button2 = uicontrol('Style', 'pushbutton', 'String', 'FAST TEST', 'Position', [10 160 100 30], 'Callback', @startFastTest);
    button3 = uicontrol('Style', 'pushbutton', 'String', 'YOUNG MODULUS TEST', 'Position', [10 120 140 30], 'Callback', @startYoungModulusTest);
    button4 = uicontrol('Style', 'pushbutton', 'String', 'UPWARD MOVEMENT', 'Position', [10 80 120 30], 'Callback', @startUpwardMovement);
    button5 = uicontrol('Style', 'pushbutton', 'String', 'DOWNWARD MOVEMENT', 'Position', [10 40 140 30], 'Callback', @startDownwardMovement);
    resetButton = uicontrol('Style', 'pushbutton', 'String', 'RESET PLOT', 'Position', [10 10 100 30], 'Callback', @resetPlot);
    disableButton = uicontrol('Style', 'pushbutton', 'String', 'TURN OFF', 'Position', [10 240 100 30], 'Callback', @turnOff);

    %values menu
    fig = figure('Position', [100, 100, 600, 450], 'Name', 'Enter values', 'NumberTitle', 'off', 'MenuBar', 'none');

    prompt1 = uicontrol('Style', 'text', 'Position', [20, 350, 200, 20], 'String', 'first side length [mm]:');
    edit1 = uicontrol('Style', 'edit', 'Position', [220, 350, 100, 20]);

    prompt2 = uicontrol('Style', 'text', 'Position', [20, 300, 200, 20], 'String', 'second side length [mm]:');
    edit2 = uicontrol('Style', 'edit', 'Position', [220, 300, 100, 20]);

    prompt3 = uicontrol('Style', 'text', 'Position', [20, 270, 200, 20], 'String', 'initial length [mm]:');
    edit3 = uicontrol('Style', 'edit', 'Position', [220, 270, 100, 20]);

    % Dodatkowe zmienne
    prompt4 = uicontrol('Style', 'text', 'Position', [20, 240, 200, 20], 'String', 'fast test velocity [mm/s]:');
    edit4 = uicontrol('Style', 'edit', 'Position', [220, 240, 100, 20]);

    prompt5 = uicontrol('Style', 'text', 'Position', [20, 210, 200, 20], 'String', 'slow test velocity [mm/s]:');
    edit5 = uicontrol('Style', 'edit', 'Position', [220, 210, 100, 20]);

    prompt6 = uicontrol('Style', 'text', 'Position', [20, 180, 200, 20], 'String', 'young modulus first part test [GPa]:');
    edit6 = uicontrol('Style', 'edit', 'Position', [220, 180, 100, 20]);

    prompt7 = uicontrol('Style', 'text', 'Position', [20, 150, 200, 20], 'String', 'young modulus second part test [GPa]:');
    edit7 = uicontrol('Style', 'edit', 'Position', [220, 150, 100, 20]);

    prompt8 = uicontrol('Style', 'text', 'Position', [20, 120, 200, 20], 'String', 'fast test length [mm]:');
    edit8 = uicontrol('Style', 'edit', 'Position', [220, 120, 100, 20]);

    prompt10 = uicontrol('Style', 'text', 'Position', [20, 60, 200, 20], 'String', 'length of first part modulus test [mm]:');
    edit10 = uicontrol('Style', 'edit', 'Position', [220, 60, 100, 20]);

    prompt11 = uicontrol('Style', 'text', 'Position', [20, 30, 200, 20], 'String', 'length of second part modulus test [mm]:');
    edit11 = uicontrol('Style', 'edit', 'Position', [220, 30, 100, 20]);

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
        fastTestVelocity = str2double(get(edit4, 'String'));
        slowTestVelocity = str2double(get(edit5, 'String')); 
        youngModulusFirstPart = str2double(get(edit6, 'String')); 
        youngModulusSecondPart = str2double(get(edit7, 'String')); 
        testLength = str2double(get(edit8, 'String')); 

        lengthFirstPartModulusTest = str2double(get(edit10, 'String')); 
        lengthSecondPartModulusTest = str2double(get(edit11, 'String')); 

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

            disp(['Fast test velocity: ', num2str(fastTestVelocity), ' [mm/s]']);
            disp(['Slow test velocity: ', num2str(slowTestVelocity), ' [mm/s]']);
            disp(['Young modulus first part test velocity: ', num2str(youngModulusFirstPart), ' [GPa]']);
            disp(['Young modulus second part velocity: ', num2str(youngModulusSecondPart), ' [GPa]']);
            disp(['Fast test length: ', num2str(testLength), ' [mm]']);

            disp(['Length of first part modulus test: ', num2str(lengthFirstPartModulusTest), ' [mm]']);
            disp(['Length of second part modulus test: ', num2str(lengthSecondPartModulusTest), ' [mm]']);

            % Zamykanie okna GUI
            close(fig);
        else
            % Wyświetlanie komunikatu o błędzie
            errordlg('Wprowadź poprawne wartości liczbowe.', 'Błąd', 'modal');
        end

