function [ shape_out ] = twoenv_get_shape( Animal, Date, Session )
% shape_out  = twoenv_get_shape( Animal, Date, Session )
%   Gets arena shape for two environment task

[~, sesh_use] = ChangeDirectory(Animal, Date, Session, 0);

if ~isempty(regexpi(sesh_use.Env, 'square'))
    shape_out = 'square';
elseif ~isempty(regexpi(sesh_use.Env, 'octagon'))
    shape_out = 'circle';
else
    shape_out = 'nan';
end


end

