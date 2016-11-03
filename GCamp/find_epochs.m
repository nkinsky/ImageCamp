function [ epochs, epoch_ind ] = find_epochs( indices )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if islogical(indices)
    disp('indices added as a logical.  Using "find" function to get indices')
    indices = find(indices);
end
ind_diff = diff(indices);

epoch_start = indices(1); epoch_end = [];
epoch_start_ind = 1; epoch_end_ind = [];
in_epoch = true;
n = 1;
for j = 1:length(ind_diff)
    
    if ~in_epoch && ind_diff(j) == 1
        epoch_start(n,1) = indices(j);
        epoch_start_ind(n,1) = j;
        in_epoch = true;
    end
    
    if in_epoch && ind_diff(j) > 1
        epoch_end(n,1) = indices(j);
        epoch_end_ind(n,1) = j;
        in_epoch = false;
        n = n + 1; % move to next epoch
    end
    
    if j == length(ind_diff)
        epoch_end(n,1) = indices(j+1);
        epoch_end_ind(n,1) = j+1;
        if ind_diff(j) > 1 % edge case with epoch of length 1 at end
            epoch_start(n,1) = indices(j+1);
            epoch_start_ind(n,1) = j+1;
        end
    end
        
end

epochs = [epoch_start epoch_end];
epoch_ind = [epoch_start_ind epoch_end_ind];

end

