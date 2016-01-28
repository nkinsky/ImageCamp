function [ TMap_roughscale ] = scale_TMap_rough(TMap_in, pcthits)
% TMap_roughscale = scale_TMap_rough(TMap, pcthits)
%  Takes an input TMap and roughly scales it so that the peak value in the
%  TMap corresponds to probability that a calcium transient occurs in that
%  pixel.  IMPORTANT NOTE: due to smoothing and the way the TMaps are
%  calculated, the probability will likely only be correct for the field with the
%  highest number of calcium transients, though this is not necessarily
%  true.  
%
% NEEDED follow-up: use calcmapdec to get an idea of the PF outline/area,
% then, for each field, put the number of transients in the center, then
% smooth, then scale, then add all the fields together so
% that each field gets the appropriate probability

max_val = max(TMap_in(:));

TMap_roughscale = TMap_in/max_val*pcthits;


end

