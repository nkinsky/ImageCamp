function [ mat_sym ] = make_mat_sym( mat_in )
% mat_sym  = make_mat_sym( mat_in )   
%   Takes matrix mat_in with upper right diagonal intact and reflects it to
%   the lower left.

[nrows, ncols] = size(mat_in);
if nrows ~= ncols
    error('mat_in must be symmetric')
end

mat_sym = mat_in;
mat_reflect = mat_in';
mat_sym(tril(true(nrows),-1)) = mat_reflect(tril(true(nrows),-1));

end

