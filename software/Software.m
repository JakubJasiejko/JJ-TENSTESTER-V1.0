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
  
 crossSectionalArea = 0;
 initialLenght = 0;

 
 Device = serialport("COM9", 9600, 'Timeout', 1e9); %% set yours COM port

% initial menu
figure(1);
button1 = uicontrol('Style', 'pushbutton', 'String', 'SLOW TEST', 'Position', [10 200 100 30], 'Callback', @startSlowTest);
button2 = uicontrol('Style', 'pushbutton', 'String', 'FAST TEST', 'Position', [10 160 100 30], 'Callback', @startFastTest);
button3 = uicontrol('Style', 'pushbutton', 'String', 'YOUNG MODULUS TEST', 'Position', [10 120 140 30], 'Callback', @startYoungModulusTest);
button4 = uicontrol('Style', 'pushbutton', 'String', 'UPWARD MOVEMENT', 'Position', [10 80 120 30], 'Callback', @startUpwardMovement);
button5 = uicontrol('Style', 'pushbutton', 'String', 'DOWNWARD MOVEMENT', 'Position', [10 40 140 30], 'Callback', @startDownwardMovement);
resetButton = uicontrol('Style', 'pushbutton', 'String', 'RESET PLOT', 'Position', [10 10 100 30], 'Callback', @resetPlot);
disableButton = uicontrol('Style', 'pushbutton', 'String', 'TURN OFF', 'Position', [10 240 100 30], 'Callback', @turnOff);

%values menu
fig = figure('Position', [100, 100, 600, 300], 'Name', 'Enter values', 'NumberTitle', 'off', 'MenuBar', 'none');

prompt1 = uicontrol('Style', 'text', 'Position', [20, 150, 100, 20], 'String', 'first side lenght [mm]:');
edit1 = uicontrol('Style', 'edit', 'Position', [120, 150, 100, 20]);

prompt2 = uicontrol('Style', 'text', 'Position', [20, 100, 100, 20], 'String', 'second side lenght [mm]:');
edit2 = uicontrol('Style', 'edit', 'Position', [120, 100, 100, 20]);

prompt3 = uicontrol('Style', 'text', 'Position', [20, 70, 100, 20], 'String', 'initial lenght [mm]:');
edit3 = uicontrol('Style', 'edit', 'Position', [120, 70, 100, 20]);

confirmButton = uicontrol('Style', 'pushbutton', 'Position', [100, 0, 100, 30], 'String', 'Confirm', 'Callback', @confirmCallback);

resultText = uicontrol('Style', 'text', 'Position', [20, 40, 300, 20], 'String', '', 'HorizontalAlignment', 'left');



measurmentData = [];
displacementData = [];
maxForceValue = 0;

    function confirmCallback(~, ~)
        % cross-sectional area- So
        
        a = str2double(get(edit1, 'String')); %first side lenght [mm]
        b = str2double(get(edit2, 'String')); %second side lenght [mm]
        c = str2double(get(edit3, 'string')); %initial lenght [mm]

        % Sprawdzanie, czy wprowadzone wartości są poprawne
        if ~isnan(a) && ~isnan(b) && ~isnan(c) 
            % Przypisywanie wartości do zmiennych w kodzie
            sideLenghtA = a;
             sideLenghtB = b;
             initialLenght = c;
             crossSectionalArea = a * b;
            
            % Wyświetlanie przypisanych wartości
           disp(['A side lenght: ', num2str(sideLenghtA), '[mm]']);
           disp(['B side lenght: ', num2str(sideLenghtB), '[mm]']);
           disp(['initial lenght: ',num2str(initialLenght),'[mm]']);
           disp('Cross sectional area:')
           disp(num2str(crossSectionalArea));
           disp('[mm^2]')
            % Zamykanie okna GUI
            close(fig);
        else
            % Wyświetlanie komunikatu o błędzie
            errordlg('Wprowadź poprawne wartości liczbowe.', 'Błąd', 'modal');
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
         clc;clear;close all;
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
    
    maxTensStrenght = maxForceValue / crossSectionalArea;
    
text(0.7, 0.9, ['Max Force: ' num2str(maxForceValue)], 'Units', 'normalized');
text(0.7, 0.8, ['Tensile strength: ' num2str(maxTensStrenght)], 'Units', 'normalized');
    drawnow; % Aktualizacja wykresu

tensStrenght = measurmentData / crossSectionalArea;
elongation = (displacementData / initialLenght) *100; %%PERCENT

figure(3);
   plot(elongation, tensStrenght);
   title("TENSION TO ELONGATION DIAGRAM");
   xlabel("elongation [%]");
   ylabel("tension [MPa]");
   
end

end


%%error powoduje niewyswietlanie wykresu!!!! error num2str