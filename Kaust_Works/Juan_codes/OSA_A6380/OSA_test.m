%%% EJEMPLO DE CONECCION ETHERNET CON EL OSA AQ6380

% Define the IP address and port of the OSA
osaIP = '192.168.1.100'; % Replace with your OSA's IP address
osaPort = 10001;         % Replace with your OSA's port number

% Create a TCP/IP object 't' associated with the OSA
t = tcpip(osaIP, osaPort, 'NetworkRole', 'client');

% Set the timeout for reading and writing data (in seconds)
t.Timeout = 10;

% Open the connection to the OSA
try
    fopen(t);
    disp('Connection successful');
catch e
    disp('Failed to connect to the OSA:');
    disp(e.message);
end

% Check if the connection is open
if strcmp(t.Status, 'open')
    fprintf('Connection is open.\n');
    
    % Send a command to the OSA
    fprintf(t, '*IDN?'); % Query the instrument identity
    
    % Read the response from the OSA
    idnResponse = fscanf(t);
    fprintf('Response from OSA: %s\n', idnResponse);
    
    % Close the connection
    fclose(t);
else
    disp('Connection could not be established or was closed.');
end

% Clean up by deleting the object and clearing it from memory
delete(t);
clear t;