function hcst_setUpFS(bench)
%hcst_setUpFS Function to prepare the FS for control
%   
%   - This function should be called before calling any other FS functions
%   - It uses the Conex.py class
%   - It creates three instances of the class, one for each axis
%   - It does not home the Conexs unless needed. If needed, it returns them
%       to the position specified by bench.FS.User_#0 where #={V, H, or F}
%   
%
%   Arguments/Outputs:
%   hcst_setUpFS(bench) Instantiates the Conex control classes.
%       Updates the FS sub-struct which contains pertient information 
%       about the stages as well as the instances of the Conex.py class. 
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_setUpFS(bench)
%           Updates 'bench', the FS sub-struct, and the requisite classes
%
%
%   See also: hcst_setUpBench, hcst_cleanUpBench, hcst_cleanUpFS
%

disp('*** Setting up FS stages... ***');

%% Add the directory with all our libraries to the Python search path
HCST_lib_PATH = '/home/hcst/HCST_lib/FS';
if count(py.sys.path, HCST_lib_PATH) == 0
    insert(py.sys.path, int32(0), HCST_lib_PATH);
end

%% Instantiate the three axes
axVer = py.Conex.Conex_Device('/dev/ttyFSConexV', 921600);
axHor = py.Conex.Conex_Device('/dev/ttyFSConexH', 921600);
axFoc = py.Conex.Conex_Device('/dev/ttyFSConexF', 921600);

%% Open the three axes for comms
axVer.open()
axHor.open()
axFoc.open()

%% Check if the axes are ready to be moved
verIsReady = axVer.isReady();
horIsReady = axHor.isReady();
focIsReady = axFoc.isReady();

%% Home the axes if they are not ready to be moved

%Home the horizontal axis first to prevent collisions
if ~horIsReady
    horIsReady = axHor.home(true);    %Use blocking (true) to ensure home before move
    if horIsReady
        axHor.moveAbs(bench.FS.User_H0,true)    %blocking to ensure pos reached
    else
        warning("Horizontal axis reported not ready after moving");
    end
end
if ~verIsReady
    verIsReady = axVer.home(true);    %Use blocking (true) to ensure home before move
    if verIsReady
        axVer.moveAbs(bench.FS.User_V0,true)    %blocking to ensure pos reached
    else
        warning("Vertical axis reported not ready after moving");
    end
end
if ~focIsReady
    focIsReady = axFoc.home(true);    %Use blocking (true) to ensure home before move
    if focIsReady
        axFoc.moveAbs(bench.FS.User_F0,true)    %blocking to ensure pos reached
    else
        warning("Focus axis reported not ready after moving");
    end
end

% reqPosSet() returns -9999 on error, so if there's no error, we're good.
if (axHor.reqPosSet() ~= -9999) && (axVer.reqPosSet() ~= -9999) && (axFoc.reqPosSet() ~= -9999)
    bench.FS.CONNECTED = true;
end

disp('*** FS stages initialized. ***');

%% Populate struct
bench.FS.axV = axVer;
bench.FS.axH = axHor;
bench.FS.axF = axFoc;

% Save backup bench object
hcst_backUpBench(bench)

end

