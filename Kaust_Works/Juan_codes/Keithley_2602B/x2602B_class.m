classdef x2602B_class < handle
    % x2602B_class this class has the basic methods to use the Keithley 
    % reference 2602B, for further complex procedures needed on the
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
    %   x2602B_class( String vendor,
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
    %   init(x2602B_class obj)
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
    %   bool logic = deleteObj (x2602B_class obj)
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
    %   String msg_idn = iDN(x2602B_class obj)
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
    %   reset(x2602B_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%% SOURCES SETTERS METHODS %%%%   
    %   This functions sets the type of source will be selected
    % 
    %   set_CHX_srcY(x2602B_class obj)
    % 
    %   X---> A (Channel A) / B (Channel B)
    %   Y---> V (voltage) / I (Current)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%% ENABLES/DISABLES CHANNELS METHODS %%%%  
    % 
    % This functions enables or diables the channels
    %    
    %   bool logic = X_CHY(x2602B_class obj)
    % 
    %   X ---> enable/disable
    %   Y ---> A (Channel A)/B (Channel B)
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
    %   double limit_set = set_CHX_limitY(x2602B_class obj ,double limit)
    % 
    %   X---> A (Channel A) / B (Channel B) 
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
    %       IMPORTANT, IN PROPERTIES ARE THE TABLES WHICH INCLUDE THE 
    %       ALLOWED VALUES OF RANGE FOR SOURCE AND MEASUREMENTS. BE AWARE
    %       TO CHANGE THE RANGE EACH TIME YOU ARE MEASURING OUT OF RANGE, JUST TO
    %       KEEP ALWAYS THE BEST RESOLUTION AND AVOID AUTORANGE TIMELOAD.
    % 
    %   double range_set = set_CHX_YRangeZ(x2602B_class obj,double range)  
    % 
    %   X---> A (Channel A) / B (Channel B) 
    %   Y---> src (source) / meas (measure)
    %   Z---> V (voltage) / I (Current)
    % 
    % 
    %   The output is a double which says the range set.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%% AUTORANGE SETTERS METHODS %%%%  
    % 
    % 
    % With these methods we can enable the autorange mode for either source
    % or measurement mode, so we dont need anymore the RANGE setters
    % methods
    % 
    %       bool logic = set_CHX_YAutoZ(x2602B_class obj)
    % 
    %   X---> A (Channel A) / B (Channel B) 
    %   Y---> src (source) / meas (measure)
    %   Z---> V (voltage) / I (Current)
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
    %     double level_set = set_CHX_srcLevelZ(x2602B_class obj,double level)
    % 
    %    X---> A (Channel A) / B (Channel B) 
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
    %       [double reading_value,string units] = get_CHX_measY(x2602B_class obj)
    % 
    %       X---> A (Channel A) / B (Channel B) 
    %       Y---> V (Voltage) / I (Current) / R (Resistance) / P (Power)
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
        InputBufferSize     %% Data to be received
        OutputBufferSize    %% Data to be sent
        Timeout             %% Waiting time while a command is proccesed
        Vendor              %% Vendor from where is the visa drivers
        GPIB_address        %% Address of the GPIB com
        Interface_index     %% Number of devices communicating

        Visa_obj            %% Visa object used to open and close communication


        Range_voltage = {0.1   , "100mV"   ,...
                         1     , "1V"      ,...
                         6     , "6V"      ,...     %%% TABLE 1
                         40    , "40V"    }

       

        Range_current = {100E-9   , "100nA"  , ...
                         1E-6     , "1uA"    , ...
                         10E-6    , "10uA"   , ...
                         100E-6   , "100uA"  , ...  %%% TABLE 2
                         1E-3     , "1mA"    , ...
                         10E-3    , "10mA"   , ...
                         100E-3   , "100mA"  , ...
                         1        , "1A"     , ...
                         3        , "3A"     }
                    
    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = x2602B_class(vend , ...
                                    aDDr , ...
                                    interIndex)
            %x2602B_class  constructor, just set the principal and
            %important parameters to set due correct communication.

            obj.InputBufferSize     = 100000;     
            obj.OutputBufferSize    = 100000;    
            obj.Timeout             = 10;         
            obj.Vendor              = vend;       
            obj.GPIB_address        = aDDr;       
            obj.Interface_index     = interIndex; 


            instr = instrfind; % We have to be sure we close every single opened intrument
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
            
            
        end % End function

        %end constructor function


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

        %% SELECT THE SOURCE, VOLTAGE CHA
        function set_CHA_srcV(obj)
            % Sets the channel A to voltage source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj ,"smua.source.func = smua.OUTPUT_DCVOLTS");
            
        end
          %% SELECT THE SOURCE, CURRENT CHA
        function set_CHA_srcI(obj)
            % To set the channel A to current source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj , "smua.source.func = smua.OUTPUT_DCAMPS");
        end


        %% SELECT THE SOURCE, VOLTAGE CHB
        function set_CHB_srcV(obj)
            % To set the channel B to voltage source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj ,"smub.source.func = smub.OUTPUT_DCVOLTS");

        end


          %% SELECT THE SOURCE, CURRENT CHA
        function set_CHB_srcI(obj)
            % To set the channel B to current source we change the TSP
            % property which controls the seleccion of the source, set on
            % the property smuX.OUTPUT_DVOLTS/AMPS
            
            fprintf(obj.Visa_obj , "smub.source.func = smub.OUTPUT_DCAMPS");

        end

        %% ENABLE channels CHA
        function logic = enable_CHA(obj)
            % We are enabling the source from CHA

            fprintf(obj.Visa_obj,"smua.source.output = smua.OUTPUT_ON");
     
            logic = true;
        end

        %% DISABLE channels CHA
        function logic = disable_CHA(obj)
            % We are disabling the source from CHA

            fprintf(obj.Visa_obj,"smua.source.output = smua.OUTPUT_OFF");
           
            logic = false;
        end

        %% ENABLE channels CHB
        function logic = enable_CHB(obj)
            % We are enabling the source from CHB

            fprintf(obj.Visa_obj,"smub.source.output = smub.OUTPUT_ON");
                      
            logic = true;
        end

        %% DISABLE channels CHB
        function logic = disable_CHB(obj)
            % We are disabling the source from CHB

            fprintf(obj.Visa_obj,"smub.source.output = smub.OUTPUT_OFF");
             
            logic = false;
                       
        end



        %% SET THE V(VOLTAGE) LIMITS CHA
        function limit_set = set_CHA_limitV(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            
            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smua.source.limitv = %.4f", limit)); % please set the limit in volts
          
            limit_set = limit;
        end 
        
         %% SET THE I(CURRENT) LIMITS CHA
        function limit_set = set_CHA_limitI(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smua.source.limiti = %.4f", limit)); % please set the limit in volts
              
            limit_set = limit;
        end 


         %% SET THE P(POWER) LIMITS CHA
        function limit_set = set_CHA_limitP(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            % we send the command to refresh the new
            % limit onto the device. 
            fprintf(obj.Visa_obj, sprintf("smua.source.limitp = %.4f", limit)); % please set the limit in volts
              
            limit_set = limit;
        end 

         %% SET THE V(VOLTAGE) LIMITS CHB
        function limit_set = set_CHB_limitV(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smub.source.limitv = %.4f", limit)); % please set the limit in volts
                 
            limit_set = limit;
        end 
        
         %% SET THE I(CURRENT) LIMITS CHB
        function limit_set = set_CHB_limitI(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.
            
            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smub.source.limiti = %.4f", limit)); % please set the limit in volts
              
            limit_set = limit;
        end 


         %% SET THE P(POWER) LIMITS CHB
        function limit_set = set_CHB_limitP(obj ,limit)

            % With this function we set the limits for the source when it
            % is enable, be sure to set a maximum power limit.

            
            % we send the command to refresh the new
            % limit into the device. 
            fprintf(obj.Visa_obj, sprintf("smub.source.limitp = %.4f", limit)); % please set the limit in volts
              
            limit_set = limit;
        end 



        %% SET THE VOLTAGE RANGE CHA FOR SOURCING
        function range_set = set_CHA_srcRangeV(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smua.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
                
                range_set = range;

            else

                disp("Please input allowed range \n");
            
            end

        end 

        %% SET THE CURRENT RANGE CHA FOR SOURCING
        function range_set = set_CHA_srcRangeI(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for Current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smua.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
                
                range_set = range;
            else
                disp("Please input allowed range \n");
            end
        end 

          %% SET THE VOLTAGE RANGE CHB FOR SOURCING
        function range_set = set_CHB_srcRangeV(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for Voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smub.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
                
                range_set = range;
            else
                disp("Please input allowed range \n");
            end
        end 

        %% SET THE CURRENT RANGE CHB FOR SOURCING
        function range_set =  set_CHB_srcRangeI(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the source for current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smub.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 



        %% SET THE VOLTAGE RANGE CHA FOR MEASURING
        function range_set = set_CHA_measRangeV(obj,range)       
           % With this function we are looking foward to change, as desired, the
            % range of the measurement for voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smua.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end    
        end 

        %% SET THE CURRENT RANGE CHA FOR MEASURING
        function range_set = set_CHA_measRangeI(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the measurement for current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smua.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
    
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 

          %% SET THE VOLTAGE RANGE CHB FOR MEASURING
        function range_set = set_CHB_measRangeV(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the measurement for Voltage. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_voltage,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smub.source.rangev = %.4f", range)); % Value in Volts, the device autorange then
                
                range_set = range;

            else
                disp("Please input allowed range \n");
            end
        end 

        %% SET THE VOLTAGE RANGE CHB FOR MEASURING
        function range_set = set_CHB_measRangeI(obj,range)       
            % With this function we are looking foward to change, as desired, the
            % range of the measurement for current. This number would represent 
            % the bounderies maximum and minimum (meaning that the source 
            % can reach the limit negatively). All the 
            % matter with the range is for accuracy only, to
            % keep the device properly safe we manage the limits.

            %%% REMEMBER, THE RANGE INPUT HAS TO BE ONE OF THE AVAILABLE IN
            %%% TABLE. SEE TABLE 1 AND 2

            if ~isempty(obj.findIndexInCell(obj.Range_current,range))
                % Then we set the range in the instrument
                fprintf(obj.Visa_obj, sprintf("smub.source.rangei = %.4f", range)); % Value in Amps, the device autorange then
                
                range_set = range;
            else
                disp("Please input allowed range \n");
            end
        end 
        

 
        %% ENABLE AUTORANGE SOURCE VOLTAGE CHA
        function logic = en_CHA_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangev = smua.AUTORANGE_ON");

                logic = true;
        end


        %% ENABLE AUTORANGE SOURCE CURRENT CHA
        function  logic = en_CHA_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangei = smua.AUTORANGE_ON");

                logic = true;
        end

         %% ENABLE AUTORANGE SOURCE VOLTAGE CHB
         function logic = en_CHB_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangev = smub.AUTORANGE_ON");
                
                logic = true;
        end


        %% ENABLE AUTORANGE SOURCE CURRENT CHB
        function  logic = en_CHB_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangei = smub.AUTORANGE_ON");

                logic = true;
        end




         %% ENABLE AUTORANGE MEASURE VOLTAGE CHA
         function  logic = en_CHA_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangev = smua.AUTORANGE_ON");

                logic = true;
        end


        %% ENABLE AUTORANGE MEASURE CURRENT CHA
        function  logic = en_CHA_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangei = smua.AUTORANGE_ON");

                logic = true;
        end

        %% ENABLE AUTORANGE MEASURE VOLTAGE CHB
        function logic = en_CHB_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangev = smub.AUTORANGE_ON");

                logic = true;
        end


        %% ENABLE AUTORANGE MEASURE CURRENT CHB
        function  logic =  en_CHB_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangei = smub.AUTORANGE_ON");
                
                logic = true;
        end


        %% DISABLE AUTORANGE SOURCE VOLTAGE CHA
        function logic = dis_CHA_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangev = smua.AUTORANGE_OFF");

                logic = false;
        end


        %% DISABLE AUTORANGE SOURCE CURRENT CHA
        function  logic = dis_CHA_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangei = smua.AUTORANGE_OFF");

                logic = false;
        end

         %% DISABLE AUTORANGE SOURCE VOLTAGE CHB
         function logic = dis_CHB_srcAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangev = smub.AUTORANGE_OFF");
                
                logic = false;
        end


        %% DISABLE AUTORANGE SOURCE CURRENT CHB
        function  logic = dis_CHB_srcAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangei = smub.AUTORANGE_OFF");

                logic = false;
        end




         %% DISABLE AUTORANGE MEASURE VOLTAGE CHA
         function  logic = dis_CHA_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangev = smua.AUTORANGE_OFF");

                logic = false;
        end


        %% DISABLE AUTORANGE MEASURE CURRENT CHA
        function  logic = dis_CHA_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smua.source.autorangei = smua.AUTORANGE_OFF");

                logic = false;
        end

        %% DISABLE AUTORANGE MEASURE VOLTAGE CHB
        function logic = dis_CHB_measAutoV(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangev = smub.AUTORANGE_OFF");

                logic = false;
        end


        %% DISABLE AUTORANGE MEASURE CURRENT CHB
        function  logic =  dis_CHB_measAutoI(obj)
                % With this function we can set the state of autorange
                % depending on the channel, the source or measurement mode
                % and depending if it is voltage and current range

                % Then we update the autorange mode in the device as wanted
      
                fprintf(obj.Visa_obj, "smub.source.autorangei = smub.AUTORANGE_OFF");
                
                logic = false;
        end


        

        %% SET THE SOURCE VOLTAGE LEVEL CHA
        function level_set = set_CHA_srcLevelV(obj,level)
            % With this function we want to set the value to source on each
            % channel. 

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smua.source.levelv = %.4f",level));

            level_set = level;
        end

        %% SET THE SOURCE CURRENT LEVEL CHA
        function level_set = set_CHA_srcLevelI(obj,level)
            % With this function we want to set the value to source in each
            % channel. 
            

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smua.source.leveli = %.4f",level));

            level_set = level;
        end

        %% SET THE SOURCE VOLTAGE LEVEL CHB
        function level_set = set_CHB_srcLevelV(obj,level)
            % With this function we want to set the value to source in each
            % channel. 

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smub.source.levelv = %.4f",level));

            level_set = level;
        end

        %% SET THE SOURCE CURRENT LEVEL CHB
        function level_set = set_CHB_srcLevelI(obj,level)
            % With this function we want to set the value to source in each
            % channel. 

            % Then we have to set the value on the device, 
            fprintf(obj.Visa_obj, sprintf("smub.source.leveli = %.4f",level));

            level_set = level;
        end


 
        %% GET VOLTAGE MEASUREMET CHA
        function [reading_value,units] = get_CHA_measV(obj)
            % With this function we will get the value of the 
            % available magnitudes , volt , current, resistance, and
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


     methods (Access = private)
        %% Find index

        function indices = findIndexInCell(~,cellArray, element)
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