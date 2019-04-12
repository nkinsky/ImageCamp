function [] = write_tstack(out_file, array_in3d)
% write_tstack(out_file, array_in3d)
%   Writes data in array_in3d to out_file. If file already exists it
%   appends the data in array_in3d to the already existing file.

exist_file = exist(out_file,'file') == 2;
nFrames = size(array_in3d, 3);

% Write first image
if ~exist_file
    imwrite(squeeze(array_in3d(:,:,1)), out_file, 'Compression', 'None');
elseif exist_file
    imwrite(squeeze(array_in3d(:,:,1)), out_file, 'Compression', 'None',...
        'WriteMode', 'Append');
end

% Now write the rest of the images
for j = 2:nFrames
    imwrite(squeeze(array_in3d(:,:,j)), out_file, 'Compression', 'None',...
        'WriteMode', 'Append');
end

%% Below is supposed to be new and fancy and fast but is way too complicated
% %  First, set up Tiff object and appropriate tags
% tobj = Tiff(out_file, 'w');
% 
% nframes =  size(array_in3d, 3);
% 
% % Set tags
% % Mode: 'r'
% % Current Image Directory: 1
% % Number Of Strips: 462
% % SubFileType: Tiff.SubFileType.Default
% tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
% tagstruct.ImageLength = size(array_in3d, 1);
% tagstruct.ImageWidth = size(array_in3d, 2);
% tagstruct.RowsPerStrip = 1;
% tagstruct.BitsPerSample = 16;
% tagstruct.Compression = Tiff.Compression.None;
% % SampleFormat: Tiff.SampleFormat.UInt
% tagstruct.SamplesPerPixel = 1;
% % tagstruct.SamplesPerPixel = size(array_in3d, 3); % this works but then
% % reading the file is hella slow
% tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% % Orientation: Tiff.Orientation.TopLeft
% 
% setTag(tobj, tagstruct);
% 
% for j = 1:nframes
%     writeEncodedStrip(tobj, j, array_in3d(:,:,j));
% end
% % write(tobj, array_in3d);
% close(tobj);

end

