classdef x2602B_class
    % x2602B_class this class has the basic methods to use the Keithley 
    % reference 2602B, for funther complex procedures needed for the
    % research field, feel free to modify the methods as you want and add
    % more if needed. Communication is done by GPIB protocol by formatted
    % commands sent through, all this class is using its own properties.



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% HERE THERE IS ALL THE METHODS DEFINED, INPUTS AND OUTPUTS
    % 
    % 
    % 
    % 
    % 
    % 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    
    properties
        InputBufferSize
        OutputBufferSize
        Timeout
        Vendor
        GPIB_address
        Interface_index

        %%% Properties of the control
        volt_curr_src_mode % Array [voltage mode A/current mode A, voltage mode B/current mode B]
        channels_on_off  % Array [Channel A ON_OFF?,Channel B ON_OFF?]
        voltage_meas_value    % Array [sourceA, MeasureA, sourceB, MeasureB] SOURCE AND MEASUREMENTS
        current_value    % Array [sourceA, sourceB] ONLY SOURCE
        voltmeasUnits        % Array [sourceA, MeasureA, sourceB, MeasureB] SOURCE AND MEASUREMENTS
        currentUnits     % Array [sourceA, sourceB] BOTH STRINGS
        Mode             % Array [sourceA/MeasureA, sourceB/MeasureB] BOTH STRINGS
        MeasurementModes % Array of [MeasModeA, MeasModeB] (AMP, VOLT, RES, POW)

    end    
    
    
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = x2602B_class(InBuffSize, ...
                                    outBuffSize, ...
                                    Timeout, ...
                                    vend , ...
                                    aDDr, ...
                                    interIndex, ...
                                    voltcurlogic, ...
                                    cHnLogic, ...
                                    voltageVal, ...
                                    currentVal, ...
                                    vUnits, ...
                                    cUnits, ...
                                    mode, ...
                                    measMode)
            %x2602B_class  constructor, just set the principal and
            %important parameters to set due correct communication.
            obj.InputBufferSize     = InBuffSize; %% Data to be received
            obj.OutputBufferSize    = outBuffSize;%% Data to be sent
            obj.Timeout             = Timeout;    %% Waiting time while a command is proccesed
            obj.Vendor              = vend;       %% Vendor from where is the visa drivers
            obj.GPIB_address        = aDDr;       %% Address of the GPIB com
            obj.Interface_index     = interIndex; %% Number of devices communicating
            

            obj.volt_curr_src_mode  = voltcurlogic;
            obj.channels_on_off     = cHnLogic;
            obj.voltage_meas_value  = voltageVal;
            obj.current_value       = currentVal;
            obj.voltmeasUnits       = vUnits;
            obj.currentUnits        = cUnits;
            obj.Mode                = mode;
            obj.MeasurementModes    = measMode;
            
        end

        %end constructor function


        %% REFREST TESTING PARAMETERS 
        %Here will be shown all the refreshing functions which work to
        %mantain all the info on the properties and not as an input of the
        %methods written, only for simplicity, so dont expect to use this
        %functions some time, they are secondary meant to use in the
        %principal methods.

        function obj = refresh_volt_curr_src_mode(obj,CHL,vol_cur_new)
            % here will be refreshing the volt_cur_src_mode property, to
            % have information about the source mode available in every
            % channel.
            if lower(CHL) == 'a'
                obj.volt_curr_src_mode(1) = vol_cur_new;
            elseif lower(CHL) == 'b'
                obj.volt_curr_src_mode(2) = vol_cur_new;
            end
        end

        function obj = refresh_channels_enable(obj,CHL,en_dis)
            % here will be refreshing the channel X property, changing
            % their state
            if lower(CHL) == 'a'
                obj.channels_on_off(1) = en_dis;
            elseif lower(CHL) == 'b'
                obj.channels_on_off(2) = en_dis;
            end
        end

         function obj = refresh_voltage_meas_value(obj,CHL,value, measFlag)
            % The value of the voltage values, changing the array where it
            % is corresponding, if we are measuring, then we will save the
            % value of the number measured, it could be value of volt, amp,
            % resistance, and power
            if lower(CHL) == 'a' && ~measFlag
                  obj.voltage_meas_value(1) = value;
            elseif lower(CHL) == 'b' && ~measFlag
                obj.voltage_meas_value(3) = value;
            end

            if measFlag % it means we are measuring
                if lower(CHL) == 'a' 
                    obj.voltage_meas_value(2) = value;
                elseif lower(CHL) == 'b'
                    obj.voltage_meas_value(4) = value;
                end
            end
         end

         function obj = refresh_current_value(obj,CHL,value)
            % here we will be refreshing the current value on the source
            % mode
            if lower(CHL) == 'a' 
                  obj.current_value(1) = value;
            elseif lower(CHL) == 'b' 
                obj.current_value(2) = value;
            end
         end

         function obj = refresh_voltmeasUnits(obj,CHL,value,measFlag)
            % Here will be refreshing the current units that the voltage
            % value have, and also the measured va  lues taken from the
            % channel.
            if lower(CHL) == 'a' && ~measFlag
                obj.voltmeasUnits(1) = value;
            elseif lower(CHL) == 'b' && ~measFlag
                obj.voltmeasUnits(3) = value;
            end

            if measFlag % it means we are measuring
                if lower(CHL) == 'a' 
                    obj.voltmeasUnits(2) = value;
                elseif lower(CHL) == 'b'
                    obj.voltmeasUnits(4) = value;
                end
            end

         end

        function obj = refresh_currentUnits(obj,CHL,value)
            % Here will be having refreshing the units of the current units
            % of the current.
            if lower(CHL) == 'a' 
                  obj.current_value(1) = value;
            elseif lower(CHL) == 'b' 
                obj.current_value(2) = value;
            end
        end


        function obj = refresh_Mode(obj,CHL,newMode)
            % Here will be having refreshing the units of the current units
            % of the current.
            if lower(CHL) == 'a' 
                  obj.Mode(1) = newMode;
            elseif lower(CHL) == 'b' 
                obj.Mode(2) = newMode;
            end
        end

        function obj = refresh_MeasurementModes(obj,CHL,newMeasMode)
            % Here will be having refreshing the units of the current units
            % of the current.
            if lower(CHL) == 'a' 
                  obj.MeasurementModes(1) = newMeasMode;
            elseif lower(CHL) == 'b' 
                obj.MeasurementModes(2) = newMeasMode;
            end
        end


        %% SET UP AND INITIATION
        function [logic,ident] = init(obj)
            % With init() we want to initiate the device properly 
            
            instr  = instrfind; % We have to be sure we close every single opened intrument
            if ~isempty(instr)
                fclose(instr);
                delete(instr);
            end
            % We return a visa object to be used in communication.
            visa_obj = visa(obj.Vendor, ...
                            sprintf('GPIB%d::%d::INSTR', ...
                            obj.Interface_index, ...
                            obj.GPIB_address));

            fopen(visa_obj);
            % With this we set the device on the remote mode
            pause(1)
            if ~isempty(iDN(visa_obj))
                logic = true;
                ident = iDN(visa_obj); 
            else
                logic = false;
                ident = "Communcation Error";
            end
        end


        %% SHUT DOWN COMMUNICATON

        function logic = shutDown(obj)
            % Close and delete the GPIB object
            fclose(Keithley);
            pause(1);
            logic = true;
            delete(Keithley);
            clear Keithley;
        end

         %% Identification

         function msg_idn = iDN(obj, visa_obj)
            % Send a messege of identification
            fprintf(visa_obj , '*IDN?'); % We sent the command, then it will send us
                                         % back the response
            msg_idn = fscanf(visa_obj);  % We try to read the port anr return the identificator
         end 


        %% RESET
        function reset(obj, visa_obj)
            % Reset the system
            fprintf(visa_obj , '*RST');
        end

        %% SELECT THE SOURCE, VOLTAGE OR CURRENT
        function obj = select_src(obj, visa_obj, CHL, SOURCE)
            % To set the channel X to voltage source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            if lower(CHL) == 'a'  
                if lower(SOURCE) == "voltage"    
                    fprintf(visa_obj , "smua.source.func = smua.OUTPUT_DCVOLTS");
                elseif lower(SOURCE) == "current"
                    fprintf(visa_obj , "smua.source.func = smua.OUTPUT_DCAMPS");
                end                               
            elseif lower(CHL) == 'b'
                if lower(SOURCE) == "voltage"    
                    fprintf(visa_obj ,"smub.source.func = smub.OUTPUT_DCVOLTS");
                elseif lower(SOURCE) == "current"
                    fprintf(visa_obj , "smub.source.func = smub.OUTPUT_DCAMPS");
                end    
            else
                %%%

            end
            refresh_volt_curr_src_mode (obj, CHL,SOURCE);

        end

        %% ENABLE/DISABLE channel A
        function obj = Toggle_ChA(obj,visa_obj)
            % We enable and disable the source, whatever channel and kind
            % of source the user is using and defined in the properties
                 
           refresh_channels_enable(obj,'A',~obj.channels_on_off(1)); % We toggle the state

            if obj.channels_on_off(1) 
                fprintf(visa_obj,"smua.source.output = smua.OUTPUT_ON");
            else   
                fprintf(visa_obj,"smua.source.output = smua.OUTPUT_OFF");
            end
            

        end
        
        %% ENABLE/DISABLE channel B
        function obj = Toggle_ChB(obj,visa_obj)
            % We enable and disable the source, whatever channel and kind
            % of source the user is using and defined in the properties
                 
           refresh_channels_enable(obj,'B',~obj.channels_on_off(2)); % We toggle the state

            if obj.channels_on_off(2) 
                fprintf(visa_obj,"smub.source.output = smub.OUTPUT_ON");
            else   
                fprintf(visa_obj,"smub.source.output = smub.OUTPUT_OFF");
            end
            

        end

        %% SET THE SOURCE LEVEL
        function obj = src_volt_level(obj,visa_obj, CHL,level)
            % We refresh first the value we want to give to the volt source
            refresh_voltage_meas_value(obj,CHL,level,false); % We are not measuring

            % Updated, then we set the level of voltage we want,

        end




    end
end