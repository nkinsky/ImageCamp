function [ compare_out, compare_out_full ] = cell_compare( cell_in1, cell_in2 )
% Recursive function to compare cells.  If cells are nested within cells,
% it digs down to deepest level and compares there

for j = 1:length(cell_in1)
    try
    if iscell(cell_in1{j})
        [compare_out_all(j), compare_out_full{j}] = cell_compare(cell_in1{j}, cell_in2{j});
    else
        temp = cell_in1{j}(:) == cell_in2{j}(:);
        if sum(temp) == length(cell_in1{j}(:))
            compare_out_all(j) = 1;
        else
            compare_out_all(j) = 0;
        end
%         keyboard
    end
    catch
        keyboard
    end
    
end

if sum(compare_out_all) == length(compare_out_all)
    compare_out = 1;
else
    compare_out = 0;
end

if exist('compare_out_full','var')
    clear compare_out_all
    compare_out_all = compare_out_full;
else
    compare_out_full = compare_out_all;
end

end

