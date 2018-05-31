function [ dtheta_shuf ] = twoenv_shuffle_dtheta( dtheta, nshuf )
% [dtheta_shuf ] = twoenv_shuffle_dtheta( dtheta, nshuf )
%   spits out a matrix of shuffled entry angle, entrydir, and landdir
%   value differences for all session pairs.

[n1,n2,n3] = size(dtheta);
dtheta_shuf = nan(n1,n2,n3,nshuf);

for k = 1:3
    dtheta_use = squeeze(dtheta(k,:,:));
    for j = 1:nshuf
        good_ind = find(~isnan(dtheta_use));
        shuf_temp = nan(size(dtheta_use));
        dshuf_ind = good_ind(randperm(length(good_ind))');
        shuf_temp(good_ind) = dtheta_use(dshuf_ind);
        dtheta_shuf(k,:,:,j) = shuf_temp;
    end
end

end

