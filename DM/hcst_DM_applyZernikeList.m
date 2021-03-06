function [Zsum,cmds] = hcst_DM_applyZernikeList( bench, PTVs, apply )
%[Zsum,cmds] = hcst_DM_applyZernikeList( bench, PTVs, apply )
%Applies a list of Zernike polynomials to the DM.
% PTV vector looks like [cmd_Z4, cmd_Z5, ... ]

    flatvec = bench.DM.flatvec;
    %offsetAct = bench.DM.offsetAct;
    
    NactAcross = 34;
    NactAcrossBeam = bench.DM.NactAcrossBeam;
    % 459 is the central actuator
%     xs = (1:NactAcross)-(NactAcross+1)/2;
%     [XS,YS] = meshgrid(xs);
%     [THETA,RHO] = cart2pol(XS-offsetAct(1),YS-offsetAct(2));

    [XS,YS] = meshgrid((1:NactAcross)-bench.DM.xc,(1:NactAcross)-bench.DM.yc);
    [THETA,RHO] = cart2pol(XS,YS);

    Zsum = zeros(size(RHO));
    ii = 1;
    for noll_index = 4:(length(PTVs)+3)
        PTV = PTVs(ii);
        [ Z, n, m ] = generateZernike( noll_index, NactAcrossBeam/2+1, RHO, THETA  );
%         Z = sign(PTV)*Z;
%         Z = Z - min(Z(:));
%         Z = Z/max(Z(:));
%         Z = abs(PTV)*Z;
        Z(isnan(Z)) = 0;
        Zsum = Zsum + PTV*Z;
        ii = ii + 1;
    end
    
    data = hcst_DM_2Dto1D(bench,Zsum);
    
    cmds = data+flatvec;
    
    if(sum(cmds>0.9)>0)
        disp(['Large poke sent!!!:', num2str(max(cmds))]);
        
    end
    
    if(apply)
        err_code = BMCSendData(bench.DM.dm, cmds);
        if(err_code~=0)
            eString = BMCGetErrorString(err_code);
            error(eString);
        end
    end
    
    

end

