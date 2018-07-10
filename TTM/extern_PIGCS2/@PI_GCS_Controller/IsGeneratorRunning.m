function iValues2 = IsGeneratorRunning(c,iValues1)
%function [bRet] = IsGeneratorRunning(c,iValues1,iValues2)
%PI MATLAB Class Library Version 1.2.0
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

FunctionName = 'PI_IsGeneratorRunning';
if(any(strcmp(FunctionName,c.dllfunctions)))
    piValues1 = libpointer('int32Ptr',iValues1);
    nValues = length(iValues1);
    iValues2 = zeros(nValues,1);
    piValues2 = libpointer('int32Ptr',iValues2);
    
    try
        [bRet,iValues1,iValues2] = calllib(c.libalias,FunctionName,c.ID,piValues1,piValues2,nValues);
        if(bRet==0)
            iError = GetError(c);
            szDesc = TranslateError(c,iError);
            error(szDesc);
        end
    catch
        rethrow(lasterror);
    end
else
    error('%s not found',FunctionName);
end