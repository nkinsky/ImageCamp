function [leftpcthit,rightpcthit,lefthits,righthits] = splitter2(session,Alt)
%[lefthitpct,righthitpct,lefthits,righthits] = splitter2(session,Alt)
%
%   Takes place fields and sorted alternation data and computes the hit
%   rates per neuron that has a PF on the stem for left/right trials. 
%
%   INPUTS:
%       session: folder containing PlaceMaps.mat and PFstats.mat. 
%
%       Alt: sorted alternation data from postrials.m. 
%
%   OUTPUTS:
%       lefthitpct: Nx1 vector (where N is the number of neurons with a PF
%       on the stem) containing the percent hit rates for each neuron for
%       all left trials. Percent hit rate is the ratio of the number of
%       times that neuron was active over the number of visits.
%
%       righthitpct: Same as lefthitpct, but for right trials. 
%
%       lefthits: Raw number of hits for each neuron for left trials.
%
%       righthits: Same as lefthits, but for right trials. 
%

%%
    [cell_ind,PF_ind] = FindStemPFs(session,1); 
    load(fullfile(session,'PFstats.mat'),'PFepochs','PFpixels','PFnumepochs'); 
    load(fullfile(session,'PlaceMaps.mat'),'x','y','FT','TMap','Xbin','Ybin');
    
%% Useful parameters. 
    stem_cells = unique(cell_ind); 
    num_stem_cells = length(stem_cells); 
    loc_index = sub2ind(size(TMap{1}),Xbin,Ybin);
    lefthits = zeros(num_stem_cells,size(PFepochs,2)); 
    righthits = zeros(num_stem_cells,size(PFepochs,2)); 
    total_epochs = zeros(num_stem_cells,size(PFepochs,2)); 

%% Calculate PF hit rates sorted by trial type. 
    %For each neuron that is active on the stem...
    for this_neuron = 1:num_stem_cells
        neuronID = stem_cells(this_neuron);                                     %Get the neuron index.
        PFIDs = PF_ind(cell_ind == neuronID);                                   %Get the PF index. 
        num_stemPFs = length(PFIDs);                                            %Number of PFs for this neuron. 
        
        %For each of its PFs...
        for this_PF = 1:num_stemPFs
            PF_epochs = PFnumepochs(neuronID,PFIDs(this_PF));                   %Get number of epochs when the mouse is in PF. 
            stemPFpix = PFpixels{neuronID,PFIDs(this_PF)};                      %Get the pixels associated with this PF.
            total_epochs(this_neuron,this_PF) = PF_epochs;                      %Total number of epochs in this PF.
            
            %For each of the visits...
            for this_epoch = 1:PF_epochs
                epoch_ind = [PFepochs{neuronID,PFIDs(this_PF)}(this_epoch,1):...
                    PFepochs{neuronID,PFIDs(this_PF)}(this_epoch,2)]; 

                %If mouse is in PF and the neuron is firing... 
                if any(FT(neuronID,epoch_ind) == 1) && any(ismember(loc_index(epoch_ind),stemPFpix)); 
                    if unique(Alt.choice(epoch_ind)) == 1
                        lefthits(this_neuron,this_PF) = lefthits(this_neuron,this_PF) + 1; 
                    elseif unique(Alt.choice(epoch_ind)) == 2
                        righthits(this_neuron,this_PF) = righthits(this_neuron,this_PF) + 1; 
                    end
                end
            end
        end
    end
   
    %Get percent hit rate (number of times place cell was active in its PF
    %divided by the number of visits). 
    leftpcthit = lefthits.*100./total_epochs; leftpcthit = nanmean(leftpcthit,2);
    rightpcthit = righthits.*100./total_epochs; rightpcthit = nanmean(rightpcthit,2);
    
end