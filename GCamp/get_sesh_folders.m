function [ folder, movie_folder ] = get_sesh_folders( day_session, square_sessions, octagon_sessions )
%[ folder, movie_folder ] = get_sesh_folders( day_session, square_sessions, octagon_sessions )
%   Takes input from day_session structure and gets the location of the
%   working folder and movie folder

if strcmpi(day_session.arena,'square')
    index = day_session.index;
    folder = square_sessions(index).folder;
    movie_folder = square_sessions(index).movie_folder;
elseif strcmpi(day_session.arena,'octagon')
    index = day_session.index;
    folder = octagon_sessions(index).folder;
    movie_folder = octagon_sessions(index).movie_folder;
end


end

