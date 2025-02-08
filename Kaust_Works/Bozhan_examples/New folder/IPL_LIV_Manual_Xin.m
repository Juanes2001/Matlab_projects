%% IPL Manual LIV Testing Program
% William 2023/11/14
% Application Note:
% This is program is for a manual stage, as in the user will need to
% manually move and probe the next device after taking an individual
% measurement.
close all;

%Close any instruments already open
instr  = instrfind;
    if ~isempty(instr)
        fclose(instr);
        delete(instr);
    end

%% Initial Parameters setting for LIV

%Integrating sphere photocurrent to power conversion factor
sphere = 1237.656;
%Calibrated 2023/11/13 for 819D-IG-3.3-CAL2 detector at 1310nm wavelength
%Calibration setup: Keysight tunable laser source through fiber
%Calibration reference: Keysight Powermeter

%Set sweep range current <<CURRENT RANGE
I_start = 0;
%Starting current in mA
%I_stop = 200;
%Ending current in mA
%I_step = 1;
%Current step in mA
put_holdall_on = 0;
%Hold plots boolean
bt = 1; 
%Ramp time per step
%% Set test parameters and probe first device
device_num = 0;
prompt = {'Enter filename:','Total # of devices:','First device #:',...
    'Sweep current range (mA):','Sweep current step (mA):', 'Device # shift (increasing = 1, decreasing = -1):'};
dlgtitle = 'Input LIV Testing Parameters';
dim = [1 50];
definput = {'TQDL_V3_H0','6','1','200','2','1'};

input_parameters = inputdlg(prompt,dlgtitle,dim,definput);
answer_string = convertCharsToStrings(input_parameters);

    bar_nametag = answer_string{1};
    total_device_num = str2double(answer_string{2});
    probe_dir = str2double(answer_string{6});
    device_num_offset = str2double(answer_string{3})-probe_dir; 
    I_stop = str2double(answer_string{4});
    I_step = str2double(answer_string{5});

%% Start LIV Testing Loop
      
keeptesting = 1;
tic %Timer start for total measurement time
    
while keeptesting == 1
        
    device_num = device_num + probe_dir;
           
    user_dialog = warndlg('Please probe the next device now. After finishing, press OK.', 'Probing');
    waitfor(user_dialog);
    %disp('Start testing device #' + device_num);
    if device_num == total_device_num
        keeptesting = 0;
        %Ready to finish afterwards if counted to last device
        fprintf('Testing the last device! \n');
    end

    %Check to make sure contact is good before every LIV sweep

    prompt2 = {'Sweep current range (mA):'};
    dlgtitle = 'Verify Sweep Parameters';
    dim2 = [1 35];
    definput2 = {answer_string{4}};

    input_parameters = inputdlg(prompt2,dlgtitle,dim2,definput2);
    answer_string2 = convertCharsToStrings(input_parameters);
    answer_string{5}=answer_string2{1};
    I_stop = str2double(answer_string2{1});

    fprintf('Testing device #%d...\n', device_num+device_num_offset );

    if device_num+device_num_offset<10
        device_name = [bar_nametag '_A00',num2str(device_num+device_num_offset)]; %add a leading 0 to device names below 10
    elseif device_num+device_num_offset<100
        device_name = [bar_nametag '_A0',num2str(device_num+device_num_offset)];
    else
        device_name = [bar_nametag '_A',num2str(device_num+device_num_offset)];
    end
    device_name = [device_name '_sphere'];

    %Set names for different saving formats
    figfile = device_name; 
    csvname = [device_name '.csv'];
    filename = [device_name '.mat'];

    LIVanswer = 'Retest';
    
    while strcmp(LIVanswer, 'Retest') 
        %start communication with keithley
        %check keithley GPIB info (for keithley 1)
        ni_board = 1;
        gpib_keithley_1 = 26;

        %config keithley 1
        sourcemeter.gpib = gpib('ni', ni_board, gpib_keithley_1);
        sourcemeter.gpib.Inputbuffersize = 100000;
        sourcemeter.gpib.OutputBufferSize = 2000;
        sourcemeter.gpib.Timeout = 25;
        fopen(sourcemeter.gpib);
        clrdevice(sourcemeter.gpib)
        clrdevice(sourcemeter.gpib)
        fprintf(sourcemeter.gpib, 'reset()');
        fprintf(sourcemeter.gpib, 'waitcomplete()');
        % fprintf(sourcemeter.gpib, 'smub.reset()');
        % fprintf(sourcemeter.gpib, 'DCL');
        fprintf(sourcemeter.gpib,'format.data = format.ASCII');
        fprintf(sourcemeter.gpib,'errorqueue.clear()');
        fprintf(sourcemeter.gpib,'smua.nvbuffer1.clear()');
        fprintf(sourcemeter.gpib, 'waitcomplete()');
        fprintf(sourcemeter.gpib,'smub.nvbuffer2.clear()');
        fprintf(sourcemeter.gpib, 'waitcomplete()');

        %configure Channel A (for Voltage and Current source)
        fprintf(sourcemeter.gpib,'smua.source.func = smua.OUTPUT_DCAMPS');
        % fprintf(sourcemeter.gpib,'smua.measure.autozero = smua.AUTOZERO_OFF');
        fprintf(sourcemeter.gpib,'smua.source.limitv=6');   %voltage limit << VOLTAGE
        fprintf(sourcemeter.gpib,'smua.source.rangev=10');  %votlage range
        fprintf(sourcemeter.gpib,'smua.source.limiti=.250');    %current limit <<CURRENT
        fprintf(sourcemeter.gpib,'smua.source.rangei=3.0');     %current range
        fprintf(sourcemeter.gpib,'smua.measure.nplc=1');
        fprintf(sourcemeter.gpib,'smua.measure.interval=0.00001');

        fprintf(sourcemeter.gpib,'smub.measure.delay=0');

        fprintf(sourcemeter.gpib,'smua.source.output=smua.OUTPUT_OFF');
        fprintf(sourcemeter.gpib,'smua.source.leveli=0');

        %configure Channel B (for Photodetector)
        fprintf(sourcemeter.gpib,'smub.source.func = smub.OUTPUT_DCVOLTS');
        fprintf(sourcemeter.gpib,'display.smub.measure.func = display.MEASURE_DCAMPS');

        % fprintf(sourcemeter.gpib,'smub.measure.autozero = smub.AUTOZERO_OFF');
        fprintf(sourcemeter.gpib,'smub.source.limitv=6'); %voltage limit
        fprintf(sourcemeter.gpib,'smub.source.limiti=.10'); %current limit
        fprintf(sourcemeter.gpib,'smub.source.levelv=0'); %voltage level
        fprintf(sourcemeter.gpib,'smub.source.rangev=1'); %voltage range
        fprintf(sourcemeter.gpib,'smub.source.rangei=3.0'); %current range
        fprintf(sourcemeter.gpib,'smub.measure.nplc=1'); 
        fprintf(sourcemeter.gpib,'smub.measure.interval=0.00001');

        fprintf(sourcemeter.gpib,'smub.measure.delay=0');

        I = I_start:I_step:(I_stop); %sweep current
        I_length_str=num2str(length(I));
        % % fprintf(sourcemeter.gpib,['mybuffer1=smua.makebuffer(', num2str(length(I)*10), ')']);
        fprintf(sourcemeter.gpib,['smub.measure.count=1']);
        fprintf(sourcemeter.gpib,'smua.nvbuffer1.appendmode=1');
        fprintf(sourcemeter.gpib,'smua.nvbuffer1.collectsourcevalues=1');
        % fprintf(sourcemeter.gpib,['mybuffer2=smub.makebuffer(', num2str(length(I)*10), ')']);
        fprintf(sourcemeter.gpib,['smub.measure.count=1']);
        fprintf(sourcemeter.gpib,'smub.nvbuffer2.appendmode=1');
        fprintf(sourcemeter.gpib,'smub.nvbuffer2.collectsourcevalues=1');

        voltage = zeros(size(I)); %%%%%VOLTAGE%%%%%%%%%%%%%%%%%

        fprintf(sourcemeter.gpib,'smua.source.output=smua.OUTPUT_ON');
        fprintf(sourcemeter.gpib,'smub.source.output=smub.OUTPUT_ON');

        %jostle channel b
        fprintf(sourcemeter.gpib,'smub.source.levelv=0.1');
        pause(0.1);
        fprintf(sourcemeter.gpib,'smub.source.levelv=0');

        fprintf(sourcemeter.gpib,'smub.source.levelv=0.1');
        pause(0.1);
        fprintf(sourcemeter.gpib,'smub.source.levelv=0');

        fprintf(sourcemeter.gpib, ['for curr=', num2str(I_start/1000), ', ', num2str((I_stop+I_step)/1000), ', ', num2str(I_step/1000), ' do smua.source.leveli=curr smua.measure.v(smua.nvbuffer1) waitcomplete() smub.measure.i(smub.nvbuffer2) waitcomplete() end']);

        fprintf(sourcemeter.gpib, ['printbuffer(1, ', I_length_str, ', smua.nvbuffer1)']);
        voltage = str2num(fscanf(sourcemeter.gpib));

        fprintf(sourcemeter.gpib, ['printbuffer(1, ', I_length_str, ', smub.nvbuffer2)']);
        photocurrent = str2num(fscanf(sourcemeter.gpib)); %PHOTOCURRENT%%%%%%%%%%%%%%%%%%

        Rs = diff(voltage)./I_step.*1000;
        Rs = [Rs,Rs(end)];  %RESISTANCE%%%%%%%%%%%%%%%%%%%%%

        fprintf(sourcemeter.gpib,'smua.source.leveli=0');
        fprintf(sourcemeter.gpib,'smua.source.output=smua.OUTPUT_OFF');
        fprintf(sourcemeter.gpib,'smub.source.levelv=0');
        fprintf(sourcemeter.gpib,'smub.source.output=smua.OUTPUT_OFF');
        fprintf(sourcemeter.gpib, 'reset()');
        fprintf(sourcemeter.gpib, 'waitcomplete()');
        % fprintf(sourcemeter.gpib, 'smub.reset()');
        % fprintf(sourcemeter.gpib, 'DCL');
        fprintf(sourcemeter.gpib,'format.data = format.ASCII');
        fprintf(sourcemeter.gpib,'errorqueue.clear()');
        fprintf(sourcemeter.gpib,'smua.nvbuffer1.clear()');
        fprintf(sourcemeter.gpib, 'waitcomplete()');
        fprintf(sourcemeter.gpib,'smub.nvbuffer2.clear()');
        fprintf(sourcemeter.gpib, 'waitcomplete()');

        %config channela
        fprintf(sourcemeter.gpib,'smua.source.func = smua.OUTPUT_DCAMPS');
        % fprintf(sourcemeter.gpib,'smua.measure.autozero = smua.AUTOZERO_OFF');
        fprintf(sourcemeter.gpib,'smua.source.limitv=6');
        fprintf(sourcemeter.gpib,'smua.source.limiti=.250');
        fprintf(sourcemeter.gpib,'smua.source.rangei=3.0');
        fprintf(sourcemeter.gpib,'smua.source.rangev=10');
        fprintf(sourcemeter.gpib,'smua.measure.nplc=1');
        fprintf(sourcemeter.gpib,'smua.measure.interval=0.00001');
        fprintf(sourcemeter.gpib,'smub.measure.delay=0');

        fprintf(sourcemeter.gpib,'smua.source.output=smua.OUTPUT_OFF');
        fprintf(sourcemeter.gpib,'smua.source.leveli=0');
        %config channelb
        fprintf(sourcemeter.gpib,'smub.source.func = smub.OUTPUT_DCVOLTS');
        fprintf(sourcemeter.gpib,'display.smub.measure.func = display.MEASURE_DCAMPS');
        % fprintf(sourcemeter.gpib,'smub.measure.autozero = smub.AUTOZERO_OFF');
        fprintf(sourcemeter.gpib,'smub.source.limitv=6');
        fprintf(sourcemeter.gpib,'smub.source.limiti=.10');
        fprintf(sourcemeter.gpib,'smub.source.levelv=0');
        fprintf(sourcemeter.gpib,'smub.source.rangev=1');
        fprintf(sourcemeter.gpib,'smub.source.rangei=3.0');
        fprintf(sourcemeter.gpib,'smub.measure.nplc=1');
        fprintf(sourcemeter.gpib,'smub.measure.interval=0.00001');
        fprintf(sourcemeter.gpib,'smub.measure.delay=0');

        fprintf(sourcemeter.gpib,'smua.source.leveli=0');
        fprintf(sourcemeter.gpib,'smua.source.output=smua.OUTPUT_OFF');
        fprintf(sourcemeter.gpib,'smub.source.levelv=0');
        fprintf(sourcemeter.gpib,'smub.source.output=smua.OUTPUT_OFF');
        fclose(sourcemeter.gpib)
        clear sourcemeter.gpib

        power = -photocurrent.*1000.*sphere;    %CONVERT PHOTOCURRENT TO POWER%%%%%%%%%%%%%%%%
        wpe = 1*100*(power)./(voltage.*I);
        %create L-I curve figure
        figure_LI = figure(2);
            set(gca,'fontsize',14);
            hold off
            plot(I,power,'-'); 
            hold off
            grid on
            title('Current-Power');
            xlabel('Current (mA)')
            ylabel('Power (mW)')

        %Create summary figure (four figures: I-power, I-V, I-R, I-WPE)
        summary_figure = figure(1);

        subplot(2,2,1);
        if put_holdall_on == 1
            hold all;
        else
            hold off;
        end
        plot(I,power,'-'); 
        title('Current-Power');

        subplot(2,2,2)
        if put_holdall_on == 1
            hold all;
        else
            hold off;
        end
        plot(I,voltage,'-');
        title('Current-Voltage');

        subplot(2,2,3)
        if put_holdall_on == 1
            hold all;
        else
            hold off;
        end
        plot(I,Rs,'-');
        ylim([0 20]);
        title('Current-Resistance');

        subplot(2,2,4);
        if put_holdall_on == 1
            hold all;
        else
            hold off;
        end
        plot(I,1*100*(power)./(voltage.*I),'-');
        ylim([0 25]);
        title('Current-WPE(singleside)');

        %Display pmax and ipmax
        pmax = max(power);
        disp("The maximum power measured is: " + pmax);
        %Output maximum power
        Ipmax = I(power==pmax);
        disp("The drive current at maximum power is: " + Ipmax);
        %Current of maximum power, in mA
        % peak WPE
        wpemax = max(wpe);
        Iwpemax=I(wpe==wpemax);
        LIVanswer = questdlg('Would you like to keep this sweep?', 'Data verification','Save','Discard','Retest','Save');
        if strcmp(LIVanswer, 'Retest')
            prompt2 = {'Sweep current range (mA) (max 1999):'};
            dlgtitle = 'Input LIV Current Range';
            dim2 = [1 35];
            definput2 = {answer_string{5}};
            while 1   %effectively a "do-while" loop - if statement breaks loop if entry is below 1000 mA
                input_parameters = inputdlg(prompt2,dlgtitle,dim2,definput2);
                answer_string2 = convertCharsToStrings(input_parameters);
                answer_string{5}=answer_string2{1};
                I_stop = str2double(answer_string2{1});
                if str2double(answer_string2{1}) < 2000
                    break
                end
            end
        end
    end
    
    if strcmp(LIVanswer,'Discard')
        fail_reason = inputdlg('Enter reason for not saving (e.g led, short, open, etc.)','Reason',dim,{'led'},'on');
        % Save summary figure of discard data
        fail_summaryfile = [figfile '_summary' '_' fail_reason{:}];
        saveas(summary_figure,fail_summaryfile,'fig');
    end
    if strcmp(LIVanswer,'Save')
    %save all .mat data
        %save figures - figname
        LIfile = [figfile '_LI'];
        summaryfile = [figfile '_summary'];
        saveas(figure_LI,LIfile,'fig');
        saveas(summary_figure,summaryfile,'fig');
        %calculate threshold
        %restrict search range to 0 - 1mW <<THRESHOLD
        start = 1;
        if max(power) < 1 %1 mW
           stop = find(power == max(power));
        else
           stop = find(power > 1);
        end
        save(csvname,'I','voltage')
        %compute slope intersection for threshold current
        newbias = I(start(1)):.5:I(stop(1));
        interparray = interp1(I(start(1):stop(1)),power(start(1):stop(1)),newbias,'spline');
        LIslope = diff(interparray)./diff(newbias);
        d2ydx2 = diff(LIslope)./diff(newbias(2:end));
        j = find(d2ydx2 == max(d2ydx2));
        threshold = newbias(j(1)); %in mA already
        %threshold='null';
        disp("Threshold found: " + threshold);
        date = datestr(now,'dd-mm-yyyy-HHMMSS');
        if not(isempty(device_name))
             save([device_name '.mat'], 'I', 'power', 'voltage', 'Rs', 'threshold', 'photocurrent', 'wpe', 'wpemax', 'Iwpemax', 'Ipmax', 'pmax', 'sphere', 'date')
        end
        clear newbias interparray LIslope d2ydx2

        % Write csv file
        dataout = {I; power; voltage; Rs}';
        header = ['Bias,Voltage,Photocurrent,Power,Resistance'];

        fid = fopen(csvname, 'w+'); 
        fprintf(fid,'%s,',date);
        fprintf(fid,'\n Threshold Current,%d,',threshold);
        fprintf(fid,'\n Max Power,%d,',pmax(1));
        fprintf(fid,'\n Current for Max Power,%d,',Ipmax);
        fprintf(fid,'\n Sphere factor,%d,',sphere);
        fprintf(fid,'\n %s,',header);

        for i=1:length(I)
            fprintf(fid,'\n %d,%d,%d,%d,%d',I(i),voltage(i),photocurrent(i),power(i),Rs(i));
        end
        fclose all;
        % csvwrite(filename, M);
    end
end






