% MATLAB Script for Keithley 2602B GPIB Communication

% Clear workspace and close all instruments
clear; clc;

% We thefine the object andthe constructor

 
Power_meter = x2602B_class("NI", 26, 0);

disp(Power_meter.iDN(Power_meter.Visa_obj));
Power_meter.set_src_mode(Power_meter.Visa_obj,'A',"current");
Power_meter.set_src_volt_curr_level(Power_meter.Visa_obj,'A',"current",0.010);


disp(Power_meter.get_meas(Power_meter.Visa_obj,'A',"voltage"));



%% KEITHLEY CONTROL%%%%




