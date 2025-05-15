classdef PMeter_class < handle
    % PMeter_class this class has the basic methods to use the power meter 
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
    %   6. VISA_obj ---> object tcpip class type used to communicate
    %                   properly with the OSA
    % 
    % %%%%%%%%%%%%%%%%%%%%%% METHODS DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 
    %%%%%% CONSTRUCTOR %%%
    %   
    %   
    %   
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        %%% Properties for communication protocol used RS-232
        serial_port

        timeout
        Serial_obj
       

    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        %% CONSTRUCTOR for communication parameters and testing
        function obj = PMeter_class(serial_port)
            % A6380_class  constructor, just set the principal and
            %important parameters to set for correct communication.

            %%% FOR THE OSA AQ6380 ip = 10.72.171.64
            %%% FOR THE OSA AQ6374 ip = 10.72.171.65
                
            obj.serial_port  = serial_port; 
            
            obj.timeout     = 10;

            %%% We start initiating the Ethernet communication

            % Create a SERIAL object associated with the PM
            obj.Serial_obj = serialport(obj.serial_port, 19200);
            obj.Serial_obj.DataBits = 8;
            obj.Serial_obj.StopBits = 1;
            obj.Serial_obj.Parity = "none";
            obj.Serial_obj.Timeout =  obj.timeout;
            

        end % End function
        %end constructor function
        
        


        %% INIT COMMUNICATION

        function init(obj)
            % Using this function you open communication with the OSA
            % Open the connection to the OSA
            try
                fopen(obj.Serial_obj);
                disp(obj.idnt())
                disp("Connection successful\n");
            catch e
                disp('Failed to connect to the PM');
                disp(e.message);
            end
            
        end

     

         %% SHUT DOWN COMMUNICATON

        function logic = deleteObj(obj)
            % Close and delete the GPIB object
            logic = true;
            delete(obj.Serial_obj);
            clear obj.Serial_obj;
        end


        %% IDENTIFICATION

        function ident = idnt(obj)
            % Close and delete the GPIB object
            % configureTerminator(obj.Serial_obj, "CR");
            write(obj.Serial_obj,1:5, "uint8");
            pause(0.05);
            ident = readline(obj.Serial_obj);
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