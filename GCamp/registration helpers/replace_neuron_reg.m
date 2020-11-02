function [] = replace_neuron_reg(animal_name, base_date, base_session,...
    bad_date, bad_session, replace_date, replace_session, name_append,...
    alt_base_date, alt_base_session, manual)
% replace_neuron_reg(animal_name, base_date, base_session,...
%     bad_date, bad_session, replace_date, replace_session, ...
%     alt_base_date, alt_base_session)
%  Fixes a bad neuron registration between "base" and "bad" sessions by using
%  the image registration between base and replace sessions. Good for
%  fixing registrations that are good for one but not the other of two
%  sessions recording and motion-corrected together on a given day.
%
% INPUTS: animal name and date/session # for each session being considered.
% "name_append" is what is appended to the end of each registration if
% used. alt_base_session uses a different base session.  manual: ''(default)
% = run automatic registration, 'masks' = try using neuron masks instead of
% minimum projection, 'manual' = try manual registration.

if nargin < 10
    manual = '';
    if nargin < 9
        alt_base_date = nan;
        alt_base_session = nan;
        if nargin < 8
            name_append = '';
        end
    end
end

%% First rename the registration info for the bad session 
base_dir = ChangeDirectory(animal_name, base_date, base_session, 0);

bad_reg_filenames{1} = fullfile(base_dir, ['RegistrationInfo-' animal_name '-' ...
    bad_date '-session' num2str(bad_session) name_append '.mat']);
bad_reg_filenames{2} = fullfile(base_dir,['neuron_map-' animal_name '-' ...
    bad_date '-session' num2str(bad_session) name_append '.mat']);

if all(cellfun(@(a) exist([a(1:(end-4)) '_bad.mat'],'file'), bad_reg_filenames))
    disp('Bad reg files already renamed')
else
    cellfun(@(a) copyfile(a, [a(1:(end-4)) '_bad.mat']), bad_reg_filenames)
end

%% Now delete files being extra careful to make sure the backup exists

for j = 1:2
    if exist([bad_reg_filenames{j}(1:(end-4)) '_bad.mat'], 'file')
        delete(bad_reg_filenames{j});
    end
end

%% Now load good image registration file
if isempty(manual)
    if isnan(alt_base_date)
        replace_filename = fullfile(base_dir, ['RegistrationInfo-' animal_name '-' ...
            replace_date '-session' num2str(replace_session) name_append '.mat']);
    else
        alt_base_dir = ChangeDirectory(animal_name, alt_base_date, ...
            alt_base_session, 0);
        replace_filename = fullfile(alt_base_dir, ['RegistrationInfo-' animal_name '-' ...
            replace_date '-session' num2str(replace_session) name_append '.mat']);
    end
    
    % Load good image transform between base and replace sessions to use for
    % base-bad session-pair
    load(replace_filename, 'RegistrationInfoX');
    alt_reg_tform = RegistrationInfoX.tform.T;
    % save(replace_filename, 'RegistrationInfoX');
end

%% Now re-run registration
switch manual
    case ''
        neuron_register(animal_name, base_date, base_session, bad_date, ...
            bad_session, 'alt_reg', alt_reg_tform);
    case 'masks'
        neuron_register(animal_name, base_date, base_session, bad_date, ...
            bad_session, 'use_neuron_masks', true);
    case 'manual'
        neuron_register(animal_name, base_date, base_session, bad_date, ...
            bad_session, 'manual_reg_enable', true);
    case 'identity'
        neuron_register(animal_name, base_date, base_session, bad_date, ...
            bad_session, 'alt_reg', affine2d(eye(3)));
    otherwise
        error('manual flag must be empty or masks or manual')
end


end

