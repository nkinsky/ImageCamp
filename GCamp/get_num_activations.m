function [ num_activations, epoch_starts, epoch_ends ] = get_num_activations(FT)
%get_num_activations(FT) - gets the total number of calcium events for a
%set of cells whose activity is recorded in the array FT

num_ICs = size(FT,1);
cal_epochs = cell(num_ICs);
epoch_starts = cell(num_ICs);
epoch_ends = cell(num_ICs);
for j = 48:num_ICs
    cal_epochs{j} = find(FT(j,:) > 0);
    if isempty(cal_epochs{j})
        epoch_ends{j} = [];
        epoch_starts{j} = [];
        num_activations(j,1) = 0;
    else
    epoch_ends{j} = [cal_epochs(find(diff(cal_epochs{j}) > 1)) cal_epochs{j}(end) ];
    epoch_starts{j} = [cal_epochs{j}(1) cal_epochs{j}(find(diff(cal_epochs{j}) > 1) + 1) ];
    num_activations(j,1) = length(epoch_ends{j});
    end
end




end

