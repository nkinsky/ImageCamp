function [ deltaPVmean, deltaPVstd ] = twoenv_get_PVdiscrim( PVcorr,same_bool,diff_bool )
% deltaPV = twoenv_get_PVdiscrim( PVcorr, same_ind, diff_ind )
% Gets change in PV between arenas versus within arena for all sessions in
% PVcorr.

PVsame = PVcorr(same_bool);
PVdiff = PVcorr(diff_bool);
deltaPVmean = mean(PVsame) - mean(PVdiff);
deltaPVstd = sqrt(var(PVsame) + var(PVdiff));

end

