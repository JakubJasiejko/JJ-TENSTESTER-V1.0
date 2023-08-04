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
%   MATLAB Software for control tester device and analising data          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function Control()

Device = serialport("COM7", 9600); %% Wybierz właściwy port COM, do którego jest podłączona płytka Arduino.

% Tworzenie przycisków
figure(1);
button1 = uicontrol('Style', 'pushbutton', 'String', 'SLOW TEST', 'Position', [10 200 100 30], 'Callback', @startSlowTest);
button2 = uicontrol('Style', 'pushbutton', 'String', 'FAST TEST', 'Position', [10 160 100 30], 'Callback', @startFastTest);
button3 = uicontrol('Style', 'pushbutton', 'String', 'YOUNG MODULUS TEST', 'Position', [10 120 140 30], 'Callback', @startYoungModulusTest);
button4 = uicontrol('Style', 'pushbutton', 'String', 'UPWARD MOVEMENT', 'Position', [10 80 120 30], 'Callback', @startUpwardMovement);
button5 = uicontrol('Style', 'pushbutton', 'String', 'DOWNWARD MOVEMENT', 'Position', [10 40 140 30], 'Callback', @startDownwardMovement);
resetButton = uicontrol('Style', 'pushbutton', 'String', 'RESET PLOT', 'Position', [10 10 100 30], 'Callback', @resetPlot);

measurmentData = [];
displacementData = [];
maxForceValue = 0;

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

while true
    data = readline(Device);
    data = str2double(strsplit(data, ','));
    measurement = data(1);
    displacement = data(2);

    measurmentData = [measurmentData, measurement];
    displacementData = [displacementData, displacement];

    figure(2);
    plot(displacementData , measurmentData);
    title("FORCE TO DISPLACEMENT DIAGRAM");
    xlabel("dispacement [mm]");
    ylabel("force [N]");

    % Aktualizacja największej wartości siły
    maxForceValue = max(maxForceValue, max(measurmentData));
    
    % Dodanie tekstu z największą wartością siły na wykresie
    text(0.7, 0.9, ['Max Force: ' num2str(maxForceValue)], 'Units', 'normalized');

    drawnow; % Aktualizacja wykresu

end

end


