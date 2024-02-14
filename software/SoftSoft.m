clc;
clear;
close all;

global velocity testlenght;


%% COM PORT PANEL

figure(1);
uiPanel = uipanel('Title', 'Konfiguracja Portu COM', 'Position', [0.1 0.3 0.8 0.4]);

comPortEdit = uicontrol(uiPanel, 'Style', 'edit', 'Position', [150 60 100 30]);
uicontrol(uiPanel, 'Style', 'text', 'Position', [30 60 120 30], 'String', 'Numer Portu COM:');

confirmButton = uicontrol(uiPanel, 'Style', 'pushbutton', 'Position', [280 60 80 30], 'String', 'Zatwierdź', 'Callback', @confirmCallback);

function confirmCallback(~, ~)
    comPortEdit = findobj('Style', 'edit');
    comPort = get(comPortEdit, 'String');

    comPort = regexprep(comPort, '[^\d]+', '');

    Device = serialport(['COM', char(comPort)], 9600, 'Timeout', 1e9);

    Control(comPort, Device);
end

function receiveAndPlotData(Device)
    
    loadCellMeasurements = [];
    encoderMeasurements = [];
    
   figure;


    while 1

    dataString = readline(Device);
       measurements = str2double(strsplit(dataString));       
            loadCell = measurements(1) / 512; %encoderPulsesPerRevolution * 2
            encoder = measurements(2);

            fprintf('llll %f\n', loadCell);
            fprintf('eeee %f\n', encoder);

            loadCellMeasurements = [loadCellMeasurements, loadCell];
            encoderMeasurements = [encoderMeasurements, encoder];
            

         plot(encoderMeasurements, loadCellMeasurements);
         title('FORCE TO DISPLACEMENT DIAGRAM');
         ylabel('FORCE [N]');
         xlabel('displacement [mm]');
         drawnow;
    end
end


%% MENU 
function Control(comPort, Device)
    fig = figure('Position', [100, 100, 600, 450], 'Name', 'Enter values', 'NumberTitle', 'off', 'MenuBar', 'none');

    welcome = uicontrol('Style', 'text', 'Position', [200, 400, 200, 40], 'String', 'TENSTESTER V1.0', 'FontSize', 15, 'FontWeight', 'bold');
    values = uicontrol('Style', 'text', 'Position', [0, 360, 200, 40], 'String', 'enter values:', 'FontSize', 12, 'FontWeight', 'bold');

    prompt1 = uicontrol('Style', 'text', 'Position', [0, 330, 200, 20], 'String', 'first side length [mm]:');
    edit1 = uicontrol('Style', 'edit', 'Position', [170, 330, 100, 20]);

    prompt2 = uicontrol('Style', 'text', 'Position', [0, 300, 200, 20], 'String', 'second side length [mm]:');
    edit2 = uicontrol('Style', 'edit', 'Position', [170, 300, 100, 20]);

    prompt3 = uicontrol('Style', 'text', 'Position', [0, 270, 200, 20], 'String', 'initial length [mm]:');
    edit3 = uicontrol('Style', 'edit', 'Position', [170, 270, 100, 20]);

    prompt4 = uicontrol('Style', 'text', 'Position', [0, 240, 200, 20], 'String', 'velocity [mm/min]:');
    edit4 = uicontrol('Style', 'edit', 'Position', [170, 240, 100, 20]);

    prompt5 = uicontrol('Style', 'text', 'Position', [0, 210, 200, 20], 'String', 'test length [mm}:');
    edit5 = uicontrol('Style', 'edit', 'Position', [170, 210, 100, 20]);

    confirmButton = uicontrol('Style', 'pushbutton', 'Position', [100, 150, 100, 30], 'String', 'Confirm', 'Callback', @setValues);

    executeButton = uicontrol('Style', 'pushbutton', 'Position', [340, 310, 100, 30], 'String', 'execute test', 'Callback', @execute);

    jogMenuButton = uicontrol('Style', 'pushbutton', 'Position', [340, 280, 100, 30], 'String', 'jog menu', 'Callback', @jog);

    resetValuesButton = uicontrol('Style', 'pushbutton', 'Position', [340, 250, 100, 30], 'String', 'reset values', 'Callback', @resetValues);

    resetPlotButton = uicontrol('Style', 'pushbutton', 'Position', [340, 220, 100, 30], 'String', 'reset plot', 'Callback', @resetPlot);

    exitButton = uicontrol('Style', 'pushbutton', 'Position', [340, 190, 100, 30], 'String', 'exit', 'Callback', @exitTesting);

    % Text and buttons on the right
    resultText = uicontrol('Style', 'text', 'Position', [400, 350, 200, 60], 'String', '', 'HorizontalAlignment', 'left');

function setValues(~, ~)
    firstSideLength = str2double(get(edit1, 'String'));
    secondSideLength = str2double(get(edit2, 'String'));
    initialLength = str2double(get(edit3, 'String'));
    global velocity testlenght;
    velocity = str2double(get(edit4, 'String'));
    testlenght = str2double(get(edit5, 'String'));

    
    if ~isnan(firstSideLength) && ~isnan(secondSideLength) && ~isnan(initialLength) && ~isnan(velocity) && ~isnan(testlenght)

        crossSectionalArea = firstSideLength * secondSideLength;

        disp(['A side length: ', num2str(firstSideLength), ' [mm]']);
        disp(['B side length: ', num2str(secondSideLength), ' [mm]']);
        disp(['Initial length: ', num2str(initialLength), ' [mm]']);
        disp('Cross-sectional area:');
        disp(num2str(crossSectionalArea));
        disp('[mm^2]');
        disp(['test velocity: ', num2str(velocity), ' [mm/s]']);
        disp(['test length: ', num2str(testlenght), ' [mm/s]']);
        

    else

        errordlg('set proper values!', 'error', 'modal');
    end
end
function execute(~, ~)
    fig5 = figure('Position', [100, 100, 300, 225], 'Name', 'TEST', 'NumberTitle', 'off', 'MenuBar', 'none');

    global velocity testlenght;

    RPM = (2 * 13.73) / velocity; % pitch * gearbox
    angle = (360 / (13.73 * 2) * testlenght); % oneRev / gearbox * pitch
    time = (testlenght / velocity) * 60000;

    dataString = sprintf('%d %f %s %f', RPM, angle, 'right', time);
    % Assuming Device is a serial port object
    write(Device, dataString, 'string');
    disp(dataString);
     exit1 = uicontrol('Style', 'pushbutton', 'Position', [100, 150, 100, 30], 'String', 'exit', 'Callback', @exitButton1);
    
    receiveAndPlotData(Device);
    

    function exitButton1(~, ~)
        close(fig5);
    end

end
    
    function resetValues(~, ~)
     firstSideLength = 0;
    secondSideLength = 0;
    initialLength = 0;
    velocity = 0;
    testLength = 0;
    crossSectionalArea  = 0; 

    disp(['A side length: ', num2str(firstSideLength), ' [mm]']);
    disp(['B side length: ', num2str(secondSideLength), ' [mm]']);
    disp(['Initial length: ', num2str(initialLength), ' [mm]']);
    disp('Cross-sectional area:');
    disp(num2str(crossSectionalArea));
    disp('[mm^2]');
    disp(['test velocity: ', num2str(velocity), ' [mm/s]']);
    disp(['test length: ', num2str(testLength), ' [mm/s]']);
    
    end
    
    function resetPlot(~, ~)
        %plot reseting
    end

    function exitTesting(~, ~)
        clc;clear;close all;
    end


        
   end %%control end