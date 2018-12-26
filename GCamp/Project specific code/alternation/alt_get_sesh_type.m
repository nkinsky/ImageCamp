function [ legit_bool, acclim_bool, forced_bool ] = alt_get_sesh_type( MD )
% [ legit_bool, acclim_bool, forced_bool ] = alt_get_sesh_type( MD )
%  Gets boolean of legit alternation sessions (not forced or acclimation), 
%  forced sessions, and acclimation sessions. Legit can also be interpreted
%  as free. Redundant with alt_id_sesh_type.

num_sessions = length(MD);
MD = complete_MD(MD); % complete it if not already done

forced_bool = false(1,num_sessions);
acclim_bool = false(1,num_sessions);
for j = 1:num_sessions % ID looping/forced/acclimation sessions
    forced_bool(j) = ~isempty(regexpi(MD(j).Notes,'forced'));
    acclim_bool(j) = any(~cellfun(@isempty,regexpi(MD(j).Notes,...
        {'looping','acclimation'})));
end

legit_bool = ~forced_bool & ~acclim_bool;

end

