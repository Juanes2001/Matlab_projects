% MATLAB Script for Keithley 2602B GPIB Communication

% Clear workspace and close all instruments
clear; clc;

% We thefine the object andthe constructor

 
Power_meter = x2602B_class(100000, ...
                         100000, ...
                         10, ...
                         "NI", ...
                          26, ...
                          0, ...
                          0, ...
                          ["voltage","current"], ...
                          [[0;0],[0;0]], ...
                          [0,0], ...
                          ["voltage","voltage"], ...
                          [[0;0],[0;0],[0;0],[0;0]], ...
                          [[0;0],[0;0]], ...
                          0, ...
                          [[1;1],[0.1;0.1],[0.3;0.3]], ...
                          [[1;1],[1;1]], ...
                          [[1;1],[1;1]], ...
                          [[1;1],[0.3;0.3],[1;1],[0.5;0.5]]);


%% Let's init the device and the communication.
instr  = instrfind; % We have to be sure we close every single opened intrument
if ~isempty(instr)
    fclose(instr);
    delete(instr);
end

Com_obj = visa (Power_meter.Vendor, sprintf("GPIB%u::%u::INSTR",Power_meter.Interface_index, Power_meter.GPIB_address));

Com_obj.InputBufferSize = 100000;
Com_obj.OutputBufferSize = 100000;
Com_obj.Timeout = 10;

fopen(Com_obj);
disp(Power_meter.iDN(Com_obj));
Power_meter.set_src_mode(Com_obj,'A',"current");
Power_meter.set_src_volt_curr_level(Com_obj,'A',"current",0.010);
Power_meter.current = 10;
Power.voltage();


disp(Power_meter.get_meas(Com_obj,'A',"voltage"));



%% KEITHLEY CONTROL%%%%




