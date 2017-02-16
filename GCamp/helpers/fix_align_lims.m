function [ ] = fix_align_lims( sessions, name_prefix, xlims, ylims )
% Fixes limits on batch_pos_align files that start with name prefix if screwed up.
% Saves each file with _archive first, then replaces it with xmin, xmax,
% ymin, ymax in xlims and ylims.

num_sessions = length(sessions);
for j = 1:num_sessions
    dirstr = ChangeDirectory(sessions(j).Animal, sessions(j).Date, sessions(j).Session);
    files_char = ls([name_prefix '*']);
    num_files = size(files_char,1);
    filenames = cell(num_files, 1);
    for k = 1:num_files
        filenames{k} = fullfile(dirstr, files_char(k,1:regexpi(files_char(k,:), '.mat')+3));
    end
    fix_each_file(filenames, xlims, ylims)
end



end


function [] = fix_each_file(filenames2, xlims2, ylims2)

for k = 1:length(filenames2)
    load(filenames2{k});
    save([filenames2{k}(1:end-4) '_archive.mat'],...
        'x_adj_cm','y_adj_cm','xmin','xmax','ymin','ymax','speed',...
        'PSAbool','LPtrace','DFDTtrace','RawTrace','FToffset',...
        'nframesinserted','time_interp','FToffsetRear','aviFrame',...
        'base_struct','sessions_included','auto_rotate_to_std');
    xmin = xlims2(1);
    xmax = xlims2(2);
    ymin = ylims2(1);
    ymax = ylims2(2);
    
    save(filenames2{k},...
        'x_adj_cm','y_adj_cm','xmin','xmax','ymin','ymax','speed',...
        'PSAbool','LPtrace','DFDTtrace','RawTrace','FToffset',...
        'nframesinserted','time_interp','FToffsetRear','aviFrame',...
        'base_struct','sessions_included','auto_rotate_to_std');
end

end


