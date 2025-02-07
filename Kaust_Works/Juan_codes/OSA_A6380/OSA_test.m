%%% EJEMPLO DE CONECCION ETHERNET CON EL OSA AQ6380

% Define the IP address and port of the OSA
osaIP = '10.72.171.64'; % Replace with your OSA's IP address
osaPort = 10001;         % Replace with your OSA's port number

instr  = instrfind; % We have to be sure we close every single opened intrument
if ~isempty(instr)
    fclose(instr);
    delete(instr);
end


% Create a TCP/IP object 't' associated with the OSA
t = tcpip(osaIP, osaPort, 'NetworkRole', 'client');

% Set the timeout for reading and writing data (in seconds)
t.Timeout = 10;

pause(1);

% Open the connection to the OSA
try
    fopen(t);
    pause(1);
    disp("Connection successful\n");
catch e
    disp('Failed to connect to the OSA:');
    disp(e.message);
end

% Check if the connection is open
if strcmp(t.Status, 'open')

    fprintf(t, "open ""anonymous""");
    idnResponse = fscanf(t);
    disp(idnResponse);
    
    % Send a command to the OSA
    fprintf(t, ' '); % Query the instrument identity
    
    % Read the response from the OSA
    idnResponse = fscanf(t);
    disp('Response from OSA:');
    disp(idnResponse);

fprintf(t, '*IDN?'); % Query the instrument identity

    idnResponse = fscanf(t);
    disp(idnResponse);
    
    % Close the connection
    fclose(t);
else
    disp('Connection could not be established or was closed.');
end

% Clean up by deleting the object and clearing it from memory
delete(t);
clear t;