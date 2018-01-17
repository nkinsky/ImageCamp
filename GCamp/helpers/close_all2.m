function [ ] = close_all2( )
% close_all2
%   Closes all windows and msgbox from Sam's PreProcess function - feel free to add more stuff to close
%   with this.

close all
global hbox; 
try
    close(hbox);
catch
    try
        delete(hbox);
    catch
    end
end


end

