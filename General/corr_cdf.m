function [r,r_boot] = corr_cdf(TMap,sessions)
%[r,r_boot] = corr_cdfs(TMap,sessions)
%
%   Plots the CDF of the empirical R values found for each neuron when
%   comparing two sessions. Also plots a shuffled CDF of R values for
%   within-session shuffled neurons. 
%
%   INPUTS: 
%       TMap: Resized TMaps from plot_multisesh_alt.m
%
%       sessions: 2 element vector containig the session numbers which you
%       want to correlate. 
%
%   OUTPUTS: 
%       r: 1xN correlation coefficients (where N is the number of neurons
%       with a non-empty TMap across both sessions).
%
%       r_boot: BxN correlation coefficients (where B is the number of
%       shuffle iterations. 
%

%% Useful parameters. 
    num_cells = size(TMap,1); 
    num_sessions = 2; 
    [l,w] = cellfun(@size,TMap,'UniformOutput',false);
    sizing = max(max(cellfun(@max, l))).*max(max(cellfun(@max, w)));    %Total number of pixels. 
    B = 500; 

    %Preallocate.
    TMap_lin = nan(sizing,num_sessions,num_cells); 
    TMap_shuf = nan(sizing,num_sessions,num_cells); 
    good_neurons = []; 
 
%% Perform correlations on non-empty TMaps.  
    %Get the neurons that have good TMaps in both sessions. 
    for this_neuron = 1:num_cells
        good = ~isempty(TMap{this_neuron,sessions(1)}) && ~isempty(TMap{this_neuron,sessions(2)}); 
        
        if good
            good_neurons = [good_neurons, this_neuron]; 
        end
    end
    
    %Preallocate.
    num_good = length(good_neurons); 
    r = nan(1,num_good); 
    r_boot = nan(B,num_good); 
    
    %Do the correlations. 
    for this_neuron = 1:num_good
        neuron_ind = good_neurons(this_neuron); 
        r(this_neuron) = corr2(TMap{neuron_ind,sessions(1)}, TMap{neuron_ind,sessions(2)}); 
    end
            
%% Shuffle.
    parfor i = 1:B
        if mod(i,10) == 0
            disp(['Running shuffle #', num2str(i), '...']); 
        end
        shuffle_ind = randperm(num_good);
        
        for this_neuron = 1:num_good
            neuron_ind = good_neurons(shuffle_ind(this_neuron)); 
            
            %Do the correlations. 
            TMap1 = TMap{good_neurons(this_neuron),sessions(1)}; 
            r_boot(i,this_neuron) = corr2(TMap1,TMap{neuron_ind,sessions(2)}); 
        end
    end 
    
%% Plot CDFs. 
    [r_p,r_x] = ecdf(r); 
    
    figure;
        hold on;
        ecdf(r_boot(:), 'bounds', 'on');            %Shuffled.   
        plot(r_x,r_p,'k');                          %Empirical, nonshuffled
        hold off;
        
        title('Cumulative Distribution of Correlation Coefficients', 'fontsize', 12); 
        xlabel('R values', 'fontsize', 12); 
        ylabel('Proportion', 'fontsize', 12); 
        set(gca, 'ticklength', [0 0]); 
end