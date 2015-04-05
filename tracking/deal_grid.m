function [xgrid, ygrid] = deal_grid(xin,yin, ind)
%function [xgrid, ygrid] = deal_grid(xin,yin, ind) 
%   helper function for s_interp_position

xgrid = zeros(size(ind)); 
ygrid = zeros(size(ind));

xgrid(:) = xin(ind(:));
ygrid(:) = yin(ind(:));


end

