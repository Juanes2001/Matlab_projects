 %%% We start initiating the Ethernet communication

instr  = instrfind; % We have to be sure we close every single opened intrument
if ~isempty(instr)
    fclose(instr);
    delete(instr);
end

ip_num      = '10.72.171.64';
port_num    = 10001;

% Create a TCP/IP object 't' associated with the OSA
t = tcpip(ip_num, port_num, 'NetworkRole', 'client');
t.Timeout =  10;


 % Using this function you open communication wiith the OSA
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
    
end


%% AFTER ALL BEFORE YOU SHOULD PERFORM ANY COMMAND YOU WANT TO SEND.
% TRYING TO GIVE YOU GUYS A CLASS WHERE YOU CAN MANAGE THE OSA EASILY, I
% HOPE I GET EVERYTHING BY THIS WEEK.


