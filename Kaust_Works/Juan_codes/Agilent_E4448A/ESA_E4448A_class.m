classdef ESA_E4448A_class < handle
    % ESA_E4448A_class this class has the basic methods to use the PSA
    % reference E4448A, for further complex procedures needed for the
    % research field, feel free to modify the methods as you want and add
    % more if you need. Communication is done by ETHERNET TCP\IP by formatted
    % commands sent through, all this class is using its own properties.


    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    HERE ARE ALL THE METHODS DEFINED, INPUTS AND OUTPUTS AND PROPERTIES DESCRIPTION
    %   The properties are defined like this:
    %  
    %   1. user_name ---> (ONLY IN CASE OF USE) sets the username set on
    %                       the ESA
    %   2. password --->  (ONLY IN CASE OF USE) Sets the password set on
    %                       the ESA
    %   3. ip_num ----> ip number set by the Ethernet Network, you can find
    %                   it on the machine's system information.
    %   4. port_num ---> Port number, you can find
    %                   it on the machine's system information.  
    %   
    %   5. timeout ---> max time in seconds  to wait while the device is 
    %                   proccessing any command sent.
    %   6. TPC_obj ---> object tcpip class type used to communicate
    %                   properly with the ESA
    % 
    % %%%%%%%%%%%%%%%%%%%%%% METHODS DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%% CONSTRUCTOR %%%
    %   
    %   
    %   ESA_E4448A_class() 
    %
    %        %% The importance of this function is it creates the object
    %        tcpip where we can then open the communication protocol
    %        between the PC and the ESA
    %   
    %   
    %%%%%%%%%%%%%%%%%%%%%%
    % 
    %
    %%%%%% INIT METHOD %%%%%%% 
    % 
    %   init(ESA_E4448A_class obj)
    %  
    %   This method only initiates the communication by opening it and
    %   sending a identification command to be sure the communication is
    %   oppened as it needed.
    % 
    %%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%%%% DELATE METHOD %%%%
    % 
    %   This one is only responsible for delating the TCP\ip object created 
    %   to quit communication. 
    %    
    %   bool logic = deleteObj (ESA_E4448A_class obj)
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
    %   String msg_idn = iDN(ESA_E4448A_class obj)
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
    %   reset(ESA_E4448A_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%%% ABORT METHOD %%%%   
    % 
    % With this one we can abort either calculation or calibration proccess,
    % including the sweep proccess as well.
    % 
    %   abort(ESA_E4448A_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    % 
    %%%%%%%%% SET CENTER FREQUENCY METHOD %%%%%%%  
    % 
    % With this one we can ask for setting the center frequency of the
    % spectrum 
    % 
    %   set_center_freq(ESA_E4448A_class obj,double frequency)
    % 
    %   frequency ---> input it in Hz, you can fit up to 3
    %   decimals if it is needed.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%
    % 
    %%%%%%%%% GET CENTER FREQUENCY METHOD %%%%%%% 
    % 
    % With this function we can query for the center frequency set on the
    % OSA
    %       double cen = get_cen_freq (ESA_E4448A_class obj)
    %   
    %       cen ---> output, double value of the center frequency
    %
    %%%%%%%%%%%%%%%%%%%%%%% 
    % 
    % 
    %%%%%%%% SET SPAN METHOD %%%%%%%%%   
    % 
    % With this one we can ask for change the span which is the distance
    % between the start and stop wavelength.
    % 
    %   set_span (ESA_E4448A_class obj,double span_freq)
    % 
    %   span ---> input it in Hz, you can fit up to 3
    %   decimals if it is needed
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% GET SPAN METHOD %%%%%%% 
    % 
    % With this function we can query for the span set on the
    % ESA
    %       double span = get_span (ESA_E4448A_class obj)
    %   
    %       span ---> output, double value of the span
    %
    %%%%%%%%%%%%%%%%%%%%%%% 
    % 
    % 
    %%%%%%%%% SET START FREQUENCY METHOD %%%%%%%   
    % 
    % With this one we can ask to change the start frequency the spectrum 
    % will begin
    % 
    %  double start = set_start_freq (ESA_E4448A_class obj,double sta_frequency)
    % 
    %   sta_frequency ---> input it in Hz, you can fit up to 3
    %   decimals if it is needed
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%%% GET START FREQUENCY METHOD %%%%%%% 
    % 
    % With this function we can query for the start frequency set on the
    % ESA
    %       double start = get_start_freq (ESA_E4448A_class obj)
    %   
    %       start ---> output, double value of the start frequency
    %
    %%%%%%%%%%%%%%%%%%%%%%%  
    % 
    % 
    %%%%%%%%% SET STOP FREQUENCY METHOD %%%%%%%   
    % 
    % With this one we can ask to change the stop frequency the spectrum 
    % will end
    % 
    %  double stop = set_stop_freq (ESA_E4448A_class obj,double sto_frequency)
    % 
    %   sto_frequency ---> input it in Hz, you can fit up to 3
    %   decimals if it is needed 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%%%% GET STOP FREQUENCY METHOD %%%%%%% 
    % 
    % With this function we can query for the stop frequency set on the
    % ESA
    %       double stop = get_stop_freq (ESA_E4448A_class obj)
    %   
    %       stop ---> output, double value of the stop frequency
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %
    %  
    %%%%%%%%% SET RESOLUTION METHOD %%%%%%%   
    % 
    % With this one we can ask to change the resolution of the sweep
    % 
    %  double res = set_res(ESA_E4448A_class obj,double resolution)
    % 
    %  resolution ---> input it in Hz, you can fit up to 3
    %   decimals if it is needed  
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    % 
    %%%%%%%%%%%% GET RESOLUTION METHOD %%%%%%% 
    % 
    % With this function we can query for the resolution set on the
    % ESA
    %       double res = get_res(ESA_E4448A_class obj)
    %   
    %       res ---> output, double value of the resolution
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    % 
    %%%%%%%%% SET SAMPLE POINTS METHOD %%%%%%%   
    % 
    % With this one we can ask to change the number of sample points to use
    % on the sweep.
    % 
    %  set_num_points (ESA_E4448A_class obj,int num_points)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    % 
    %%%%%%%%%%% GET NUMBER OF POINTS METHOD %%%%%%% 
    % 
    % With this function we can query the number of points set on the
    % ESA
    %       int num_points =   get_num_points(ESA_E4448A_class obj)
    %   
    %       num_points ---> output, integer value of the number of points.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %
    %%%%%%%%% SETTERS OF SWEEP MODES METHODS %%%%%%%   
    % 
    % With this one we can ask to change the SWEEP modes available
    % 
    %    String sw_mode = set_sweep_X(ESA_E4448A_class obj)
    % 
    %   X ----> single / auto 
    % 
    %   sx_mode --> As an output it will return the mode either "single" or "auto"  sweep. 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % 
    % 
    %%%%%%%%% INITIATE SWEEP METHOD %%%%%%%   
    % 
    % With this one we can ask to start sweep.
    % 
    %   do_sweep(ESA_E4448A_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%  IS THE SWEEP DONE? %%%%%%%%%%
    % 
    %   This method ask if the sweep currently doing is done   
    % 
    % boolean  logic = issweepDone(ESA_E4448A_class obj)
    % 
    %   It returns true if the sweep is done or false if it is not
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%%%%  SETTERS OF FORMAT %%%%%%%%%
    % 
    %   This method ask to set the format for the data desired   
    % 
    %   set_format_X(ESA_E4448A_class obj)
    % 
    %   X---> ASCII / R64 /R32
    % 
    %   ASCII will set into ascii if numeric format is desired. (This one is desired for now)
    %   R64 will set into REAL,64 8 bytes long decimal format, read the book for more deltail.
    %   R32 will set into REAL,32 4 bytes long decimal format, read the book for more deltail.
    %
    %      By reseting the ESA, the defoult format will be ASCII. 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%% GET TRACE DATA Y %%%%%%%%%%
    % 
    %   This method ask for the Y-axis data from a sweep on some specific trace
    % 
    %   Available trace letters ---> (A,B,C,D,E,F,G) 
    % 
    %   double[] values_ampl = get_TR_Ampl (ESA_E4448A_class obj,int trace_num)
    % 
    %   It returns an array of values from the X axis from start wavelength
    %   to stop wavelength.
    % 
    %    trace_num---> The trace number implies the number of the trace we
    %    desire to catch the data. Could be 1/2/3.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        %%% Properties for communication protocol used GPIB
        user_name 
        password
        ip_num
        port_num
        timeout
        TPC_obj
        
        
    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = ESA_E4448A_class(ip_number,port_number)
            % ESA_E4448A_class  constructor, just set the principal and
            %important parameters to set due correct communication.
                
            obj.user_name   = user;
            obj.password    = password;
            obj.ip_num      = ip_number;
            obj.port_num    = port_number;
            obj.timeout     = 10;
            




            %%% We start initiating the Ethernet communication

            instr  = instrfind; % We have to be sure we close every single opened intrument
            if ~isempty(instr)
                fclose(instr);
                delete(instr);
            end

            % Create a TCP/IP object 't' associated with the OSA
            obj.TPC_obj = tcpip(obj.ip_num, obj.port_num, 'NetworkRole', 'client');
            obj.TPC_obj.Timeout =  obj.timeout;
            

        end % End function

        %End constructor function
        

        %% INIT COMMUNICATION

        function init(obj)
            % Using this function you open communication wiith the OSA
            % Open the connection to the OSA
            try
                fopen(obj.TPC_obj);
                pause(1);
                disp("Connection successful\n");
            catch e
                disp('Failed to connect to the ESA:');
                disp(e.message);
            end

            % Check if the connection is open
            if strcmp(obj.TPC_obj.Status, 'open')
            
                fprintf(obj.TPC_obj, "open ""anonymous""");
                idnResponse = fscanf(obj.TPC_obj);
                disp(idnResponse);
            
                % Send a command to the ESA
                fprintf(obj.TPC_obj, ' '); % Query the instrument identity
            
                % Read the response from the ESA
                idnResponse = fscanf(obj.TPC_obj);
                disp('Response from OSA:');
                disp(idnResponse);
            end
            
        end






         %% SHUT DOWN COMMUNICATON

        function logic = deleteObj(obj)
            % Close and delete the GPIB object
            fclose(obj.TPC_obj);
            pause(1);
            logic = true;
            delete(obj.TPC_obj);
            clear obj.TPC_obj;
        end

         %% Identification

         function msg_idn = iDN(obj)
            % Send a messege of identification
            fprintf(obj.TPC_obj , '*IDN?'); % We sent the command, then it will send us
                                             % back the response

            msg_idn = fscanf(obj.TPC_obj);  % We try to read the port anr return the identificator
         end 

        %% RESET
        function reset(obj)
            % Reset the system
            fprintf(obj.TPC_obj ,'*RST');
        end

        %% ABORT MEASUREMENTS
        function abort(obj)
            % With this function you can abort some measurements ongoing
            % for any reason needed.
            fprintf(obj.TPC_obj ,':ABORT');
        end





     %% SET CENTER FREQUENCY

     function set_center_freq (obj, frequency)
                % This function helps to set the center frequency, also to
                % have centered properly the spectrum analized.
                
                %%% With the communication opened, we just send the
                %%% command
                %%% which sets the center frequency desired.
                fprintf(obj.TPC_obj, sprintf(":SENSe:FREQuency:CENTer %.3fHZ", frequency));  
        end


    %% GET CENTER FREQ
    function cen =   get_cen_freq (obj)
            % This function returns the current center frequency.

            fprintf(obj.TPC_obj, ":SENSe:FREQuency:CENTer?");

            cen = str2double(fscanf(obj.TPC_obj));
        
    end
       
        %% SET SPAN

        function set_span (obj, span_freq)
                % This function helps to set the span frequency length, which is the,
                % between the start and stop frequency from the center 
                % frequency.
                
                %%% With the communication opened, we just send the command
                %%% which sets the span desired.
                fprintf(obj.TPC_obj, sprintf(":SENSe:FREQuency:SPAN %.3fHZ", span_freq));

              
        end

        %% GET SPAN 
        function span =   get_span(obj)
            % This function returns the current span.

            fprintf(obj.TPC_obj, ":SENSe:FREQuency:SPAN?");

            span = str2double(fscanf(obj.TPC_obj));
        
        end

        %% SET START FREQUENCY

        function set_start_lam (obj, sta_frequency)
                % This function helps to set the start frequency, this to
                % control where the spectum will start.
                
                %%% With the communication opened, we just send the command
                %%% which sets the start frequency desired.
                fprintf(obj.TPC_obj, sprintf(":SENSe:FREQuency:STARt %.3fHZ", sta_frequency));
        end

        %% GET START FREQ
        function start =   get_start_freq(obj)
            % This function returns the current start frequency.

            fprintf(obj.TPC_obj, ":SENSe:FREQuency:STARt?");

            start = str2double(fscanf(obj.TPC_obj));
        
        end

         %% SET STOP FREQUENCY

        function set_stop_freq (obj, sto_frequency)
                % This function helps to set the stop frequency, this to
                % control where the spectum will stop.

                %%% With the communication opened, we just send the command
                %%% which sets the stop frequency desired.
                fprintf(obj.TPC_obj, sprintf(":SENSe:FREQuency:STOp %.3fHZ", sto_frequency));   
        end

        %% GET STOP FREQ
        function stop =   get_stop_freq(obj)
            % This function returns the current stop frequency.

            fprintf(obj.TPC_obj, ":SENSe:FREQuency:STOp?");

            stop = str2double(fscanf(obj.TPC_obj));
        
        end


        %% SET THE RESOLUTION

        function  set_res (obj, resolution)
                % This function helps too set the resolution wanted, it
                % means, the minimum step between frequencies  

                %%% With the communication opened, we just send the command
                %%% which sets the resolution
                fprintf(obj.TPC_obj, sprintf(":SENSe:BANDwidth:RESolution %.3fHZ",resolution));   
        end


        %% GET RESOLUTION
        function res =   get_res_freq(obj)
            % This function returns the current resolution.

            fprintf(obj.TPC_obj, ":SENSe:BANDwidth:RESolution?");

            res = str2double(fscanf(obj.TPC_obj));
        
        end


        %% SET THE NUMBER OF POINTS

        function set_num_points (obj, num_points)
                % This function helps too set the number of points the instrument
                %will measure for make the trace

                %%% With the communication opened, we just send the
                %%% command where we ask for the number of points desired
                fprintf(obj.TPC_obj, sprintf(":SENSE:SWEEP:POINTS %u",num_points));
        end

        %% GET NUMBER OF POINTS
        function num_points =   get_num_points(obj)
            % This function returns the current resolution.

            fprintf(obj.TPC_obj, ":SENSE:SWEEP:POINTS?");

            num_points = str2double(fscanf(obj.TPC_obj));
        
        end
        

        %% SET THE SWEEP MODE SINGLE

        function sw_mode = set_sweep_single(obj)
                % This function helps to set the sweep mode in SINGLE.

                %%% With the communication opened, we just send the command
                %%% which sets off the continuous sweep, in that case we
                %%% are in single mode sweep.
                fprintf(obj.TPC_obj,":INITiate:CONTinuous OFF");

                sw_mode = "single";
        end


        %% SET THE SWEEP MODE AUTO

        function sw_mode = set_sweep_auto(obj)
                % This function helps to set the sweep mode in AUTO.

                %%% With the communication opened, we just send the command
                %%% which sets on the continuous sweep, in that case we
                %%% are in auto mode sweep. Then it perform an automatic 
                %%% repetidely sweep.
                fprintf(obj.TPC_obj,":INITiate:CONTinuous ON");

                sw_mode = "auto"; 
        end
       
        %% DO A SWEEP

        function do_sweep(obj)
                % With this function we initiate the sweep
                fprintf(obj.TPC_obj, ":INITIATE");
        end

        
        %% SET FORMAT ASCII

        function set_format_ASCII(obj)
            % With this we set the format of the data measured on one sweep
            % or the current data shown on OSA's screen. It'll set the
            % format on these different options:

            % ---> ASCii = ASCII format, 1 byte long 
            % ---> REAL,64 = , 8 bytes long. 
            % ---> REAL,32 = , 4 bytes long.

            fprintf(obj.TPC_obj, ":FORMat:DATA ASCii");
        end

        %% SET FORMAT REAL 64

        function set_format_R64(obj)
            % With this we set the format of the data measured on one sweep
            % or the current data shown on OSA's screen. It'll set the
            % format on these different options:

            % ---> ASCii = ASCII format, 1 byte long 
            % ---> REAL,64 = , 8 bytes long. 
            % ---> REAL,32 = , 4 bytes long.

            fprintf(obj.TPC_obj, ":FORMat:DATA REAL,64");
        end

        %% SET FORMAT REAL 32

        function set_format_R32(obj)
            % With this we set the format of the data measured on one sweep
            % or the current data shown on OSA's screen. It'll set the
            % format on these different options:

            % ---> ASCii = ASCII format, 1 byte long 
            % ---> REAL,64 = , 8 bytes long. 
            % ---> REAL,32 = , 4 bytes long.

            fprintf(obj.TPC_obj, ":FORMat:DATA REAL,32");
        end



        %% GET TRACE VALUES Y

        function values_ampl = get_TR_Ampl (obj,trace_num)
            % This function ask for the Y amplitudes list from the start
            % frequency to the stop frequency.
            
            fprintf(obj.TPC_obj, sprintf(":TRACE:DATA? TRACE%u", trace_num));

            Y_values = fscanf(obj.TPC_obj);

            % Split the string at each comma
            parts = split(Y_values, ',');

            frpintf("Amplitude values taken from Trace %u \n",trace_num);
            
            % Convert the split strings to an array of doubles
            values_ampl = str2double(parts);
        end


        %% OPERATION STATUS

        function logic = issweepDone(obj)
            
            %With this function we can know then the sweep operation is
            %terminated, just to have more control on the scripts
            fprintf(obj.TPC_obj,":STATus:OPERation?");

            byte_c = str2double(fscanf(obj.TPC_obj));
            sweepbit = byte_c & 8; % bit 3 is status sweep operation, the mask is 8 

            if ~sweepbit
                logic = true;
            else
                logic = false;
            end    
        end

         %% CLEAR STATUS

        function clear_status(obj)
            
            %With this function we can clear any queue status
            fprintf(obj.TPC_obj,"*CLS");
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