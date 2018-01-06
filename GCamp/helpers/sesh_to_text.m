function [ text_out ] = sesh_to_text( session, file_flag )
% [text_out ] = sesh_to_text( session, file_flag )
%   Makes session into a string: 'Animal - 09_28_1982s1'. file_flag = true 
%   makes it work for saving files, otherwise it will include \s to make it
%   work in text/axis labels, etc. default = false;
if nargin < 2
    file_flag = false;
end
if ~file_flag
    text_out = [mouse_name_title(session.Animal),...
        ' - ' mouse_name_title(session.Date) 's' num2str(session.Session)];
else
    text_out = [session.Animal ' - ' session.Date 's' num2str(session.Session)];
end

end

