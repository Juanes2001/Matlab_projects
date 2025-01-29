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
        voltage_on_off
        current_on_off
        channelA_on_off %Array ['A',ON_OFF]
        channelB_on_off %Array ['B',ON_OFF]

    end    
    
    
    methods
        %% CONSTRUCTOR
        function obj = x2602B_class(InBuffSize, outBuffSize, Timeout, vend ,aDDr ...
                                    ,interIndex)
            %x2602B_class  constructor, just set the principal and
            %important parameters to set due correct communication.
            obj.InputBufferSize     = InBuffSize; %% Data to be received
            obj.OutputBufferSize    = outBuffSize;%% Data to be sent
            obj.Timeout             = Timeout;    %% Waiting time while a command is proccesed
            obj.Vendor              = vend;       %% Vendor from where is the visa drivers
            obj.GPIB_address        = aDDr;       %% Address of the GPIB com
            obj.Interface_index     = interIndex; %% Number of devices communicating
    
        end

        %end constructor function
        %% SET UP AND INITIATION
        function visa_obj = init(obj)
            % with init() we want to initiate the device properly 
            
            instr  = instrfind;% we have to be sure we close the every single opened intrument
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
        end


        %% SHUT DOWN COMMUNICATON

        function shutDown(obj)
            % Close and delete the GPIB object
            fclose(Keithley);
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

        %% SET VOLTAGE AS A SOURCE
        function select_source(obj, visa_obj)
            % To set the channel X to voltage source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            if obj.voltage_on_off
                if obj.channelA_on_off(2)    
                    fprintf(visa_obj , sprintf("smu%s.source.func = smu%s.OUTPUT_DC%s", ...
                                                obj.channelA_on_off(1), ...
                                                obj.channelA_on_off(1), ...
                                                'VOLTS'));
                else
                    fprintf(visa_obj , sprintf("smu%s.source.func = smu%s.OUTPUT_DC%s", ...
                                                obj.channelB_on_off(1), ...
                                                obj.channelB_on_off(1), ...
                                                'VOLTS'));
                end    
            elseif obj.current_on_off
                if obj.channelA_on_off(2)    
                    fprintf(visa_obj , sprintf("smu%s.source.func = smu%s.OUTPUT_DC%s", ...
                                                obj.channelA_on_off(1), ...
                                                obj.channelA_on_off(1), ...
                                                'VOLTS'));
                else
                    fprintf(visa_obj , sprintf("smu%s.source.func = smu%s.OUTPUT_DC%s", ...
                                                obj.channelB_on_off(1), ...
                                                obj.channelB_on_off(1), ...
                                                'VOLTS'));
                end    
            else
                %%%

            end

        end

        %% ENABLE/DISABLE
        function on_offSource(obj,visa_obj)
            % We enable and disable the source, whatever channel and kind
            % of source the user is using
                
            if obj.channelA_on_off(2) 
                fprintf(visa_obj, sprintf("smu%s.source.output = smu%s.OUTPUT_ON", ...
                                            obj.channelA_on_off(1), ...
                                            obj.channelA_on_off(1) ));
            elseif   
                fprintf(visa_obj, sprintf("smu%s.source.output = smu%s.OUTPUT_OFF", ...
                                            obj.channelA_on_off(1), ...
                                            obj.channelA_on_off(1) ));

            end

        end
        %% SET THE SOURCE LEVEL
        function src_level(obj,visa_obj,channel, source, value, units)

            % First we set the string of the source just to know if 
            
        end




    end
end