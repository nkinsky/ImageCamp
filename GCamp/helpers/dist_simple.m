function [ dist_mat ] = dist_simple(vec1,vec2)
% dist_simple(vec1,vec2)
%   Calculates distance of all points in vec1 to vec2 - both must be 2d column
%   vectors

dist_mat = nan(size(vec1,1),size(vec2,1));
for j = 1:size(vec1,1)
    pos1 = vec1(j,:);
    pos_diff = pos1 - vec2;
    pos_dist = sqrt(pos_diff(:,1).^2 + pos_diff(:,2).^2);
    dist_mat(j,:) = pos_dist';
end

end

