function hcst_andor_testLib(bench)
%hcst_Andor_testLib Function to test the Andor commands
%
%   
%   Inputs:
%       'bench' is the object containing all pertinent bench information
%           and instances. It is created by the hcst_config() function.
%
%
%   Examples:
%       hcst_Andor_testLib(bench)
%           Runs through the available MATLAB Andor commands
%
%
%   See also: hcst_testLib, hcst_setUpBench, hcst_cleanUpBench
%


%% Execute the functions/commands, one-by-one


im = hcst_andor_getImage(bench);


figure;
imagesc(double(im)/2^16);
axis image; 
colorbar;
title('Normalized image');

end