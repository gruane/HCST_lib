function vec = hcst_DM_2Dto1D(bench,map)
%vec = hcst_DM_2Dto1D(bench, map)
%Converts 2D array to 1D vector of actuator pokes 
% 
%  NOTE: This function only accounts for DM1 right now. It can easily be
%  modified to include the commands for DM2 as well.
%
%--INPUT:
% map: a 34x34 matrix of DM1 commands in units of volts
%
%--OUTPUT:
%  vec = a 1x4096 vector in units of bits. The first 952 elements
%  correspond to the commands for DM1. The commands for DM2 correspond to
%  elements 1024+1:1024+924. All other elements in the vector must be zero
%  or else very odd computer behavior can occur, such as rebooting.


Nact = 952;
NactAcross = 34;
xs = (1:NactAcross)-(NactAcross+1)/2;
[XS,YS] = meshgrid(xs);
RS = sqrt(XS.^2 + YS.^2);

% mat(RS<17.5) = 1;
% act_ele = find(mat==1);

% figure(1); imagesc(mat); axis xy equal tight;


vec = zeros(1,bench.DM.cmdLength);
vec(1:Nact) = map(RS<NactAcross/2+0.5);


end
