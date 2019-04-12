function [] = replace_bad_frames(infile,outfile,bad_frames,replace_frames)
% replace_bad_frames(infile,outfile,bad_frames,replace_frames)
%
% Replaces bad_frames in infile with the frame index/indices specified in
% replace_frames. replace_frames is either one frame index or an array of frame
% indices that matches the length of bad_frames.  If it is just one frame,
% that frame will replace all the bad frames.

% Get filetype
[~,~,ext] = fileparts(file); 
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
        bad_bool = false(1,100);
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
        
        while rowg < ngood || rob < nbad
           if rowg == 1 && rowb == 1
               
            
        end
end

toc
end
