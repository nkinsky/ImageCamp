function [ proj_out ] = h5mov_proj( moviefile, proj_type)
% proj_out = h5mov_proj( moviefile, proj_type)
%   Create a 'max' or 'min' projection of an h5 movie (or tif/tiff now!).
%   NOTE: to write proj_out to a tif file you will need to normalize it by
%   its maximum first to preserve it, e.g.:
%
%       imwrite(proj_out/max(proj_out(:)),'test.tif','TIFF')

% Get movie information. 
[~,~,ext] = fileparts(moviefile); % Get filetype
file_type = ext(2:end);
switch file_type
    case 'h5'
        info = h5info(moviefile,'/Object');
        Xdim = info.Dataspace.Size(1);
        Ydim = info.Dataspace.Size(2);
        NumFrames = info.Dataspace.Size(3);
    case {'tif','tiff'}
        tstack = TIFFStack(moviefile);
        [Xdim, Ydim, NumFrames] = size(tstack); 
    otherwise
        error('You must enter in either a .tif/.tiff or .h5 file')
        
end
FrameChunkSize = min([1250 NumFrames]);
ChunkStarts = 1:FrameChunkSize:NumFrames;
ChunkEnds = FrameChunkSize:FrameChunkSize:NumFrames;
ChunkEnds(length(ChunkStarts)) = NumFrames;
NumChunks = length(ChunkStarts);

if nargin < 2
    proj_type = input('What type of projection do you want to make (max/min)? ',...
        's');
end

switch proj_type
    case 'max'
        F = @max;
        bool_use = @gt;
        newproj = zeros(Xdim,Ydim); % start at 0 for max proj
    case 'min'
        F = @min;
        bool_use = @lt;
        newproj = inf(Xdim,Ydim); % Start at infinity for min proj
    case 'mean' % Not finished yet, clearly
        F = @mean;
        newproj = zeros(Xdim, Ydim);
    otherwise
        disp('only ''min'' and ''max'' projections enabled currently')
end

% Error catching in case another file has been loaded recently.

Set_T_Params(moviefile)

p = ProgressBar(NumChunks);
switch proj_type
    case {'min', 'max'} 

        for i = 1:NumChunks
            FrameList = ChunkStarts(i):ChunkEnds(i);
            temp = LoadFrames(moviefile,FrameList);
            tempproj = feval(F,temp,[],3); % Get min/max
            newproj(feval(bool_use,tempproj,newproj)) = ...
                tempproj(feval(bool_use,tempproj,newproj));
            
            p.progress;
        end
        p.stop;
        
    case 'mean'
        for i = 1:NumChunks
            FrameList = ChunkStarts(i):ChunkEnds(i);
            temp = LoadFrames(moviefile,FrameList);
            tempproj = feval(F,temp,3); % Get mean
            
            % Add mean*nframes used to previous
            newproj = tempproj*length(FrameList) + newproj;
            
            p.progress;
        end
        newproj = newproj/NumFrames; % divide by # frames to get mean of each pixel
        p.stop;
end

proj_out = newproj;

end

