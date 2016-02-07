function [] = delay_pilot_TMap_compare(continuous_sesh, delay_sesh, filter_use,varargin)
% delay_pilot_TMap_compare(continuous_sesh, delay_sesh, filter_use)
% Plot TMaps for continuous v delay and compare to continuous within
% session
%
% continuous_sesh and delay_sesh are sessions from MakeMouseSessionList
% that you wish to use.  They must come from the same recording session and
% have the same number of neurons, but should be of different block types
% (e.g. continous vs. delay). 
%
% filter_use is a vector of neuron numbers that you wish to include
%
%
% varargins: 
% - 'disp_iffr': display in-field firing rate - must be followed
%           by output PFhits and PFiffr from function IFFR_Sam, e.g.
%            ...'disp_iffr',PFhits,PFiffr,...
% 
% - % 'plot_type': 1 (default) = scroll through each neuron for visual 
%           inspection
%           2 = run through and save each plot to the continuous_sesh
%           directory.  Must list the working directory you wish to save
%           the plots in (suggest NOT using the one with all your MATLAB
%           variables as this will blow up that folder).  e.g.
%           ...'plot_type', 2, [pwd filesep 'plot_folder'],...

%% Get varargins
plot_type = 1; % default
PFhits = []; % default
PFiffr = []; % default
PFpasses = []; % default
disp_iffr = 0; % default
for j = 1:length(varargin)
   if strcmpi('disp_iffr',varargin{j})
       disp_iffr = 1; % plot flag
       % Get and calculate all required values for plotting
       PFhits = varargin{j+1};
       PFiffr = varargin{j+2};
       PFpasses = round(PFhits*100./PFiffr);
   end
   if strcmpi('plot_type',varargin{j})
      plot_type = varargin{j+1}; 
      plot_folder = varargin{j+2};
   end
end

session_use = continuous_sesh; % Continuous block(s)
session_use(2) = delay_sesh; % Delay block(s)

% Load relevant variables from each session
ChangeDirectory_NK(session_use(1));
load('PlaceMaps.mat', 'RunOccMap', 'TMap_gauss', 'pval','x','y','t','FT');
load('PFstats','PFpcthits');
TMap_continuous = TMap_gauss;
RunOccMap_continuous = RunOccMap;
pcthits_continuous = max(PFpcthits,2);
pval_continuous = pval;

ChangeDirectory_NK(session_use(2));
load('PlaceMaps.mat', 'RunOccMap', 'TMap_gauss', 'pval');
load('PFstats','PFpcthits');
TMap_delay = TMap_gauss;
RunOccMap_delay = RunOccMap;
pcthits_delay = max(PFpcthits,2);
pval_delay = pval;

% Above way of getting pcthits is a hack - using IFFR from Sam's script is
% better!
if disp_iffr == 1
    pcthits_continuous = max(PFiffr(:,:,1),[],2);
    pcthits_delay = max(PFiffr(:,:,2),[],2);
end

% % filter neurons - keep ones that have ok pval in either session
% neuron_use_either = find(pval_continuous > (1 - pval_thresh) | ...
%     pval_delay > (1-pval_thresh));

%% scroll through and plot everything

neurons_to_plot = filter_use; 

h1 = figure(501); 
cm = colormap('jet');
for j = 1:length(neurons_to_plot) 
    clf
    % Scale each TMap to reflect pcthits
    TMap_cont_scale = scale_TMap_rough(TMap_continuous{neurons_to_plot(j)},...
        pcthits_continuous(neurons_to_plot(j)));
    TMap_delay_scale = scale_TMap_rough(TMap_delay{neurons_to_plot(j)},...
        pcthits_delay(neurons_to_plot(j)));
    
    cmax = max([TMap_cont_scale(:); TMap_delay_scale(:)]);
    cmin = min([TMap_cont_scale(:); TMap_delay_scale(:)]);
    
    % Make non-occupied spots white
    [~, TMap_cont_nan] = make_nan_TMap(RunOccMap_continuous,...
        TMap_cont_scale); % Continuous blocks
    [~, TMap_delay_nan] = make_nan_TMap(RunOccMap_delay,...
        TMap_delay_scale); % Delayed blocks
    
    corr_plot(j) = corr(TMap_continuous{neurons_to_plot(j)}(:),...
        TMap_delay{neurons_to_plot(j)}(:)); % Get correlation value
    
%     % Make non-occupied spots white - continuous by block 
%     for k = 1:2
%         [~, TMap_cont_half_nan{k}] = make_nan_TMap(RunOccMap,...
%             TMap_cont_half(k).TMap_gauss{neurons_to_plot(j)}); 
%     end
    
    subplot(6,1,[1 2]); 
    imagesc_nan(rot90(TMap_cont_nan,1), cm, [1 1 1], [cmin, round(cmax,1)]);
    colorbar('Ticks', [cmin, round(cmax,1)]); % Add colorbar
    title(['Continuous - neuron ' num2str(neurons_to_plot(j)) ...
        ' with correlation = ' num2str(corr_plot(j),'%.2f')])

    subplot(6,1,[3 4]); 
    imagesc_nan(rot90(TMap_delay_nan,1), cm, [1 1 1], [cmin, round(cmax,1)]);
    colorbar('Ticks', [cmin, round(cmax,1)]); % Add colorbar
    title(['Delayed - neuron ' num2str(neurons_to_plot(j))])
    
    trans_train = logical(FT(neurons_to_plot(j),:));
    
    subplot(6,1,[5 6])
    plot(t,x,'b',t(trans_train),x(trans_train),'r*');
    xlabel('time (s)'); ylabel('x position (cm)');
    legend('Trajectory','Ca Transients');
    
    if disp_iffr == 1
        %%% ADD TEXT FOR IFFR %%% - note that these are only work well for
        %%% Nat's computer setup currently - may need to tweak for your own...
        % Create textbox
        
        % If there are multiple place-fields, identify which one has the
        % maximum IFFR in EITHER condition
        
        ii = find(max(PFiffr(neurons_to_plot(j),:)) ...
            == PFiffr(neurons_to_plot(j),:,:)); % Get index of max IFFR
        [~, max_field_num, ~] = ind2sub(size(PFiffr(neurons_to_plot(j),:,:)),ii); %Pull-out which field_number it is
        
        if any(PFiffr(neurons_to_plot(j),:))
            
            try
                annotation(figure(h1),'textbox',...
                    [0.013 0.80 0.093 0.05],...
                    'String',{['IFTL = ' num2str(PFiffr(neurons_to_plot(j),max_field_num,1),'%.2f')],...
                    ['( ' num2str(PFhits(neurons_to_plot(j),max_field_num,1)) ' hits / '], ...
                    [ num2str(PFpasses(neurons_to_plot(j),max_field_num,1)) ' passes)']},...
                    'FitBoxToText','on');
                
                % Create textbox
                annotation(figure(h1),'textbox',...
                    [0.013 0.51 0.093 0.05],...
                    'String',{['IFTL = ' num2str(PFiffr(neurons_to_plot(j),max_field_num,2),'%.2f')],...
                    ['( ' num2str(PFhits(neurons_to_plot(j),max_field_num,2)) ' hits / '], ...
                    [ num2str(PFpasses(neurons_to_plot(j),max_field_num,2)) ' passes)']},...
                    'FitBoxToText','on');
            catch
                disp('Annotation error-catching enabled')
                keyboard
            end
        else
            disp(['Error in ' num2str(neurons_to_plot(j)) ' PFiffr'])
        end
    
    end
    
%     subplot(6,1,6)
%     plot(t,y,'b',t(trans_train),y(trans_train),'r*');
%     xlabel('time (s)'); ylabel('y position (cm)');
%     legend('Trajectory','Ca Transients');
%     
%     half_name = {'1st','2nd'};
%     for k = 1:2
%         subplot(2,2,2+k)
%         imagesc_nan(TMap_cont_half_nan{k},dm,[1 1 1]);
%         title(['Continuous ' half_name{k} ' - neuron ' num2str(neurons_to_plot(j))])
%     end
%     
    if plot_type == 1
        waitforbuttonpress;
    elseif plot_type == 2 % Save all stuff to PDFs

%         print(fullfile(plot_folder,['Neuron #',num2str(neurons_to_plot(j))]),'-dpdf'); % formatting for this sucks
        export_fig(fullfile(plot_folder,['Neuron #',num2str(neurons_to_plot(j))]),'-pdf')
end

end