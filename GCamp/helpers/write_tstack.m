function [] = write_tstack(out_file, array_in3d)
% write_tstack(out_file, array_in3d)
%   Writes data in array_in3d to out_file. If file already exists it
%   appends the data in array_in3d to the already existing file.
%
%   IMPORTANT NOTE: This requires downloading saveastiff from FileExchange
%   and putting it on your MATLAB path:
%
%   https://www.mathworks.com/matlabcentral/fileexchange/35684-multipage-tiff-stack?focused=7519472&tab=function&s_tid=mwa_osa_a

% Use default options to saveastiff
options.color = false;
options.compress = 'no';
options.message = true;
options.append = false;
options.overwrite = false;
options.big = true; % keep as big unless you notice slowdowns

% First set flag for big file if writing to one > ~4GB.
% info = whos('array_in3d');
% size_ok = info.bytes/(2^32-1) < 1;
% if ~size_ok
%     options.big = true;
% end

% Write first image
exist_file = exist(out_file,'file') == 2;
if exist_file
    options.append = true;
end
saveastiff(array_in3d, out_file, options);

end

%%% OLD CODE That doesn't work with big files below
% First, check to see if you will go over the write limit in MATLAB.
% info = whos('array_in3d');
% size_ok = info.bytes/(2^32-1) < 1;
% if ~size_ok
%     nchunks = ceil(info.bytes/(2^32-1)); % Get # of 2^32-1 byte chunks to write
%     chunksize = floor(nFrames/(info.bytes/(2^32-1))); % Get chunksize in frames
%     
%     % delegate chunks to write out!
%     chunks(1,1) = 2; chunks(nchunks,2) = nFrames;
%     for j = 2:nchunks
%         chunks(j-1,2) = chunksize*(j-1); 
%         chunks(j,1) = chunksize*(j-1)+1;
%     end
% end
% 
% 
% % Write first image
% if ~exist_file
%     imwrite(squeeze(array_in3d(:,:,1)), out_file, 'Compression', 'None');
% elseif exist_file
%     imwrite(squeeze(array_in3d(:,:,1)), out_file, 'Compression', 'None',...
%         'WriteMode', 'Append');
% end
% 
% % Now write the rest of the images
% if nFrames > 1 % only do this if you have more than one input frame
% %     if size_ok % This is redundant with below but keep for later-debugging if needed.
%     
%     hwsub = waitbar(0,'Writing sub-chunks of large TIFF file...');
%     for j = 2:nFrames
%         imwrite(squeeze(array_in3d(:,:,j)), out_file, 'Compression', 'None',...
%             'WriteMode', 'Append');
%         waitbar(j/nFrames, hwsub);
%     end
%     close(hwsub)
% %     elseif ~size_ok
% %         hwsub = waitbar(0,'Writing sub-chunks of large TIFF file...');
% %         for j = 1:nchunks
% %             fstart = chunks(j,1);
% %             fend = chunks(j,2);
% %             imwrite(squeeze(array_in3d(:,:,fstart:fend)), out_file, ...
% %                 'Compression', 'None', 'WriteMode', 'Append');
% %             waitbar(j/nchunks, hwsub);
% %         end
% %         close(hwsub);
% %     end
% end

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

% end

