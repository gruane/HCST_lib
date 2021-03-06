function [diffCmds2D,fullcmds1D] = hcst_DM_applySineProbe( bench, DM, w, ang, psi, PTV )
%[cmds2D,cmds1D] = hcst_DM_applyEFCprobe( bench, ProbeArea, psi, PTV, apply )
% Applies or returns Give'on style DM probes for EFC

    flatvec = bench.DM.flatvec;
    %offsetAct = bench.DM.offsetAct;
    
    Nact = bench.DM.NactAcross;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    % 459 is the central actuator

%     [XS,YS] = meshgrid(((1:Nact)-bench.DM.xc)/Nact,((1:Nact)-bench.DM.yc)/Nact);
    [XS,YS] = meshgrid(((1:Nact)-bench.DM.xc),((1:Nact)-bench.DM.yc));
    RHO = sqrt(XS.^2 + YS.^2);            %Matrix of element dist. from cent.
    TTA = atan2(XS,YS);                   %Matrix of element angle from cent.

%     offsetX = offsetAct(2);
%     offsetY = offsetAct(1);

%     offsetX = 0;
%     offsetY = 0;

    D = NactAcrossBeam / Nact;

    ang = ang*180/pi;
    wx = w*cos(ang);
    wy = w*sin(ang);
    
%     diffCmds2D = PTV*cos(2*pi*wx/D*XS + psi).*cos(2*pi*wy/D*YS);
    diffCmds2D = PTV*(1+cos(2*pi.*RHO.*cos(TTA-ang)/w+psi));
    figure(103)
    imagesc(diffCmds2D)
    axis image
    %
    diffCmds2D = falco_fit_dm_surf(DM,diffCmds2D);
    map =fliplr(diffCmds2D');
%     map = fliplr(rot90(diffCmds2D,1)); %JLlop Apr10, 2019
%     map = flipud(diffCmds2D'); %JLlop Apr10, 2019
    data = hcst_DM_2Dto1D(bench,map);
    
    fullcmds1D = data+flatvec;
    
    err_code = BMCSendData(bench.DM.dm, fullcmds1D);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end    
    

end

