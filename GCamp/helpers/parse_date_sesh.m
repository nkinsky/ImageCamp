function [date_underscore, session] = parse_date_sesh(date_sesh)
% [date_underscore, sesh_num] = parse_date_sesh(date_sesh)
%   Takes date + session in combined string (MM/DD/YYYY-1 or MM_DD_YYYY-1
%   or M/D/YYYY-1 etc.) and spits out MM_DD_YYYY string + session number.

if all(~isnan(date_sesh)) && ~(strcmpi(date_sesh, 'manual') || ...
        strcmpi(date_sesh, 'use above after done'))
    dash = regexp(date_sesh, '-');
    date_in = date_sesh(1:(dash-1));
    session = str2num(date_sesh((dash+1):end));
    date_underscore = date_under(date_sesh(1:(dash-1)));
else
    date_underscore = nan;
    session = nan;
end

end

