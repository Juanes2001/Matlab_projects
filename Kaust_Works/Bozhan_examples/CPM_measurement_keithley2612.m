clearvars
close all
clc
instrreset
format long
colors='bgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmybgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmy';
lasing_threshold=-40;
%% Get and confirm filename
filename=input('Filename>>','s');
filenames=dir([strcat(filename, '_scan_data') '*']);
ok_write=isempty(filenames);

while ok_write==0
    ok_write=input('File already exists. 1 (or any number except 0) to overwrite>>');
end

%% Inputs for Keithley
I_start=30;
I_step=5;
I_stop=200; %300;
I_Gain=I_start:I_step:I_stop;%fliplr([9:1:22]);
limit_V_Gain =5;

V_SA_start=0;
V_SA_step=.3; %.3
V_SA_stop=7;
V_SA=V_SA_start:V_SA_step:V_SA_stop;
V_Gain = NaN(length(V_SA),length(I_Gain)); 
I_SA=NaN(length(I_Gain), length(V_SA));
limit_I_SA = 100;

center_RFfreq=I_SA;
center_RFpow=I_SA;
% power=I_SA;

%% Inputs for OSA
splitter_loss_OSA = 0.16+6.85;%.325+3.02; %dB
splitter_loss_powmtr = 0.16+10.7;%.325+6.71; %dB
splitter_loss_ESA = 0.16+2.95;
check_time=.05; %checks to see if the scan is done in intervals of this many seconds
% lstart = 1190; %nm
% lstop = 1330;   %nm
start_center_wl=1285e-9; %m
span_fine = 35; %nm
amp = -20;      %dBm - ref level

RBW_course =.1;         %nm = res bandwidth
RBW_fine=.02;
sensitivity='NORMAL'; %AUTO, NORMAL, MID, HIGH1, HIGH2, HIGH3, 
idle_sensitivity='NORMAL';
connector='ANGL'; %NORM or ANGL
speed='1x'; %1x for lasers, 2x for SLI
%% Configure Keithley
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Gain Keithley
K_Gain_SA = gpib('ni', 0, 12); % 
K_Gain_SA.Inputbuffersize = 100000;
K_Gain_SA.OutputBufferSize = 2000;
K_Gain_SA.Timeout = 10;
fopen(K_Gain_SA); 

fprintf(K_Gain_SA, 'smua.reset()');
fprintf(K_Gain_SA, 'smua.sense = smua.SENSE_REMOTE');
fprintf(K_Gain_SA, 'smua.source.func = smua.OUTPUT_DCAMPS');
fprintf(K_Gain_SA, 'smua.measure.autorangev = smua.AUTORANGE_ON');
fprintf(K_Gain_SA, ['smua.source.limitv = ' num2str(limit_V_Gain)]);
% fprintf(K_Gain_SA,'smub.source.rangei=0.1');
fprintf(K_Gain_SA,'smua.measure.nplc=1');  % has to do with how many ADC measurements are averaged for a user measurement
fprintf(K_Gain_SA,'smua.measure.interval=0.01'); % sets time interval between measurements
fprintf(K_Gain_SA, ['smua.source.leveli = ' num2str(I_Gain(1)) 'E-3']);
fprintf(K_Gain_SA, 'smua.source.output = smua.OUTPUT_ON');
fprintf(K_Gain_SA,'display.smua.measure.func = display.MEASURE_DCVOLTS');
fprintf(K_Gain_SA,'errorqueue.clear()');
fprintf(K_Gain_SA,'smua.nvbuffer1.clear()');
fprintf(K_Gain_SA, 'waitcomplete()');
fprintf(K_Gain_SA,'smua.nvbuffer2.clear()');
fprintf(K_Gain_SA, 'waitcomplete()');

%fprintf(K_Gain_SA, 'print(smua.measure.v())');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(K_Gain_SA, 'smub.reset()');
fprintf(K_Gain_SA, 'smub.source.func = smub.OUTPUT_DCVOLTS');
fprintf(K_Gain_SA, ['smub.source.limiti = ' num2str(limit_I_SA) 'E-3']);
% fprintf(K_Gain_SA, 'smub.measure.autorangei = smub.AUTORANGE_ON');
fprintf(K_Gain_SA,'smub.source.rangei=0.1');
fprintf(K_Gain_SA,'smub.source.rangev=8');
fprintf(K_Gain_SA,'smub.measure.nplc=1');  % has to do with how many ADC measurements are averaged for a user measurement
fprintf(K_Gain_SA,'smub.measure.interval=0.01'); % sets time interval between measurements
fprintf(K_Gain_SA, ['smub.source.levelv = ' num2str(V_SA_start)]);
fprintf(K_Gain_SA, 'smub.source.output = smub.OUTPUT_ON');
fprintf(K_Gain_SA, 'print(smub.measure.i())');
fprintf(K_Gain_SA,'display.smub.measure.func = display.MEASURE_DCAMPS');
fprintf(K_Gain_SA,'errorqueue.clear()');
fprintf(K_Gain_SA,'smub.nvbuffer1.clear()');
fprintf(K_Gain_SA, 'waitcomplete()');
fprintf(K_Gain_SA,'smub.nvbuffer2.clear()');
fprintf(K_Gain_SA, 'waitcomplete()');
%fprintf(K_Gain_SA, 'reading = smub.measure.i()');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Configure ESA

esa = FSU50('TCPIP::169.254.254.249::inst0::INSTR');
esa.connect;
% esa.mode = 'SAN';
% esa.RFstart = 0; % Hz
% esa.RFstop = 12e9; % Hz
% esa.RFspan = 0; % Hz
% esa.RFcenter = 12e9; % Hz
% esa.RBW = 200e3; % Hz

% %% Configure OSA
% 
% osa = AQ6370('TCPIP::169.254.254.254::inst0::INSTR');
% osa.connect;

%% Configure OSA and  Power Meter
POWERMETER=gpib('ni', 0, 11); % Agilent Power Meter
fopen(POWERMETER);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OSA=visa('ni', 'TCPIP::169.254.254.254::inst0::INSTR');
OSA.InputBufferSize=17*span_fine/.004+1000; %17 characters per trace data point required, sampling bandwidth determins # of points
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

%% Run 2-D Swwep
% figyour=figure;
% hold off
for j=1:length(I_Gain)
    fprintf(K_Gain_SA, ['smua.source.leveli = ' num2str(I_Gain(j)) 'E-3']); %set Laser Gain current
    if j==1
        fprintf(OSA, ':SENSe:WAVelength:CENTer %.10fm', start_center_wl);
    end
    k=1;
    compliance = 0;
    notlasing=0;
    while k<=length(V_SA) && compliance == 0  && notlasing == 0
        fprintf(K_Gain_SA, ['smub.source.levelv = ' num2str(V_SA(k))]); % set SA voltage
        %pause(2)
%         fprintf(K_Gain_SA, 'print(smua.measure.v())');
%         fprintf(K_Gain_SA, 'print(smub.measure.i())');
%        fprintf(K_Gain_SA, 'compliance = smub.source.compliance');
%         compliance_str=query(K_Gain_SA, 'print(compliance)');
%         compliance = strcmp('t', compliance_str(1));
        if k==1 && j~=1
            fprintf(OSA, ':SENSe:WAVelength:CENTer %.10fm', center_wl(j-1,1));
        end
        
        %% Borad ESA Sweep
        esa.RFcenter=19e9;
        esa.RFspan=10e9;
        esa.RBW=500e3;
        esa.VBW=1e6;
        esa.Single;
        esa.Write("CALC:MARK1:MAX")
        center_RFpow(j,k) = str2num(esa.Query("CALC:MARK1:Y?"));

%% Narrow ESA sweep
        
        if center_RFpow(j,k) < -70
            notlasing_esa=1;
        else
            center_RFfreq(j,k)=str2num(esa.Query("CALC:MARK1:X?"));
            esa.Write("CALC:MARK:FUNC:CENT")
            esa.RFspan=20e6;
            esa.RBW=5e3;
            esa.VBW=10e3;
            %esa.SWT = 1;
            esa.Single;
            %esa.SweCoun = 3;
            pause(1);

            figure(1)
            plot(esa.readTrace.XData, esa.readTrace.YData);
            
            esa.saveTrace([filename '_ESP_' num2str(I_Gain(j)) 'mA_' num2str(V_SA(k)) 'V.mat'])
            % esa.SweCoun = 1;
            %esa.Single;

        end

        %% OSA sweep
         if j==1
            fprintf(OSA, ':SENSe:WAVelength:CENTer %.10fm', start_center_wl);
        elseif k==1 && j~=1
            fprintf(OSA, ':SENSe:WAVelength:CENTer %.10fm', center_wl(j-1,1));
        end
        fprintf(OSA, ':init:imm;');

        fprintf(OSA, ':CALCulate:AMARKer1:MAXimum');
        fprintf(OSA,':CALCULATE:AMARKER1:X?');
        center_wl(j,k) =  str2num(fscanf(OSA));
        fprintf(OSA,':CALCULATE:AMARKER1:Y?');
        center_pow(j,k) =  str2num(fscanf(OSA));
        if center_pow(j,k) < lasing_threshold
            notlasing=1;
        else
            fprintf(OSA,':TRAC:DATA: Y? TRA;');
            opticalpower =  str2num(fscanf(OSA));
            fprintf(OSA,':TRAC:DATA: X? TRA;');
            wavelength = str2num(fscanf(OSA));

            fprintf(OSA, ':SENSe:WAVelength:CENTer %.10fm', center_wl(j,k));
            
            figure(2)
            plot(wavelength, opticalpower)%,colors(n))

            save([filename '_OSP_' num2str(I_Gain(j)) 'mA_' num2str(V_SA(k)) 'V.mat'], 'opticalpower', 'wavelength')
            
        end
        
        
        fprintf(K_Gain_SA, 'smub.measure.i(smub.nvbuffer1)');
        fprintf(K_Gain_SA, 'printbuffer(1, 1, smub.nvbuffer1)');
        I_SA(j,k)=str2num(fscanf(K_Gain_SA));
        fprintf(K_Gain_SA, 'smua.measure.v(smua.nvbuffer2)');
        fprintf(K_Gain_SA, 'printbuffer(1, 1, smua.nvbuffer2)');
        V_Gain(j,k)=str2num(fscanf(K_Gain_SA));
        k=k+1;
        power(j,k) = query(POWERMETER,'FETCH2:CHAN1:POW?','%s','%f');
    end 
end


fprintf(K_Gain_SA, 'smua.source.output=smua.OUTPUT_OFF');
fprintf(K_Gain_SA, 'smub.source.output=smub.OUTPUT_OFF');
fprintf(OSA, [':SENS:SENS ' idle_sensitivity]);
esa.disconnect

instrreset
clear K_Gain_SA OSA ESA
save([filename '_OSP_scan_data.mat'], 'I_Gain', 'V_Gain', 'V_SA', 'I_SA', 'center_wl', 'center_pow','power', 'RBW_fine', 'splitter_loss_OSA','splitter_loss_powmtr')
save([filename '_ESP_scan_data.mat'], 'I_Gain', 'V_Gain', 'V_SA', 'I_SA', 'center_RFfreq', 'center_RFpow')

% save([filename '_OSP_scan_data.mat'], 'I_Gain', 'V_SA', 'center_wl', 'center_pow','power', 'RBW_fine', 'splitter_loss_OSA','splitter_loss_powmtr')
% save([filename '_ESP_scan_data.mat'], 'I_Gain', 'V_SA', 'center_RFfreq', 'center_RFpow','splitter_loss_ESA')