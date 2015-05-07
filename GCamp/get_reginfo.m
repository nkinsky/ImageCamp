function [tform_struct ] = get_reginfo( base_folder, reg_folder, RegistrationInfoX )
% [ tform ] = get_reginfo( working_folder, RegistrationInfoX )
%   Matches the session working_folders base_folder and reg_folder up to the data in RegistrationInfoX
%   and pulls all the appropriate registration data.  If base folder is
%   specified as [], then it only searches for reg_folder.

% Get
for k = 1:size(RegistrationInfoX,2);
    if ~isempty(base_folder)
        temp_base(k) = strcmpi([base_folder '\ICmovie_min_proj.tif'], ...
            RegistrationInfoX(k).base_file);
    else
        temp_base(k) = 1;
    end
    temp_reg(k) = strcmpi([reg_folder '\ICmovie_min_proj.tif'], ...
        RegistrationInfoX(k).register_file);
end
temp = temp_base & temp_reg; % Get boolean to correct index in RegistrationInfoX
% Pull relevant info
tform_use = RegistrationInfoX(temp).tform;
reg_pix_exclude = RegistrationInfoX(temp).exclude_pixels;

% Dump into a structure
tform_struct.tform = tform_use;
tform_struct.reg_pix_exclude = reg_pix_exclude;
tform_struct.base_ref = imref2d(size(imread(RegistrationInfoX(temp).base_file)));

end

