function [ max_proj ] = movie_max( movie, frames )
% max_proj = movie_max( movie,... )
%  Gives you a maximum projection of the whole movie, or across the frames
%  specified in the optional 2nd argument.

Set_T_Params(movie);

[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');
if nargin == 2
    NumFrames = length(frames);
else 
    frames = 1:NumFrames;
end

max_proj = -inf*ones(Xdim,Ydim);
for j = 1:NumFrames
    temp = LoadFrames(movie,frames(j));
    max_proj = max(cat(3,max_proj,temp),[],3);
end


end

