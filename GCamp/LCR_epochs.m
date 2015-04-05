% Calculate L, R, and Center epochs

%% Load data


%% Smooth Data!!! This will help later for sure!! Hopefully this will prevent
% jumps

%% Find jumps and fill in values in-between

%% Establish limits

yr = [34 42];
yl = [12 20];
cent = [20 34];

l_index = y >= yl(1) & y < yl(2);
c_index = y >= cent(1) & y < cent(2);
r_index = y >= yr(1) & y < yr(2);

figure
plot(x,y,'b-',x(l_index),y(l_index),'r.',x(c_index),y(c_index),'m.',...
    x(r_index),y(r_index),'g.')

[ l_starts, l_ends] = find_start_end( l_index );
[ c_starts, c_ends] = find_start_end( c_index );
[ r_starts, r_ends] = find_start_end( r_index );

%% Filter out any trips that are less than 50 frames
f_cut = 50;

l_dur = l_ends-l_starts; l_ok = l_dur >= f_cut; 
l_starts_v = l_starts(l_ok); l_ends_v = l_ends(l_ok); 

c_dur = c_ends-c_starts; c_ok = c_dur >= f_cut; 
c_starts_v = c_starts(c_ok); c_ends_v = c_ends(c_ok); 

r_dur = r_ends-r_starts; r_ok = r_dur >= f_cut; 
r_starts_v = r_starts(r_ok); r_ends_v = r_ends(r_ok); 

% Need to figure out how to combine two trips to a given arm that have a
% jump in between them... maybe include data from "findjumps?" YES!
% Or look for

%% Figure out what the closest "ends" is if in the center stem...

for j = 1:length(c_starts_v)
    
    if sum(c_starts_v(j) == r_ends_v) == 1
        c_trial{j} = 'r';
    elseif sum(c_starts_v(j) == l_ends_v) == 1
        c_trial{j} = 'l';
    end
    
end


%% Plot check

for j = 1:length(r_ends)-1

    figure(10)
    subplot(1,2,1)
    plot(x,y,'b-',x(r_starts(j):1:r_ends(j)),y(r_starts(j):1:r_ends(j)),'r.')
    title(num2str(j))
    subplot(1,2,2)
    plot(x,y,'b-',x(r_starts(j+1):1:r_ends(j+1)),y(r_starts(j+1):1:r_ends(j+1)),'g.')
    title(num2str(j+1))
    
    waitforbuttonpress

end


    





