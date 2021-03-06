function data = hcst_DM_flattenDM( bench, apply )
%data = hcst_DM_flattenDM( bench, apply )
%Returns array of voltages data that provide a flat DM surface. With apply=true,
%this function also flattens the DM. 
% Set apply=true to apply voltages to DM. apply=false returns the
% volatages.
%   author: G. Ruane
%   last modified: July 13, 2018


    data = bench.DM.flatvec;
    
    if(apply)
        err_code = BMCSendData(bench.DM.dm, data);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    end
    
end

