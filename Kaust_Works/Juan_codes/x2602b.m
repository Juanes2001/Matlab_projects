% MATLAB Script for Keithley 2602B GPIB Communication

% Clear workspace and close all instruments
clear; clc;
%Close any instruments already open
instr  = instrfind;
if ~isempty(instr)
    fclose(instr);
    delete(instr);
end

% Define GPIB parameters
GPIB_address = 26; % Change this to your Keithley's GPIB address
interface_index = 0; % Normally 0 unless multiple GPIB interfaces are used

% Create a GPIB object
Keithley = visa('NI', sprintf('GPIB%d::%d::INSTR', interface_index, GPIB_address));

% Set buffer size and timeout
Keithley.InputBufferSize = 10000;
Keithley.OutputBufferSize = 10000;
Keithley.Timeout = 10; % Time in seconds

% Open connection to the instrument
fopen(Keithley);

% Reset the instrument
fprintf(Keithley, '*RST');

pause(1);

fprintf(Keithley, 'beeper.enable = beeper.ON' );
fprintf(Keithley,'beeper.beep(5,100)');

% Setup measurement - Configure for a voltage measurement
fprintf(Keithley, '*IDN?');
disp(fscanf(Keithley));

% Close and delete the GPIB object
fclose(Keithley);
delete(Keithley);
clear Keithley;


%% KEITHLEY CONTROL%%%%








