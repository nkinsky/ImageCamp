function [nFrames,nDropped,droppedInds] = get_droppedframe_infoXML(varargin)
%
%
%

%% Import XML files. 
    if isempty(varargin)
        file = file_select_batch('*.xml'); 
    else 
        for thisFile=1:length(varargin)
            file(thisFile).path = varargin{thisFile};
        end
    end
    
    nFiles = length(file); 
    
    %Hack. Looks like the xml files are stereotyped enough that I can just
    %specify a row number for them. 
    droppedRow = 13;
    nDroppedRow = 12;
    nFramesRow = 11; 
    
    for thisFile=1:nFiles
        f = fopen(file(thisFile).path); 
        file(thisFile).data = textscan(f,'%s','Delimiter','\n');
        
        nFrames = str2num(file(thisFile).data{1}{nFramesRow}(21:end-7));
        nDropped = str2num(file(thisFile).data{1}{nDroppedRow}(28:end-7));
        droppedInds = str2num(file(thisFile).data{1}{droppedRow}(22:end-7));
        
    end
    
end