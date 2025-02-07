classdef A6380_class < handle
    % A6380_class this class has the basic methods to use the OSA 
    % reference A6380, for further complex procedures needed for the
    % research field, feel free to modify the methods as you want and add
    % more if needed. Communication is done by ETHERNET TCP\IP by formatted
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
        
        center
        span
        start   
        stop
        peak_wave
        resolution
        sensitivity
        sam_points
        sweep_type

        

    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = A6380_class(user,password)
            % A6380_class  constructor, just set the principal and
            %important parameters to set due correct communication.
                
            obj.user_name   = user;
            obj.password    = password;
            obj.ip_num      = '10.72.171.64';
            obj.port_num    = 10001;
            obj.timeout     = 10;


                       %%% Spectrum parameters

            obj.center      = 0;
            obj.span        = 0;
            obj.start       = 0;
            obj.stop        = 0;
            obj.peak_wave   = 0;
            obj.resolution  = 0;
            obj.sensitivity = 0;
            obj.sam_points  = 0;
            obj.sweep_type  = '';


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

        %end constructor function


         %% REFREST TESTING PARAMETERS 
        %Here will be shown all the refreshing functions which work to
        %mantain all the info on the properties and not as an input of the
        %methods written, only for simplicity, so dont expect to use this
        %functions some time, they are secondary meant to use in the
        %principal methods.

        function obj = refresh_center(obj,new_center)
            %%% Thiss function wants to refresh the center value set on the
            %%% OSA.


        
        end% End function


        %% INIT COMMUNICATION

        function init(obj)
            % Using this function you open communication wiith the OSA
            % Open the connection to the OSA
            try
                fopen(obj.TPC_obj);
                pause(1);
                disp("Connection successful\n");
            catch e
                disp('Failed to connect to the OSA:');
                disp(e.message);
            end

            % Check if the connection is open
            if strcmp(obj.TPC_obj.Status, 'open')
            
                fprintf(obj.TPC_obj, "open ""anonymous""");
                idnResponse = fscanf(obj.TPC_obj);
                disp(idnResponse);
            
                % Send a command to the OSA
                fprintf(obj.TPC_obj, ' '); % Query the instrument identity
            
                % Read the response from the OSA
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


        %% SET CENTER WAVELENGHT

        function obj = set_center_lam (obj, wavelenght)
                % This function helps to set the center wavelenght, also to
                % have centered properly the spectrum analized
                
                %%% With the communication opened, we just send the command
                %%% which sets the center wavelenght desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:CENTER %.3fNM", wavelenght));
        end

       
        %% SET SPAN WAVELENGHT

        function obj = set_span (obj, span_lenght)
                % This function helps to set the span lenght, which is the,
                % between the start and stop wavelenght from the center 
                % waveleght.
                
                %%% With the communication opened, we just send the command
                %%% which sets the span desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:SPAN %.3fNM", span_lenght));
        end

        %% SET START WAVELENGHT

        function obj = set_start_lam (obj, sta_wavelenght)
                % This function helps to set the start wavelenght, this to
                % control where the spectum will start.
                
                %%% With the communication opened, we just send the command
                %%% which sets the start wavelenght desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:START %.3fNM", sta_wavelenght));
        end

         %% SET STOP WAVELENGHT

        function obj = set_stop_lam (obj, sto_wavelenght)
                % This function helps to set the stop wavelenght, this to
                % control where the spectum will stop.

                %%% With the communication opened, we just send the command
                %%% which sets the stop wavelenght desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:STOP %.3fNM", sto_wavelenght));
        end



         %% CALCULATE PEAK POWER WAVELENGHT

        function peak_lam = calc_peak (obj)
                % This function helps to calculate the peak power
                % wavelenght 

                %%% With the communication opened, we just send the command
                %%% which sets the stop wavelenght desired.
                fprintf(obj.TPC_obj, ":CALCULATE:MARKER:MAXiMUM:PEAK?");
                
                % We read the value of the wavelenght peak power
                peak_lam = fscanf(obj.TPC_obj);

        end


        %% CALCULATE PEAK POWER WAVELENGHT and set center

        function peak_lam_set = setcalc_peak (obj)
                % This function helps to calculate the peak power
                % wavelenght and at the same time set the red peak power as
                % the center weavelenght

                %%% With the communication opened, we just send the command
                %%% which sets the stop wavelenght desired.
                fprintf(obj.TPC_obj, ":CALCULATE:MARKER:MAXiMUM:PEAK?");
                
                % We read the value of the wavelenght peak power
                peak_lam_set = fscanf(obj.TPC_obj);
                
                %We set the red peak wavelenght as the center wavelenght
                set_center_lam(peak_lam_set);

        end

    end % End of the methods


end %End of the class


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%