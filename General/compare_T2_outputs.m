% Compare T2 outputs

%% Directories
new_dir = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working';
old_dir = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working old version';

%% Variable names to compare

vars_compare = {'Blobs.mat','Transients.mat','ProcOut.mat','NormTraces.mat',...
    'ExpTransients.mat','pPeak.mat','expPosTr.mat','T2Output.mat'};

fullfiles = cellfun(@(a) fullfile(pwd,a),vars_compare,'UniformOutput',0);
[~, field_savename, ~] = cellfun(@fileparts,fullfiles,'UniformOutput',0);


%% Compare

for j = 7% 1:length(vars_compare)
   var_old = load(fullfile(old_dir,vars_compare{j}));
   var_new = load(fullfile(new_dir,vars_compare{j}));
   names = fieldnames(var_old);
   
   for k = 1:length(names)
       try
           if ischar(var_old.(names{k}))
               compare_out = strcmpi(var_old.(names{k}),var_new.(names{k}));
           elseif iscell(var_old.(names{k}))
               compare_out = cell_compare(var_old.(names{k}),var_new.(names{k}));
           elseif isnumeric(var_old.(names{k})) || islogical(var_old.(names{k}))
               temp = var_old.(names{k})(:) == var_new.(names{k})(:);
               if sum(temp) == length(var_old.(names{k})(:))
                   compare_out = 1;
               else
                   compare_out = 0;
               end
           end
           
           var_compare.(field_savename{j}).(names{k}) = compare_out;
       catch
           disp(['Error in comparing ' vars_compare{j} ' variable ' names{k}] )
           continue
       end
   end
    
    
    
end