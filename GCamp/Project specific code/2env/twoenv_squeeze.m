function [ circ2square_out ] = twoenv_squeeze( circ2square_mat )
% circ2square_out = twoenv_squeeze_circ2square( circ2square_mat )
%   Takes input circ2square mat or cell (either remapping array or
%   shuffle_mat2 or corr_mat) in 16x16 format and dumps it into 8x8 format
%   with rows = square sessions and columns = circle sessions.  Does
%   nothing if it is in 8x8 format (presumably within square or within
%   circle comparisons).

sq_ind = [1 2 7 8 9 12 13 14];
circ_ind = [3 4 5 6 10 11 15 16];

num_comps = length(circ2square_mat(:));
switch num_comps
    case 256
        if ~iscell(circ2square_mat)
            circ2square_out = nan(8,8);
            % go through one direction and dump in values
            for j = 1:8
                for k = 1:8
                    sq_ind_use = sq_ind(j);
                    circ_ind_use = circ_ind(k);
                    if sq_ind_use < circ_ind_use
                        circ2square_out(j,k) = circ2square_mat(sq_ind_use, circ_ind_use);
                    elseif sq_ind_use > circ_ind_use
                        circ2square_out(j,k) = circ2square_mat(circ_ind_use, sq_ind_use);
                    end
                    
                end
            end
        elseif iscell(circ2square_mat)
            circ2square_out = cell(8,8);
            for j = 1:8
                for k = 1:8
                    sq_ind_use = sq_ind(j);
                    circ_ind_use = circ_ind(k);
                    if sq_ind_use < circ_ind_use
                        circ2square_out{j,k} = circ2square_mat{sq_ind_use, circ_ind_use};
                    elseif sq_ind_use > circ_ind_use
                        circ2square_out{j,k} = circ2square_mat{circ_ind_use, sq_ind_use};
                    end
                    
                end
            end
        end
    case 64
        circ2square_out = circ2square_mat;
    otherwise
        error('You have entered in a matrix that is not 8x8 or 16x16')
end

end % Function end

