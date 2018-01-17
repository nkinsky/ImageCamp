function [ PVdiffs, PVdiffd, std_s, std_d ] = twoenv_connPVdelta( PVcorrs )
% [PVdiffs, PVdiffd, std_s, std_d ] = twoenv_connPV( PVcorrs )
%   Spits out deltaPVmean for connected days for the same day and across
%   days. Ditto for stdev of PVmean.

diff_bool = [checkerboard(1,2,2) > 0 checkerboard(1,2,2) == 0; ...
    checkerboard(1,2,2) == 0 checkerboard(1,2,2) > 0];
same_bool = [checkerboard(1,2,2) == 0 checkerboard(1,2,2) > 0; ...
    checkerboard(1,2,2) > 0 checkerboard(1,2,2) == 0];
same_bool(logical(eye(8))) = false;
same_day = true(8);
same_day(1:4,5:8) = false;
same_day(5:8,1:4) = false;

[PVdiffs, std_s] = twoenv_get_PVdiscrim(PVcorrs,same_bool & same_day,...
    diff_bool & same_day);
[PVdiffd,std_d] = twoenv_get_PVdiscrim(PVcorrs,same_bool & ~same_day,...
    diff_bool & ~same_day);


end

