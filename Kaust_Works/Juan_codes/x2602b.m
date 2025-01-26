% Example MATLAB Script to Setup and Communicate with Keithley 2602B via GPIB

% Clear MATLAB workspace
clear;
clc;

% Create a GPIB object. Replace 'GPIB0::26::INSTR' with your GPIB address
% The '26' should be replaced with the GPIB address of your instrument.
visaObj = visa('NI', 'GPIB0::26::INSTR');

% Set buffer size and timeout
visaObj.InputBufferSize = 10000;
visaObj.OutputBufferSize = 10000;
visaObj.Timeout = 10; % in seconds

% Open connection to the instrument
fopen(visaObj);

% Communicate with the instrument
fprintf(visaObj, '*RST'); % Reset the instrument
fprintf(visaObj, 'source:function current'); % Set the source to current
fprintf(visaObj, 'source:current:level 0.01'); % Set the source current to 10 mA
fprintf(visaObj, 'measure:voltage()'); % Measure the voltage across the load

% Read the measured voltage
voltage = fscanf(visaObj);

% Display the measured voltage
disp(['Measured Voltage: ', voltage, ' V']);

% Close the VISA object
fclose(visaObj);
delete(visaObj);
clear visaObj;