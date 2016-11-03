function [ odd_epoch_frames, even_epoch_frames, odd_epochs, even_epochs ] = get_odd_even_epochs( frames )
% [ odd_epoch_frames, even_epoch_frames, odd_epochs, even_epochs ] = get_odd_even_epochs( frames )
%   Detailed explanation goes here

if islogical(frames)
    disp('frames is entered as a logical veriable.  Using "find" function to get indices')
    frames = find(frames);
end

epochs = find_epochs(frames);

odd_epoch_frames = []; even_epoch_frames = []; 
for j = 1:size(epochs,1); 
    if mod(j,2) == 1
        odd_epoch_frames = [odd_epoch_frames epochs(j,1):epochs(j,2)]; 
    elseif mod(j,2) == 0 
        even_epoch_frames = [even_epoch_frames epochs(j,1):epochs(j,2)]; 
    end
end

odd_epochs = find_epochs(odd_epoch_frames);
even_epochs = find_epochs(even_epoch_frames);

end

