function WM_batch_preprocess(varargin)
%% Mosaic Batch Pre-Process
%   Using Will's file formats and naming conventions. 

%% Variables
    mic_per_pix = 1.16; 
    spatial_filt = 20; 
    spatial_ds = 2;
    currentDir = pwd; 

%% Step 0: Initialize Mosaic. 
    mosaic.terminate(); 
    mosaic.initialize(); 

%% Step 1: Select file. 
    if isempty(varargin)
        [filename, pathname] = uigetfile({'*.xml', 'Miniscope files'},'Select file to load');
        fileNoExt = filename(1:end-4); 
    else
        [pathname, fileNoExt, ext] = fileparts(varargin{1});
        filename = [fileNoExt,ext];
    end

%% Step 2: Fix static frames. 
    if ~exist('skip_fix','var') || skip_fix ~= 1
        disp('Checking for staticky frames...'); 

        cd(pathname); 
        fileChunks = dir([fileNoExt,'*.tif']); 
        nChunks = length(fileChunks); 

        for chunknum=1:nChunks
            filetofix = fileChunks(chunknum).name; 
            if ~exist([filetofix(1:end-4),'fixed.mat'],'file');
                disp(['Checking ',filetofix,' for bad frames...']); 
                FixFrames(filetofix); 
            else 
                disp('File has been fixed already.'); 
                disp(['Delete ',[filetofix(1:end-4),'fixed.mat'], ' if you wish to rerun.']); 
                disp(' ');            
            end
        end
    end

%% Step 3: Check for dropped frames. 
    [~,nDropped] = get_droppedframe_infoXML(filename); 

    if nDropped>0
        disp('Dropped frames detected! Loading movie to save.');

        if ~exist('BrokenMovie-Objects','dir')
            try 
                movie_use = mosaic.loadMiniscope(filename,'pixelWidth',mic_per_pix,...
                    'pixelHeight',mic_per_pix); 
            catch
                disp('TIFs are missing frames! Retrieve files from external HD.');
            end
        end

    else
        disp('No dropped frames detected. Proceed to load movie in Mosaic standalone.'); 
    end


%% Step 4: 
    %If there are dropped frames and the BrokenMovie has not yet been saved...
    if nDropped>0 && ~exist('BrokenMovie-Objects','dir')
        disp('Saving broken movie to run fix_dropped_frames()...');

        mosaic.saveOneObject(movie_use,'BrokenMovie.mat'); 
    elseif nDropped>0 && exist('BrokenMovie-Objects','dir')
        disp('BrokenMovie already saved! Delete to rerun, other enter return'); 
        keyboard; 
    end

    %Get file names. 
    if nDropped>0
        brokenMovieDir = fullfile(pathname,'BrokenMovie-Objects');
        infile = fullfile(brokenMovieDir,['Obj_1 - ',fileNoExt,'.h5']); 

        %If the fixed version has not yet been saved...
        if nDropped>0 && ~exist(fullfile(pathname,'BrokenMovie_fixed-Objects'),'dir')
            fix_dropped_frames(infile,'xml_files',filename);
            disp('Dropped frames fixed. Load BrokenMovie_fixed in Mosaic standalone for motion correction.'); 
        elseif nDropped>0 && exist(fullfile(pathname,'BrokenMovie_fixed-Objects'),'dir')
            disp('Movie has already been fixed. Delete BrokenMovie_fixed folder to rerun, else enter return.');
            keyboard; 
        elseif nDropped==0 && concat
            disp('Concatenated movie saved! Load ConcatMovie in Mosaic standalone for motion correction.'); 
        elseif ~concat
            disp('Batch preprocess session concluded. Load XML in Mosaic standalone for motion correction.'); 
        end
    end
%% Close.
    mosaic.terminate();
    clear; 
    
end