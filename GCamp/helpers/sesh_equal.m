function [ equal_bool ] = sesh_equal( sesh1, sesh2 )
% equal_bool = sesh_equal( sesh1, sesh2 )
%   Determines if sesh1 and sesh2 are the same

equal_bool = strcmpi(sesh1.Animal, sesh2.Animal) && ...
    strcmpi(sesh1.Date, sesh2.Date) && (sesh1.Session == sesh2.Session);


end

