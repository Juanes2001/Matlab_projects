classdef ESA_E4448A_class < handle
    % ESA_E4448A_class this class has the basic methods to use the PSA
    % reference E4448A, for further complex procedures needed for the
    % research field, feel free to modify the methods as you want and add
    % more if you need. Communication is done by ETHERNET TCP\IP by formatted
    % commands sent through, all this class is using its own properties.


    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % HERE ARE ALL THE METHODS DEFINED, INPUTS AND OUTPUTS AND PROPERTIES DESCRIPTION
    %   The properties are defined like this:
    %  
    % 
    % %%%%%%%%%%%%%%%%%%%%%% METHODS DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%% CONSTRUCTOR %%%
    %   
    %  
    %   
    %%%%%%%%%%%%%%%%%%%%
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
        user_name 
        password
        ip_num
        port_num
        timeout
        TPC_obj
        
        %%% Spectrum parameters
        
        
        
        
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

        %% OPERATION STATUS

        function logic = issweepDone(obj)
            
            %With this function we can know then the sweep operation is
            %terminated, just to have more control on the scripts
            fprintf(obj.TPC_obj,":STATus:OPERation?");

            byte_c = str2double(fscanf(obj.TPC_obj));
            sweepbit = byte_c & 8;

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