% Save workspace with date_str appended

temp_date = datevec(now);

save_name = ['workspace_' num2str(temp_date(1)) '_' num2str(temp_date(2)) ...
    '_' num2str(temp_date(3)) '_' num2str(temp_date(4))...
    '_' num2str(temp_date(5)),'.mat'];

save(save_name)