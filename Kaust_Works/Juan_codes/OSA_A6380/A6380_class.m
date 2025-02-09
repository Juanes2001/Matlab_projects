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
    %   7. center ---> Center wavelength set on the OSA 
    % 
    %   8. span ----> span distance set on the OSA  
    % 
    %   9. start ----> Start wavelength set on the OSA
    %   
    %   10. stop ----> Stop wavelength set on the OSA
    %   
    %   11. peak_wave ----> Peak power wavelength Set on the OSA
    % 
    %   12. resolution ----> Resolution set on the OSA for the sweep
    %                       operation
    %   13. sensibility ----> Sensibility mode as an Array of modes, it
    %   includes respectively the name mode as a String and the number  returned by the
    %   OSA when query option is desired.
    % 
    %                       ["NAME", num] 
    % 
    %   14. sam_points ---> Number of sample points used to make a spectrum trace 
    %   
    %   15. sweep_type ---> Sweep mode as an Array of modes, it
    %   includes respectively the name mode as a String and the number returned by the
    %   OSA when query option is desired.   
    % 
    %   16. Sens_matr ---> Vector of fixed values from the sensitibity 
    %                       to be used by the methods 
    %   17. Sweep_matr ---> Vector of fixed values from the Sweep modes to
    %                       be used by the methods
    % 
    % 
    % 
    % 
    % 
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
    %%%%%%%% REFRESH METHODS %%%
    %   
    %   For the refresh methods these are not needed to be touched, because
    %   the principal methods use them to refresh the properties, so you
    %   can have the same current state of the OSA in the
    %   properties.
    %   
    %%%%%%%%%%%%%%%%%%%%%%%
    % 
    %%%%%%% REFRESH INITIAZION %%%
    %   
    %    A6380_class obj = refresh_Init( A6380_class obj)
    % 
    %   This function can count as a Constructor, the diference is it takes
    %   the current parameters the device has at the moment just to have
    %   initial parameters correspoding with the instrument itself. 
    % 
    %%%%%%%%%%%%%%%%%%%%%%% 
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
    %%%%%%%%% SET CENTER WAVELENGTH METHOD %%%%   
    % 
    % With this one we can ask for set the center wavelength of the
    % spectrum
    % 
    %  A6380_class obj = set_center_lam (A6380_class obj,double wavelength)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %
    %%%%%%%% SET SPAN METHOD %%%%%%%%%   
    % 
    % With this one we can ask for change the span which is the distance
    % between the start and stop wavelength.
    % 
    %  A6380_class obj = set_span (A6380_class obj,double span_length)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    % 
    %%%%%%%%% SET START WAVELENGTH METHOD %%%%%%%   
    % 
    % With this one we can ask to change the start wavelength the spectrum 
    % will begin
    % 
    %  A6380_class obj = set_start_lam (A6380_class obj,double sta_wavelengTH)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % 
    %%%%%%%%% SET STOP WAVELENGTH METHOD %%%%%%%   
    % 
    % With this one we can ask to change the stop wavelength the spectrum 
    % will end
    % 
    %  A6380_class obj = set_stop_lam (A6380_class obj,double sto_wavelengTH)
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
    %  A6380_class obj = set_res (A6380_class obj,double resolution)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% SETTERS OF SENSIBILITY METHODS %%%%%%%   
    % 
    % With this one we can ask to change the SENSIBILITY of the instrument
    % between the diferents modes available
    % 
    %  A6380_class obj = set_sens_X(A6380_class obj)
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
    %   A6380_class obj = set_num_points (A6380_class obj,int num_points)
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % 
    %%%%%%%%% SETTERS OF SWEEP MODES METHODS %%%%%%%   
    % 
    % With this one we can ask to change the SWEEP modes available
    % 
    %  A6380_class obj = set_sweep_X(A6380_class obj)
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

        %%% Spectrum parameters
        
        center      %%% Value of the center wavelength
        span        %%% Value of the span
        start       %%% Value of the start wavelength
        stop        %%% Value of the center wavelength
        peak_wave   %%% Value of the peak wavelength
        resolution  %%% Value of the resolution
        sensibility %%% Array of string and value of the sensitibity type ["Name", num]
        sam_points  %%% Value of the number of sample points per sweep
        sweep_type  %%% Array of String type and num, shows the sweep type 
                        % it was going to be done ["Name", num]
        
        % Options for sensitibity

        
         Sens_matr = [["NHLD",0] ,...     %NORMAL_HOLD
                      ["NAUT",1] ,...     %NORMAL_AUTO
                      ["NORMal",2],...   %NORMAL
                      ["MID",3] ,...     %MID
                      ["HIGH1",4] ,...   %HIGH1
                      ["HIGH2",5] ,...   %HIGH2 
                      ["HIGH3",6] ,...   %HIGH3
                      ["RAPID1",7] ,...  %RAPID1
                      ["RAPID2",8] ,...  %RAPID2
                      ["RAPID3",9] ,...  %RAPID3
                      ["RAPID4",10] ,... %RAPID4
                      ["RAPID5",11] ,... %RAPID5
                      ["RAPID6",12]]     %RAPID6 

        % Options for sweep mode
        Sweep_matr = [["SINGLE",1] ,... % SINGle 
                      ["REPEAT",2] ,... % REPeat 
                      ["AUTO" ,3] ]     % AUTO 

    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = A6380_class()
            % A6380_class  constructor, just set the principal and
            %important parameters to set due correct communication.
                
            obj.user_name   = ""; 
            obj.password    = "";
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
            obj.sensibility = ['',0];
            obj.sam_points  = 0;
            obj.sweep_type  = ['',0];


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

        function obj = refresh_Init(obj)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%% INITIATION OF THE CENTER WAVELENGTH
            fprintf(obj.TPC_obj, ":SENSE:WAVELENGTH:CENTER?");
            obj.center = str2double(fscanf(obj.TPC_obj));

            %%% INITIATION OF THE SPAN
            fprintf(obj.TPC_obj, ":SENSE:WAVELENGTH:SPAN?");
            obj.span = str2double(fscanf(obj.TPC_obj));

            %%% INITIATION OF THE START WAVELENGTH
            fprintf(obj.TPC_obj, ":SENSE:WAVELENGTH:START?");
            obj.start = str2double(fscanf(obj.TPC_obj));

            %%% INITIATION OF THE STOP WAVELENGTH
            fprintf(obj.TPC_obj, ":SENSE:WAVELENGTH:STOP?");
            obj.stop = str2double(fscanf(obj.TPC_obj));

            %%% INITIATION OF THE PEAK WAVELENGTH
            %%% This one is set during using the OSA, due to only measured
            %%% when one sweep has been done.

            %%% INITIATION OF THE RESOLUTION
            fprintf(obj.TPC_obj, ":SENSe:BANDwidth:RESolution?");
            obj.resolution = str2double(fscanf(obj.TPC_obj));

            %%% INITIATION OF THE SENSIBILITY
            fprintf(obj.TPC_obj, ":SENSe:SENSe?");
            obj.sensibility(2) = str2int(fscanf(obj.TPC_obj));

            [row,colm] = find(obj.Sens_matr == obj.sensibility(2));

            obj.sensibility(1) = obj.Sens_matr(row,colm - 1);

            %%% INITIATION OF THE SAMPLE POINTS
            fprintf(obj.TPC_obj, ":SENSE:SWEEP:POINTS?");
            obj.sam_points = str2int(fscanf(obj.TPC_obj));

            %%% INITIATION OF THE SWEEP MODE
            fprintf(obj.TPC_obj, ":INITIATE:SMODE?");
            obj.sweep_type(2) = str2int(fscanf(obj.TPC_obj));

            [row,colm] = find(obj.Sweep_matr == obj.sweep_type(2));

            obj.sweep_type(1) = obj.Sweep_matr(row,colm - 1);


        end % End function


        function obj = refresh_center(obj,new_center)
            %%% This function wants to refresh the center value set on the
            %%% OSA.
            
            obj.center = new_center;
        
        end% End function

        function obj = refresh_span(obj,new_span)
            %%% This function wants to refresh the span value set on the
            %%% OSA.
            
            obj.span = new_span;
        
        end% End function

        function obj = refresh_start(obj,new_start)
            %%% This function wants to refresh the start value set on the
            %%% OSA.
            
            obj.start = new_start;
        
        end% End function


        function obj = refresh_stop(obj,new_stop)
            %%% This function wants to refresh the stop value set on the
            %%% OSA.
            
            obj.stop = new_stop;
        
        end% End function


        function obj = refresh_peak_wave(obj,new_peak_wave)
            %%% This function wants to refresh the peak vavelength 
            %%% value set on the OSA.
            
            obj.peak_wave = new_peak_wave;
        
        end% End function

        function obj = refresh_resolution(obj,new_res)
            %%% This function wants to refresh the resolution 
            %%% value set on the OSA.
            
            obj.resolution = new_res;
        
        end% End function
        

        function obj = refresh_sensibility(obj, new_sense)
            %%% This function wants to refresh the sensibility 
            %%% value set on the OSA.
            
            obj.sensibility = new_sense;
        
        end% End function

        function obj = refresh_sam_points(obj, new_sample)
            %%% This function wants to refresh the Sample points 
            %%% value set on the OSA.
            
            obj.sam_points = new_sample;
        
        end% End function

        function obj = refresh_SwMode(obj, new_sweep_mode)
            %%% This function wants to refresh the sweep mode
            %%% value set on the OSA.
            
            obj.sam_points = new_sweep_mode;
        
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
                
                obj.refresh_Init();
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
            obj.refresh_Init();
        end

        %% ABORT MEASUREMENTS
        function abort(obj)
            % With this function you can abort some measurements ongoing
            % for any reason needed.
            fprintf(obj.TPC_obj ,':ABORT');
        end


        %% SET CENTER WAVELENGTH

        function obj = set_center_lam (obj, wavelength)
                % This function helps to set the center wavelengTH, also to
                % have centered properly the spectrum analized
                
                %%% With the communication opened, we just send the command
                %%% which sets the center wavelengTH desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:CENTER %.3f", wavelength));
                
                % We refresh
                obj.refresh_center(wavelength);
        end

       
        %% SET SPAN

        function obj = set_span (obj, span_length)
                % This function helps to set the span lengTH, which is the,
                % between the start and stop wavelengTH from the center 
                % wavelegth.
                
                %%% With the communication opened, we just send the command
                %%% which sets the span desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:SPAN %.3f", span_length));
                
                %We refresh
                obj.refresh_span(span_length);
        end

        %% SET START WAVELENGTH

        function obj = set_start_lam (obj, sta_wavelengTH)
                % This function helps to set the start wavelengTH, this to
                % control where the spectum will start.
                
                %%% With the communication opened, we just send the command
                %%% which sets the start wavelengTH desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:START %.3f", sta_wavelengTH));
                
                %We refresh
                obj.refresh_start(sta_wavelengTH);
        end

         %% SET STOP WAVELENGTH

        function obj = set_stop_lam (obj, sto_wavelengTH)
                % This function helps to set the stop wavelengTH, this to
                % control where the spectum will stop.

                %%% With the communication opened, we just send the command
                %%% which sets the stop wavelengTH desired.
                fprintf(obj.TPC_obj, sprintf(":SENSE:WAVELENGTH:STOP %.3f", sto_wavelengTH));
                
                %We Refresh
                obj.refresh_stop(sto_wavelengTH);
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

                % We refresh the peak wavelength value
                obj.refresh_peak_wave(peak_lam);
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

                % We refresh the peak wavelength value and the center
                % wavelength value
                obj.refresh_peak_wave(peak_lam_set);
                obj.refresh_center(peak_lam_set);
        end

        %% SET THE RESOLUTION

        function obj = set_res (obj, resolution)
                % This function helps too set the resolution wanted, it
                % means, the minimum step between wavelengTHs  

                %%% With the communication opened, we just send the command
                %%% which sets the resolution
                fprintf(obj.TPC_obj, sprintf(":SENSe:BANDwidth:RESolution %.3f",resolution));
                
                % We refresh
                obj.refresh_resolution(resolution);
        end

        %% SET THE SENSIBILITY  NORMAL HOLD

        function obj = set_sens_NORMAL_HOLD (obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE NHLD");

                [row,colm] = find(obj.Sens_matr == "NHLD");

                % We refresh
                obj.refresh_sensibility(["NHLD",  obj.Sens_matr(row,colm + 1)]);
        end

         %% SET THE SENSIBILITY  NORMAL AUTO

        function obj = set_sens_NORMAL_AUTO (obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE NAUT");

                [row,colm] = find(obj.Sens_matr == "NAUT");

                % We refresh
                obj.refresh_sensibility(["NAUT",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  NORMAL

        function obj = set_sens_NORMAL(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE NORMal");

                [row,colm] = find(obj.Sens_matr == "NAUT");

                % We refresh
                obj.refresh_sensibility(["NAUT",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  MID

        function obj = set_sens_MID(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE MID");

                [row,colm] = find(obj.Sens_matr == "MID");

                % We refresh
                obj.refresh_sensibility(["MID",  obj.Sens_matr(row,colm + 1)]);
        end


        %% SET THE SENSIBILITY  HIGH1

        function obj = set_sens_HIGH1(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE HIGH1");
                
                [row,colm] = find(obj.Sens_matr == "HIGH1");

                % We refresh
                obj.refresh_sensibility(["HIGH1",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  HIGH2

        function obj = set_sens_HIGH2(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE HIGH2");

                [row,colm] = find(obj.Sens_matr == "HIGH2");

                % We refresh
                obj.refresh_sensibility(["HIGH2",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  HIGH3

        function obj = set_sens_HIGH3(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE HIGH3");

                [row,colm] = find(obj.Sens_matr == "HIGH3");

                % We refresh
                obj.refresh_sensibility(["HIGH3",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  RAPID1

        function obj = set_sens_RAPID1(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID1");

                [row,colm] = find(obj.Sens_matr == "RAPID1");

                % We refresh
                obj.refresh_sensibility(["RAPID1",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  RAPID2

        function obj = set_sens_RAPID2(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID2");

                [row,colm] = find(obj.Sens_matr == "RAPID2");

                % We refresh
                obj.refresh_sensibility(["RAPID2",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  RAPID3

        function obj = set_sens_RAPID3(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID3");

                [row,colm] = find(obj.Sens_matr == "RAPID3");

                % We refresh
                obj.refresh_sensibility(["RAPID3",  obj.Sens_matr(row,colm + 1)]);
        end


        %% SET THE SENSIBILITY  RAPID4

        function obj = set_sens_RAPID4(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID4");

                [row,colm] = find(obj.Sens_matr == "RAPID4");

                % We refresh
                obj.refresh_sensibility(["RAPID4",  obj.Sens_matr(row,colm + 1)]);
        end


        %% SET THE SENSIBILITY  RAPID5

        function obj = set_sens_RAPID5(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID5");

                [row,colm] = find(obj.Sens_matr == "RAPID5");

                % We refresh
                obj.refresh_sensibility(["RAPID5",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE SENSIBILITY  RAPID6

        function obj = set_sens_RAPID6(obj)
                % This function helps too set the sensibility mode, it 
                % means which sensitive we want out instrument to have. 

                %%% With the communication opened, we just send the command
                %%% which sets the SENSIBILITY MODE   
                fprintf(obj.TPC_obj, ":SENSE:SENSE RAPID6");

                [row,colm] = find(obj.Sens_matr == "RAPID6");

                % We refresh
                obj.refresh_sensibility(["RAPID6",  obj.Sens_matr(row,colm + 1)]);
        end

        %% SET THE NUMBER OF POINTS

        function obj = set_num_points (obj, num_points)
                % This function helps too set the number of points the instrument
                %will measure for make the trace

                %%% With the communication opened, we just send the
                %%% command where we ask for the number of points desired
                fprintf(obj.TPC_obj, sprintf(":SENSE:SWEEP:POINTS %u",num_points));

                % We refresh
                obj.refresh_sam_points(num_points);
        end

        %% SET THE SWEEP MODE SINGLE

        function obj = set_sweep_single(obj)
                % This function helps to set the sweep mode in SINGLE.

                %%% With the communication opened, we just send the command
                %%% which sets the sweep mode
                fprintf(obj.TPC_obj,":INITIATE:SMODE SINGLE");

                [row,colm] = find(obj.Sweep_matr == "SINGLE");

                % We refresh
                obj.refresh_SwMode(["SINGLE",  obj.Sweep_matr(row,colm + 1)]);
                
        end


        %% SET THE SWEEP MODE REPEAT

        function obj = set_sweep_repeat(obj)
                % This function helps to set the sweep mode in REPEAT.

                %%% With the communication opened, we just send the command
                %%% which sets the sweep mode
                fprintf(obj.TPC_obj,":INITIATE:SMODE REPEAT");

                [row,colm] = find(obj.Sweep_matr == "REPEAT");

                % We refresh
                obj.refresh_SwMode(["REPEAT",  obj.Sweep_matr(row,colm + 1)]);
        end
        
        %% SET THE SWEEP MODE AUTO

        function obj = set_sweep_auto(obj)
                % This function helps to set the sweep mode in AUTO.

                %%% With the communication opened, we just send the command
                %%% which sets the sweep mode
                fprintf(obj.TPC_obj,":INITIATE:SMODE AUTO");

                [row,colm] = find(obj.Sweep_matr == "AUTO");

                % We refresh
                obj.refresh_SwMode(["AUTO",  obj.Sweep_matr(row,colm + 1)]);
        end


        %% DO A SWEEP

        function do_sweep(obj)
                % With this function we initiate the sweep
                fprintf(obj.TPC_obj, ":INITIATE");
        end


    end % End of the methods


end %End of the class


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%