function [tuning_curve, sig_obj_tuning] = plot_NO_PETH( PETH_out, PSA_mean_shuffle, cell_no, num_shuffles, hfig, plot_flag )
% [tuninv_curve, active_thresh_pass] = plot_NO_PETH( PETH_out, PSA_mean_shuffle, cell_no, num_shuffles, hfig, plot_flag )
%    Plots a PETH raster with tuning curves and significant epochs in stars.
%    Does double duty and spits out tuning curve for each cell and whether
%    or not it was significant or not.

if nargin < 4
    num_shuffles = 100;
    hfig = figure;
    plot_flag = true;
end

if plot_flag; figure(hfig); end

imageSR = 20;
frame_buffer = (size(PETH_out{1},3)-1)/2*[1 1];
plot_color = {'b.', 'r.'}; plot_color2 = {'b'; 'r'}; plot_color3 = {'b*','r*'};
clength = 5; % # frames to smooth with
legend_names = {'Object 1', 'Object 2'};
times_plot = (-frame_buffer:frame_buffer)/imageSR;
ratio_thresh = 0.33; % Cell must be active more than this ratio of trials to be considered and object cell

[~, nsamp, ~] = cellfun(@size, PETH_out); % Get number of samples for each object
j = cell_no;

subplot(5,1,1:4)
cla
hl = [];
PETH_plot = cell(1,2);
active_ratio = zeros(1,2);
start_row = 0;
for k = 1:2

    PETH_plot{k} = squeeze(PETH_out{k}(j,:,:));
    [PSA_trial, PSA_times] = find(PETH_plot{k});
    plot_row = start_row + PSA_trial;
    
    if plot_flag
        subplot(5,1,1:4)
        htemp = plot(times_plot(PSA_times), plot_row, plot_color{k});
        if ~isempty(htemp); hl(k) = htemp(1); end
        hold on
    end
    
    start_row = nsamp(1);
    active_ratio(1,k) = sum(any(PETH_plot{k},2))/size(PETH_plot{k},1);
    
end

if plot_flag
    plot([times_plot(1), times_plot(end)], [nsamp(1) + 0.5, nsamp(1) + 0.5],'k-')
    plot([0 0], [0 sum(nsamp)],'k:')
    
    hold off
    xlim([times_plot(1), times_plot(end)])
    ylim([0 sum(nsamp)]);
    set(gca,'YDir','reverse')
    title(['Neuron ' num2str(j)]);
    legend(hl(hl~= 0), legend_names(hl ~= 0))
    
    % Plot mean curve
    subplot(5,1,5)
    cla
end
shuf_mat = [];
tuning_curve = zeros(2,sum(frame_buffer)+1);
sig_epochs = false(2,sum(frame_buffer)+1);
active_thresh_pass = false(1,2);
sig_obj_tuning = false(1,2);
for k = 1:2
    if any(sum(PETH_plot{k},1)) && size(PETH_out{k}(j,:,:),2) > 4
        tuning_curve(k,:) = convtrim(mean(PETH_plot{k},1),ones(clength,1))/clength;
        if plot_flag
            plot(times_plot, tuning_curve(k,:), plot_color2{k});
            hold on
        end
    end
    %
    temp_shuf = squeeze(PSA_mean_shuffle(:,k,j,:));
    shuf_mat = [shuf_mat; temp_shuf]; %#ok<AGROW>
    active_thresh_pass(1,k) = active_ratio(1,k) > ratio_thresh;
    sig_epochs(k,:) = (sum((tuning_curve(k,:) - temp_shuf) > 0,1)/num_shuffles >=.99)...
        .*active_thresh_pass(1,k);
    if plot_flag
        plot(times_plot(sig_epochs(k,:)), tuning_curve(k,sig_epochs(k,:)), plot_color3{k})
    end
    % Cells that have at least 5 significant time points AND pass the active 
    % number of samples test are considered significant
    sig_obj_tuning(1,k) = active_thresh_pass(1,k) & (sum(sig_epochs(k,:)) > 5); 
end

if plot_flag
    std_use = std(shuf_mat,0,1);
    mu_use = mean(shuf_mat,1);
    plot(times_plot,mu_use+3*std_use,'k--');
    hold on;
    
    ylim([0 0.6])
end

end

