function [ ] = fix_align_scale( sessions, name_prefix, scale )
% Fixes scale for data - adjusts x_adj_cm, y_adj_cm, xmin/xmax, and
% ymin/ymax for each session

num_sessions = length(sessions);
for j = 1:num_sessions
    dirstr = ChangeDirectory(sessions(j).Animal, sessions(j).Date, sessions(j).Session);
    files_char = ls([name_prefix '*']);
    num_files = size(files_char,1);
    filenames = cell(1, 1);
    n = 1;
    for k = 1:num_files
        if regexpi(files_char(k,:), '_archive')
            continue
        end
        filenames{n} = fullfile(dirstr, files_char(k,1:regexpi(files_char(k,:), '.mat')+3));
        n = n + 1;
    end
    fix_each_file(filenames, scale)

end

end


function [] = fix_each_file(filenames2, scale)

for k = 1:length(filenames2)
    load(filenames2{k});
    save([filenames2{k}(1:end-4) '_scale_archive.mat'],...
        'x_adj_cm','y_adj_cm','xmin','xmax','ymin','ymax','speed',...
        'PSAbool','LPtrace','DFDTtrace','RawTrace','FToffset',...
        'nframesinserted','time_interp','FToffsetRear','aviFrame',...
        'base_struct','sessions_included','auto_rotate_to_std');
    xmin = xmin*scale;
    ymin = ymin*scale;
    xmax = xmax*scale;
    ymax = ymax*scale;
    
    x_adj_cm = x_adj_cm*scale;
    y_adj_cm = y_adj_cm*scale;
    
    save(filenames2{k},...
        'x_adj_cm','y_adj_cm','xmin','xmax','ymin','ymax','speed',...
        'PSAbool','LPtrace','DFDTtrace','RawTrace','FToffset',...
        'nframesinserted','time_interp','FToffsetRear','aviFrame',...
        'base_struct','sessions_included','auto_rotate_to_std');
end

end


