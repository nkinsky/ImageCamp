function [ yvec_interp ] = lin_interp_vec( xvec, yvec, xvec_interp )
%lin_interp_vec Linearly interpolate position/speed data for an arbitrary
%length vector of values.

% Get appropriate time points to interpolate for each timestamp
xvec_index = arrayfun(@(a) [max(find(a >= xvec)) min(find(a < xvec))],...
    xvec_interp, 'UniformOutput',0);
xvec_interp_cell = arrayfun(@(a) a, xvec_interp,'UniformOutput',0);

yvec_interp = cellfun(@(a,b) lin_interp(xvec(a), yvec(a),...
    b), xvec_index, xvec_interp_cell);



end

