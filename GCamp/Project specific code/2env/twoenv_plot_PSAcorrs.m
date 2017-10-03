function [hcb ] = twoenv_plot_PSAcorrs(PSAbool, corrs_use, hax )
% twoenv_plot_PSAcorrs(PSAbool, corrs_use, hax )
%   The goal is to plot PSAbool sorted with neurons color coded by their
%   correlations in another session.  Start with just connected sessions
%   for ease, maybe move to other sessions afterward (what does this get
%   at? Do coherent cells come online earlier/later?)

if nargin < 3
    figure; hax = gca;
end
% cmap = colormap('jet');

% [~, edges] = histcounts(corrs_use, size(cmap,1));
% 
% PSA_use = repmat(PSAbool,[1,1,3]);
% num_neurons = size(PSAbool,1);
% for j = 1:num_neurons
%     if isnan(corrs_use(j))
%         continue
%     end
% %     bin_log = edges(1:end-1) < corrs_use(j) & corrs_use(j) <= edges(2:end);
% %     for k = 1:3
% %     PSA_use(j,:,k) = cmap(bin_log,k)*PSA_use(j,:,k);
% %     end
% 
% end

%% Assign each neuron its correlation value for each PSE for later color coding
num_neurons = size(PSAbool,1);
PSA_use = double(PSAbool);
for j= 1:num_neurons
    if isnan(corrs_use(j))
        PSA_use(j,:) = PSA_use(j,:)*-1;
        continue
    end
    PSA_use(j,:) = PSA_use(j,:)*corrs_use(j);
end

% Sort the neurons by time of recruitment
PSA_use(~PSAbool) = nan; % Set false/zeros to nan to make white background later
[~, sort_ind] = sortPSA(PSAbool);
PSA_use = PSA_use(sort_ind,:);

% Plot it out!
axes(hax);
imagesc_nan(PSA_use); % colormap(cmap)
hcb = colorbar; hcb.Ticks = [min(corrs_use) 0 max(corrs_use)];
hcb.Label.String = 'Correlation';
title('Cell recruitment with correlations')
% keyboard

end

