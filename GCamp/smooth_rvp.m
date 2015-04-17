function [ rvp_smooth ] = smooth_rvp( rvp_raw, smooth_adj )
% rvp_smooth  = smooth_rvp( rvp_raw, smooth_adj )
%   Smooths reverse placefield data.
%
%   INPUTS
%   rvp_raw: cell with rvps for each occupancy bin
%   smooth_adj: number of adjacent bins you wish to use for smoothing.
%   e.g. a value of 1 takes the 8 bins surrounding a given bin and averages
%   them
%   
%   OUTPUTS
%   rvp_smooth: smoothed rvps the same size as rvp_raw

NumXBins = size(rvp_raw,2);
NumYBins = size(rvp_raw,1);
for i = 1:NumXBins
        for j = 1:NumYBins
            % Get adjacent bins to smooth
            [ind_near_bins] = get_nearest_indices(j, i, ...
                NumYBins, NumXBins, smooth_adj);
            % Set up counters
            temp = zeros(size(rvp_raw{j,i})); nn = 0;
            % Do the actual smoothing
            for k = 1:length(ind_near_bins)
               temp(:) = nansum([temp(:) rvp_raw{ind_near_bins(k)}(:)],2);
               nn = nn + ~isnan(sum(rvp_raw{ind_near_bins(k)}(:))); % Adds to counter only if the RVP is not NaN
            end
            
            rvp_smooth{j,i} = temp/nn; % get average
            
            % Make sure appropriate frames get sent back to NaN if they
            % started like that - don't let smoothing making them ok
            if isnan(sum(rvp_raw{j,i}(:)))
                rvp_smooth{j,i}(:) = NaN*ones(size(rvp_raw{j,i}(:)));
            end
        end


end

