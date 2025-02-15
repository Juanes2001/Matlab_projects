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
    %   1. user_name ---> (ONLY IN CASE OF USE) sets the username set on
    %                       the OSA
    %   2. password --->  (ONLY IN CASE OF USE) Sets the password set on
    %                       the OSA
    %   3. ip_num ----> ip number set by the Ethernet Network, you can find
    %                   it on the machine's system information.
    %   4. port_num ---> Port number, you can find
    %                   it on the machine's system information.  
    %   
    %   5. timeout ---> max time in seconds  to wait while the device is 
    %                   proccessing any command sent.
    %   6. TPC_obj ---> object tcpip class type used to communicate
    %                   properly with the OSA
    % 
    % %%%%%%%%%%%%%%%%%%%%%% METHODS DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%% CONSTRUCTOR %%%
    %   
    %   
    %   A6380_class() 
    %
    %        %% The importance of this function is it creates the object
    %        tcpip where we can then open the communication protocol
    %        between the PC and the OSA
    %   
    %   
    %%%%%%%%%%%%%%%%%%%%%%
    % 
    %
    %%%%%% INIT METHOD %%%%%%% 
    % 
    %   init(A6380_class obj)
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
    %   bool logic = deleteObj (A6380_class obj)
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
    %   String msg_idn = iDN(A6380_class obj)
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
    %   reset(A6380_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%%% ABORT METHOD %%%%   
    % 
    % With this one we can abort either calculation or calibration proccess,
    % including the sweep proccess as well.
    % 
    %   abort(A6380_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%   
    % 
    % 
    %%%%%%%%% SET CENTER WAVELENGTH METHOD %%%%%%%  
    % 
    % With this one we can ask for setting the center wavelength of the
    % spectrum 
    % 
    %  double cen  = set_center_lam (A6380_class obj,double wavelength)
    % 
    %   wavelength ---> input it in nanometers, you can fit up to 3
    %   decimals if it is needed
    % 
    %%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %
    %%%%%%%% SET SPAN METHOD %%%%%%%%%   
    % 
    % With this one we can ask for change the span which is the distance
    % between the start and stop wavelength.
    % 
    %  double spa = set_span (A6380_class obj,double span_length)
    % 
    %   span_length ---> input it in nanometers, you can fit up to 3
    %   decimals if it is needed
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    % 
    %%%%%%%%% SET START WAVELENGTH METHOD %%%%%%%   
    % 
    % With this one we can ask to change the start wavelength the spectrum 
    % will begin
    % 
    %  double start = set_start_lam (A6380_class obj,double sta_wavelength)
    % 
    %   sta_wavelengTH ---> input it in nanometers, you can fit up to 3
    %   decimals if it is needed
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%%% SET STOP WAVELENGTH METHOD %%%%%%%   
    % 
    % With this one we can ask to change the stop wavelength the spectrum 
    % will end
    % 
    %  double stop = set_stop_lam (A6380_class obj,double sto_wavelength)
    % 
    %   sto_wavelength ---> input it in nanometers, you can fit up to 3
    %   decimals if it is needed 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% CALCULATE PEAK WAVELENGTH METHOD %%%%%%%   
    % 
    % With this one we can ask for the peak power wavelength
    % 
    %  double peak_lam = calc_peak (A6380_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% CALCULATE AND SET PEAK WAVELENGTH METHOD %%%%%%%   
    % 
    % With this one we can ask for the peak power wavelength and at the
    % same time set as the center
    % 
    %  double peak_lam_set = setcalc_peak (A6380_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    %  
    %%%%%%%%% SET RESOLUTION METHOD %%%%%%%   
    % 
    % With this one we can ask to change the resolution of the sweep
    % 
    %  double res = set_res (A6380_class obj,double resolution)
    % 
    %  resolution ---> input it in nanometers, you can fit up to 3
    %   decimals if it is needed  
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% SETTERS OF SENSIBILITY METHODS %%%%%%%   
    % 
    % With this one we can ask to change the SENSIBILITY of the instrument
    % between the diferents modes available
    % 
    %  String sens = set_sens_X(A6380_class obj)
    % 
    %   X---->  NHLD    = NORMAL HOLD
    %           NAUT    = NORMAL AUTO
    %           NORMal  = NORMAL
    %           MID     = MID
    %           HIGH1   = HIGH1 or HIGH1
    %           HIGH2   = HIGH2 or HIGH2
    %           HIGH3   = HIGH3 or HIGH3
    %           RAPID1  = RAPID1
    %           RAPID2  = RAPID2
    %           RAPID3  = RAPID3
    %           RAPID4  = RAPID4
    %           RAPID5  = RAPID5
    %           RAPID6  = RAPID6
    % 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% SET SAMPLE POINTS METHOD %%%%%%%   
    % 
    % With this one we can ask to change the number of sample points to use
    % on the sweep.
    % 
    %   int num_p = set_num_points (A6380_class obj,int num_points)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% SETTERS OF SWEEP MODES METHODS %%%%%%%   
    % 
    % With this one we can ask to change the SWEEP modes available
    % 
    %    set_sweep_X(A6380_class obj)
    % 
    %   X ----> single / repeat / auto 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % 
    % 
    % %%%%%%%% INITIATE SWEEP METHOD %%%%%%%   
    % 
    % With this one we can ask to start sweep.
    % 
    %   do_sweep(A6380_class obj)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%  IS THE SWEEP DONE?
    % 
    %   This method ask if the sweep currently doing is done   
    % 
    % boolean  logic = issweepDone(A6380_class obj)
    % 
    %   It returns true if the sweep is done or false if it is not
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        %%% Properties for communication protocol used GPIB
        user_name %% 
        password
        ip_num
        port_num
        timeout
        TPC_obj
        
        % Options for sensitibity

        
         Sens_matr = {"NHLD",0 ,...     %NORMAL_HOLD
                      "NAUT",1 ,...     %NORMAL_AUTO
                      "NORMal",2,...   %NORMAL
                      "MID",3 ,...     %MID
                      "HIGH1",4 ,...   %HIGH1
                      "HIGH2",5 ,...   %HIGH2 
                      "HIGH3",6 ,...   %HIGH3
                      "RAPID1",7 ,...  %RAPID1
                      "RAPID2",8 ,...  %RAPID2
                      "RAPID3",9 ,...  %RAPID3
                      "RAPID4",10 ,... %RAPID4
                      "RAPID5",11 ,... %RAPID5
                      "RAPID6",12}     %RAPID6 

        % Options for sweep mode
        Sweep_matr = {"SINGLE",1 ,... % SINGle 
                      "REPEAT",2 ,... % REPeat 
                      "AUTO" ,3 }     % AUTO 

    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = A6380_class(ip_num)
            % A6380_class  constructor, just set the principal and
            %important parameters to set due correct communication.

            %%% FOR THE OSA AQ6380 ip = 10.72.171.64
            %%% FOR THE OSA AQ6374 ip = 10.72.171.65
                
            obj.user_name   = ""; 
            obj.password    = "";
            obj.ip_num      = ip_num;
            obj.port_num    = 10001;
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

        %end constructor function
        
        


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


        %% SET CENTER WAVELENGTH

        function cen = set_center_lam (obj, wavelength)
                % This function helps to set the center wavelengTH, also to
                % have centered properly the spectrum analized
                
                %%% With the communication opened, we just send the
                %%% command
                %%% which sets the center wavelengTH desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:CENTER %.3fE-9", wavelength));

                fprintf(obj.TPC_obj, ":SENSE:WAVELENGTH:CENTER?");
                cen = str2double(fscanf(obj.TPC_obj));
                
        end

       
        %% SET SPAN

        function spa = set_span (obj, span_length)
                % This function helps to set the span lengTH, which is the,
                % between the start and stop wavelengTH from the center 
                % wavelegth.
                
                %%% With the communication opened, we just send the command
                %%% which sets the span desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:SPAN %.3fE-9", span_length));

                spa = span_length;
        end

        %% SET START WAVELENGTH

        function start = set_start_lam (obj, sta_wavelength)
                % This function helps to set the start wavelengTH, this to
                % control where the spectum will start.
                
                %%% With the communication opened, we just send the command
                %%% which sets the start wavelengTH desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:START %.3fE-9", sta_wavelength));
                
                start = sta_wavelength;
        end

         %% SET STOP WAVELENGTH

        function stop = set_stop_lam (obj, sto_wavelength)
                % This function helps to set the stop wavelengTH, this to
                % control where the spectum will stop.

                %%% With the communication opened, we just send the command
                %%% which sets the stop wavelengTH desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:STOP %.3fE-9", sto_wavelength));
                    
                stop = sto_wavelength;
        end



        %% CALCULATE PEAK POWER WAVELENGTH

        function peak_lam = calc_peak (obj)
                % This function helps to calculate the peak power
                % wavelengTH 

                %%% With the communication opened, we just send the command
                %%% which sets the stop wavelengTH desired.
                fprintf(obj.TPC_obj, ":CALCULATE:MARKER:MAXiMUM");

                fprintf(obj.TPC_obj, ":CALCULATE:MARKER:X?");
                
                % We read the value of the wavelengTH peak power
                peak_lam = fscanf(obj.TPC_obj);

        end


        %% CALCULATE PEAK POWER WAVELENGTH and set center

        function peak_lam_set = setcalc_peak (obj)
                % This function helps to calculate the peak power
                % wavelengTH and at the same time set the red peak power as
                % the center weavelengTH

                %%% With the communication opened, we just send the command
                %%% which sets the stop wavelengTH desired.
                fprintf(obj.TPC_obj, ":CALCulate:MARKer:MAXimum:SCENter");

                fprintf(obj.TPC_obj, ":SENSE:WAVELENGTH:CENTER?");
                % We read the value of the wavelengTH peak power
                peak_lam_set = fscanf(obj.TPC_obj);

        end


        %% SET THE RESOLUTION

        function res = set_res (obj, resolution)
                % This function helps too set the resolution wanted, it
                % means, the minimum step between wavelengths  

                %%% With the communication opened, we just send the command
                %%% which sets the resolution
                fprintf(obj.TPC_obj, sprintf(":SENSe:BANDwidth:RESolution %.3fE-9",resolution));
                
                res = resolution;
        end


        %% SET THE SENSIBILITY  NORMAL HOLD

        function sens = set_sens_NORMAL_HOLD (obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE NHLD");

                sens = "NHLD";

        end

         %% SET THE SENSIBILITY  NORMAL AUTO

        function sens = set_sens_NORMAL_AUTO (obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE NAUT");
               
                sens = "NAUT";
        end

        %% SET THE SENSIBILITY  NORMAL

        function sens = set_sens_NORMAL(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have.


                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE NORMal");

               sens = "NORMAL";
        end

        %% SET THE SENSIBILITY  MID

        function sens = set_sens_MID(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE MID");

                sens = "MID";
        end


        %% SET THE SENSIBILITY  HIGH1

        function sens = set_sens_HIGH1(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE HIGH1");
                
                sens = "HIGH1";
        end

        %% SET THE SENSIBILITY  HIGH2

        function sens = set_sens_HIGH2(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE HIGH2");

                sens = "HIGH2";
        end

        %% SET THE SENSIBILITY  HIGH3

        function sens = set_sens_HIGH3(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                
                
                fprintf(obj.TPC_obj, ":SENSE:SENSE HIGH3");

                sens = "HIGH3";
        end

        %% SET THE SENSIBILITY  RAPID1

        function sens = set_sens_RAPID1(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID1");

                sens = "RAPID1";
        end

        %% SET THE SENSIBILITY  RAPID2

        function sens = set_sens_RAPID2(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID2");

                sens = "RAPID2";
        end

        %% SET THE SENSIBILITY  RAPID3

        function sens = set_sens_RAPID3(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID3");

                sens = "RAPID3";
        end


        %% SET THE SENSIBILITY  RAPID4

        function sens = set_sens_RAPID4(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID4");

                sens = "RAPID4";
        end


        %% SET THE SENSIBILITY  RAPID5

        function sens = set_sens_RAPID5(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID5");

                sens = "RAPID5";
        end

        %% SET THE SENSIBILITY  RAPID6

        function sens = set_sens_RAPID6(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID6");

                sens = "RAPID6";
        end

        %% SET THE NUMBER OF POINTS

        function num_p = set_num_points (obj, num_points)
                % This function helps too set the number of points the instrument
                %will measure for make the trace

                %%% With the communication opened, we just send the
                %%% command where we ask for the number of points desired
                fprintf(obj.TPC_obj, sprintf(":SENSE:SWEEP:POINTS %u",num_points));

                num_p = num_points;
        end

        %% SET THE SWEEP MODE SINGLE

        function set_sweep_single(obj)
                % This function helps to set the sweep mode in SINGLE.

                %%% With the communication opened, we just send the command
                %%% which sets the sweep mode
                fprintf(obj.TPC_obj,":INITIATE:SMODE SINGLE");
                
        end


        %% SET THE SWEEP MODE REPEAT

        function set_sweep_repeat(obj)
                % This function helps to set the sweep mode in REPEAT.

                %%% With the communication opened, we just send the command
                %%% which sets the sweep mode
                fprintf(obj.TPC_obj,":INITIATE:SMODE REPEAT");
        end
        
        %% SET THE SWEEP MODE AUTO

        function set_sweep_auto(obj)
                % This function helps to set the sweep mode in AUTO.

                %%% With the communication opened, we just send the command
                %%% which sets the sweep mode
                fprintf(obj.TPC_obj,":INITIATE:SMODE AUTO");


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
            fprintf(obj.TPC_obj,":stat:oper:even?");

            byte_c = str2double(fscanf(obj.TPC_obj));
            sweepbit = byte_c & 1;

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