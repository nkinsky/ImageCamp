


AllIC_comb = zeros(size(All_ICmask_days{1}));
for j = 1:5
    for k = 1:length(All_ICmask_days{j}(:))
        if All_ICmask_days{j}(k) > 0
            AllIC_comb(k) = j*All_ICmask_days{j}(k);
        elseif AllIC_comb(k) > 0
            AllIC_comb(k) = AllIC_comb(k);
        else
        end
   end
    
end