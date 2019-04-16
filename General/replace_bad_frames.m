function [] = replace_bad_frames(infile,outfile,bad_frames,replace_frames)
% replace_bad_frames(infile,outfile,bad_frames,replace_frames)
%
% Replaces bad_frames in infile with the frame index/indices specified in
% replace_frames. replace_frames is either one frame index or an array of frame
% indices that matches the length of bad_frames.  If it is just one frame,
% that frame will replace all the bad frames.
%
% For the future: automatically interpolate if fewer than a few frames and
% automatically replace with the previous good frame if super long.
%
% Example to fix bad frames in a tiff file
%
% % Load file with bad frames
% tstack_bad = TIFFStack('badfile.tiff');
%
% % Scroll through and ID bad frames (you know they start around frame
% % 100 from Inscopix). Note them down.
% scroll_tiff_frames(tstack_bad, 100);
%
%  % say you identified frames 125 and 135-140 as bad, note them down and
%  % note the frames you want to replace them with (usually the previous
%  % good frame)
% bad_frames = [125 135:140];
% replace_frames = [124 134 134 134 134 134 134];
% 
% % Now run replace_bad_frames
% replace_bad_frames('badfile.tiff','badfile_fixed.tiff', bad_frames...,
%   replace_frames);
% 
% % Check your work! Make a minimum projection...
% tstack_fixed = TIFFStack('badfile_fixed.tiff');
% figure; imagesc(min(tstack_fixed(:,:,:),[],3)); colormap(gray);


if exist(outfile, 'file') == 2
    error('out_file already exists. Delete and start over or use different name')
end

% Get filetype
[~,~,ext] = fileparts(infile); 
filetype = ext(2:end);

% Set things up
switch filetype
    case 'h5'
        info = h5info(infile,'/Object');
        NumFrames = info.Dataspace.Size(3);
        XDim = info.Dataspace.Size(1);
        YDim = info.Dataspace.Size(2);
        
    case {'tiff', 'tif'}
        tstack = TIFFStack(infile);
        [XDim,YDim, NumFrames] = size(tstack);

    otherwise
        error('files must be in either h5 or tiff format')
        
        
end

% If only one frame is entered, deal it out to every index in
% replace_frames
if length(bad_frames) ~= length(replace_frames)
    replace_frames(1:length(bad_frames)) = replace_frames;
end

tic
% Loop through and replace frames!
switch filetype
    case 'h5'
        
        h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','uint16');
        
        p = ProgressBar(NumFrames);
        for i = 1:NumFrames
            
            if sum(i == bad_frames) > 0
                replace_ind = (i == bad_frames); % get index of bad frame to replace
                F{i} = h5read(infile,'/Object',[1 1 replace_frames(replace_ind) 1],[XDim YDim 1 1]);
                h5write(outfile,'/Object',uint16(F{i}),[1 1 i 1],[XDim YDim 1 1]);
            else
                F{i} = h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]);
                h5write(outfile,'/Object',uint16(F{i}),[1 1 i 1],[XDim YDim 1 1]);
            end
            p.progress;
            
        end
        p.stop;
        
    case {'tif', 'tiff'}
        %%% NRK - need to loop through and find chunks of bad frames
        %%% together. Write chunk of good frames, then write chunk of bad
        %%% frames, then write good, etc. 
        bad_bool = false(1,NumFrames);
        bad_bool(bad_frames) = true;
        good_epochs = NP_FindSupraThresholdEpochs(~bad_bool,eps,false);
        bad_epochs = NP_FindSupraThresholdEpochs(bad_bool,eps, false);
        if ismember(1, good_epochs)
            curr_epoch = 'good';
        elseif ismember(1, bad_epochs)
            curr_epoch = 'bad';
        end
        ngood = size(good_epochs,1);
        nbad = size(bad_epochs,1);
        rowg = 1;
        rowb = 1;
        bf_curr_ind = 1;
        n = 1;
        hw = waitbar(0, 'Fixing movie...');
        while rowg <= ngood || rowb <= nbad
            
            % Need to error check all of the code below
            if strcmpi(curr_epoch ,'good')
                frames_write = tstack(:,:, ...
                    good_epochs(rowg,1):good_epochs(rowg,2));
                write_tstack(outfile, frames_write);
                curr_epoch = 'bad';
                rowg = rowg + 1;
                waitbar(n/(ngood + nbad), hw);
                n = n + 1;
            elseif strcmpi(curr_epoch, 'bad')
                len_epoch = diff(bad_epochs(rowb,:))+1;
                rep_frame_nums = replace_frames(bf_curr_ind:...
                    (bf_curr_ind + len_epoch-1));
                frames_write = tstack(:,:,rep_frame_nums);
                write_tstack(outfile, frames_write);
                curr_epoch = 'good';
                rowb = rowb + 1;
                bf_curr_ind = bf_curr_ind + len_epoch;
                waitbar(n/(ngood + nbad), hw);
                n = n + 1;
            end  
        end
        % Now write the last good epoch!
        
        close(hw)
end

toc
end
