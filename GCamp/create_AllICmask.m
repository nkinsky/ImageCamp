function [ All_ICmask ] = create_AllICmask( IC_cell, create_type )
% [ All_ICmask ] = create_AllICmask( IC_cell )
% create_AllICmask Takes a cell array of individual IC masks and creates a
% single mask containing all the ICs in one array. Option 2nd argument
% dicates what kind of mask you make. 1 = union of all ROIs, 2 = addition
% (lets you see if there is more than 1 neuron in a given area)

if nargin == 1
    create_type = 1;
end


All_ICmask = zeros(size(IC_cell{1}));
if create_type == 1
    for j = 1:length(IC_cell)
        %     All_ICmask = All_ICmask + IC_cell{j};
        All_ICmask = All_ICmask | IC_cell{j};
    end
elseif create_type == 2
    for j = 1:length(IC_cell)
        %     All_ICmask = All_ICmask + IC_cell{j};
        All_ICmask = All_ICmask + IC_cell{j};
    end
end

All_ICmask = double(All_ICmask);
end

