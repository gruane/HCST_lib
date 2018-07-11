function resPos = hcst_LS_getPos(B)
%hcst_LS_getPos Function to get the position of the LS (in mm)
%   
%   - Uses the MATLAB Zaber_Toolbox provided by Zaber Technologies
%   
%
%   Arguments/Outputs:
%   resPos = hcst_LS_getPos(B) gets the LS position
%       'B.bench' is the struct containing all pertient bench information
%           and instances. It is created by the hcst_config() function.
%       'resPos' is a vector with the position of the axes, in the order:
%           [Vertical, Horizontal]
%
%
%   Examples:
%       hcst_LS_getPos(B)
%           Returns the position of both axes (in mm)
%
%
%   See also: hcst_setUpBench, hcst_LS_move, hcst_cleanUpBench
%

M2MM = 1000;    %Conversion by which to multiply m to get mm

%% get the position of each axis
% Query position; convert to mm
try
    resPos(1) = B.bench.LS.axV.Units.nativetoposition(B.bench.LS.axV.getposition)*M2MM;
catch exception
    % Close port if a MATLAB error occurs, otherwise it remains locked
    fclose(B.bench.LS.axV.Protocol.Port);
    rethrow(exception);
end

try
    resPos(2) = B.bench.LS.axH.Units.nativetoposition(B.bench.LS.axH.getposition)*M2MM;
catch exception
    % Close port if a MATLAB error occurs, otherwise it remains locked
    fclose(B.bench.LS.axH.Protocol.Port);
    rethrow(exception);
end

end