function axesIdentifierArray  = qSAI(c)
% Get axis identifier of all axes.
% 
%   SYNTAX 
%       axesIdentifierArray = QSAI()
% 
%   DESCRIPTION 
%   Get axis identifier of all configured axes.Make shure you index the
%   returned cell array "devices" with curly brackets to get the string:
%   axis1 = axesIdentifierArray{1}.
%    
%   OUTPUT 
%       axesIdentifierArray            List axis identifier of all
%       (cell array of chars)          configured axes. 
%       
% 
%   EXAMPLE
%       axesIdentifierArray = QSAI()
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if(c.ID<0), error('The controller is not connected'),end;
functionName = [ c.libalias, '_', mfilename];
if(any(strcmp(functionName,c.dllfunctions)))
	szAnswer = blanks(8001);
	try
		[bRet,szAnswer] = calllib(c.libalias,functionName,c.ID,szAnswer,8000);
		if(bRet==0)
			iError = GetError(c);
			if(iError == -5)
				szAnswer = blanks(18001);
				[bRet,szAnswer] = calllib(c.libalias,functionName,c.ID,szAnswer,18000);
				if(bRet==0)
					iError = GetError(c);
					szDesc = TranslateError(c,iError);
					error(szDesc);
				end
			else
				szDesc = TranslateError(c,iError);
				error(szDesc);
			end
        else
            regularExpression = '\w';
            axesIdentifierArray = regexp(szAnswer, regularExpression, 'match');
        end
	catch
		rethrow(lasterror);
	end
else
	error('%s not found',functionName);
end
