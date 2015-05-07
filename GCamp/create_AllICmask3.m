function [ All_ICmask, ICnz_mask ] = create_AllICmask3( IC_cell,ICthresh )
%[ All_ICmask, ICnz_mask ] = create_AllICmask2( IC_cell,ICnz )
% create_AllICmask Takes a cell array of individual IC masks and creates a
% single mask containing all the ICs in one array.  Note that IC_cell is the
% full, non-edited IC, and ICnz is the index of the values where the
% edited/masked IC is non-zero.
% IC_thresh = array the same size as IC_cell with the threshold used to
% determine the IC


All_ICmask = zeros(size(IC_cell{1}));
ICnz_mask = cell(size(IC_cell));
for j = 1:size(IC_cell,2)
    ICnz_mask{j} = zeros(size(IC_cell{j}));
    ICnz_mask{j}(IC_cell{j}(:) > ICthresh(1)) = ones(1, sum(IC_cell{j}(:) > ICthresh(1)));
    All_ICmask = All_ICmask | ICnz_mask{j};
end

end

