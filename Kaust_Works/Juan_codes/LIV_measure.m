clear
close all
clc

addpath('C:\Users\Juanes\Desktop\GitHub\Matlab_projects\Kaust_Works\Juan_codes\Keysight_B2902B');
addpath('C:\Users\Juanes\Desktop\GitHub\Matlab_projects\Kaust_Works\Juan_codes\OSA_A6380');

%% we create the objects of the classes needed
osa = A6380_class("10.72.171.64"); % ETHERNET % GPIB

keysight = B2902B_class('NI', 23, 0);
 
% We make sure there are not intruments enable

osa.delateAll();

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
idle_sensitivity='NORMAL';
connector='ANGL'; %NORM or ANGL


%% Configure Keysight SMU
% Connect to the instrument

keysight.init();


%%
% Setup the instrument
keysight.reset(); % Reset the intrument
keysight.set_format_ASCII();
keysight.set_CH1_srcI();
keysight.set_CH1_limitV(limit_V_Gain);
keysight.set_CH1_srcLevelI(I_Gain(1));

keysight.enable_CH1();



%% Configure OSA
osa.init();
osa.TPC_obj.InputBufferSize=17*span_fine/.002+1000; %17 characters per trace data point required, sampling bandwidth determins # of points

osa.reset();
osa.set_num_points_ONauto();



% fprintf(OSA, [':SENS:SETT:FCON ' connector]);

osa.set_speed_1x();
osa.set_sweep_single();
osa.set_span(span_fine);
osa.set_center_lam(start_center_wl);
osa.set_res(RBW_fine);
osa.set_sens_NORMAL();
osa.dis_Cal_WaveAuto();
osa.dis_Cal_ZeroAuto();


%% Run 2D Mapping
tic
for j=1:length(I_Gain)
    %Set Laser Gain current
    keysight.set_CH1_srcLevelI(I_Gain(j));
    k=1;
    compliance = 0;
    notlasing = 0;
    pause(0.5);

    osa.do_sweep();
    while ~osa.issweepDone()
    end
    opticalpower = osa.get_TR_Y('a');
    wavelength = osa.get_TR_X('a');
    
    fig = figure(4);
    plot(wavelength*1e9, opticalpower)
    
    saveas(f, [fileImgName '' '.png']);
    save([filename '_OSA_' num2str(I_Gain(j)*1000) 'mA_'], 'opticalpower', 'wavelength')
    
end

%% Clean Up

osa.set_sens_NORMAL();

% Clean up Keysight SMU
% Turn off the output
keysight.disable_CH1();


% Disconnect and cleanup
keysight.deleteObj();
osa.deleteObj();
toc
%%
save([filename '_scan_data.mat'], 'I_Gain', 'V_Gain', 'V_Gain_LIV', 'V_SA', 'I_SA', 'center_wl', 'center_pow','power','power_LIV', 'RBW_fine', 'splitter_loss_OSA','splitter_loss_powmtr', 'center_RFfreq', 'center_RFpow','Four_wire')