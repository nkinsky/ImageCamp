function [pval,lefthitpct,righthitpct,bootleft,bootright] = bootsplit(session)
%[pval,lefthitpct,righthitpct,bootleft,bootright] = bootsplit(session)
%
%   Computes the percent hit rate of place cells with place fields on the
%   center stem for both left and right trials. Then compares the
%   difference between left and right hit rates to the difference between
%   trials with their left/right identity shuffled. 
%
%   INPUT:
%       session: Folder containing PlaceMaps.mat. 
%
%   OUTPUTS: 
%       pval: Nx1 vector containing the p-values of the permutation test
%       for each neuron. 
%
%       lefthitpct: Nx1 vector containing percent hit rate (number of times
%       neuron fired over number of visits) of each neuron. 
%
%       righthitpct: Same as lefthitpct, but for right turn trials.
%
%       bootleft: NxB (where B is the number of permutation iterations)
%       containing the hit rates for each neuron on left trials, run on
%       shuffled data. 
%
%       bootright: Same as bootleft, but for right trials. 
%

%% Sort trials.
    load(fullfile(session,'PlaceMaps.mat'),'x','y'); 
    Alt = postrials(x,y,0,'skip_rot_check',1,'suppress_output',1);
   
%% Find splitters. 
    [lefthitpct,righthitpct] = splitter2(session,Alt);                  %Find hit rates for each neuron. 
    splitdiff = abs(righthitpct - lefthitpct);                          %Take the difference between hit rates in left vs. right. 
        
%% Useful parameters.
    B = 1000;                               %Number of iterations.
    num_stem_cells = length(lefthitpct);    %Number of neurons active on the stem.
    
    %Preallocate. 
    bootleft = zeros(num_stem_cells,B);      
    bootright = zeros(num_stem_cells,B); 
    bootdiff = zeros(num_stem_cells,B);
    pval = nan(num_stem_cells,1); 
    
%% Run B iterations of permutation tests, shuffling left/right trials. 
    parfor i=1:B
        Alt_shuf = shuff_trials(Alt); 
        
        [bootleft(:,i),bootright(:,i)] = splitter2(session,Alt_shuf);   %Find hit rates for each neuron. 
        bootdiff(:,i) = abs(bootright(:,i) - bootleft(:,i));            %Take the difference between hit rates in left vs. right. 
    end
    
%% Get statistically significant splitters.
    for this_neuron = 1:num_stem_cells
        if length(unique(bootdiff(this_neuron,:))) > 1;                 %Only take the p-value if there are at least two possible outcomes for bootdiff. 
            pval(this_neuron) = sum(bootdiff(this_neuron,:) < splitdiff(this_neuron))/B; 
        end
    end
    
    pval = 1 - pval; 
    
    %Save. 
    save Splitters.mat pval; 
end