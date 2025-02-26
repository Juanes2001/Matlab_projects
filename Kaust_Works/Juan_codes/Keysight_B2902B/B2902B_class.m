classdef B2902B_class < handle
    % B2902B_class this class has the basic methods to use the Keysight 
    % reference B2902B, for further complex procedures needed on the
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
    % 
    % %%%%%%%%%%%%%%%%%%%%%% METHODS DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%% CONSTRUCTOR %%%
    %   
    %   For the constructor this is the following order of inputs
    %   
    %   B2902B_class( String vendor,
    %                 int aDDr,
    %                 ind interIndex  ) 
    %
    %                 % This also starts the
    %                 communication protocol between the PC and Keithley so
    %                 it is not needed to use fopen.
    %   
    %%%%%%%%%%%%%%%%%%%%
    % 
    %
    %%%%% INIT METHOD %%%%%%% 
    % 
    %   init(B2902B_class obj)
    %  
    %   This method only initiates the communication by opening it and
    %   sending a identification command to be sure the communication is
    %   oppened as it needed.
    % 
    %%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%%%% DELATE METHOD %%%%
    % 
    %   This one is only responsible for delating the visa object created 
    %   to quit communication. 
    %    
    %   bool logic = deleteObj (B2902B_class obj)
    %   
    %   logic -> return from the function, is logic, so you can use the
    %   variable just to know if the process delating was correct.
    %   
    %%%%%%%%%%%%%%%%%%%%%%%   
    %   
    %   
    %%%%%%%% IDENTIFICATION METHOD %%%%   
    %   
    %   With this method we can ask to device to identify.
    %   
    %   String msg_idn = iDN(B2902B_class obj)
    %   
    %   msg_idn --> message returned by the device just to know the
    %   communication was efectively created.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    % 
    %%%%%%%% RESET METHOD %%%%   
    % 
    % With this one we can ask for reset the device to default properties
    % 
    %   reset(B2902B_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%% SOURCES SETTERS METHODS %%%%   
    %   This functions sets the type of source will be selected
    % 
    %   set_CHX_srcY(B2902B_class obj)
    % 
    %   X---> 1 (Channel 1) / 2 (Channel 2)
    %   Y---> V (voltage) / I (Current)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%% ENABLES/DISABLES CHANNELS METHODS %%%%  
    % 
    % This functions enables or diables the channels
    %    
    %   bool logic = X_CHY(B2902B_class obj)
    % 
    %   X ---> enable/disable
    %   Y ---> 1 (Channel 1)/2 (Channel 2)
    % 
    %   The output is a boolean which says about the if we triggered to 
    %   enable the output or to disable.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%% LIMITS SETTERS METHODS %%%%   
    % 
    %   This function allows you to set the limits of the differents
    %   channels and the diferents sources, voltage, current, and power,
    %   just to define some to have spetial bounderies to not damage the
    %   instrument.
    %
    %   double limit_set = set_CHX_limitY(B2902B_class obj ,double limit)
    % 
    %   X---> 1 (Channel 1) / 2 (Channel 2) 
    %   Y---> V (voltage) / I (Current)/ P (Power)
    % 
    %   The output is a double which says the limit set.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%% RANGE SETTERS METHODS %%%% 
    % 
    %  This functions sets the range for either sourcing and measuring, the
    %  range is really important to manage because good logic and handleing
    %  of the ranges leads to avoid overload in the measuremets, and the
    %  time of autoranging as well.
    % 
    %   double range_set = set_CHX_YRangeZ(B2902B_class obj,double range)  
    % 
    %   X---> 1 (Channel 1) / 2 (Channel 2) 
    %   Y---> src (source) / meas (measure)
    %   Z---> V (voltage) / I (Current)
    % 
    % 
    %   The output is a double which says the range set.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%% ENABLE/DISABLE MEASUREMENT MODE %%%%%%%%
    % 
    % With this function we want to enbale or disable of each channel the
    % measurement mode,  IS IMPORTANT TO ENABLE THE MODE IF MEASUREMENT IS
    % DESIRED, OTHERWISE NaN OR OVERLOAD VALUES WILL BE RETURNED.
    % 
    %   boolean logic = X_CHY_meas(B2902B_class obj)
    % 
    %   X ---> en/dis
    %   Y ---> 1 (Channel 1)/2 (Channel 2)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%
    % 
    %%%%%%%% AUTORANGE ENABLE/DISABLE METHODS %%%%  
    % 
    % 
    % With these methods we can enable the autorange mode for either source
    % or measurement mode, so we dont need anymore the RANGE setters
    % methods
    % 
    %       bool logic = X_CHY_ZAutoW(B2902B_class obj)
    %
    %   X---> en/dis
    %   Y---> 1 (Channel 1) / 2 (Channel 2) 
    %   Z---> src (source) / meas (measure)
    %   W---> V (voltage) / I (Current)
    % 
    %   the output is a boolean which returns a true always, by setting the
    %   range manually it disables, on the script you have to erase manually 
    %   the variable whenever you are recording the boolean value. 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%  
    % 
    % 
    %%%%%%%% LEVEL SOURCE SETTERS METHODS %%%%   
    % 
    %     With these methods we set the level of sourcing we want to output
    %
    %     double level_set = set_CHX_srcLevelZ(B2902B_class obj,double level)
    % 
    %    X---> 1 (Channel 1) / 2 (Channel 2) 
    %    Y---> V (voltage)   / I (Current)
    % 
    %   It returns the level os the specific source set.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%% MEASUREMENTS GETTERS METHODS %%%%    
    %
    %   With these methods we get the different meausrements we want to know
    %   from the device
    % 
    %       [double reading_value,string units] = get_CHX_measY(B2902B_class obj)
    % 
    %       X---> 1 (Channel 1) / 2 (Channel 2) 
    %       Y---> V (Voltage) / I (Current) / R (Resistance)
    % 
    %       It returns the reading value and the units as a string
    % 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        %%% Properties for communication protocol used GPIB
        InputBufferSize         %% Data to be received
        OutputBufferSize        %% Data to be sent
        Timeout                 %% Waiting time while a command is proccesed
        Vendor                  %% Vendor from where is the visa drivers
        GPIB_address            %% Address of the GPIB com
        Interface_index         %% Number of devices communicating

        Visa_obj                %% Visa object used to open and close communication
                    


        Range_voltage = {0.2   , "200mV"   ,...
                         2     , "2V"      ,...
                         20    , "20V"     ,...     %%% TABLE 1
                         200   , "200V"   }

       
        Range_current = {10E-9    , "10nA"   , ...
                         100E-9   , "100nA"  , ...
                         1E-6     , "1uA"    , ...
                         10E-6    , "10uA"   , ...  %%% TABLE 2
                         100E-6   , "100uA"  , ...
                         1E-3     , "1mA"    , ...
                         10E-3    , "10mA"   , ...
                         100E-3   , "100mA"  , ...
                         1        , "1A"     , ...
                         1.5      , "1.5A"   ,...
                         3        , "3A"     ,...
                         3        , "3A"     ,...
                         10       , "10A"    }


        Range_resis =   {2     , "2Ohms"   , ...
                         20    , "20Ohms"  , ...
                         200   , "200Ohms" , ...
                         2E3   , "2kOhms"  , ...  %%% TABLE 3
                         20E3  , "20kOhms" , ...
                         200E3 , "200kOhms", ...
                         2E6   , "2MOhms"  , ...
                         20E6  , "20MOhms" , ...
                         200E6 , "200MOhms"}
                    
    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = B2902B_class(vend , ...
                                    aDDr, ...
                                    interIndex)
            %B2902B_class  constructor, just set the principal and
            %important parameters to set due correct communication.

            obj.InputBufferSize     = 100000;     
            obj.OutputBufferSize    = 100000;     
            obj.Timeout             = 10;         
            obj.Vendor              = vend;       
            obj.GPIB_address        = aDDr;       
            obj.Interface_index     = interIndex; 
            
            obj.Visa_obj = visa (vend, sprintf("GPIB%u::%u::INSTR", ...
                                 interIndex, ...
                                 aDDr));
            obj.Visa_obj.InputBufferSize = 100000;
            obj.Visa_obj.OutputBufferSize = 100000;
            obj.Visa_obj.Timeout = 10;
            
            
        end % End function

        %end constructor function
        


        %% DETALE ALL OPENED COMUNICATIONS
        
        function delateAll(obj)
            % With this function we seek to delate all opened instrumet if
            % needed
            instr  = instrfind; % We have to be sure we close every single opened intrument
            if ~isempty(instr)
                fclose(instr);
                delete(instr);
            end
        end

       %% INIT COMMUNICATION
       function init(obj)
           % This function initiates communication with the Keithley
           
           fopen(obj.Visa_obj);
            
            % With this we set the device on the remote mode
            pause(1);
            if ~isempty(iDN(obj))
                ident = iDN(obj); 
                disp(ident);
            else
                ident = "Communcation Error";
                disp(ident);
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
            fprintf(obj.Visa_obj ,'*RST');
        end

        %% SELECT THE SOURCE, VOLTAGE CH1
        function set_CH1_srcV(obj)
            % Sets the channel 1 to voltage source we change the SCPI
            % property which controls the seleccion of the source, set 
            % [:SOURce[c]]:FUNCtion:MODE mode
            
            fprintf(obj.Visa_obj ,":SOUR1:FUNC:MODE VOLT");
            
        end
          %% SELECT THE SOURCE, CURRENT CH1
        function set_CH1_srcI(obj)
            % Sets the channel 1 to current source we change the SCPI
            % property which controls the seleccion of the source, set 
            % [:SOURce[c]]:FUNCtion:MODE mode
            
            fprintf(obj.Visa_obj , ":SOUR1:FUNC:MODE CURR");
        end

            %% SELECT THE SOURCE, VOLTAGE CH2
        function set_CH2_srcV(obj)
            % Sets the channel 2 to voltage source we change the SCPI
            % property which controls the seleccion of the source, set 
            % [:SOURce[c]]:FUNCtion:MODE mode
            
            fprintf(obj.Visa_obj ,":SOUR2:FUNC:MODE VOLT");
            
        end
          %% SELECT THE SOURCE, CURRENT CH2
        function set_CH2_srcI(obj)
            % Sets the channel 2 to current source we change the SCPI
            % property which controls the seleccion of the source, set 
            % [:SOURce[c]]:FUNCtion:MODE mode
            
            fprintf(obj.Visa_obj , ":SOUR2:FUNC:MODE CURR");
        end

        %% ENABLE channels CH1
        function logic = enable_CH1(obj)
            % We are enabling the source from CH1

            fprintf(obj.Visa_obj,":OUTP1 ON");
     
            logic = true;
        end

        %% DISABLE channels CH1
        function logic = disable_CH1(obj)
            % We are disabling the source from CH1

            fprintf(obj.Visa_obj,":OUTP1 OFF");
           
            logic = false;
        end

        %% ENABLE channels CH2
        function logic = enable_CH2(obj)
            % We are enabling the source from CH2

            fprintf(obj.Visa_obj,":OUTP2 ON");
                      
            logic = true;
        end

        %% DISABLE channels CH2
        function logic = disable_CH2(obj)
            % We are disabling the source from CH2

            fprintf(obj.Visa_obj,":OUTP2 OFF");
             
            logic = false;
                       
        end



        %% SET THE V(VOLTAGE) LIMITS CH1
        function limit_set = set_CH1_limitV(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            
            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf(":SENS1:VOLT:PROT %.4f", limit)); % please set the limit in volts
          
            limit_set = limit;
        end 
        
         %% SET THE I(CURRENT) LIMITS CH1
        function limit_set = set_CH1_limitI(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            
            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf(":SENS1:CURR:PROT %.4f", limit)); % please set the limit in AMPS
          
            limit_set = limit;
        end 

 

         %% SET THE V(VOLTAGE) LIMITS CH2
        function limit_set = set_CH2_limitV(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            
            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf(":SENS2:VOLT:PROT %.4f", limit)); % please set the limit in volts
          
            limit_set = limit;
        end 
        
         %% SET THE I(CURRENT) LIMITS CH2
        function limit_set = set_CH2_limitI(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            
            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf(":SENS2:CURR:PROT %.4f", limit)); % please set the limit in AMPS
          
            limit_set = limit;
        end  


        %% SET THE VOLTAGE RANGE CH1 FOR SOURCING
        function range_set = set_CH1_srcRangeV(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.


            %%% REMEMBER THE INPUT MUST BE ONE OF THE ALLOWED

            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("SOUR1:VOLT:RANG %.4f", range)); % Value in Volts, the device autorange is disabled then
                
                range_set = range;
            else
                disp("Please input allowed range \n");
            end
        end 

        %% SET THE VOLTAGE RANGE CH1 FOR SOURCING
        function range_set = set_CH1_srcRangeI(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.
            
            %%% REMEMBER THE INPUT MUST BE ONE OF THE ALLOWED

            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("SOUR1:CURR:RANG %.4f", range)); % Value in AMPS, the device autorange is disabled then
                
                range_set = range;
            else
                disp("Please input allowed range \n");
            end
        end  

        %% SET THE VOLTAGE RANGE CH2 FOR SOURCING
        function range_set = set_CH2_srcRangeV(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.


            %%% REMEMBER THE INPUT MUST BE ONE OF THE ALLOWED

            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("SOUR2:VOLT:RANG %.4f", range)); % Value in Volts, the device autorange is disabled then
                
                range_set = range;
            else
                disp("Please input allowed range \n");
            end
        end 

        %% SET THE VOLTAGE RANGE CH2 FOR SOURCING
        function range_set = set_CH2_srcRangeI(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.
   
            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("SOUR2:CURR:RANG %.4f", range)); % Value in AMPS, the device autorange is disabled then
                
                range_set = range;
            else
                disp("Please input allowed range \n");
            end
        end 




        %% ENABLE MEASUREMENTS CH1
        function logic = en_CH1_meas(obj)
            % It enables the CH1 all Measurements

            fprintf(obj.Visa_obj, ":SENS1:FUNC:ALL");

            logic = true;

        end

        %% DISABLE MEASUREMENTS CH1
        function logic = dis_CH1_meas(obj)
            % It disables the CH1 all Measurements

            fprintf(obj.Visa_obj, ":SENS1:FUNC:OFF:ALL");

            logic = false;

        end


        %% ENABLE MEASUREMENTS CH2
        function logic = en_CH2_meas(obj)
            % It enables the CH2 all Measurements

            fprintf(obj.Visa_obj, ":SENS2:FUNC:ALL");

            logic = true;

        end

        %% DISABLE MEASUREMENTS CH2
        function logic = dis_CH2_meas(obj)
            % It disables the CH2 all Measurements

            fprintf(obj.Visa_obj, ":SENS2:FUNC:OFF:ALL");

            logic = false;

        end

        %% SET THE VOLTAGE RANGE CH1 FOR MEASURING
        function range_set = set_CH1_measRangeV(obj,range)       
           % With this function we are looking foward to change, as desired, the
            % range of the measurement for voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            
            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprinf(obj.Visa_obj, sprintf(":SENS1:VOLT:RANG %.4f", range)); % Value in Volts, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 

         %% SET THE CURRENT RANGE CH1 FOR MEASURING
        function range_set = set_CH1_measRangeI(obj,range)       
           % With this function we are looking foward to change, as desired, the
            % range of the measurement for current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            
            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprinf(obj.Visa_obj, sprintf(":SENS1:CURR:RANG %.4f", range)); % Value in AMPS, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 


        %% SET THE CURRENT RANGE CH1 FOR MEASURING
        function range_set = set_CH1_measRangeR(obj,range)       
           % With this function we are looking foward to change, as desired, the
            % range of the measurement for resistance. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            
            if ~isempty(obj.findIndexInCell(obj.Range_resis,range))
                % Then we set the range in the instrument
                fprinf(obj.Visa_obj, sprintf(":SENS1:RES:RANG %.1f", range)); % Value in Ohms, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 

          %% SET THE VOLTAGE RANGE CH1 FOR MEASURING
        function range_set = set_CH2_measRangeV(obj,range)       
           % With this function we are looking foward to change, as desired, the
            % range of the measurement for voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            
            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprinf(obj.Visa_obj, sprintf(":SENS2:VOLT:RANG %.4f", range)); % Value in Volts, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 

         %% SET THE CURRENT RANGE CH1 FOR MEASURING
        function range_set = set_CH2_measRangeI(obj,range)       
           % With this function we are looking foward to change, as desired, the
            % range of the measurement for current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            
            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprinf(obj.Visa_obj, sprintf(":SENS2:CURR:RANG %.4f", range)); % Value in AMPS, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 


        %% SET THE CURRENT RANGE CH1 FOR MEASURING
        function range_set = set_CH2_measRangeR(obj,range)       
           % With this function we are looking foward to change, as desired, the
            % range of the measurement for resistance. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            
            if ~isempty(obj.findIndexInCell(obj.Range_resis,range))
                % Then we set the range in the instrument
                fprinf(obj.Visa_obj, sprintf(":SENS2:RES:RANG %.1f", range)); % Value in Ohms, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 
        

 
        %% ENABLE AUTORANGE SOURCE VOLTAGE CH1
        function logic = en_CH1_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR1:VOLT:RANG:AUTO ON");

                logic = true;
        end


        %% ENABLE AUTORANGE SOURCE CURRENT CH1
        function  logic = en_CH1_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR1:CURR:RANG:AUTO ON");

                logic = true;
        end

          %% ENABLE AUTORANGE SOURCE VOLTAGE CH2
        function logic = en_CH2_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR2:VOLT:RANG:AUTO ON");

                logic = true;
        end


        %% ENABLE AUTORANGE SOURCE CURRENT CH2
        function  logic = en_CH2_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR2:CURR:RANG:AUTO ON");

                logic = true;
        end




         %% ENABLE AUTORANGE MEASURE VOLTAGE CH1
         function  logic = en_CH1_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS1:VOLT:RANG:AUTO ON");

                logic = true;
        end


        %% ENABLE AUTORANGE MEASURE CURRENT CH1
        function  logic = en_CH1_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS1:CURR:RANG:AUTO ON");

                logic = true;
        end

        %% ENABLE AUTORANGE MEASURE VOLTAGE CH2
        function logic = en_CH2_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS2:VOLT:RANG:AUTO ON");

                logic = true;
        end


        %% ENABLE AUTORANGE MEASURE CURRENT CH2
        function  logic =  en_CH2_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS2:CURR:RANG:AUTO ON");
                
                logic = true;
        end


        %% DISABLE AUTORANGE SOURCE VOLTAGE CH1
        function logic = dis_CH1_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR1:VOLT:RANG:AUTO OFF");

                logic = false;
        end


        %% DISABLE AUTORANGE SOURCE CURRENT CH1
        function  logic = dis_CH1_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR1:CURR:RANG:AUTO OFF");

                logic = false;
        end

          %% DISABLE AUTORANGE SOURCE VOLTAGE CH2
        function logic = dis_CH2_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR2:VOLT:RANG:AUTO OFF");

                logic = false;
        end


        %% DISABLE AUTORANGE SOURCE CURRENT CH2
        function  logic = dis_CH2_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SOUR2:CURR:RANG:AUTO OFF");

                logic = false;
        end




         %% DISABLE AUTORANGE MEASURE VOLTAGE CH1
         function  logic = dis_CH1_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS1:VOLT:RANG:AUTO OFF");

                logic = false;
        end


        %% DISABLE AUTORANGE MEASURE CURRENT CH1
        function  logic = dis_CH1_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS1:CURR:RANG:AUTO OFF");

                logic = false;
        end

        %% DISABLE AUTORANGE MEASURE VOLTAGE CH2
        function logic = dis_CH2_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS2:VOLT:RANG:AUTO OFF");

                logic = false;
        end


        %% DISABLE AUTORANGE MEASURE CURRENT CH2
        function  logic =  dis_CH2_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, ":SENS2:CURR:RANG:AUTO OFF");
                
                logic = false;
        end

        %% SET THE SOURCE VOLTAGE LEVEL CH1
        function level_set = set_CH1_srcLevelV(obj,level)
            % With this function we want to set the value to source on each
            % channel. 

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf(":SOUR1:VOLT %.4f",level));

            level_set = level;
        end

        %% SET THE SOURCE CURRENT LEVEL CH1
        function level_set = set_CH1_srcLevelI(obj,level)
            % With this function we want to set the value to source in each
            % channel. 
            

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf(":SOUR1:CURR %.4f",level));

            level_set = level;
        end

        %% SET THE SOURCE VOLTAGE LEVEL CH2
        function level_set = set_CH2_srcLevelV(obj,level)
            % With this function we want to set the value to source in each
            % channel. 

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf(":SOUR2:VOLT %.4f",level));

            level_set = level;
        end

        %% SET THE SOURCE CURRENT LEVEL CH2
        function level_set = set_CH2_srcLevelI(obj,level)
            % With this function we want to set the value to source in each
            % channel. 

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf(":SOUR2:CURR %.4f",level));

            level_set = level;
        end


 
        %% GET VOLTAGE MEASUREMET CH1
        function [reading_value,units] = get_CH1_measV(obj)
            % With this function we will get the value of the 
            % available magnitudes , volt , current, resistance,
            % then we just select the channel and the magnitud
            % we want.

            fprintf(obj.Visa_obj, ":MEAS:VOLT? (@1)");
            units = "V";
         
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end
    
        %% GET CURRENT MEASUREMET CH1

        function [reading_value,units] = get_CH1_measI (obj)
            % With this function we will get the value of the
            % available magnitudes , volt , currtent, resistance 
            % then we just select the channel and the magnitud
            % we want.


            fprintf(obj.Visa_obj, ":MEAS:CURR? (@1)");
            units = "A";

            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% GET RESISTANCE MEASUREMET CH1

        function [reading_value,units] = get_CH1_measR(obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance
                % then we just select the channel and the magnitud
                % we want.

            fprintf(obj.Visa_obj, ":MEAS:RES? (@1)");
            units = "Ohms";
            
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end



        %% GET VOLTAGE MEASUREMET CH2
        function [reading_value,units] = get_CH2_measV(obj)
            % With this function we will get the value of the 
            % available magnitudes , volt , current, resistance,
            % then we just select the channel and the magnitud
            % we want.

            fprintf(obj.Visa_obj, ":MEAS:VOLT? (@2)");
            units = "V";
         
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end
    
        %% GET CURRENT MEASUREMET CH2

        function [reading_value,units] = get_CH2_measI (obj)
            % With this function we will get the value of the
            % available magnitudes , volt , currtent, resistance 
            % then we just select the channel and the magnitud
            % we want.


            fprintf(obj.Visa_obj, ":MEAS:CURR? (@2)");
            units = "A";

            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% GET RESISTANCE MEASUREMET CH2

        function [reading_value,units] = get_CH2_measR(obj)
                % With this function we will get the value of the
                % available magnitudes , volt , currtent, resistance
                % then we just select the channel and the magnitud
                % we want.

            fprintf(obj.Visa_obj, ":MEAS:RES? (@2)");
            units = "Ohms";
            
            reading_value = str2double(fscanf(obj.Visa_obj));
            
        end


        %% SET FORMAT ASCII

        function set_format_ASCII(obj)
            % With this we set the format of the data measured on one sweep
            % or the current data shown on Keysight's screen. It'll set the
            % format on these different options:

            % ---> ASCii = ASCII format, 1 byte long 
            % ---> REAL,64 = , 8 bytes long. 
            % ---> REAL,32 = , 4 bytes long.

            fprintf(obj.Visa_obj, ":FORMat:DATA ASCii");
        end


         %% SET FORMAT REAL 64

        function set_format_R64(obj)
            % With this we set the format of the data measured on one sweep
            % or the current data shown on Keysight's screen. It'll set the
            % format on these different options:

            % ---> ASCii = ASCII format, 1 byte long 
            % ---> REAL,64 = , 8 bytes long. 
            % ---> REAL,32 = , 4 bytes long.

            fprintf(obj.Visa_obj, ":FORMat:DATA REAL,64");
        end

        %% SET FORMAT REAL 32

        function set_format_R32(obj)
            % With this we set the format of the data measured on one sweep
            % or the current data shown on Keysight's screen. It'll set the
            % format on these different options:

            % ---> ASCii = ASCII format, 1 byte long 
            % ---> REAL,64 = , 8 bytes long. 
            % ---> REAL,32 = , 4 bytes long.

            fprintf(obj.Visa_obj, ":FORMat:DATA REAL,32");
        end



    end % End of the methods



    methods (Access = private)
        %% Find index

        function indices = findIndexInCell(obj,cellArray, element)
            % This function finds all indices of a given element in a cell array.
            %
            % Args:
            %   cellArray: A cell array which may contain various data types.
            %   element: The element to search for within the cell array.
            %
            % Returns:
            %   indices: An array of indices where the element is found.
        
            % Use cellfun with a custom function to compare elements
            if isnumeric(element) || islogical(element)
                % Handle numeric and logical types
                indices = find(cellfun(@(x) isequal(x, element), cellArray));
            elseif ischar(element) || isstring(element)
                % Handle strings and character arrays
                indices = find(cellfun(@(x) isequal(x, element), cellArray));
            else
                % This part can be extended to handle other specific data types or objects
                indices = find(cellfun(@(x) isequal(x, element), cellArray));
            end
        
            % Return empty if no matches are found
            if isempty(indices)
                indices = [];
            end
        end


    end % End of the private methods


end %End of the class


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%