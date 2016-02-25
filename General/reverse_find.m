function [ binary_out ] = reverse_find(indices,array_size )
% binary_out = reverse_find(indices,array_size)
%   reverses find function in matlab, i.e. takes indices for an array and
%   puts them back into the array as ones

binary_out = zeros(size(array_size));
binary_out(indices) = 1;


end

