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

Device = serialport("COM7", 9600); %%choose proper COM, to which your Arduino board is connected. 

% buttons
figure;
button1 = uicontrol('Style', 'pushbutton', 'String', 'SLOW TEST', 'Position', [10 200 100 30], 'Callback', @startSlowTest);
button2 = uicontrol('Style', 'pushbutton', 'String', 'FAST TEST', 'Position', [10 160 100 30], 'Callback', @startFastTest);
button3 = uicontrol('Style', 'pushbutton', 'String', 'YOUNG MODULUS TEST', 'Position', [10 120 140 30], 'Callback', @startYoungModulusTest);
button4 = uicontrol('Style', 'pushbutton', 'String', 'UPWARD MOVEMENT', 'Position', [10 80 120 30], 'Callback', @startUpwardMovement);
button5 = uicontrol('Style', 'pushbutton', 'String', 'DOWNWARD MOVEMENT', 'Position', [10 40 140 30], 'Callback', @startDownwardMovement);

% Matrices for data
measurmentData = [];
displacementData = [];

% Functions for buttons
    function startSlowTest(~, ~)
        write(Device, "M11" ,'string'); % Wysłanie komendy do Arduino
        
    end

    function startFastTest(~, ~)
        write(Device, "M12",'string');

    end

    function startYoungModulusTest(~, ~)
        write(Device, "M13" ,'string');

    end

    function startUpwardMovement(~, ~)
        write(Device, "M1" ,'string');

    end

    function startDownwardMovement(~, ~)
        write(Device, "M2" ,'string');

    end



while true

        data = readline(Device); 
        data = str2double(strsplit(data, ',')); 
        displacement = data(2);
        
        measurmentData = [measurmentData, measurement];
        displacementData = [displacementData, displacement];

        figure(2);
        plot(displacementData , measurmentData);
       
    end
end

