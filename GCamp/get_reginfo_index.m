function [ reg_index ] = get_reginfo_index( reg_folder, RegistrationInfoX )
%[ reg_index ] = get_reginfo_index( reg_folder, RegistrationInfoX )
%   Get index to use in RegistrationInfoX file.
for k = 1:size(RegistrationInfoX,2);
    temp(k) = strcmpi([reg_folder '\ICmovie_min_proj.tif'], ...
        RegistrationInfoX(k).register_file);
end
reg_index = find(temp);
end

