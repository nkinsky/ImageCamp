function [ DI, active_cells, DIfull ] = get_discr_ratio( PV1, PV2 )
% [DI, active_cells, DIfull] = get_discr_ratio( PV1, PV2 )
%   Get discrimination ratio for all cells in a given population vector.  
%   DI = (FR1-FR2)/(FR1+FR2) for each cell.
%   PV = FR of all cells

% keyboard

active_cells = (PV1 ~= 0 | PV2 ~= 0); % exclude cells that are inactive in both PV1 and PV2

PV1_use = PV1(active_cells);
PV2_use = PV2(active_cells);

DI = (PV1_use - PV2_use)./(PV1_use + PV2_use);

DIfull = nan(size(PV1));
DIfull(active_cells) = DI;

end