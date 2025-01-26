%% Single Wavelength Power Sweep for Xiangpeng
% Instruments: 
% Keysight Tunable Laser N7776C
% Keysight VOA N7761A
% Keysight Power Meter N7742C
% William He, December 18, 2023

clear;
%Close any instruments already open
instr  = instrfind;
if ~isempty(instr)
    fclose(instr);
    delete(instr);
end

%% Setup Parameters
wavelength = 1281.41;
power_start = 0; %dbm
power_end = 11; %dbm
power_step = 0.1;
% Calculatethe number of points
points = floor((power_end-power_start) / power_step) + 1; 

%% Set Up Instruments
N7742C = visa('KEYSIGHT', 'TCPIP0::100.65.31.121::inst0::INSTR');
N7742C.InputBufferSize = 8388608;
N7742C.ByteOrder = 'littleEndian';
fopen(N7742C);

N7776C = visa('KEYSIGHT', 'TCPIP0::100.65.30.13::inst0::INSTR');
N7776C.InputBufferSize = 8388608;
N7776C.ByteOrder = 'littleEndian';
fopen(N7776C);

fprintf(N7776C, '*RST');
fprintf(N7742C, '*RST');
fprintf(N7776C, sprintf(':SOURce0:POWer:UNIT %d', 0));
fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:UNIT %d', 0));
fprintf(N7776C, sprintf(':SOURce0:WAVelength %g NM', wavelength));
fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:WAVelength %g NM', wavelength));
fprintf(N7776C, sprintf(':SOURce0:POWer:STATe %d', 1));
fprintf(N7776C, sprintf(':SOURce0:POWer:LEVel:IMMediate:AMPLitude %g DBM', 2));
pause(10)

%% Measurement Loop
P = [];
for power = power_start:power_step:power_end
    fprintf(N7776C, sprintf(':SOURce0:POWer:LEVel:IMMediate:AMPLitude %g DBM', power));
    pause(0.2)
    fprintf(N7742C, ':INITiate:CHANnel:IMMediate');
    pause(0.1)
    powerValue = str2double(query(N7742C, ':FETCh2:CHANnel:SCALar:POWer:DC?'));
    P = [P, powerValue];
end
fprintf(N7776C, sprintf(':SOURce0:POWer:STATe %d', 0));

% %% Check for errors
% errors = query(N7776C, ':SYSTem:ERRor:ALL?');
% disp(errors)
% errors = query(N7742C, ':SYSTem:ERRor:ALL?');
% disp(errors)
csvwrite('TRANS_1310_80_0.2_0V.csv', P);
%% Cleanup
fclose(N7742C);
delete(N7742C);
clear N7742C;
fclose(N7776C);
delete(N7776C);
clear N7776C;

%% Plot Results
power_i = power_start:power_step:power_end;
figure(1);
subplot(2,1,1)
trans=plot(power_i, P,'-');
xlabel("Input Power (dBm)");
ylabel("Output Power (dBm)");
title('Input vs Output Power');

T = 10.^((P-power_i)./10).*100;
subplot(2,1,2)
trans_curve=plot(power_i, T,'-');
xlabel("Input Power (dBm)");
ylabel("Transmission (%)");
title('Transmission vs Input Power');
%ylim([0,25]);

saveas(gcf,'trans_1310_80_0.2_0V.png');

