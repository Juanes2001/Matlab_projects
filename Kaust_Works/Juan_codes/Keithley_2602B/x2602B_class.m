classdef x2602B_class < handle
    % x2602B_class this class has the basic methods to use the Keithley 
    % reference 2602B, for funther complex procedures needed for the
    % research field, feel free to modify the methods as you want and add
    % more if needed. Communication is done by GPIB protocol by formatted
    % commands sent through, all this class is using its own properties.


    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % HERE ARE ALL THE METHODS DEFINED, INPUTS AND OUTPUTS AND PROPERTIES DESCRIPTION
    %   The properties are defined like this:
    %   1 InputBufferSize ---> property for visa's objects where we can
    %                          define a maximum buffer size as input, 
    %                          it means, max bytes allowed to receive in 
    %                          one transaction.
    %   2 OutputBufferSize ---> property for visa's objects where we can
    %                          define a maximum buffer size as output, 
    %                          it means, max bytes allowed to send in 
    %                          one transaction.    
    %   3. Timeout ---> max time in seconds  to wait while the device is 
    %                   proccessing any command sent.
    %   4. Vendor ----> Enterprice where the visa drivers came from ('NI',
    %                   'KEYSIGHT')
    %   5. GPIB_address ---> Address displayed on the device as the GPIB
    %                        port selected.
    %   6. Interface_index ---> Property used in case there are more than 1
    %                           keithley using, input 0 otherwise
    %   %%%%%%%%%%%%%%%%%%%%%% SRC and MEAS PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%% 
    %     
    %   7. volt_curr_src_mode ---> Array of the source mode is selected to supply
    %      [put "voltage" for CHA voltage source/ put "current" for CHA current source ,
    %       put "voltage" for CHB voltage source/ put "current" for CHB current source]
    %   8. volt_curr_src_value ---> Matrix of values where are saved the
    %                               value to source either voltage or
    %                               current.
    %     [voltage value in volts CHA, current value un amps CHA]
    %     [voltage value in volts CHB, current value un amps CHB] 
    %   9. channels_on_off ---> Array of booleans where we can find if some
    %                           channel is On or Off.
    %      [CHA 1--> ON/ 0--> OFF , CHB 1--> ON/ 0--> OFF]
    %   10. volt_curr_res_pow_meas_mode ---> Array of modes available to
    %                                       measure, they can be coltage,
    %                                       current, resistance, or power.
    %   [CHA put "voltage" if want to measure voltage/put "current" if want to measure current/
    %        put "resistance" if want to measure resistance/put "power" if want to measure power ,
    %    CHB put "voltage" if want to measure voltage/put "current" if want to measure current/
    %        put "resistance" if want to measure resistance/put "power" if want to measure power]
    %   
    %   11. volt_curr_res_pow_meas_value ---> Matrix of values where are
    %                                         saved the values measured.
    %                                         the units of each are (V, A, OHMS, W)
    %   [CHA voltage value, CHA current value, CHA resistance value, CHA power value]
    %   [CHB voltage value, CHB current value, CHB resistance value, CHB power value]
    %   
    %   12. Src_Meas_Mode ---> Array of booleans, are saved the modes currently used 
    %                          to operate, source or measure mode. 
    %   [CHA Measurement mode on/off, CHA Source mode on/off]
    %   [CHB Measurement mode on/off, CHB Source mode on/off]
    %   
    %   13. isMeasuring ----> Boolean, shows if the device are measuring
    %                         currently or not. 
    %   14. Volt_Curr_Pow_Limits -----> Matrix of values to set the limits
    %                                   of sourcing to now damage the
    %                                   device.
    %      [CHA voltage limit, CHA, current limit, CHA power limit]
    %      [CHB voltage limit, CHB, current limit, CHB power limit]
    %   15.MeasAuto ---> Matrix of booleans, which set for each channel if the  
    %                    measurement autorange mode is on or if it is off.
    %       [CHA Voltage autorange , CHA Current autorange]
    %       [CHB Voltage autorange , CHB Current autorange]
    %   
    % 
    %   16. SrcAuto ---> Matrix of booleans, which set for each channel if the  
    %                    Source autorange mode is on or if it is off.
    %       [CHA Voltage autorange , CHA Current autorange]
    %       [CHB Voltage autorange , CHB Current autorange]
    % 
    % 
    %   17.VoltCurrRange ---> Matrix of values, in which we set the values
    %                         of the range for measure and sourcing modes,
    %                         for each channel. With this we can control the 
    %                         accuracy of every measurement.  
    % [CHA measure voltage range , CHA measure current range , CHA source voltage range, CHA source current range ]
    % [CHB measure voltage range , CHB measure current range , CHB source voltage range, CHB source current range ]
    % 
    % 
    % %%%%%%%%%%%%%%%%%%%%%% METHODS DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %   %%% CONSTRUCTOR %%%
    %   
    %   For the constructor this is the following order of inputs
    %   
    %   x2602B_class( int InputBufferSize,
    %                 int InputBufferSize)
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    %   
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    % 
    %   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        %%% Properties for communication protocol used GPIB
        InputBufferSize
        OutputBufferSize
        Timeout
        Vendor
        GPIB_address
        Interface_index

        Visa_obj 

        %%% Properties of the control
        volt_curr_src_mode % Array [voltage smode A/current smode A, voltage smode B/current smode B]
                           % YOU SHOULD PUT AS INPUT STRINGS "voltage" or "current". 

        volt_curr_src_value % Array of values to be sourced [Volt Val [CHA,CHB] , Curr Val [CHA,CHB]]


        channels_on_off    % Array [Channel A ON_OFF?,Channel B ON_OFF?]


        volt_curr_res_pow_meas_mode % Array [voltage Mmode A/current Mmode A/Res Mmode A/Pow Mmode A
                                    %       ,voltage Mmode B/current Mmode B/Res Mmode B/Pow Mmode B] 

        volt_curr_res_pow_meas_value % Array [Volt value A, Curr value A, Res value A, Pow value A] 
                                     %       [Volt value B, Curr value B, Res value B, Pow value B]
        
       
        
        Src_Meas_Mode               % Array [[MeasA,MeasB] On_Off, [sourceA,sourceB] On_Off] 
                                

        

        isMeasuring        % Boolean, shows is we are measuring or 
                                % sourcing, 0 Sourcing, 1 Measuring 

        Volt_Curr_Pow_Limits    % Array of arrays of the limits source of 
                                % voltage, current and power for 
                                % each channel
                                % [voltage lim [CHA,CHB],
                                % current lim [CHA,CHB], 
                                % power lim [CHA,CHB]]    

        MeasAuto    % This property will allow the autorange in measurement
                    % mode, it means it will autorange to the most
                    % apropiate range available to maximaze acuracy [Auto Volt, Auto Curr]
                    
        SrcAuto     % This property will allow the autoragne in source mode
                    % it means if the instrument measures some value, it
                    % will change the measuremet ragne to the highest
                    % acuracy range available for that value, likewise if
                    % the value is out of range. [Auto Volt, Auto Curr]
        
        VoltCurrRange   % Array of arrays where we will find the info about
                        % the current range of each channel for both the
                        % source and measure mode, the maximum value where
                        % we can either measure or source, only in the case
                        % we measure the same magnitud as we are sourcing,
                        % the ranges of both are attached so is mandatory
                        % to change the range to be the same in this array
                        % in that case. Otherwise, the ranges are
                        % independent. We will use ranges only for acuracy,
                        % to care about the device protection, we use the
                        % limits of voltage, current, and power.
                       
                        % [Meas Voltage Range [CHA,CHB],
                        %  Meas Current Range [CHA,CHB],
                        %  Source Voltage Range [CHA,CHB],
                        %  Source Current Range [CHA,CHB]] Everything in
                        %                                   Volts and Amps
                    
    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = x2602B_class(vend , ...
                                    aDDr, ...
                                    interIndex)
            %x2602B_class  constructor, just set the principal and
            %important parameters to set due correct communication.
            obj.InputBufferSize     = 100000; %% Data to be received
            obj.OutputBufferSize    = 100000;%% Data to be sent
            obj.Timeout             = 10;    %% Waiting time while a command is proccesed
            obj.Vendor              = vend;       %% Vendor from where is the visa drivers
            obj.GPIB_address        = aDDr;       %% Address of the GPIB com
            obj.Interface_index     = interIndex; %% Number of devices communicating


            instr  = instrfind; % We have to be sure we close every single opened intrument
            if ~isempty(instr)
                fclose(instr);
                delete(instr);
            end

            
            obj.Visa_obj = visa (vend, sprintf("GPIB%u::%u::INSTR", ...
                                 interIndex, ...
                                 aDDr));
            obj.Visa_obj.InputBufferSize = 100000;
            obj.Visa_obj.OutputBufferSize = 100000;
            obj.Visa_obj.Timeout = 10;

            fopen(obj.Visa_obj);
            
            % With this we set the device on the remote mode
            pause(1);
            if ~isempty(iDN(obj,visa_obj))
                logic = true;
                ident = iDN(obj,visa_obj); 
                disp(ident);
            else
                logic = false;
                ident = "Communcation Error";
            end

            obj.volt_curr_src_mode              = ["voltage","current"];
            obj.volt_curr_src_value             = [[0;0],[0;0]];
            obj.channels_on_off                 = [0,0];
            obj.volt_curr_res_pow_meas_mode     = ["voltage","voltage"];
            obj.volt_curr_res_pow_meas_value    = [[0;0],[0;0],[0;0],[0;0]];
            
            obj.Src_Meas_Mode        = [[0;0],[0;0]];
            obj.isMeasuring          = 0;
            obj.Volt_Curr_Pow_Limits = [[1;1],[0.1;0.1],[0.3;0.3]];
            obj.MeasAuto             = [[1;1],[1;1]];
            obj.SrcAuto              = [[1;1],[1;1]];
            obj.VoltCurrRange        = [[1;1],[0.3;0.3],[1;1],[0.5;0.5]];
            
        end % End function

        %end constructor function


        %% REFREST TESTING PARAMETERS 
        %Here will be shown all the refreshing functions which work to
        %mantain all the info on the properties and not as an input of the
        %methods written, only for simplicity, so dont expect to use this
        %functions some time, they are secondary meant to use in the
        %principal methods.

        function obj = refresh_vi_SrcMode(obj,CHL,volt_curr_mode)
            % here will be refreshing the volt_cur_src_mode property, to
            % have information about the source mode available in every
            % channel.

            % [Voltage/Current (CHA) , Voltage/Current (CHB)]

            if lower(CHL) == 'a'
                obj.volt_curr_src_mode(1) = volt_curr_mode;
            elseif lower(CHL) == 'b'
                obj.volt_curr_src_mode(2) = volt_curr_mode;
            end
        end% End function

       function obj = refresh_vi_SrcValue(obj, CHL, volt_curr_mode, level)
            % Here you will be refreshing the binary state of either the
            % measure or source mode of each channel
           
           % [MeasA , SourceA]
           % [MeasB , SourceB] ONLY ON/OFF states, true or falce, 1 or 0

            if lower(CHL) == 'a'
                if lower(volt_curr_mode) == "voltage"
                    obj.volt_curr_src_value (1,1) = level; %In volts
                elseif lower(volt_curr_mode) == "current"
                    obj.volt_curr_src_value (1,2) = level; %In amps
                end
            elseif lower(CHL) == 'b' 
                 if lower(volt_curr_mode) == "voltage"
                    obj.volt_curr_src_value (2,1) = level;
                elseif lower(volt_curr_mode) == "current"
                    obj.volt_curr_src_value (2,2) = level;
                end
            end
        end % End of the function

        function obj = refresh_CHL_enable(obj,CHL,newCHState)
            % here will be refreshing the channel X property, changing
            % their state

            % [CHA ON/OFF, CHB, ON/OFF] (only 0 or 1 , true or false), what
            % ever you want, just binary content


            if lower(CHL) == 'a'
                obj.channels_on_off(1) = newCHState;
            elseif lower(CHL) == 'b'
                obj.channels_on_off(2) = newCHState;
            end
        end % End function

         function obj = refresh_virp_MeasMode(obj,CHL,src_meas_Mode)
            % This function refresh the mode of measurement wanted for the
            % user, between voltage, current, resistance, and Power, only
            % the string of the name of what is going to be measured is desired.

            %   [voltage Mmode A/current Mmode A/Res Mmode A/Pow Mmode A
            %   ,voltage Mmode B/current Mmode B/Res Mmode B/Pow Mmode B] 

            if lower(CHL) == 'a' 
                  obj.volt_curr_res_pow_meas_mode(1) = src_meas_Mode;
            elseif lower(CHL) == 'b'
                  obj.volt_curr_res_pow_meas_mode(2) = src_meas_Mode;
            end
         end % End of the function

         function obj = refresh_virp_MeasValue(obj,CHL,meas_mode,value)
            % Here will be refreshed the value of the desired magnitudes
            % between: voltage, Current, resistance, and power. All of them
            % are red in international units. [V,A,Ohm,W]

            % [Volt value A, Curr value A, Res value A, Pow value A] 
            % [Volt value B, Curr value B, Res value B, Pow value B]
        
            if lower(CHL) == 'a'
                switch lower(meas_mode)
                    case "voltage"
                        obj.volt_curr_res_pow_meas_value(1,1) = value;
                    case "current"
                        obj.volt_curr_res_pow_meas_value(1,2) = value;
                    case "resistance"
                        obj.volt_curr_res_pow_meas_value(1,3) = value;
                    case "power"    
                        obj.volt_curr_res_pow_meas_value(1,4) = value;
                    otherwise
                        %%%
                end    
                        
            elseif lower(CHL) == 'b' 
                switch lower(meas_mode)
                    case "voltage"
                        obj.volt_curr_res_pow_meas_value(2,1) = value;
                    case "current"
                        obj.volt_curr_res_pow_meas_value(2,2) = value;
                    case "resistance"
                        obj.volt_curr_res_pow_meas_value(2,3) = value;
                    case "power"    
                        obj.volt_curr_res_pow_meas_value(2,4) = value;
                    otherwise
                        %%%
                end 
            end
         end % End of the function


       function obj = refresh_SrcMeasMode(obj, CHL, src_meas_mode, newSMState)
            % Here you will be refreshing the binary state of either the
            % measure or source mode of each channel
           
           % [MeasA , SourceA]
           % [MeasB , SourceB] ONLY ON/OFF states, true or falce, 1 or 0

            if lower(CHL) == 'a'
                if lower(src_meas_mode) == "measure"
                    obj.Src_Meas_Mode (1,1) = newSMState;
                elseif lower(src_meas_mode) == "source"
                    obj.Src_Meas_Mode (1,2) = newSMState;
                end
            elseif lower(CHL) == 'b' 
                 if lower(src_meas_mode) == "measure"
                    obj.Src_Meas_Mode (2,1) = newSMState;
                elseif lower(src_meas_mode) == "source"
                    obj.Src_Meas_Mode (2,2) = newSMState;
                end
            end
        end % End of the function

        function obj = refresh_isMeas(obj,newMState)
            % This refreshing will be updating the measuring state, it
            % means if we are measuring or if we are supplying
            
            obj.isMeasuring = newMState; 
        end % End  of the function
        
        function obj = refresh_vip_Limits(obj,CHL,volt_curr_pow_mode ,limit)
            % This function refresh the property of the limit value
            % depending if we are measuring or if we are supplying in form
            % of current or voltage, Either cases will have different
            % options of limiting, 
            % FOR VOLTAGE: from 10mV up to 40V
            % FOR CURRENT:  from 10uA up to 3A ( 3Amps only
            %                                   when voltage is down to 
            %                                   6V, 1amp if up from 6V to
            %                                   40V )
            %FOR POWER: FROM 0 up to 1000W (not recomended)

             %     [ VOLT_LIM_CHA , CURR_LIM_CHA , POW_LIM_CHA ]
             %     [ VOLT_LIM_CHB , CURR_LIM_CHB , POW_LIM_CHB ] 
           
               
                if volt_curr_pow_mode == "voltage" 
                    if lower(CHL) == 'a'
                       obj.Volt_Curr_Pow_Limits(1,1) = limit; 
                    elseif lower(CHL) == 'b'
                       obj.Volt_Curr_Pow_Limits(2,1) = limit;
                   end
                elseif volt_curr_pow_mode == "current"
                   if lower(CHL) == 'a'
                       obj.Volt_Curr_Pow_Limits(1,2) = limit;
                   elseif lower(CHL) == 'b'
                       obj.Volt_Curr_Pow_Limits(2,2) = limit;
                   end
                elseif volt_curr_pow_mode == "power"
                    if lower(CHL) == 'a'
                       obj.Volt_Curr_Pow_Limits(1,3) = limit;
                   elseif lower(CHL) == 'b'
                       obj.Volt_Curr_Pow_Limits(2,3) = limit;
                   end
                
                
                
                end
           end % End function

           function obj = refresh_vi_Rang(obj, CHL, src_meas_mode ,volt_curr_mode, range)

               % This function will refresh the property of range of
               % voltage and current either in source or measure mode.
               % if someone is trying to measure and source the same
               % either voltage or current, the range of both cases, 
               % (measure and source) will be the same. then you just have
               % to modify the source, not the measure, otherwise, the
               % ranges are independent, so the autorange 


               %     [ MVOLT_RAN_CHA , MCURR_RAN_CHA , SVOLT_RAN_CHA , SCURR_RAN_CHA ]
               %     [ MVOLT_RAN_CHB , MCURR_RAN_CHB , SVOLT_RAN_CHB , SCURR_RAN_CHB ] 

               if lower(src_meas_mode) == "measure"
                   if lower(CHL) == 'a'
                       if lower(volt_curr_mode) == "voltage"
                            obj.VoltCurrRange(1,1) = range;
                       elseif lower(volt_curr_mode) == "current"
                            obj.VoltCurrRange(1,2) = range;
                       end    
                   elseif lower(CHL) == 'b'
                       if lower(volt_curr_mode) == "voltage"
                            obj.VoltCurrRange(2,1) = range;
                       elseif lower(volt_curr_mode) == "current"
                            obj.VoltCurrRange(2,2) = range;
                       end
                   end
                    
               elseif lower(src_meas_mode) == "source"
                   if lower(CHL) == 'a'
                       if lower(volt_curr_mode) == "voltage"
                            obj.VoltCurrRange(1,3) = range;
                       elseif lower(volt_curr_mode) == "current"
                            obj.VoltCurrRange(1,4) = range;
                       end
                   elseif lower(CHL) == 'b'
                       if lower(volt_curr_mode) == "voltage"
                            obj.VoltCurrRange(2,3) = range;
                       elseif lower(volt_curr_mode) == "current"
                            obj.VoltCurrRange(2,4) = range;
                       end
                   end
               end
           end % End function




           function obj = refresh_autorange(obj, CHL, src_meas_mode, volt_curr_mode , newAuState)
    
               % We refresh with this function the state of autorange 
    
               if lower(src_meas_mode) == "measure"
                   if lower(CHL) == 'a'
                       if lower(volt_curr_mode) == "voltage"
                            obj.MeasAuto(1,1) = newAuState;
                       elseif lower(volt_curr_mode) == "current"
                            obj.MeasAuto(1,2) = newAuState;
                       end    
                   elseif lower(CHL) == 'b'
                       if lower(volt_curr_mode) == "voltage"
                            obj.MeasAuto(2,1) = newAuState;
                       elseif lower(volt_curr_mode) == "current"
                            obj.MeasAuto(2,2) = newAuState;
                       end
                   end
                    
               elseif lower(src_meas_mode) == "source"
                   if lower(CHL) == 'a'
                       if lower(volt_curr_mode) == "voltage"
                            obj.SrcAuto(1,1) = newAuState;
                       elseif lower(volt_curr_mode) == "current"
                            obj.SrcAuto(1,2) = newAuState;
                       end
                   elseif lower(CHL) == 'b'
                       if lower(volt_curr_mode) == "voltage"
                            obj.SrcAuto(2,1) = newAuState;
                       elseif lower(volt_curr_mode) == "current"
                            obj.SrcAuto(2,2) = newAuState;
                       end
                   end
               end
                
           end % End of the function

        %% SET UP AND INITIATION
        function obj = init(obj, visa_obj)
            % With init() we want to initiate the device properly 
           
            % With this we set the device on the remote mode
            pause(1)
            if ~isempty(iDN(obj,visa_obj))
                logic = true;
                ident = iDN(obj,visa_obj); 
                disp(ident);
            else
                logic = false;
                ident = "Communcation Error";
            end
        end


        %% SHUT DOWN COMMUNICATON

        function logic = deleteObj(obj)
            % Close and delete the GPIB object
            fclose(obj.Visa_obj);
            pause(1);
            logic = true;
            delete(obj.Visa_obj);
            clear obj.Visa_obj;
        end

         %% Identification

         function msg_idn = iDN(obj)
            % Send a messege of identification
            fprintf(obj.Visa_obj , '*IDN?'); % We sent the command, then it will send us
                                             % back the response

            msg_idn = fscanf(obj.Visa_obj);  % We try to read the port anr return the identificator
         end 


        %% RESET
        function reset(obj)
            % Reset the system
            fprintf(obj.Visa_obj , '*RST');
        end

        %% SELECT THE SOURCE, VOLTAGE CHA
        function obj = set_CHA_srcV(obj)
            % To set the channel A to voltage source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj ,"smua.source.func = smua.OUTPUT_DCVOLTS");
           
            refresh_vi_SrcMode (obj, 'a' ,"voltage");
        end


          %% SELECT THE SOURCE, CURRENT CHA
        function obj = set_CHA_srcI(obj)
            % To set the channel A to current source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj , "smua.source.func = smua.OUTPUT_DCAMPS");
           
            refresh_vi_SrcMode (obj, 'a',"current");
        end


        %% SELECT THE SOURCE, VOLTAGE CHB
        function obj = set_CHB_srcV(obj)
            % To set the channel B to voltage source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj ,"smub.source.func = smub.OUTPUT_DCVOLTS");
           
            refresh_vi_SrcMode (obj, 'a' ,"voltage");
        end


          %% SELECT THE SOURCE, CURRENT CHA
        function obj = set_CHB_srcI(obj)
            % To set the channel B to current source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj , "smub.source.func = smub.OUTPUT_DCAMPS");
           
            refresh_vi_SrcMode (obj, 'b',"current");
        end

        %% ENABLE/DISABLE channels
        function obj = Toggle_CHX(obj,CHL)
            % We enable and disable the source, whatever channel and kind
            % of source the user is using and defined in the properties
                 
           refresh_CHL_enable(obj,CHL,~obj.channels_on_off(1)); % We toggle the state

            if obj.channels_on_off(1) 
                fprintf(obj.Visa_obj,sprintf("smu%s.source.output = smu%s.OUTPUT_ON", lower(CHL),lower(CHL)));
            else   
                fprintf(obj.Visa_obj,sprintf("smu%s.source.output = smu%s.OUTPUT_OFF", lower(CHL),lower(CHL)));
            end
           
        end

       
        %% SET THE V(VOLTAGE) LIMITS CHA
        function obj = set_CHA_limitV(obj ,limit)

            % With this function we set the limits for the source when it
            % is open, it is important to know the voltage limit is
            % available when we are sourcing current, and likewise in the
            % other case, in both cases be sure to set maximum power limit.

            % First refresh the voltage limit
            refresh_vip_Limits(obj, 'a' , "voltage", limit);
            
            % after refreshing, we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smua.source.limitv = %.4f", limit)); % please set the limit in volts
                    
        end 
        
         %% SET THE I(CURRENT) LIMITS CHA
        function obj = set_CHA_limitI(obj ,limit)

            % With this function we set the limits for the source when it
            % is open, it is important to know the voltage limit is
            % available when we are sourcing current, and likewise in the
            % other case, in both cases be sure to set maximum power limit.

            % First refresh the voltage limit
            refresh_vip_Limits(obj, 'a' , "current", limit);
            
            % after refreshing, we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smua.source.limiti = %.4f", limit)); % please set the limit in volts
                    
        end 


         %% SET THE P(POWER) LIMITS CHA
        function obj = set_CHA_limitP(obj ,limit)

            % With this function we set the limits for the source when it
            % is open, it is important to know the voltage limit is
            % available when we are sourcing current, and likewise in the
            % other case, in both cases be sure to set maximum power limit.

            % First refresh the voltage limit
            refresh_vip_Limits(obj, 'a' , "power", limit);
            
            % after refreshing, we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smua.source.limitp = %.4f", limit)); % please set the limit in volts
                    
        end 

         %% SET THE V(VOLTAGE) LIMITS CHB
        function obj = set_CHB_limitV(obj ,limit)

            % With this function we set the limits for the source when it
            % is open, it is important to know the voltage limit is
            % available when we are sourcing current, and likewise in the
            % other case, in both cases be sure to set maximum power limit.

            % First refresh the voltage limit
            refresh_vip_Limits(obj, 'b' , "voltage", limit);
            
            % after refreshing, we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smub.source.limitv = %.4f", limit)); % please set the limit in volts
                    
        end 
        
         %% SET THE I(CURRENT) LIMITS CHB
        function obj = set_CHB_limitI(obj ,limit)

            % With this function we set the limits for the source when it
            % is open, it is important to know the voltage limit is
            % available when we are sourcing current, and likewise in the
            % other case, in both cases be sure to set maximum power limit.

            % First refresh the voltage limit
            refresh_vip_Limits(obj, 'b' , "current", limit);
            
            % after refreshing, we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smub.source.limiti = %.4f", limit)); % please set the limit in volts
                    
        end 


         %% SET THE P(POWER) LIMITS CHB
        function obj = set_CHB_limitP(obj ,limit)

            % With this function we set the limits for the source when it
            % is open, it is important to know the voltage limit is
            % available when we are sourcing current, and likewise in the
            % other case, in both cases be sure to set maximum power limit.

            % First refresh the voltage limit
            refresh_vip_Limits(obj, 'b' , "power", limit);
            
            % after refreshing, we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smub.source.limitp = %.4f", limit)); % please set the limit in volts
                    
        end 



        %% SET THE VOLTAGE RANGE CHA FOR SOURCING
        function obj = set_CHA_srcRangeV(obj,range )       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'a', obj.isMeasuring, "voltage", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smua.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
            
        end 

        %% SET THE CURRENT RANGE CHA FOR SOURCING
        function obj = set_CHA_srcRangeI(obj,range)       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'a', obj.isMeasuring, "current", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smua.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
            
        end 

          %% SET THE VOLTAGE RANGE CHB FOR SOURCING
        function obj = set_CHB_srcRangeV(obj,range )       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'b', obj.isMeasuring, "voltage", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smub.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
            
        end 

        %% SET THE VOLTAGE RANGE CHB FOR SOURCING
        function obj = set_CHB_srcRangeI(obj,range)       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'b', obj.isMeasuring, "current", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smub.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
            
        end 



        %% SET THE VOLTAGE RANGE CHA FOR MEASURING
        function obj = set_CHA_measRangeV(obj,range )       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'a', obj.isMeasuring, "voltage", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smua.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
            
        end 

        %% SET THE CURRENT RANGE CHA FOR MEASURING
        function obj = set_CHA_measRangeI(obj,range)       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'a', obj.isMeasuring, "current", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smua.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
            
        end 

          %% SET THE VOLTAGE RANGE CHB FOR MEASURING
        function obj = set_CHB_measRangeV(obj,range)       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'b', obj.isMeasuring, "voltage", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smub.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
            
        end 

        %% SET THE VOLTAGE RANGE CHB FOR MEASURING
        function obj = set_CHB_measRangeI(obj,range)       
            % With this function we are looking to change, as desired, the
            % range of the source and meter either for voltage or current. 
            % For the first one would be the bounderies
            % maximum and minumin (meaning that it can reach the limit 
            % negatively), all the matter with the range is for acuracy only, to
            % keep the device properly safe we manage the limits.

            % First refresh because we want to do a change on the
            % established ranges
            refresh_vi_Rang(obj,'b', obj.isMeasuring, "current", range);

            % Then we set the range in the instrument
            fprinf(obj.Visa_obj, sprintf("smub.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
            
        end 
        

 
        %% SET AUTORANGE SOURCE VOLTAGE CHA
        function obj = set_CHA_srcAutoV(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'a',"source","voltage", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangev = smua.AUTORANGE_ON");
        end


        %% SET AUTORANGE SOURCE CURRENT CHA
        function obj = set_CHA_srcAutoI(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'a',"source","current", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangei = smua.AUTORANGE_ON");
        end

         %% SET AUTORANGE SOURCE VOLTAGE CHB
        function obj = set_CHB_srcAutoV(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'b',"source","voltage", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangev = smub.AUTORANGE_ON");
        end


        %% SET AUTORANGE SOURCE CURRENT CHB
        function obj = set_CHB_srcAutoI(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'b',"source","current", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangei = smub.AUTORANGE_ON");
        end




         %% SET AUTORANGE MEASURE VOLTAGE CHA
        function obj = set_CHA_measAutoV(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'a',"measure","voltage", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangev = smua.AUTORANGE_ON");
        end


        %% SET AUTORANGE MEASURE CURRENT CHA
        function obj = set_CHA_measAutoI(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'a',"measure","current", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangei = smua.AUTORANGE_ON");
        end

        %% SET AUTORANGE MEASURE VOLTAGE CHB
        function obj = set_CHB_measAutoV(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'b',"measure","voltage", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangev = smub.AUTORANGE_ON");
        end


        %% SET AUTORANGE MEASURE CURRENT CHB
        function obj = set_CHB_measAutoI(obj)
                % With this function we can toggle state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                %First we refresh the auntorange states depending on the
                %entries

                refresh_autorange(obj,'b',"measure","current", true);
                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangei = smub.AUTORANGE_ON");
        end

        %% SET THE SOURCE VOLTAGE LEVEL CHA
        function obj = set_CHA_srcLevelV(obj,level)
            % With this function we want to set the value to source in each
            % channel. 
            refresh_vi_SrcValue(obj,CHL,volt_curr_mode,level);

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smua.source.levelv = %.4f",level));
        end

        %% SET THE SOURCE CURRENT LEVEL CHA
        function obj = set_CHA_srcLevelI(obj,level)
            % With this function we want to set the value to source in each
            % channel. 
            refresh_vi_SrcValue(obj,CHL,volt_curr_mode,level);

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smua.source.leveli = %.4f",level));
        end

        %% SET THE SOURCE VOLTAGE LEVEL CHB
        function obj = set_CHB_srcLevelV(obj,level)
            % With this function we want to set the value to source in each
            % channel. 
            refresh_vi_SrcValue(obj,CHL,volt_curr_mode,level);

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smub.source.levelv = %.4f",level));
        end

        %% SET THE SOURCE CURRENT LEVEL CHB
        function obj = set_CHB_srcLevelI(obj,level)
            % With this function we want to set the value to source in each
            % channel. 
            refresh_vi_SrcValue(obj,CHL,volt_curr_mode,level);

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smub.source.leveli = %.4f",level));
        end


 
        %% GET VOLTAGE MEASUREMET CHA

        function [reading_value,units] = get_CHA_measV (obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smua.measure.v()");
                units = "V";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end
    
        %% GET CURRENT MEASUREMET CHA

        function [reading_value,units] = get_CHA_measI (obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smua.measure.i()");
                units = "A";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% GET RESISTANCE MEASUREMET CHA

        function [reading_value,units] = get_CHA_measR(obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smua.measure.r()");
                units = "Ohms";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% GET POWER MEASUREMET CHA

        function [reading_value,units] = get_CHA_measP(obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smua.measure.p()");
                units = "W";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% GET VOLTAGE MEASUREMET CHB

        function [reading_value,units] = get_CHB_measV (obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smub.measure.v()");
                units = "V";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end
    
        %% GET CURRENT MEASUREMET CHB

        function [reading_value,units] = get_CHB_measI (obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smub.measure.i()");
                units = "A";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% GET RESISTANCE MEASUREMET CHB

        function [reading_value,units] = get_CHB_measR(obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smub.measure.r()");
                units = "Ohms";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% GET POWER MEASUREMET CHB

        function [reading_value,units] = get_CHB_measP(obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance, and
                % power, then we just select the channel and the magnitud
                % we want.

                fprintf(obj.Visa_obj, "read_value = smub.measure.p()");
                units = "W";
            
            fprintf(obj.Visa_obj, "print(read_value)");
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end



    end % End of the methods


end %End of the class


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%