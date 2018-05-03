function [ h, delta_mean, arena_rot, p, ncells, coh_ratio ] = ...
    plot_delta_angle_hist(sesh1, sesh2, map_sesh, varargin)
%  [ h, delta_mean, arena_rot, p, ncells, coh_ratio ] = ...
%       plot_delta_angle_hist( sesh1, sesh2, map_sesh, ...)
%   Plot histogram of all place field rotation angles between sessions.
%   Spits out axes handle, the circular mean of all pf rotations, 

ip = inputParser;
ip.addRequired('sesh1',@isstruct);
ip.addRequired('sesh2',@isstruct);
ip.addRequired('map_sesh',@isstruct);
ip.addParameter('circ2square', false, @islogical);
ip.addParameter('TMap_type', 'TMap_unsmoothed', @(a) ...
    strcmp(a,'TMap_unsmoothed') || strcmp(a,'TMap_gauss'));
ip.addParameter('h', gobjects(0), @(a) isempty(a) || ishandle(a));
ip.addParameter('bin_size', 4, @(a) all(a == 1) || all(a == 4)...
    || all(isnan(a)) || ischar(a)); % bin size for TMaps to use
ip.addParameter('PCfilter', false, @islogical); % include only place cells = true, include all = false
ip.addParameter('plot_arena_rot', true, @islogical);
ip.addParameter('nshuf',0,@isnumeric);
ip.addParameter('plot_legend',true, @islogical);
ip.addParameter('sig_thresh',0.05, @isnumeric); % significance thresh for p-value
ip.addParameter('hist_binsize', 22.5, @numeric); % Bin size for histograms

% cutoff for if pfs are considered coherent or no - also used to determine
% significance: count # pf rots < coh_ang_thresh away from mean and compare
% to shuffled values to determine significance
ip.addParameter('coh_ang_thresh', 22.5, @isnumeric); 
ip.addParameter('plot_flag', true, @islogical);
ip.parse(sesh1, sesh2, map_sesh, varargin{:});
circ2square = ip.Results.circ2square;
TMap_type = ip.Results.TMap_type;
bin_size = ip.Results.bin_size;
PCfilter = ip.Results.PCfilter;
nshuf = ip.Results.nshuf;
h = ip.Results.h;
sig_thresh = ip.Results.sig_thresh;
hist_binsize = ip.Results.hist_binsize;
coh_ang_thresh = ip.Results.coh_ang_thresh;
plot_flag = ip.Results.plot_flag;
plot_arena_rot = ip.Results.plot_arena_rot & plot_flag;
plot_legend = ip.Results.plot_legend & plot_flag;

% Calculate bins
edges = 0:hist_binsize:360;
centers = edges(1:(end-1)) + hist_binsize/2;

if isempty(h) && plot_flag
    figure; set(gcf,'Position', [2200 420 580 330]);
    h = gca;
end

sesh1 = complete_MD(sesh1); sesh2 = complete_MD(sesh2); % fill in data

% Load all the appropriate files
if circ2square; trans_append = '_trans'; else; trans_append = ''; end
map_sesh = complete_MD(map_sesh);
load(fullfile(map_sesh.Location,['batch_session_map' ...
    trans_append '.mat']));
batch_session_map = fix_batch_session_map(batch_session_map); %#ok<NODEF>
s1_ind = get_session_index(sesh1,batch_session_map.session);
s2_ind = get_session_index(sesh2,batch_session_map.session);

% Get the differences in PF angle and position between the two sessions
[delta_angle, delta_pos, pos1, ~, delta_angle_shuf] = get_PF_angle_delta(sesh1, ...
    sesh2, batch_session_map, TMap_type, bin_size, PCfilter, false, nshuf);

% Count how many neurons are detected on each day and how many are not
% active while the mouse is running on one day. This should be zero since
% it is fixed in get_PF_angle_delta, but keep it here just in case.
nan_bool = isnan(delta_angle);
% disp([num2str(sum(nan_bool)) ' NaN angles out of ' num2str(length(nan_bool))...
%     ' total: ' sesh1.Animal 'sesh ' num2str(s1_ind) 'v' num2str(s2_ind)])
delta_angle = delta_angle(~nan_bool); % Keep only good values
ncells = length(delta_angle);

% Calculate the mean rotation of the data
delta_mean = circ_rad2ang(circ_mean(circ_ang2rad(delta_angle)));
if delta_mean < 0; delta_mean = delta_mean + 360; end

% Debugging statement
if isnan(delta_mean)
    keyboard
end

% %%
% keyboard
%%

% Get arena rotation
[~, rot1] = get_rot_from_db(sesh1);
[~, rot2] = get_rot_from_db(sesh2);
arena_rot = rot2 - rot1;
if arena_rot < 0; arena_rot = arena_rot + 360; end

% Plot histogram into axes h
if plot_flag
    axes(h);
    hhist = histogram(delta_angle,edges); %#ok<NASGU>
    ylims = get(gca,'YLim');
    xlim([0 360]);
    xlabel('PF rotation'); ylabel('Count')
    hold on
    hCImean = gobjects(0);
end
%% Do shuffling and get p-value - look in the nbins closest bins to the median
% rot bin and sum up the counts for all shuffles and compare to actual data
nbins = 0; % # bins either side of median bin to include in p-value calc (2*binsize = 30 most likely);

% First, calculate # pf rotations close to mean in real data

% Get limits and account for values < 0 and > 360
count_lims = repmat([delta_mean-coh_ang_thresh, ...
    delta_mean+coh_ang_thresh],3,1) + [-360 0 360]'; 

% Make boolean of angles within the limits
ndata_bool = bw_bool(delta_angle, count_lims);
nmean_data = sum(ndata_bool); % sum them up.
coh_ratio = nmean_data/length(ndata_bool); % Get ratio of cells that are coherent

% pre-allocate for shuffling
shuf_count = nan(nshuf, length(edges)-1);
shuf_mean = nan(1,length(edges)-1);
shuf_CI = nan(2,length(edges)-1);
p = nan;
if nshuf > 0
    % Get shuffled data counts by bins
    for j = 1:nshuf
        shuf_count(j,:) = histcounts(delta_angle_shuf(:,j),edges);
    end
    % Calculate CI and mean of shuffled data
    shuf_CI = quantile(shuf_count,[0.025, 0.975],1);
    shuf_mean = mean(shuf_count,1);
    
    % Plot shuffled CIs and mean
    if plot_flag
        hCImean = plot(centers,shuf_CI,'k--',centers,shuf_mean,'k-');
    end
    % Calc p-value
    % Bin Method (kept for legacy purposes but commented)
%     ix = findclosest(delta_mean,centers);
%     bins_sum = (ix-nbins):(ix+nbins);
%     bins_sum(bins_sum < 1) = bins_sum(bins_sum < 1) + length(centers);
%     bins_sum(bins_sum > length(centers)) = ...
%         bins_sum(bins_sum > length(centers)) - length(centers);
%     shuf_mean_sum = sum(shuf_count(:,bins_sum),2);
%     ndata_sum = sum(hhist.Values(bins_sum));
%     p = 1 - sum(ndata_sum > shuf_mean_sum)/nshuf; % bin method
    
    % Exact method: Get # pfs with rotations close to mean of actual data
    nshuf_bool = bw_bool(delta_angle_shuf, count_lims);
    nmean_shuf = sum(nshuf_bool,1);
    p = 1 - sum(nmean_data > nmean_shuf)/1000;
    
    if p < sig_thresh; p_str = '*'; else; p_str = ''; end
    
    ylims1 = get(gca,'YLim');
    text(30,ylims1(2)*0.9,[ p_str 'pshuf = ' num2str(p,'%0.1e')])
end

%% Method for calculating where 95% CI on ecdf crosses real data - seems
% way too conservative
% delta_angle_pad = cat(1,delta_angle,delta_angle-360,delta_angle+360);
% delta_diff = delta_angle_pad - delta_mean;
% delta_shuf_pad = cat(1,delta_angle_shuf,delta_angle_shuf-360,delta_angle_shuf+360);
% delta_shuf_diff = delta_shuf_pad - delta_mean;
% 
% delta_ap = delta_diff(delta_diff >= 0);
% delta_an = delta_diff(delta_diff <= 0);
% na_pos = histcounts(delta_ap,0:1:360);
% ap_cdf = cumsum(na_pos);
% na_neg = histcounts(abs(delta_an),0:1:360);
% an_cdf = cumsum(na_neg);
% ns_pos = nan(nshuf,360);
% ns_neg = nan(nshuf,360);
% exc = true(size(ap_cdf)); exc(1:10) = false;
% cross_p = zeros(1,nshuf); cross_n = zeros(1,nshuf);
% for j=1:nshuf
%     shuf_use = delta_shuf_diff(:,j);
%     delta_shufp = shuf_use(shuf_use >= 0);
%     np_shuf = histcounts(delta_shufp,0:1:360);
%     np_shuf_cdf = cumsum(np_shuf);
%     cross_p(j) = find(ap_cdf-np_shuf_cdf < 0 & exc,1,'first');
%     
%     delta_shufn = shuf_use(shuf_use <= 0);
%     nn_shuf = histcounts(abs(delta_shufn),0:1:360);
%     nn_shuf_cdf = cumsum(nn_shuf);
%     cross_n(j) = find(an_cdf-nn_shuf_cdf < 0 & exc,1,'first');
% end
% 
% % Seems to be not conservative enough - not crossing until like 130
% % degrees!

%% Plot optional things (arena_rot, legend)
hrot = gobjects(0);
if plot_arena_rot
    hrot = plot([arena_rot arena_rot], ylims, 'r--');
end
if plot_legend
    if nshuf > 0
        legend(cat(1,hCImean([1,3]), hrot), ...
            {'Shuf. 95% CI','Shuf. mean','Arena rot.'})
    elseif nshuf == 0
        legend(hrot,'Arena rot.')
    end
end

% Get values for inserting into plots
sesh1_ind = get_session_index(sesh1, batch_session_map.session);
sesh2_ind = get_session_index(sesh2, batch_session_map.session);
mouse = sesh1.Animal;
envs = {'sq', 'oct'};
sesh1_env = envs{isempty(regexpi(sesh1.Env,'square')) + 1};
sesh2_env = envs{isempty(regexpi(sesh2.Env,'square')) + 1};

if plot_flag
    title([mouse_name_title(mouse) ': ' sesh1_env num2str(sesh1_ind)...
        ' v ' sesh2_env  num2str(sesh2_ind)])
end

end

