% Calculate F0 correlations from day to day

comp_use = 'norval';
arena_type = {'square' 'octagon'};

% File locations + loading them
if strcmpi(comp_use,'laptop')
    % LAPTOP %
    square_sessions_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\square_sessions_laptop.mat';
    octagon_sessions_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\octagon_sessions_laptop.mat';
    session_ref_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\session_ref.mat';
    reg_info_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\RegistrationInfoX_laptop.mat';
elseif strcmpi(comp_use,'norval')
    % NORVAL %
    session_ref_file = 'J:\GCamp Mice\Working\2env\session_ref.mat';
    square_sessions_file = 'J:\GCamp Mice\Working\2env\square_sessions.mat';
    octagon_sessions_file = 'J:\GCamp Mice\Working\2env\octagon_sessions.mat';
    reg_info_file = 'J:\GCamp Mice\Working\2env\RegistrationInfoX.mat';
    cell_mask_file = 'J:\GCamp Mice\Working\2env\11_19_2014\1 - 2env square left 201B\Working\AllICmask.mat';
end

load(square_sessions_file); load(octagon_sessions_file);
load(session_ref_file); load(reg_info_file);

% General pixels to exclude
base_ref = imref2d(size(imread(RegistrationInfoX(1).base_file)));
% Pixels to exclude from RVP analysis! (e.g. due to traveling waves, motion
% artifacts, etc.)
% AvgFrame_DF_reg = ones(RegistrationInfo(1).base_ref.ImageSize);
num_x_pixels = base_ref.ImageSize(2);
num_y_pixels = base_ref.ImageSize(1);
x_exclude = 325:num_x_pixels; % in pixels
y_exclude = 300:num_y_pixels;
exclude_gen = zeros(base_ref.ImageSize);
exclude_gen(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));

% % This is stolen from reverse_placefield_grouped2 and excludes all non IC
% % areas...still not the best, but eliminates most of the background!!!
% AvgFrame_DF_reg = ones(tform(1).base_ref.ImageSize);
% num_x_pixels = size(AvgFrame_DF_reg,2);
% num_y_pixels = size(AvgFrame_DF_reg,1);
% x_exclude = 325:num_x_pixels; % in pixels
% y_exclude = 300:num_y_pixels;
% exclude = zeros(size(AvgFrame_DF_reg));
% exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));
% % keyboard
% load(cell_mask_file);
% exclude = ~(AllICmask & ~exclude); 
% % Exclude pixels due to registration
% for j = 1:2
%     if ~isempty(tform(j).reg_pix_exclude)
%         exclude(:) = exclude(:) | tform(j).reg_pix_exclude;
%     end
% end

%%% Do this with the octagon sessions also! Or maybe with both!!!

% Set sesh_use = square or octagon, depending on which you want to look at
for i = 1:2
    if strcmpi(arena_type{i},'square')
        sesh_use = square_sessions;
    elseif strcmpi(arena_type{i},'octagon')
        sesh_use = octagon_sessions;
    end
    F0_corr = zeros(size(sesh_use,2)); F0_var_corr = F0_corr;
    for j = 1:size(sesh_use,2)
        if exist([sesh_use(j).folder '\F0_ChangeMovie.mat'],'file')
            reg_index = get_reginfo_index( sesh_use(j).folder, RegistrationInfoX );
            F01 = importdata([sesh_use(j).folder '\F0_ChangeMovie.mat']);
            F01_reg = imwarp(F01.F0,RegistrationInfoX(reg_index).tform,'OutputView', ...
                base_ref, 'InterpolationMethod','nearest');
            var1_reg = imwarp(F01.image_var,RegistrationInfoX(reg_index).tform,'OutputView', ...
                base_ref, 'InterpolationMethod','nearest');
            
            exclude(:) = exclude_gen(:) | RegistrationInfoX(reg_index).exclude_pixels;
        else
            disp(['Skipping Session ' num2str(j)])
            F0_corr(j,:) = nan;
            F0_var_corr(j,:) = nan;
            continue
        end
        
        % Need something to exclude certain pixels here...
        for k = 1:size(sesh_use,2)
            if exist([sesh_use(k).folder '\F0_ChangeMovie.mat'],'file')
                reg_index = get_reginfo_index( sesh_use(k).folder, RegistrationInfoX );
                F02 = importdata([sesh_use(k).folder '\F0_ChangeMovie.mat']);
                F02_reg = imwarp(F02.F0,RegistrationInfoX(reg_index).tform,'OutputView', ...
                    base_ref, 'InterpolationMethod','nearest');
                var2_reg = imwarp(F02.image_var,RegistrationInfoX(reg_index).tform,'OutputView', ...
                    base_ref, 'InterpolationMethod','nearest');
                
                % Update exclude to include pixels from 2nd session
                exclude(:) = exclude(:) | RegistrationInfoX(reg_index).exclude_pixels;
                include = ~exclude;
                
                F01_use = zeros(size(F01_reg)); F02_use = F01_use;
                var1_use = F01_use; var2_use = F01_use;
                F01_use(include) = F01_reg(include);
                F02_use(include) = F02_reg(include);
                var1_use(include) = var1_reg(include);
                var2_use(include) = var2_reg(include);
                
                % Correlations!!!
                temp = corrcoef(F01_use,F02_use);
                temp2 = corrcoef(F01_use./var1_use,F02_use./var2_use);
                F0_corr(j,k) = temp(1,2);
                F0_var_corr(j,k) = temp(1,2);
                
                % Distances
                F0_dist(j,k) = pdist([F01_use(:) F02_use(:)]');
                
            else
                F0_corr(j,k) = nan;
                F0_var_corr(j,k) = nan;
            end
        end
        F0_sesh(i).F0_regj} = F01_use;
    end
    F0_sesh(i).arena = arena_type{i};
    F0_sesh(i).F0_corr = F0_corr;
    F0_sesh(i).F0_var_corr = F0_var_corr;
    F0_sesh(i).F0_dist = F0_dist;

end