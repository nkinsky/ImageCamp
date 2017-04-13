function [ ] = dispNK( str, output_log )
% dispNK( str, output_log )
%   display output in str to screen if output_log = true
if nargin < 2
    output_log = true;
end
if output_log
    disp(str)
end


end

