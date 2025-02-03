% MATLAB Script for Keithley 2602B GPIB Communication

% Clear workspace and close all instruments
clear; clc;

% We thefine the object andthe constructor

 
Power_meter = x2602B_class("NI", 26, 0);

Power_meter.enable_CHA()
Power_meter.disable_CHA()




%% KEITHLEY CONTROL%%%%




