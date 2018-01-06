function [ xout, grpsout] = scatterbox_reshape( xcell, grps)
% [ xout, grpsout] = scatterbox_reshape( xcell, grps)
%   Reshape data that is already grouped to work with scatterBox function

xout = cat(1,xcell{:});
grp_nums = cellfun(@length, xcell);

%%
grpsout = [];
for j= 1:length(grp_nums)
   grpsout = [grpsout; repmat(grps(j), grp_nums(j),1)];
end

%%

end

