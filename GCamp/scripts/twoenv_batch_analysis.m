% Batch script for two-env experiment

%% Set up mega-variable - note that working_dir 1 = square sessions and 2 = octagon sessions (REQUIRED)

Mouse(1).Name = 'G30';
Mouse(1).working_dirs{1} = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working';
Mouse(1).working_dirs{2} = 'J:\GCamp Mice\Working\G30\2env\11_20_2014\1 - 2env octagon left\Working';

Mouse(2).Name = 'G31';
Mouse(2).working_dirs{1} = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\1 - 2env square right\Working';
Mouse(2).working_dirs{2} = 'J:\GCamp Mice\Working\G31\2env\12_16_2014\1 - 2env octagon left\Working';

num_animals = length(Mouse);

for j = 1:num_animals
    Mouse(j).key = '1,1 = square no-rotate, 1,2 = octagon no-rotate, 2,1 = square rotate, 2,2 = octagon rotate';
end

%% Run tmap_corr_across_days for all conditions

for j = 1:num_animals
    for k = 1:length(Mouse(j).working_dirs)
        for m = 0:1
            Mouse(j).corr_matrix{m+1,k} = tmap_corr_across_days(Mouse(j).working_dirs{k},'rotate_to_std',m);
        end
    end
end

%% Dump means into a mega-matrix (combine ALL correlation values here also to get a mega cdf for each session?)

num_sessions = size(Mouse(1).corr_matrix{1},1);
mega_mean(1).matrix = cell(num_sessions,num_sessions); % No rotate
mega_mean(2).matrix = cell(num_sessions,num_sessions); % rotate
for j = 1:num_animals
    for k = 1:2
        for ll = 1:num_sessions
            for mm = 1:num_sessions
                mega_mean_rot_temp = nanmean(squeeze(Mouse(j).corr_matrix{2,k}(ll,mm,:)));
                mega_mean_no_rot_temp = nanmean(squeeze(Mouse(j).corr_matrix{1,k}(ll,mm,:)));
                
                mega_mean(1).matrix{ll,mm} = [mega_mean(1).matrix{ll,mm} mega_mean_no_rot_temp];
                mega_mean(2).matrix{ll,mm} = [mega_mean(2).matrix{ll,mm} mega_mean_rot_temp];
            end
        end
    end
    
end

%% Can I try filtering everything and then doing this?