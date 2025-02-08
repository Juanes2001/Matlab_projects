clear
close all
clc

%Close any instruments already open
instr = instrfind;
if ~isempty(instr)
    fclose(instr);
    delete(instr);
end
%%
%Settings
splitter_loss_OSA = 3.12; %dB
splitter_loss_powmtr = 3.37; %dB
Do_LIV = 0;
Four_wire = 0;
foldername = 'B072 20C';
filename = 'AllUCSBMLL4_Die2_Bar2_B072_20C';
format long
if ~exist(foldername, 'dir')
    mkdir(foldername);
end
cd(foldername)

%% LIV Sweep
if Do_LIV
    cd('LIV')
    Fiber_coupled_LIV_WH
    cd ..
end

%% Inputs for Keysight SMU
I_start = 0.05;
I_step = 0.005;
I_stop = 0.25;
I_Gain = I_start:I_step:I_stop;
limit_V_Gain = 4;

V_SA_start = 0;
V_SA_step = -0.3;
V_SA_stop = -7;
V_SA = V_SA_start:V_SA_step:V_SA_stop;
limit_I_SA = -0.06;

V_Gain = NaN(length(I_Gain),length(V_SA)); 
I_SA=V_Gain;
center_RFfreq=I_SA;
center_RFpow=I_SA;
power=I_SA;
center_wl=I_SA;
center_pow=I_SA;

V_Gain_LIV=NaN(1,length(I_Gain));
power_LIV = V_Gain_LIV;
pow_ave = NaN(1,4);

%% Inputs for OSA
check_time=.05; %checks to see if the scan is done in intervals of this many seconds
start_center_wl=1297; %nm
lasing_threshold=-splitter_loss_OSA-36;

span_fine = 37; %nm
amp = -20;      %dBm - ref level

RBW_course =.1;         %nm = res bandwidth
RBW_fine=.02;
sensitivity='NORMAL'; %AUTO, NORMAL, MID, HIGH1, HIGH2, HIGH3, 
idle_sensitivity='NORMAL';
connector='ANGL'; %NORM or ANGL
speed='1x'; %1x for lasers, 2x for SLI

%% Configure Keysight SMU
% Connect to the instrument
B2902B = visa('agilent', 'USB0::0x2A8D::0x9201::MY61391572::0::INSTR');
B2902B.InputBufferSize = 8388608;
B2902B.ByteOrder = 'littleEndian';
fopen(B2902B);
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

fprintf(OSA, '*RST');
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


% %% Configure Powermeter
% N7742C = visa('agilent', 'TCPIP0::100.65.31.121::inst0::INSTR');
% N7742C.InputBufferSize = 8388608;
% N7742C.ByteOrder = 'littleEndian';
% fopen(N7742C);
% fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:UNIT %d', 1));
% fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:WAVelength %g NM', 1310.0));
% fprintf(N7742C, sprintf(':SENSe2:CHANnel:POWer:ATIMe %g US', 1.0));

%% Configure NanoTrak
% Define the paths to the necessary Thorlabs .NET assemblies
MOTORPATHDEFAULT = 'C:\Program Files\Thorlabs\Kinesis\';
DEVICEMANAGERDLL = 'Thorlabs.MotionControl.DeviceManagerCLI.dll';
NANOTRAKDLL = 'Thorlabs.MotionControl.KCube.NanoTrakCLI.dll';

% Load .NET assemblies if not already loaded
asm_dev = NET.addAssembly([MOTORPATHDEFAULT, DEVICEMANAGERDLL]);
asm_nano = NET.addAssembly([MOTORPATHDEFAULT, NANOTRAKDLL]);

% Import the namespaces
import Thorlabs.MotionControl.DeviceManagerCLI.*
import Thorlabs.MotionControl.KCube.NanoTrakCLI.*

% Initialize the Device List
DeviceManagerCLI.BuildDeviceList();

% Get the list of connected devices
serialNumbersNet = DeviceManagerCLI.GetDeviceList();
serialNumbers = cell(ToArray(serialNumbersNet));

% Select the first NanoTrak device from the list
serial_no = serialNumbers{1};  % Replace with the appropriate serial number if needed

% % Check if the device is a KCube NanoTrak
% if ~KCubeNanoTrak.IsKCubeNanoTrak(serial_no)
%     error('Device is not a KCube NanoTrak');
% end

% Connect to the NanoTrak
nanoTrak = KCubeNanoTrak.CreateKCubeNanoTrak(serial_no);
nanoTrak.Connect(serial_no);

% Start polling
nanoTrak.StartPolling(200); % Poll every 200 ms
pause(1); % Wait for the device to initialize

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

%% Configure ESA
% IP address of the Spectrum Analyzer
ip = '192.168.1.103'; 
% Standard port for GPIB over LAN
port = 5025; 
% Create TCP/IP object 'ESA' associated with instrument
ESA = tcpip(ip, port); 
% Set size of receiving buffer, if necessary
ESA.InputBufferSize = 120000;
% Open connection to the instrument
fopen(ESA);
fine_span = 3e5;
numberOfPoints = 8001;
numberOfPoints2 = 1000;
fine_res = 500;
fine_vid = fine_res;

%%
fprintf(ESA, '*RST'); 
fprintf(ESA, ':FREQ:CENT 25e9');
fprintf(ESA, ':FREQ:SPAN 50e9');
fprintf(ESA, ':BAND:RES 1e6');
fprintf(ESA, ':BAND:VID 1e6');
fprintf(ESA, 'DET POS');
fprintf(ESA, [':SENSe:SWEep:POINts ' num2str(numberOfPoints)]);
fprintf(ESA, 'INIT:CONT OFF');
fprintf(ESA, ':SWEep:TIME?');
t1 = fscanf(ESA);
load('C:\IPL_experiment\William\ESA_Noise_Floor.mat')

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
        nanoTrakPower = nanoTrak.GetReading();
        power(j,k) = nanoTrakPower.AbsoluteReading;
        disp(['Optical Power: ', num2str(power(j,k))]);
        % ESA find RF beatnote
        %Trigger wide sweep
        fprintf(ESA, ':INIT:IMM; *WAI');
        pause(str2num(t1))
        fprintf(ESA, ':TRACe:DATA? TRACE1');
        widedata = fscanf(ESA);
        % Convert the returned data to a numeric array
        wideData = str2double(strsplit(widedata, ','));
        % Frequency vector (linear spacing assumed)
        frequency_wide = linspace(0, 50e9, numberOfPoints);
        % Plot the data
        figure(5);
        plot(frequency_wide/1e9, wideData);
        xlabel('Frequency (GHz)');
        ylabel('Amplitude (dB)');
        title('ESA Wide Sweep Results');
        sigsearch = wideData-noiseFloor;
        [sigLevel, sigIndex] = max(sigsearch(2:end));
        figure(6);
        plot(frequency_wide/1e9, sigsearch);
        xlabel('Frequency (GHz)');
        ylabel('Amplitude (dB)');
        title('ESA Signal Search Results');
        if  sigLevel> -3
            % Find max peak and set marker
            fprintf(ESA, [':FREQ:CENT ', num2str(frequency_wide(sigIndex))]);
            % Narrow down the span for focused measurement
            fprintf(ESA, ':FREQ:SPAN 4e9');
            % Adjust RBW and VBW for detailed measurements
            fprintf(ESA, ':BAND:RES 200e3');
            fprintf(ESA, ':BAND:VID 200e3');
            fprintf(ESA, ':INIT:IMM; *WAI');
            % Find max peak and set marker
            fprintf(ESA, 'CALC:MARK:MAX');
            % Center on the marker
            fprintf(ESA, 'CALC:MARK:CENT');
            % Narrow down the span for focused measurement
            fprintf(ESA, ':FREQ:SPAN 20e6');
            % Adjust RBW and VBW for detailed measurements
            fprintf(ESA, ':BAND:RES 5e3');
            fprintf(ESA, ':BAND:VID 5e3');
            
            % Trigger another single sweep for detailed analysis
            fprintf(ESA, ':INIT:IMM; *WAI');
            % Find max peak and set marker
            fprintf(ESA, 'CALC:MARK:MAX');
            % Query Y (amplitude) of marker 1
            fprintf(ESA, 'CALC:MARK:Y?');
            center_RFpow = str2double(fscanf(ESA));
            % Query X (frequency) of marker 1
            fprintf(ESA, 'CALC:MARK:X?');
            center_RFfreq = str2double(fscanf(ESA));
            
            % Center on the marker
            fprintf(ESA, 'CALC:MARK:CENT');
            fprintf(ESA, [':FREQ:SPAN ', num2str(fine_span)]);
            fprintf(ESA, [':BAND:RES ', num2str(fine_res)]);
            fprintf(ESA, [':BAND:VID ', num2str(fine_vid)]);
            fprintf(ESA, [':SENSe:SWEep:POINts ' num2str(numberOfPoints2)]);
            fprintf(ESA, ':SWEep:TIME?');
            t2 = fscanf(ESA);
            % Trigger another single sweep for detailed analysis
            fprintf(ESA, ':INIT:IMM; *WAI');
            pause(str2num(t2))
            % Query the trace data
            fprintf(ESA, ':TRACe:DATA? TRACE1');
            data = fscanf(ESA);
            % Convert the returned data to a numeric array
            RFData = str2double(strsplit(data, ','));
            % Frequency vector (linear spacing assumed)
            RFfrequency = linspace(center_RFfreq-fine_span/2, center_RFfreq+fine_span/2, numberOfPoints2);
            % Plot the data
            figure(7);
            set(gcf, 'Position', [100, 50, 600, 450]);
            plot(RFfrequency/1e9, RFData);
            xlabel('Frequency (Hz)');
            ylabel('Amplitude (dBm)');
            title('Peak RF Signal');
            xlim([center_RFfreq-fine_span/2 center_RFfreq+fine_span/2]/1e9);
            save([filename '_ESA_' num2str(I_Gain(j)*1000) 'mA_' num2str(-V_SA(k)) 'V.mat'], 'RFfrequency', 'RFData', 'frequency_wide', 'wideData', 'sigsearch')
            fprintf(ESA, [':SENSe:SWEep:POINts ' num2str(numberOfPoints)]);
            fprintf(ESA, ':FREQ:CENT 25e9');
            fprintf(ESA, ':FREQ:SPAN 50e9');
            fprintf(ESA, ':BAND:RES 1e6');
            fprintf(ESA, ':BAND:VID 1e6');
        else
            save([filename '_ESA_' num2str(I_Gain(j)*1000) 'mA_' num2str(-V_SA(k)) 'V.mat'], 'frequency_wide', 'wideData', 'sigsearch')
        end
        % Loop over each channel to acquire data
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
power=power.*10^(20/10+3);

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
fclose(ESA);
delete(ESA);
clear ESA;
fclose(OSC);
delete(OSC);
clear OSC;
% Stop polling and disconnect
nanoTrak.StopPolling();
nanoTrak.Disconnect();
clear("nanoTrak")
toc
%%
save([filename '_scan_data.mat'], 'I_Gain', 'V_Gain', 'V_Gain_LIV', 'V_SA', 'I_SA', 'center_wl', 'center_pow','power','power_LIV', 'RBW_fine', 'splitter_loss_OSA','splitter_loss_powmtr', 'center_RFfreq', 'center_RFpow','Four_wire')