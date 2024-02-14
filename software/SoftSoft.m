clc;
clear;
close all;

global velocity, 
global crossSectionalArea;
global initialLength; 

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
    
    global crossSectionalArea;
    global initialLength;

    stress = [];
    loadCellMeasurements = [];
    encoderMeasurements = [];
    strain = [];
    
   figure;
   button = uicontrol('Style', 'pushbutton', 'String', 'plot off', 'Position', [20, 0, 100, 30], 'Callback', @disablePlot);
    function disablePlot(~, ~)
    clf; 
    close;
end

    while 1

    dataString = readline(Device);
       measurements = str2double(strsplit(dataString));       
            loadCell = measurements(1); 
            encoder = abs(measurements(2) / 512); %encoderPulsesPerRevolution * 2

            fprintf('llll %f\n', loadCell);
            fprintf('eeee %f\n', encoder);

            loadCellMeasurements = [loadCellMeasurements, loadCell];
            encoderMeasurements = [encoderMeasurements, encoder];
            
            stress = [stress, loadCell/crossSectionalArea];
            strain = [strain, ((encoder + initialLength)/initialLength)*100];

            maxForce = max(loadCellMeasurements);
            maxStrain = max(stress);

         subplot(2,1,1);
         plot(encoderMeasurements, loadCellMeasurements, 'r-', 'LineWidth', 2);
         title('FORCE TO DISPLACEMENT DIAGRAM');
         ylabel('force [N]');
         xlabel('displacement [mm]');
         grid on;
         text(0.7, 0.9, ['Max Force: ' num2str(maxForce) '[N]'], 'Units', 'normalized');
         subplot(2,1,2);
         plot(strain, stress, 'r-', 'LineWidth', 2);
         title('STRESS TO STRAIN DIAGRAM');
         ylabel('stress [MPa]');
         xlabel('strain [%]');
         grid on;

        text(0.7, 0.9, ['Tensile strength: ' num2str(maxStrain) '[MPa]'], 'Units', 'normalized');
         
         
         drawnow;


     
    end


end


%% MENU 
function Control(comPort, Device)
    fig = figure('Position', [100, 100, 600, 450], 'Name', 'TENSTESTER V1.0', 'NumberTitle', 'off', 'MenuBar', 'none');

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

    confirmButton = uicontrol('Style', 'pushbutton', 'Position', [100, 150, 100, 30], 'String', 'Confirm', 'Callback', @setValues);

    executeButton = uicontrol('Style', 'pushbutton', 'Position', [340, 310, 100, 30], 'String', 'execute test', 'Callback', @execute);

    jogMenuButton = uicontrol('Style', 'pushbutton', 'Position', [340, 280, 100, 30], 'String', 'jog menu', 'Callback', @jog);

    exitButton = uicontrol('Style', 'pushbutton', 'Position', [340, 250, 100, 30], 'String', 'exit', 'Callback', @exitTesting);

    % Text and buttons on the right
    resultText = uicontrol('Style', 'text', 'Position', [400, 350, 200, 60], 'String', '', 'HorizontalAlignment', 'left');

function setValues(~, ~)
    global crossSectionalArea;
    firstSideLength = str2double(get(edit1, 'String'));
    secondSideLength = str2double(get(edit2, 'String'));
    global initialLength; 
    initialLength = str2double(get(edit3, 'String'));
    global velocity;
    velocity = str2double(get(edit4, 'String'));

    
    if ~isnan(firstSideLength) && ~isnan(secondSideLength) && ~isnan(initialLength) && ~isnan(velocity) 

        crossSectionalArea = firstSideLength * secondSideLength;

        disp(['A side length: ', num2str(firstSideLength), ' [mm]']);
        disp(['B side length: ', num2str(secondSideLength), ' [mm]']);
        disp(['Initial length: ', num2str(initialLength), ' [mm]']);
        disp('Cross-sectional area:');
        disp(num2str(crossSectionalArea));
        disp('[mm^2]');
        disp(['test velocity: ', num2str(velocity), ' [mm/s]']);
        

    else

        errordlg('set proper values!', 'error', 'modal');
    end
end
function execute(~, ~)

    global velocity;

    RPM = velocity /(2 * 13.73); % pitch * gearbox


    dataString = sprintf('%d %s %s %f', RPM, 'left', 'start');
    % Assuming Device is a serial port object
    write(Device, dataString, 'string');
    disp(dataString);
    receiveAndPlotData(Device);


end

    

    function exitTesting(~, ~)
        clc;clear;close all;
    end
    function jog(~, ~)
    fig5 = figure('Position', [100, 100, 300, 225], 'Name', 'jog movement', 'NumberTitle', 'off', 'MenuBar', 'none');
    upButton = uicontrol('Style', 'pushbutton', 'Position', [100, 150, 100, 30], 'String', 'upward', 'Callback', @upward);
    downButton = uicontrol('Style', 'pushbutton', 'Position', [100, 120, 100, 30], 'String', 'downward', 'Callback', @downward);

        function upward(~, ~)
            dataString = '500 left';
            write(Device, dataString, 'string');
            
        end

        function downward(~, ~)
            dataString = '500 right';
            write(Device, dataString, 'string');
        end


    end
   end %%control end
