function [] = create_ChangeMovie( infile, outfile, smoothfr )
%create_ChangeMovie( infile, outfile, smoothfr )
%   Takes an ICMovie, spatially smoothed with a 2 pixel disk, and outputs a
%   ChangeMovie (1st temporal derivative).  smoothfr is the # of frames to
%   smooth (e.g. for 1 sec at 20fps you should use 20)

TempSmoothMovie(infile,'TempSmoothMovie.h5',smoothfr);
ChangeMovie('TempSmoothMovie.h5',outfile);

delete 'TempSmoothMovie.h5'


end

