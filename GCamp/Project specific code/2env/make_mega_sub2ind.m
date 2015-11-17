function [ind_out] = make_mega_sub2ind(mega_size,col1,col2)
% Code only to be used in the twoenv_batch_analysis script - gets indices
% for all mice AND sessions

ind_out = [];
for j = 1:mega_size(3)
    ind_out = [ind_out ; sub2ind(mega_size, col1,col2,j*ones(length(col1),1))];
end

end