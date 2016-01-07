function [ name_plot ] = mouse_name_title( Animal_name )
% name_plot = mouse_name_title( Animal_name )
%   Takes a mouse name with an underscore in it and outputs something that
%   you can use in titles

% Find where the underscore is
u_ind = regexp(Animal_name,'_');

name_plot = [Animal_name(1:u_ind-1) '\' Animal_name(u_ind:end)];


end

