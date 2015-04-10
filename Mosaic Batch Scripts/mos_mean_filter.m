% Mos mean filter
filter_size = 2;
type = 'circular';

mosaic.initialize();
infile = uigetfile();
infile = mosaic.loadObjects(infile);
filtermovie = mosaic.filterMovie(infile,'filterType', type,...
    'filterSize', filter_size);
mosaic.saveOneObject(filtermovie,'ICmovie_smooth.mat');