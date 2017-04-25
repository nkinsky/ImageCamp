function [ ] = NO_scroll_PF( sesh1_struct, other_structs, start_cell )
% NO_scroll_PF( sesh1_struct, other_structs, start_cell )
%   sesh1_struct is the first (habituation) day of a given experiment and
%   should be entered as MD(#).
%   other_structs are the 3 testing days for the same experiment.

if nargin < 3
    start_cell = 1;
end

sesh = cat(2,sesh1_struct, other_structs);
num_sessions = length(sesh);

aviSR = 30.0003;
%% Load Placefields for each session
curr_dir = cd;
for j = 1:num_sessions
   [dirstr, sesh_full] = ChangeDirectory_NK(sesh(j),1);
   load(fullfile(dirstr,'Placefields.mat'),'TMap_gauss','RunOccMap','PSAbool',...
       'isrunning','x','y','pval');
   sesh(j).TMap_gauss = TMap_gauss;
   sesh(j).pval = pval;
   sesh(j).ZeroMap = nan(size(RunOccMap));
   sesh(j).ZeroMap(RunOccMap ~= 0) = 0;
   sesh(j).PSAbool = PSAbool;
   sesh(j).x = x;
   sesh(j).y = y;
   sesh(j).isrunning = isrunning;
   load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool')
   [~,~,~,~,~,~,sesh(j).AVItime] = AlignImagingToTracking(sesh_full.Pix2CM,...
       PSAbool,0); % Get aviTimes corresponding to PSAbool in Placefields.mat
   try % Load a blank arena frame if the avi file isn't there
       pos_dir = fullfile(fileparts(dirstr),'cineplex');
       avi_file = ls(fullfile(pos_dir, '*.avi'));
       avi_file = fullfile(pos_dir, avi_file);
       vidObj = VideoReader(avi_file);
       sesh(j).arena_frame = readFrame(vidObj);
   catch
       sesh(j).arena_frame = nan;
       
   end
   load(fullfile(dirstr,'Pos.mat'),'xAVI','yAVI','AVItime_interp','time_interp');
   sesh(j).xAVI = xAVI;
   sesh(j).yAVI = yAVI;
   
   try
       [sesh(j).PETH, sesh(j).PETH_trace, sesh(j).trace_shuffle, sesh(j).sig_sum] = NO_PETH(sesh_full, 40, 'scroll_flag', false);
       sesh(j).PETHbool = true;
   catch
       sesh(j).PETHbool = false; % If no NO_tracking_final file present, don't do the PETH analysis
   end
end
cd(curr_dir);

% Load batch map
base_dir = ChangeDirectory_NK(sesh(1),0);
load(fullfile(base_dir,'batch_session_map.mat'));

NumNeurons = size(batch_session_map.map,1);

%% Plot them out

n = start_cell;
stay_in = true;
num_rows = size(sesh(1).TMap_gauss{1},2);
while stay_in
    for j = 1:num_sessions
        neuron_use = batch_session_map.map(n,j+1);
        
        subplot(4,4,j)
        if ~isnan(neuron_use) && neuron_use ~= 0
            imagesc_nan(rot90(sesh(j).TMap_gauss{neuron_use},1));
            title([mouse_name_title(sesh(j).Date) ' - neuron ' num2str(neuron_use) ])
            axis off
            text(1,num_rows,num2str(sesh(j).pval(neuron_use)))
        elseif neuron_use == 0
            imagesc_nan(rot90(sesh(j).ZeroMap,1));
            title([mouse_name_title(sesh(j).Date) ' - Neuron not active'])
            axis off
        elseif isnan(neuron_use)
            imagesc_nan(rot90(nan(size(sesh(j).ZeroMap)),1));
            title([mouse_name_title(sesh(j).Date) ' - Ambiguous neuron identity'])
            axis off
        end
        
        good_ind = find(sesh(j).isrunning); % get indices where the mouse was active
        if ~isnan(neuron_use) && neuron_use ~= 0
            PSAbool_ind = sesh(j).PSAbool(neuron_use,:); % get PS epochs for a given neuron
            PSA_ind_full = good_ind(PSAbool_ind); % get PS epochs for full session (not speed thresholded)
%             PSA_AVItime = AVItime_interp(PSA_ind_full); % get PS epochs in PSAtime
            PSA_AVItime = sesh(j).AVItime(PSA_ind_full);
            AVI_time_full = (1:1:length(sesh(j).xAVI))/aviSR; % get AVI times for full session
            PSA_AVIind = arrayfun(@(a) findclosest(a,AVI_time_full),PSA_AVItime); % get putative-spiking AVI indices
        else
            PSA_AVIind = [];
            PSAbool_ind = [];
        end
        
        % Plot trace PETHs at each object
        if sesh(j).PETHbool
            trace_out = sesh(j).PETH_trace;
            shuf_out = sesh(j).trace_shuffle;
            sig_sum = sesh(j).sig_sum;
            ylims = nan(2,2);
            if ~isnan(neuron_use) && neuron_use ~= 0
                for k = 1:2
                    ax(k) = subplot(4,4,8+4*(k-1)+j);
                    
                    trace_plot = squeeze(trace_out{k}(neuron_use,:,:));
                    frames_plot = (1:length(trace_plot));
                    times_plot = (frames_plot - mean(frames_plot))/20;
                    
                    baseline = nanmean(trace_plot,2);
                    mean_trace = nanmean(trace_plot - baseline,1);
                    h_ind = plot(times_plot,(trace_plot - baseline),'r:');
                    
                    % Calculate shuffled mean
                    shuf_plot = squeeze(shuf_out{k}(neuron_use,:,:));
                    baseline = nanmean(shuf_plot,2);
                    mean_shuf = nanmean(shuf_plot - baseline,1); % Better would be to plot 95% CI for this and plot over that
                    
                    sig_use = logical(squeeze(sig_sum(k,neuron_use,:))); % Gets pts that are significantly above the shuffled curve
                    
                    hold on
                    h_mean = plot(times_plot, mean_trace,'k', times_plot(sig_use), mean_trace(sig_use), 'k*');
                    h_shuf = plot(times_plot, mean_shuf, 'b--');
                    hold off
                    if k == 2; xlabel('Time from object sample (s)'); end
                    ylabel('Fluorescence (au)')
                    title(['Object ' num2str(k)])
                    ylims(k,:) = get(gca,'YLim');
%                     if n == 3 && j == 4
%                         keyboard
%                     end
                end
                
                for k = 1:2
                    set(ax(k),'YLim',[min(ylims(:,1)), max(ylims(:,2))])
                    %                 subplot(4,4,8+4*(k-1)+j)
                    %                 ylim([min(ylims(:,1)), max(ylims(:,2))])
                end
            else % Overwrite plots so that you don't get previous cell activity here.
                for k = 1:2
                    subplot(4,4,8+4*(k-1)+j);
                    imagesc_nan(nan(5,5));
                    axis off
                end
            end
        end
        
        % Plot trajectory
        subplot(4,4,4+j)
        imagesc(flipud(sesh(j).arena_frame))
        hold on
        plot(sesh(j).xAVI,sesh(j).yAVI,'b',sesh(j).xAVI(PSA_AVIind),sesh(j).yAVI(PSA_AVIind),'r.')
        set(gca,'YDir','normal')
        hold off
        axis off

    end
    [n, stay_in] = LR_cycle(n,[1 NumNeurons]);
end


end

