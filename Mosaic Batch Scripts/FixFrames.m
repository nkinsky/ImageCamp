function FixFrames(filename)
%FixFrames(filename)
%
%   The camera occasionally produces bad frames that are characterized by
%   massive static. This function uses the mean pixel value of the entire
%   frame to determine whether it is a bad frame or not. If it is,
%   FixFrames will replace that frame with the frame before it. Note that
%   your tif file will be overwritten with the new tif after corrections. 
%
%   INPUT:
%       filename: Filename of the brain imaging tif movie. 
%

%% Parameters and preallocation. 
    imgdata = imfinfo(filename); 
    numframes = size(imgdata,1); 
    
    meanframes = nan(numframes,1); 
    
%% Get the mean pixel value for every frame. 
    for thisframe = 1:numframes
        frame = imread(filename,thisframe);
        meanframes(thisframe) = mean(frame(:)); 
    end
    
%% Get bad frames. 
    SD = std(meanframes); 
    toohigh = mean(meanframes) + 4*SD; 
    toolow = mean(meanframes) - 4*SD;
    
    badframes = find(meanframes > toohigh | meanframes < toolow); 
    numbadframes = length(badframes); 
    
    %Display them. 
    for i=1:numbadframes
        figure;
        frame = imread(filename,badframes(i)); 
        imshow(frame,[]);
        title(['Frame #', num2str(badframes(i))]); 
    end
        
    %List the bad frames. 
    if isempty(badframes)
        disp('All frames in this recording are good!');
    elseif ~isempty(badframes)
        disp('Bad frames detected:');
        for i=1:numbadframes
            disp(badframes(i));
        end
    end
    
    %Manual check. 
    if ~isempty(badframes)
        goodframes = input('Are these all bad frames? If not, enter frame numbers. Otherwise, leave empty. ', 's');
        goodframes = str2num(goodframes); 
        if ~isempty(goodframes)
            badframes(ismember(badframes,goodframes)) = []; 
        end
    end
    
    close all;
    
%% Replace bad frames. 
    %Replace bad frames with the previous and save. 
    outputname = [filename(1:end-4), 'fixed.tif']; 
    if ~isempty(badframes)
        for i=1:numframes
            frame = imread(filename,i);
            if ismember(i,badframes);
                frame = imread(filename,i-1); 
            end
            imwrite(frame,outputname,'WriteMode','append','Compression','none'); 
        end
        
        %Replace old movie with fixed movie. 
        delete(filename); 
        FileRename(outputname,filename);
    end
    
    save([filename(1:end-4), 'fixed.mat'],'badframes'); 
    
end