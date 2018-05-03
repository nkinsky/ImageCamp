function [ p, hhist, hshuf_CI, hshuf_mean ] = twoenv_plot_entry_hist( delta_theta_v_pfrot, ...
    delta_theta_shuf, binsize, h, plot_shuf)
% [ p, hhist] = twoenv_plot_entry_hist( delta_theta_v_pfrot, delta_theta_shuf, ...
%       nbins, h )
%   Plots a polar histogram of theta_x - theta_pf with binsize and with
%   shuffled confidence intervals. Spits out axes handle and...
%   pval = 1 - #(delta_theta count = 0 > #shuf_theta_count = 0)/ # shuf
%   x = entry side, entry_direction, or entry_dir, in degrees

if nargin < 5
    plot_shuf = true;
end
    
bin_size_rad = circ_ang2rad(binsize);
edges_rad = -bin_size_rad/2:bin_size_rad:(2*pi()-bin_size_rad/2);
edges_deg = circ_rad2ang(edges_rad);

nbins = length(edges_deg)-1;
%% Plot histogram
axes(h)
hhist = polarhistogram(circ_ang2rad(delta_theta_v_pfrot(:)),edges_rad);
hold on

%% Get and plot shuffled value CIs
nshuf = size(delta_theta_shuf,3);
p = nan;

% Get histogram of shuffled values for each and calculate p-value
shuf_n = nan(nshuf,length(edges_deg)-1);
ndata = histcounts(delta_theta_v_pfrot, edges_deg);
for j = 1:nshuf
    shuf_use = delta_theta_shuf(:,:,j);
    shuf_n(j,:) = histcounts(shuf_use(:), edges_deg);
end
p_allbins = 1 - sum(ndata > shuf_n)/nshuf;
p = p_allbins(1);


% Get 95% CIs for each bin
CI = nan(2, nbins);
shuf_mean = nan(1,nbins);
for k = 1:size(shuf_n,2)
    bin_n = shuf_n(:,k);
    [f,x] = ecdf(bin_n);
    CI(1,k) = x(findclosest(0.025,f));
    CI(2,k) = x(findclosest(0.975,f));
    shuf_mean(k) = mean(bin_n);
end

if plot_shuf
    
    CI_plot = [CI CI(:,1)];
    shuf_mean_plot = [shuf_mean, shuf_mean(1)];
    theta_plot = circ_ang2rad(edges_deg + binsize/2);
    hold on
    % NK debug here
    hshuf_CI = polarplot(theta_plot,CI_plot(1,:),'k--');
    polarplot(theta_plot,CI_plot(2,:),'k--')
    hshuf_mean = polarplot(theta_plot,shuf_mean_plot,'k-');
end

end

