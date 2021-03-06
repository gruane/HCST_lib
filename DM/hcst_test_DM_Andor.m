%{
Script to test the hcst_[...] functions
******************************************************
This script runs through the hcst_[...] functions to check that they are
working correctly. It basically calls the individual test functions
associated with each device.
******************************************************
%}

clear; close all;
addpath(genpath('/home/hcst/HCST_lib/'));

%% Create and populate bench struct
fprintf("\n___Creating 'bench' struct\n")
bench = hcst_config();
% bench = hcst_setUpBench(bench);
fprintf("___'bench' struct created successfully\n\n")

hcst_setUpAndor(bench);

%% Call Andor test function

tint = 0.1;

hcst_andor_setExposureTime(bench,tint);
cropim = false;
numImages = 1;
for imnum = 1:numImages
im0 = hcst_andor_getImage(bench);


[rows,cols] = size(im0);
centx = 1297;
centy = 1168; 
cropsize = 128;

croprows = centy-cropsize/2+1:centy+cropsize/2;
cropcols = centx-cropsize/2+1:centx+cropsize/2;

% figure;
% imagesc(double(im(croprows,cropcols))/2^16);
% axis image; 
% colorbar;

figure(1);
if(cropim)
    imagesc(double(im0(croprows,cropcols))/2^16);
else
    imagesc(double(im0)/2^16);
end
axis image; 
colorbar;
pause(1)
end

%% Fire up DM

hcst_setUpDM(bench);


%% Poke all actuators 


% Poke one actuator at a time
data = zeros(1,bench.DM.dm.size);
pokeValue = 0.3;

% % for k = 527-12:527+12
for k = 513:537
    flatvec = hcst_DM_flattenDM(bench, true);
    im0 = hcst_andor_getImage(bench);

    fprintf('Poking actuator %d of %d.\r', k, bench.DM.Nact)
	data(k) = pokeValue;
	BMCSendData(bench.DM.dm, data);
%     lut = 1:dm.size;
    %BMCSendDataCustomMapping(bench.DM.dm, data, bench.DM.lut);
	im = hcst_andor_getImage(bench);
    
    figure(1);
    imagesc(double(im)/2^16-double(im0)/2^16);
    axis image; 
    colorbar;
%     pause(1)
    
	data(k) = 0;
	BMCSendData(bench.DM.dm, data);
end

disp('Poke test complete.');


%% Flatten the DM

flatvec = hcst_DM_flattenDM(bench, true);

imflat = hcst_andor_getImage(bench);
maxImflat = max(imflat(:));

figure(1);
imagesc(double(imflat(croprows,cropcols))/2^16);
axis image; 
colorbar;
pause(1)

hcst_DM_zeroDM(bench);

imrelaxed = hcst_andor_getImage(bench);
maxImrelaxed = max(imrelaxed(:));

maxImflat/maxImrelaxed

figure(2);
imagesc(double(imrelaxed(croprows,cropcols))/2^16);
axis image; 
colorbar;
pause(1)


%%
hcst_cleanUpDM(bench);

hcst_cleanUpAndor(bench);

