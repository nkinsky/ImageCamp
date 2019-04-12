function [] = write_tstack(out_file, array_in3d)
% write_tstack(out_file, array_in3d)
%   Detailed explanation goes here


%  First, set up Tiff object and appropriate tags
tobj = Tiff(out_file, 'w');

% Set tags
% Mode: 'r'
% Current Image Directory: 1
% Number Of Strips: 462
% SubFileType: Tiff.SubFileType.Default
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.ImageLength = size(array_in3d, 1);
tagstruct.ImageWidth = size(array_in3d, 2);
tagstruct.RowsPerStrip = 1;
tagstruct.BitsPerSample = 16;
tagstruct.Compression = Tiff.Compression.None;
% SampleFormat: Tiff.SampleFormat.UInt
tagstruct.SamplesPerPixel = size(array_in3d, 3);
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% Orientation: Tiff.Orientation.TopLeft

setTag(tobj, tagstruct);

write(tobj, array_in3d);
close(tobj);

end

