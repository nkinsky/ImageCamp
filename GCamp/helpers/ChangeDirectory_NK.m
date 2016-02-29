function [ dirstr ] = ChangeDirectory_NK(MD_in)
% dirstr = ChangeDirectory_NK(MD_in)
%
% Lazy man's ChangeDirectory - takes only the appropriate session from MD as
% input


dirstr = ChangeDirectory(MD_in.Animal,MD_in.Date,MD_in.Session);

end

