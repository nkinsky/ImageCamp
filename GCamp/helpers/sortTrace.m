function [ trace_sort, sort_ind ] = sortTrace(PSAbool,trace, NeuronPixelIdxList)
% [ trace_sort, trace_nb_sort] = sortTrace(PSAbool,trace,... )
%   Sorts raw traces based on their initial recruitment time in PSAbool.
%   If the optional 3rd argument, NeuronPixelIdxList, is specified, an
%   additional sorted array containing only well isolated neurons (i.e.
%   those that don't overlap with any other ROIs) is also calculated
%   
%   INPUTS:
%
%   PSAbool: a boolean array of putative spiking events.  Rows = neurons,
%   columns = frames.
%
%   trace: An array of calcium traces.  Sam size as PSAbool
%
%   NeuronPixelIdxList (optional): From FinalOutput.mat.  A list of the 
%   pixel indices for each neuron ROI (used to identify buddy neurons). If
%   left blank


%% ID buddies if specified
if nargin == 3
    % Get buddies
    disp('Finding buddy neurons')
    buddy_bool = find_buddies(NeuronPixelIdxList);
    nobuddy_bool = ~any(buddy_bool,2);
    
    % sort PSA with no buddy neurons included
    PSA_nb = PSAbool(nobuddy_bool,:);
    trace_nb = trace(nobuddy_bool,:);
    [~, nb_sort_ind] = sortPSA(PSA_nb);
    
    % Apply to the trace
    trace_nb_sort = trace_nb(nb_sort_ind,:);
    
    trace_sort = trace_nb_sort;
    sort_ind = nb_sort_ind;
    
elseif nargin == 2
    
    [~, sort_ind] = sortPSA(PSAbool);
    trace_sort = trace(sort_ind,:);     
    
end

%% Calculate ALL neuron locations




end

