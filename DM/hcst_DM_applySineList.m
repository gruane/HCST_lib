function [fullcmds1D,diffCmds2D] =  hcst_DM_applySineList( bench, spatFreq_rs, spatFreq_qs, PTVs, phzs )
%cmds = hcst_DM_applySineList( bench, spatFreq_rs, spatFreq_qs, PTVs, phzs  )

    if(any(isnan(spatFreq_rs)));error('Nan sent to DM');end
    if(any(isnan(spatFreq_qs)));error('Nan sent to DM');end
	if(any(isnan(PTVs)));error('Nan sent to DM');end
    if(any(isnan(phzs)));error('Nan sent to DM');end

    flatvec = bench.DM.flatvec;
    NactAcross = bench.DM.NactAcross;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    
    xs = (1:NactAcross)-(NactAcross+1)/2;
    [XS,YS] = meshgrid(xs);
    [THETA,RHO] = cart2pol(XS,YS);
    
    % Note: we should error check that all four arrays are same length.
    
    ripples = zeros(size(RHO));
    
    for ii = 1:length(spatFreq_rs)
        spatFreq_q = spatFreq_qs(ii);
        spatFreq_r = spatFreq_rs(ii);
        PTV = PTVs(ii);
        phz = phzs(ii);

        %ripple = PTV*(0.5*sin(2*pi*RHO.*cos(THETA-spatFreq_q/180*pi)*spatFreq_r/NactAcrossBeam - phz)+0.5);
        ripple = PTV*sin(2*pi*RHO.*cos(THETA-spatFreq_q/180*pi)*spatFreq_r/NactAcrossBeam - phz);
        %figure;imagesc(ripple);axis image;colorbar;
        
        ripples = ripples + ripple;
    
    end
    diffCmds2D = ripples;% Output 2D commands added to current map
    
    
%     ripples = (ripples);
    ripples = flipud(ripples');
    
	data = hcst_DM_2Dto1D(bench,ripples);

	cmds = data+flatvec;
    
    fullcmds1D = cmds;% Output 1D commands sent to DM
    
    if(any(isnan(cmds)));error('Nan sent to DM');end
    if(~isreal(cmds));error('Complex num sent to DM');end
    if(~isnumeric(cmds));error('non-number sent to DM');end
    
    err_code = BMCSendData(bench.DM.dm, cmds);
    if(err_code~=0)
        eString = BMCGetErrorString(err_code);
        error(eString);
    end

    
end

