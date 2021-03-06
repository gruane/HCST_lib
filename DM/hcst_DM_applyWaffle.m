function [fullcmds1D,diffCmds2D] = hcst_DM_applyWaffle( bench, wfl_spatFreq, wfl_ang, PTV )
%cmds = hcst_DM_applyWaffle( bench, wfl_spatFreq, wfl_ang, PTV, phzs )

    [fullcmds1D,diffCmds2D] = hcst_DM_applySineList( bench, [wfl_spatFreq wfl_spatFreq], [wfl_ang wfl_ang-90], [PTV PTV], [0 0] );
    
end

