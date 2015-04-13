% Calculate F0 correlations from day to day

% File locations + loading them
square_sessions_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\square_sessions_laptop.mat';
octagon_sessions_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\octagon_sessions_laptop.mat';
session_ref_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\session_ref.mat';
reg_info_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\RegistrationInfoX_laptop.mat';
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

%%% Do this with the octagon sessions also! Or maybe with both!!!

F0_corr = zeros(size(square_sessions,2)); F0_var_corr = F0_corr;
for j = 1:size(square_sessions,2)
    if exist([square_sessions(j).folder '\F0_ChangeMovie.mat'],'file')
        reg_index = get_reginfo_index( square_sessions(j).folder, RegistrationInfoX );
        F01 = importdata([square_sessions(j).folder '\F0_ChangeMovie.mat']);
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
    for k = 1:size(square_sessions,2)
        if exist([square_sessions(k).folder '\F0_ChangeMovie.mat'],'file')
            reg_index = get_reginfo_index( square_sessions(k).folder, RegistrationInfoX );
            F02 = importdata([square_sessions(k).folder '\F0_ChangeMovie.mat']);
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
            
            temp = corrcoef(F01_use,F02_use);
            temp2 = corrcoef(F01_use./var1_use,F02_use./var2_use);
            F0_corr(j,k) = temp(1,2);
            F0_var_corr(j,k) = temp(1,2);
        else
            F0_corr(j,k) = nan;
            F0_var_corr(j,k) = nan;
        end
   end
end