function [names, dates, sessions, inds] = get_unique_values( MD )
% [names, dates, sessions, inds] = get_unique_values( MD )
%  Gets unique animal names, dates, and sessions from the structure. inds
%  returns the indices in MD matching each (col 1 = name, col 2 = date,
%  col 3 = session)

names = unique(arrayfun(@(a) a.Animal,MD,'UniformOutput',false));
name_ind = arrayfun(@(a) find(strcmpi(a.Animal,names)),MD);

dates = unique(arrayfun(@(a) a.Date,MD,'UniformOutput',false));
date_ind = arrayfun(@(a) find(strcmpi(a.Date,dates)),MD);

sessions = unique(arrayfun(@(a) a.Session,MD));
session_ind = arrayfun(@(a) find(a.Session == sessions),MD);

inds = [name_ind', date_ind', session_ind'];

end

