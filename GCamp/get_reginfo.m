function [tform_struct ] = get_reginfo( working_folder, RegistrationInfoX )
% [ tform ] = get_reginfo( working_folder, RegistrationInfoX )
%   Matches the session working_folder up to the data in RegistrationInfoX
%   and pulls all the appropriate registration data

for k = 1:size(RegistrationInfoX,2);
    temp(k) = strcmpi([working_folder '\ICmovie_min_proj.tif'], ...
        RegistrationInfoX(k).register_file);
end
tform_use = RegistrationInfoX(temp).tform;
reg_pix_exclude = RegistrationInfoX(temp).exclude_pixels;

tform_struct.tform = tform_use;
tform_struct.reg_pix_exclude = reg_pix_exclude;
tform_struct.base_ref = imref2d(size(imread(RegistrationInfoX(temp).base_file)));

end

