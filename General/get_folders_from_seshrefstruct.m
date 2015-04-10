function [ index, folder, movie_folder ] = get_folders_from_seshrefstruct( day, square_sessions, octagon_sessions, day_index, session_index )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if strcmpi(day(day_index).session(session_index).arena,'square')
    index = day(day_index).session(session_index).index;
    folder = square_sessions(index).folder;
    movie_folder = square_sessions(index).movie_folder;
elseif strcmpi(day(day_index).session(session_index).arena,'octagon')
    index = day(day_index).session(session_index).index;
    folder = octagon_sessions(index).folder;
    movie_folder = octagon_sessions(index).movie_folder;
end


end

