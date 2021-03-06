function [c, iNumDevices]  = OpenTCPIPDaisyChain ( c, szHostName, port )

functionName = ['PI_', mfilename];

% Method available?
if ( ~any ( strcmp ( functionName, c.dllfunctions ) ) ), error('Method %s not found',functionName), end;

% Create variables for C interface
iNumDevices = 0;
piNumDevices = libpointer ( 'int32Ptr', iNumDevices );
szDCDevices = blanks ( 10001 );

try
    % call C interface
    % second returning argument would be "szHostName" which is not needed. Hence is "~"
    [ c.DC_ID, ~, iNumDevices, szDCDevices ]  = calllib ( c.libalias, functionName, szHostName, port, piNumDevices, szDCDevices, 10001);
    
    if ( c.DC_ID < 0 )
        iError = GetError ( c );
        szDesc = TranslateError ( c, iError );
        error ( szDesc );
    end
    
catch ME
    error ( ME.message );
end

% Create list of available Daisy Chain Devices
daisyChainDevicesAsCellArray = regexp(szDCDevices, '\n', 'split');

for address = 1 : size ( daisyChainDevicesAsCellArray , 2)
    if ( ~isempty ( daisyChainDevicesAsCellArray {address} ) )
        c.ConnectedDaisyChainDevices{address} = [sprintf('%02d: ', address), daisyChainDevicesAsCellArray{address}];
    end
end