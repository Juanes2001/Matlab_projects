clear
close all
clc

%% we create the objects of the classes needed
osa = A6380_class("10.72.171.64"); % ETHERNET
keysight = B2902B_class('NI', 23, 0); % GPIB
 
% We make sure there are not intruments enable




%%
%Settings
splitter_loss_OSA = 3.12; %dB
splitter_loss_powmtr = 3.37; %dB
Do_LIV = 0;
Four_wire = 0;
foldername = 'B074 20C';
filename = 'AllUCSBMLL4_Die1_Bar2_B074_20C';
format long
cd(foldername)

%% LIV Sweep
if Do_LIV
    cd('LIV')
    Fiber_coupled_LIV_WH
    cd ..
end

%% Inputs for Keysight SMU
I_start = 0.01;
I_step = 0.001;
I_stop = 0.20;
I_Gain = I_start:I_step:I_stop;
limit_V_Gain = 4;

% V_SA_start = 0;
% V_SA_step = -0.3;
% V_SA_stop = -7;
% V_SA = V_SA_start:V_SA_step:V_SA_stop;
% limit_I_SA = -0.06;
% 
% V_Gain = NaN(length(I_Gain),length(V_SA)); 
% I_SA=V_Gain;
% center_RFfreq=I_SA;
% center_RFpow=I_SA;
% power=I_SA;
% center_wl=I_SA;
% center_pow=I_SA;
% 
% V_Gain_LIV=NaN(1,length(I_Gain));
% power_LIV = V_Gain_LIV;
% pow_ave = NaN(1,4);

%% Inputs for OSA
check_time = .05;       %checks to see if the scan is done in intervals of this many seconds
start_center_wl = 1297; %nm
lasing_threshold = -splitter_loss_OSA - 36;

span_fine = 37; %nm
amp = -20;      %dBm - ref level
                
RBW_course = .1; %nm = res bandwidth
RBW_fine = .02;   
sensitivity='NORMAL'; %AUTO, NORMAL, MID, HIGH1, HIGH2, HIGH3, 
idle_sensitivity='NORMAL';
connector='ANGL'; %NORM or ANGL
speed='1x'; %1x for lasers, 2x for SLI

%% Configure Keysight SMU
% Connect to the instrument

osa



%%
% Setup the instrument
fprintf(B2902B, '*RST');
fprintf(B2902B, ':FORMat:DATA ASCii');
fprintf(B2902B, ':SOURce1:FUNCtion:MODE CURRent');
fprintf(B2902B, sprintf(':SENSe1:VOLTage:PROTection:LEVel %g', limit_V_Gain));
fprintf(B2902B, ':SOURce2:FUNCtion:MODE VOLTage');
fprintf(B2902B, sprintf(':SENSe2:CURRent:PROTection:LEVel %g', limit_I_SA));
fprintf(B2902B, sprintf(':SOURce1:CURRent %g', I_Gain(1)));
fprintf(B2902B, sprintf(':SOURce2:VOLTage %g', V_SA(1)));
fprintf(B2902B, sprintf(':DISPlay:ENABle ON'));
fprintf(B2902B, ':OUTPut1:STATe 1');
fprintf(B2902B, ':OUTPut2:STATe 1');
fprintf(B2902B, ':MEAS:CURRent? (@2)');
I_SA(1,1) = str2num(fscanf(B2902B));
fprintf(B2902B, ':MEAS:VOLTage? (@1)');
V_Gain(1,1) = str2num(fscanf(B2902B));

%% Configure OSA 
OSA=visa('ni', 'TCPIP::192.168.1.100::inst0::INSTR');
OSA.InputBufferSize=17*span_fine/.002+1000; %17 characters per trace data point required, sampling bandwidth determins # of points
OSA.Timeout=25;
fopen(OSA);

fprintf(OSA,'*RST');
% fprintf(OSA, ':INIT:CONT OFF'); %Disable continuous sweep
fprintf(OSA, ':SENS:SWE:POIN auto');
%fprintf(OSA, [':SENS:SWE:POIN' num2str(Points)]);
fprintf(OSA, [':SENS:SETT:FCON ' connector]);
fprintf(OSA, [':SENS:SWE:SPE' speed ]);
fprintf(OSA, ':init:smode 1'); %Set to single sweep
fprintf(OSA, ':SENSe:WAVelength:SPAN %dnm', span_fine);
fprintf(OSA, ':SENSe:WAVelength:Center %dnm', start_center_wl);
fprintf(OSA, ':SENS:BWID:RES %.2fnm', RBW_fine);
fprintf(OSA, [':SENS:SENS ' sensitivity]);
fprintf(OSA, ':CALibration:WAVelength:INTernal:AUTO 0');
fprintf(OSA, ':CALibration:ZERO[:AUTO] 0');

%% Configure OSC
% Typically 2ms/div, 5V/div on 2.5Hz spin
% Initialize VISA object
OSC = visa('agilent', 'USB0::0x0957::0x17BC::MY54450145::0::INSTR');
OSC.InputBufferSize = 8388608;
OSC.ByteOrder = 'littleEndian';
fopen(OSC);

% Set the oscilloscope to remote mode
fprintf(OSC, ':SYSTEM:REMOTE');
fprintf(OSC, ':ACQuire:MODE RTIM'); % Real-time acquisition mode
fprintf(OSC, ':ACQuire:STOPAfter RUNSTop'); % Ensure continuous acquisition

% Define the channels
channels = {'CHAN1'};
dataStorage = {'AC_signal'};

% Preallocate storage variables
AC_signal = [];


% %% Configure Powermeter
% N7742C = visa('agilent', 'TCPIP0::100.65.31.121::inst0::INSTR');
% N7742C.InputBufferSize = 8388608;
% N7742C.ByteOrder = 'littleEndian';
% fopen(N7742C);
% fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:UNIT %d', 1));
% fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:WAVelength %g NM', 1310.0));
% fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:ATIMe %g US', 1.0));

%% Run 2D Mapping
tic
for j=1:length(I_Gain)
    %Set Laser Gain current
    fprintf(B2902B, sprintf(':SOURce1:CURRent %g', I_Gain(j)));
    k=1;
    compliance = 0;
    notlasing = 0;
    for k=1:length(V_SA)
        fprintf(B2902B, sprintf(':SOURce2:VOLTage %g', V_SA(k)));
        pause(0.1)
        fprintf(B2902B, ':MEAS:CURRent? (@2)');
        I_SA(j,k) = str2num(fscanf(B2902B));
        fprintf(B2902B, ':MEAS:VOLTage? (@1)');
        V_Gain(j,k) = str2num(fscanf(B2902B));

        fprintf(OSA, ':init:imm;');
        fprintf(OSA, ':CALCulate:AMARKer1:MAXimum');
        fprintf(OSA,':CALCULATE:AMARKER1:X?');
        center_wl(j,k) =  str2num(fscanf(OSA));
        fprintf(OSA,':CALCULATE:AMARKER1:Y?');
        center_pow(j,k) =  str2num(fscanf(OSA));

        fprintf(OSA,':TRAC:DATA: Y? TRA;');
        opticalpower =  str2num(fscanf(OSA));
        fprintf(OSA,':TRAC:DATA: X? TRA;');
        wavelength = str2num(fscanf(OSA));
        fprintf(OSA, ':SENSe:WAVelength:CENTer %.10fm', center_wl(j,k));
        figure(4);
        plot(wavelength*1e9, opticalpower)
        ylim([-80 0])
        save([filename '_OSA_' num2str(I_Gain(j)*1000) 'mA_' num2str(-V_SA(k)) 'V.mat'], 'opticalpower', 'wavelength')
        %power(j,k) = str2double(query(N7742C, ':FETCh2:CHANnel:SCALar:POWer:DC?'));
        for i = 1:length(channels)
            channel = channels{i};
            dataVar = dataStorage{i};
        
            % Acquire waveform data
            fprintf(OSC, [':WAVeform:SOURce ' channel]);   % Set waveform source to the selected channel
            fprintf(OSC, ':WAVeform:FORMat ASCii');        % Set waveform format to ASCII
        
            % Read waveform data
            fprintf(OSC, ':WAVeform:DATA?');  % Request waveform data
            waveformData = fscanf(OSC, '%s'); % Read waveform data
        
            % Process the acquired data
            waveformData = str2double(strsplit(waveformData, ',')); % Convert ASCII data to numeric array
        
            % Read time axis data
            fprintf(OSC, ':WAVeform:XINCrement?');
            xIncrement = str2double(fscanf(OSC, '%s')); % Time increment per sample
        
            fprintf(OSC, ':WAVeform:POINts?');
            numPoints = str2double(fscanf(OSC, '%s')); % Number of points in waveform
        
            fprintf(OSC, ':WAVeform:XORigin?');
            xorigin = str2double(fscanf(OSC, '%s')); % Origin of waveform
        
            % Generate time axis
            timeAxis = (xorigin:xIncrement:xorigin+(numPoints-1)*xIncrement);
        
            % Store the data in the corresponding variable
            assignin('base', dataVar, waveformData);
        end
        figure(8)
        plot(timeAxis, AC_signal);
        xlabel('Time (s)');
        ylabel('Amplitude (V)');
        title('Average AC Signal');
        save([filename '_OSC_' num2str(I_Gain(j)*1000) 'mA_' num2str(-V_SA(k)) 'V.mat'], 'timeAxis', 'AC_signal')
    end
end

%power=power.*10^(splitter_loss_powmtr/10);
%% Clean Up

fprintf(OSA, [':SENS:SENS ' idle_sensitivity]);

% Clean up Keysight SMU
% Turn off the output
fprintf(B2902B, ':OUTPut1:STATe 0');
fprintf(B2902B, ':OUTPut2:STATe 0');

% Check for errors
errors = query(B2902B, ':SYSTem:ERRor:ALL?');
disp(errors)

% Disconnect and cleanup
fclose(B2902B);
delete(B2902B);
fclose(OSA);
delete(OSA);
clear B2902B OSA;
% fclose(N7742C);
% delete(N7742C);
% clear N7742C;
fclose(OSC);
delete(OSC);
clear OSC;

toc
%%
save([filename '_scan_data.mat'], 'I_Gain', 'V_Gain', 'V_Gain_LIV', 'V_SA', 'I_SA', 'center_wl', 'center_pow','power','power_LIV', 'RBW_fine', 'splitter_loss_OSA','splitter_loss_powmtr', 'center_RFfreq', 'center_RFpow','Four_wire')