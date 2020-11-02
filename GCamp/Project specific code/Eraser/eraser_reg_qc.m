% Eraser reg_qc scripts
%% Fix bad registrations listed in file!
checkfilename = 'C:\Users\kinsky\Dropbox\Imaging Project\Manuscripts\Eraser\Figures\Registration Quality\Registration Fix Checklist.xlsx';
round = 6;  % round 1 = auto, round 2 = manual, round 3 = auto that depends on doing round 2 first
[~, ~, bad_list] = xlsread(checkfilename);
bad_list = bad_list(2:end,:);
header = bad_list(1,:);
%%
good_rows = find(cellfun(@(a,b) all(~isnan(a)) & b == round, bad_list(:,1), ...
    bad_list(:,6)));

success_bool = false(size(good_rows));
track_errors = cell(2,1); error_num = 0;
for j = 1:length(good_rows)
    try
        row_use = good_rows(j);
        mouse = bad_list{row_use,1};
        [base_date, base_sesh] = parse_date_sesh(bad_list{row_use, 2});
        [bad_date, bad_sesh] = parse_date_sesh(bad_list{row_use, 3});
        [replace_date, replace_sesh] = parse_date_sesh(bad_list{row_use, 4});
        [alt_base_date, alt_base_sesh] = parse_date_sesh(bad_list{row_use, 5});
        round_check = bad_list{row_use,6};
        manual_flag = bad_list{row_use,7};
        if isnan(manual_flag); manual_flag = ''; end;
        if round_check == round  % double check...
            replace_neuron_reg(mouse, base_date, base_sesh, bad_date, bad_sesh, ...
                replace_date, replace_sesh, '', alt_base_date, alt_base_sesh, ...
                manual_flag);
        end
        success_bool(j) = true;
    catch ME
        disp(['Error in row ' num2str(row_use)]);
        error_num = error_num + 1;
        track_errors{1, error_num} = row_use;
        track_errors{2, error_num} = ME.identifier;
    end
end

