% MATLAB Script for Keithley 2602B GPIB Communication

% Clear workspace and close all instruments
clear; clc;

% We thefine the object andthe constructor

 
Power_meter = x2602B_class("NI", 26, 0);
Power_meter.init();

Power_meter.enable_CHA();
Power_meter.disable_CHA();

Power_meter.set_CHA_srcI();
Power_meter.set_CHA_srcLevelI(1E-3);

Power_meter.set_CHA_srcRangeI(1);


disp(Power_meter.get_CHA_measV());

Power_meter.set_CHA_measRangeV(40);

Power_meter.set_CHB_srcI();
disp(Power_meter.get_CHB_measI());

Power_meter.en_CHA_srcAutoV();

Power_meter.set_CHA_limitI(0.2);
Power_meter.set_CHA_limitV(1.5);


%% KEITHLEY CONTROL%%%%




