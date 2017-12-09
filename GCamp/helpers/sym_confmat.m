function [ confmat_sym ] = sym_confmat( confmat)
%  confmat_sym = sym_confmat(confmat)
%   Makes a confusion matrix symmetric by averaging off diagonal terms.
%   Used to fix slight differences due to filtering or shuffling. if
%   confmat is logical takes the logical AND of it and its transpose.

if ~any(islogical(confmat(:)))
    confmat = cat(3,confmat,confmat');
    confmat_sym = nanmean(confmat,3);
elseif any(islogical(confmat(:)))
    confmat_sym = confmat & confmat';
end


end

