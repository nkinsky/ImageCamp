function [ shuf_corrs ] = shuffle_PVcorrs( PV1, PV2, num_shuffles, shuf_type )
% shuf_corrs = shuffle_PVcorrs( PV1, PV2, num_shuffled, shuf_type )
%   Calculated shuffled correlations (Spearman) between two PVs. shuf_type
%   = 'bin' or 'neuron' to shuffle spatial bins or neuron identities
%   between sessions, respectively (NOTE: 'bin' only is currently
%   supported). Default is also to exclude bins with no occupancy.  Will
%   need to revise hard code below if you want to change this.
%% Process optional arguments & assign defaults
if nargin < 4
    shuf_type = 'bin';
    if nargin < 3
        num_shuffles = 100;
    end
end

[nx,ny,nn] = size(PV1); % get number of bins in each direction and num_neurons
nbins = nx*ny;
%% Run it

shuf_corrs = nan(nx*ny,num_shuffles); % pre-allocate
switch shuf_type
    case 'bin'
        PV1a = reshape(PV1,nx*ny,nn); % Reshape to num_bins x num_neurons array
        for j = 1:num_shuffles
            PVshuf = shuffle_PVbin(PV2, true); % Shuffle spatial bin
            PVshufa = reshape(PVshuf,nx*ny,nn); % Reshape to num_bins x num_neurons array
            parfor k = 1:nbins
                shuf_corrs(k,j) = corr(PV1a(k,:)',PVshufa(k,:)','type','Spearman',...
                    'rows','complete');
            end
        end
        shuf_corrs = reshape(shuf_corrs,nx,ny,num_shuffles);
    otherwise
        error('non-supported shuffle type')
end


end

