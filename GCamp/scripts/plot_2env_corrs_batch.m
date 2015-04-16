% NARRATIVE and TO-Do
% It appears that the general story is that, in the absence of a "task",
% the representations are pretty unstable and remap every 1-2 days or so.
% However, we do see stability from day 1 through day 4 general, and from
% day 4 to day 5, but after we introduce a change we see a lot of
% remapping, perhaps due to confusion in the mouse about what is going on.
% 
% TO-DO
% 1) Look at within session correlations to see if there is remapping
% within a session...
% 2) For octagon in particular, look to see how correlations in the middle
% of the arena compare to the edges... they seem much higher, so maybe the
% remapping is all due to confusion about how the arena is rotated...
% 3) Look at correlations between day 4 session 2 and the first part of day
% 5 (only in the rectangle BEFORE the environments are connected). Compare
% to the same AFTER the arenas are connected.

rotate_flag = 1;

%% File Locations

%%% NORVAL %%%
if rotate_flag == 1
rot_txt_sq = '';
rvp_filename = 'reverse_placefields_ChangeMovie.mat';
square_session(1).file = 'J:\GCamp Mice\Working\2env\11_19_2014\1 - 2env square left 201B\Working\blah';
square_session(2).file = 'J:\GCamp Mice\Working\2env\11_19_2014\2 - 2env square mid 201B\Working\corrs_cmperbin2_day1_sesh1_z_smooth.mat';
square_session(3).file = 'J:\GCamp Mice\Working\2env\11_22_2014\1 - 2env square right 201B\Working\corrs_cmperbin2_day1_sesh2_z_smooth.mat';
square_session(4).file = 'J:\GCamp Mice\Working\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working\corrs_cmperbin2_day4_sesh1_z_smooth.mat';
square_session(5).file = 'J:\GCamp Mice\Working\2env\11_23_2014\Working\session1\square left\corrs_cmperbin2_day4_sesh2_z_smooth.mat'; % **Need to breakd down more
square_session(6).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\1 - square right 180\corrs_cmperbin2_day5_sesh1_z_smooth.mat'; % **Need to breakd down more
square_session(7).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\1 - square right 180\corrs_cmperbin2_day7_sesh1_z_smooth.mat';
square_session(8).file = 'J:\GCamp Mice\Working\2env\11_25_2014\2 - 2env square right 90CCW 201B\Working\corrs_cmperbin2_day7_sesh1_z_smooth.mat';
square_only_file = 'J:\GCamp Mice\Working\2env\11_23_2014\Working\session1\square left\square only\1st half only\corrs_cmperbin2_day4_sesh1_z_smooth.mat';

rot_txt_oct = '';
octagon_session(1).file = 'J:\GCamp Mice\Working\2env\11_20_2014\1 - 2env octagon left\Working\blah';
octagon_session(2).file = 'J:\GCamp Mice\Working\2env\11_20_2014\2 - 2env octagon right 90CCW\Working\corrs_cmperbin2_day2_sesh1_z_smooth.mat';
octagon_session(3).file = 'J:\GCamp Mice\Working\2env\11_21_2014\1 - 2env octagon mid 201B\Working\corrs_cmperbin2_day2_sesh2_z_smooth.mat';
octagon_session(4).file = 'J:\GCamp Mice\Working\2env\11_21_2014\2 - 2env octagon left  90CW 201B\Working\corrs_cmperbin2_day3_sesh1_z_smooth.mat';
octagon_session(5).file = 'J:\GCamp Mice\Working\2env\11_23_2014\Working\session2\octagon right\corrs_cmperbin2_day3_sesh2_z_smooth.mat'; % **Need to breakd down more
octagon_session(6).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\1 - square right 180\corrs_cmperbin2_day5_sesh1_z_smooth.mat'; % **Need to breakd down more
octagon_session(7).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\2 - octagon left 180\corrs_cmperbin2_day8_sesh1_z_smooth.mat';
octagon_session(8).file = 'J:\GCamp Mice\Working\2env\11_26_2014\2 - 2 env octagon mid 201B\Working\corrs_cmperbin2_day8_sesh1_z_smooth.mat';
elseif rotate_flag == 0
%%% NORVAL - NO ROTATE CONTROL %%%
rvp_filename = 'reverse_placefields_ChangeMovie_no_rotate.mat';
rot_txt_sq = ' - No Rotation Control'; % This gets stuck into titles of figures
square_session(1).file = 'J:\GCamp Mice\Working\2env\11_19_2014\1 - 2env square left 201B\Working\blah';
square_session(2).file = 'J:\GCamp Mice\Working\2env\11_19_2014\2 - 2env square mid 201B\Working\corrs_cmperbin2_day1_sesh1_no_rotate_z_smooth.mat';
square_session(3).file = 'J:\GCamp Mice\Working\2env\11_22_2014\1 - 2env square right 201B\Working\corrs_cmperbin2_day1_sesh2_no_rotate_z_smooth.mat';
square_session(4).file = 'J:\GCamp Mice\Working\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working\corrs_cmperbin2_day4_sesh1_no_rotate_z_smooth.mat';
square_session(5).file = 'J:\GCamp Mice\Working\2env\11_23_2014\Working\session1\square left\corrs_cmperbin2_day4_sesh2_no_rotate_z_smooth.mat'; % **Need to breakd down more
square_session(6).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\1 - square right 180\corrs_cmperbin2_day5_sesh1_no_rotate_z_smooth.mat'; % **Need to breakd down more
square_session(7).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\1 - square right 180\corrs_cmperbin2_day7_sesh1_no_rotate_z_smooth.mat';
square_session(8).file = 'J:\GCamp Mice\Working\2env\11_25_2014\2 - 2env square right 90CCW 201B\Working\corrs_cmperbin2_day7_sesh1_no_rotate_z_smooth.mat';
square_only_file = 'J:\GCamp Mice\Working\2env\11_23_2014\Working\session1\square left\square only\1st half only\corrs_cmperbin2_day4_sesh1_no_rotate_z_smooth.mat';

rot_txt_oct = ' - No Rotation Control'; % This gets stuck into titles of figures
octagon_session(1).file = 'J:\GCamp Mice\Working\2env\11_20_2014\1 - 2env octagon left\Working\blah';
octagon_session(2).file = 'J:\GCamp Mice\Working\2env\11_20_2014\2 - 2env octagon right 90CCW\Working\corrs_cmperbin2_day2_sesh1_no_rotate_z_smooth.mat';
octagon_session(3).file = 'J:\GCamp Mice\Working\2env\11_21_2014\1 - 2env octagon mid 201B\Working\corrs_cmperbin2_day2_sesh2_no_rotate_z_smooth.mat';
octagon_session(4).file = 'J:\GCamp Mice\Working\2env\11_21_2014\2 - 2env octagon left  90CW 201B\Working\corrs_cmperbin2_day3_sesh1_no_rotate_z_smooth.mat';
octagon_session(5).file = 'J:\GCamp Mice\Working\2env\11_23_2014\Working\session2\octagon right\corrs_cmperbin2_day3_sesh2_no_rotate_z_smooth.mat'; % **Need to breakd down more
octagon_session(6).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\1 - square right 180\corrs_cmperbin2_day5_sesh1_no_rotate_z_smooth.mat'; % **Need to breakd down more
%%% THE FILE BELOW SHOULD BE SESH1!!!
octagon_session(7).file = 'J:\GCamp Mice\Working\2env\11_24_2014\Working\2 - octagon left 180\corrs_cmperbin2_day8_sesh2_no_rotate_z_smooth.mat'; % 
octagon_session(8).file = 'J:\GCamp Mice\Working\2env\11_26_2014\2 - 2 env octagon mid 201B\Working\corrs_cmperbin2_day8_sesh1_no_rotate_z_smooth.mat';
end

% rot_txt_oct = 'No Rotation Control'; % This gets stuck into titles of figures

% ** for day 4-5 and 6-7, these only compare the WHOLE 2env session to the
% individual session, so I need to look at only the first (or last) 5
% minutes in the 2 env arena.  For days 5-6, I need to break this down into
% only octagon or only square sessions
square_days = [ 1 1 4 4 5 6 7 4 ; ......should be able to do this by manually breaking up the Pos.mat file...
                1 4 4 5 6 7 7 5];
square_sesh = [ 1 2 1 2 1 1 1 2; ...
                2 1 2 1 1 1 2 1];
octagon_days = [ 2 2 3 3 5 6 8 ;
                 2 3 3 5 6 8 8] ;
octagon_sesh = [ 1 2 1 2 2 1 1 ;
                 2 1 2 2 2 2 2] ;
%% This helps get all the appropriate file locations you may need to past into above...
% for i = 1:8
%     cd(octagon_sessions(i).folder);
%     t = ls('*.mat');
%     clear ttt
%     for j = 1:size(t,1)
%         ttt(j) = ~isempty(regexpi(t(j,:),'corrs_cmperbin2')) & isempty(regexpi(t(j,:),'_no_rotate'));
%     end
%     ind_use = find(ttt);
%     if sum(ttt) == 1
%         filename{i} = t(ind_use,:);
%     else
%         filename{i} = 'blah';
%     end
% end

%% Load and plot square sessions

for j = 1:8
    if j < 8
        load(square_session(j+1).file);
        square_session(j+1).corr_1_2 = nanmean(corrs.corr_1_2(:));
        square_session(j+1).corr_2_win = nanmean(corrs.corr_2_win(:));
        square_session(j).corr_1_win = nanmean(corrs.corr_1_win(:));
        square_session(j+1).shuffle_max = max(corrs.corr_shuffle);
        square_session(j+1).text_bw = ['D' num2str(square_days(1,j)) '.' ...
            num2str(square_sesh(1,j)) ' - D' num2str(square_days(2,j)) '.' ...
            num2str(square_sesh(2,j))];
        square_session(j).text_win = ['D' num2str(square_days(1,j)) '.' ...
            num2str(square_sesh(1,j)) ];
    end
    file_rvp = [ square_session(j).file(1:max(regexpi(square_session(j).file,'\\')))...
        rvp_filename];
    load(file_rvp,'corrs')
    square_session(j).corr_1_ctrl = corrs.control_1_2_z;
end
square_session(1).corr_1_2 = nan;
square_session(1).text_bw = 'NA';
square_session(8).corr_1_win = square_session(7).corr_2_win;
square_session(8).text_win = ['D' num2str(square_days(2,7)) '.' ...
       num2str(square_sesh(2,7)) ];
square_session(1).shuffle_max = nan;


square_corr_plot = arrayfun(@(a) a.corr_1_2,square_session);
square_xtick = arrayfun(@(a) a.text_bw, square_session,'UniformOutput',0);
square_corr_win = arrayfun(@(a) a.corr_1_win,square_session);
square_corr_win_ctrl = arrayfun(@(a) a.corr_1_ctrl,square_session);
square_win_xtick = arrayfun(@(a) a.text_win, square_session,'UniformOutput',0);
square_shufflemax_plot = arrayfun(@(a) a.shuffle_max, square_session);

% Plot square corrs
h = figure; 
subplot(2,2,1); 
plot(1:8, square_corr_plot, 'bs-', 1:8, square_shufflemax_plot, 'rs--',...
    [5 5], [0 1],'g-.', [7 7], [0 1], 'k-.')
ylabel('Correlation'); title(['Whole Arena Correlations (Square)' rot_txt_sq]);
xlim([1 8]); ylim([0 0.7]); set(gca,'XTickLabel', square_xtick)
legend('Square session corrs', 'shuffled max values','hallway open','hallway closed')
subplot(2,2,2);
plot(1:8, square_corr_win,'bs-',1:8, square_corr_win_ctrl,'r--'); ylim([0 0.7])
ylabel('Correlation'); title('Square Within Day Correlations - Whole Arena'); 
xlabel('Day.Session'); legend('1st half to 2nd half','Interleaved Control');
set(gca,'XTickLabel', square_win_xtick);


% Plot w-in values to make sure remapping isn't occuring within
% Plot octagon also!

%% Plot Octagon Sessions

for j = 1:7
   load(octagon_session(j+1).file);
   octagon_session(j+1).corr_1_2 = nanmean(corrs.corr_1_2(:));
   octagon_session(j+1).corr_2_win = nanmean(corrs.corr_2_win(:));
   octagon_session(j).corr_1_win = nanmean(corrs.corr_1_win(:));
   octagon_session(j+1).shuffle_max = max(corrs.corr_shuffle);
   octagon_session(j+1).text_bw = ['D' num2str(octagon_days(1,j)) '.' ...
       num2str(octagon_sesh(1,j)) ' - D' num2str(octagon_days(2,j)) '.' ...
       num2str(octagon_sesh(2,j))];
   octagon_session(j).text_win = ['D' num2str(octagon_days(1,j)) '.' ...
       num2str(octagon_sesh(1,j)) ];
end
octagon_session(1).corr_1_2 = nan;
octagon_session(1).text_bw = 'NA';
octagon_session(8).corr_1_win = octagon_session(7).corr_2_win;
octagon_session(8).text_win = ['D' num2str(octagon_days(2,7)) '.' ...
       num2str(octagon_sesh(2,7)) ];
octagon_session(1).shuffle_max = nan;

octagon_corr_plot = arrayfun(@(a) a.corr_1_2,octagon_session);
octagon_xtick = arrayfun(@(a) a.text_bw, octagon_session,'UniformOutput',0);
octagon_corr_win = arrayfun(@(a) a.corr_1_win,octagon_session);
octagon_win_xtick = arrayfun(@(a) a.text_win, octagon_session,'UniformOutput',0);
octagon_shufflemax_plot = arrayfun(@(a) a.shuffle_max, octagon_session);

% Plot octagon corrs
figure(h); 
subplot(2,2,3)
plot(1:8,octagon_corr_plot,'bs-',1:8,octagon_shufflemax_plot,'rs--',...
    [5 5], [0 1],'g-.', [7 7], [0 1], 'k-.')
xlim([1 8]); ylim([0 0.7]); set(gca,'XTickLabel', octagon_xtick)
ylabel('Correlation'); title(['Whole Arena Correlations (Octagon)' rot_txt_oct])
legend('Octagon session corrs', 'shuffled max values')
subplot(2,2,4)
plot(1:8, octagon_corr_win,'bs-'); ylim([0 0.7])
ylabel('Correlation'); title(['Octagon Within Day Correlations (Whole Arena)' rot_txt_oct]); 
xlabel('Day')

% Average Square and Octagon
figure
plot(1:8,mean([square_corr_plot ; octagon_corr_plot],1),...
    'bs-',1:8,octagon_shufflemax_plot,'rs--',...
    [5 5], [0 1],'g-.', [7 7], [0 1], 'k-.')
xlim([1 8]); ylim([0 0.7]); set(gca,'XTickLabel', octagon_xtick)
ylabel('Correlation'); title([ 'Whole Arena Correlations' rot_txt_sq])
legend('Average Session Corrs', 'shuffled max values')


%% Load and plot square sessions centers only

cx = 4:7; cy = 4:7;

for j = 1:7
   load(square_session(j+1).file);
   square_session(j+1).corr_1_2 = mean(nanmean(corrs.corr_1_2(cy,cx)));
   square_session(j+1).corr_2_win = mean(nanmean(corrs.corr_2_win(cy,cx)));
   square_session(j).corr_1_win = mean(nanmean(corrs.corr_1_win(cy,cx)));
   square_session(j+1).shuffle_max = max(corrs.corr_shuffle);
   square_session(j+1).text_bw = ['D' num2str(square_days(1,j)) '.' ...
       num2str(square_sesh(1,j)) ' - D' num2str(square_days(2,j)) '.' ...
       num2str(square_sesh(2,j))];
   square_session(j).text_win = ['D' num2str(square_days(1,j)) '.' ...
       num2str(square_sesh(1,j)) ];
end
square_session(1).corr_1_2 = nan;
square_session(1).text_bw = 'NA';
square_session(8).corr_1_win = square_session(7).corr_2_win;
square_session(8).text_win = ['D' num2str(square_days(2,7)) '.' ...
       num2str(square_sesh(2,7)) ];
square_session(1).shuffle_max = nan;

square_corr_plot = arrayfun(@(a) a.corr_1_2,square_session);
square_xtick = arrayfun(@(a) a.text_bw, square_session,'UniformOutput',0);
square_corr_win = arrayfun(@(a) a.corr_1_win,square_session);
square_win_xtick = arrayfun(@(a) a.text_win, square_session,'UniformOutput',0);
square_shufflemax_plot = arrayfun(@(a) a.shuffle_max, square_session);

% Plot square corrs
h2 = figure; 
subplot(2,2,1); 
plot(1:8, square_corr_plot, 'bs-', 1:8, square_shufflemax_plot, 'rs--',...
    [5 5], [0 1],'g-.', [7 7], [0 1], 'k-.')
ylabel('Correlation'); title([ 'Center of Arena Correlations (Square)' rot_txt_sq]);
xlim([1 8]); ylim([0 0.7]); set(gca,'XTickLabel', square_xtick)
legend('Square session corrs', 'shuffled max values','hallway open','hallway closed')
subplot(2,2,2);
plot(1:8, square_corr_win,'bs-'); ylim([0 0.7])
ylabel('Correlation'); title(['Square Within Day Correlations (Center Only)' rot_txt_sq]);
xlabel('Day')


% Plot w-in values to make sure remapping isn't occuring within
% Plot octagon also!

%% Plot Octagon Sessions - centers only
cy = 6:8; cx = 4:6;

for j = 1:7
   load(octagon_session(j+1).file);
   octagon_session(j+1).corr_1_2 = mean(nanmean(corrs.corr_1_2(cy,cx)));
   octagon_session(j+1).corr_2_win = mean(nanmean(corrs.corr_2_win(cy,cx)));
   octagon_session(j).corr_1_win = mean(nanmean(corrs.corr_1_win(cy,cx)));
   octagon_session(j+1).shuffle_max = max(corrs.corr_shuffle);
   octagon_session(j+1).text_bw = ['D' num2str(octagon_days(1,j)) '.' ...
       num2str(octagon_sesh(1,j)) ' - D' num2str(octagon_days(2,j)) '.' ...
       num2str(octagon_sesh(2,j))];
   octagon_session(j).text_win = ['D' num2str(octagon_days(1,j)) '.' ...
       num2str(octagon_sesh(1,j)) ];
end
octagon_session(1).corr_1_2 = nan;
octagon_session(1).text_bw = 'NA';
octagon_session(8).corr_1_win = octagon_session(7).corr_2_win;
octagon_session(8).text_win = ['D' num2str(octagon_days(2,7)) '.' ...
       num2str(octagon_sesh(2,7)) ];
octagon_session(1).shuffle_max = nan;

octagon_corr_plot = arrayfun(@(a) a.corr_1_2,octagon_session);
octagon_xtick = arrayfun(@(a) a.text_bw, octagon_session,'UniformOutput',0);
octagon_corr_win = arrayfun(@(a) a.corr_1_win,octagon_session);
octagon_win_xtick = arrayfun(@(a) a.text_win, octagon_session,'UniformOutput',0);
octagon_shufflemax_plot = arrayfun(@(a) a.shuffle_max, octagon_session);

% Plot octagon corrs
figure(h2); 
subplot(2,2,3)
plot(1:8,octagon_corr_plot,'bs-',1:8,octagon_shufflemax_plot,'rs--',...
    [5 5], [0 1],'g-.', [7 7], [0 1], 'k-.')
ylabel('Corelations'); title([ 'Center of Arena Correlations (Octagon)' rot_txt_oct])
xlim([1 8]); ylim([0 0.7]); set(gca,'XTickLabel', octagon_xtick)
legend('Octagon session corrs', 'shuffled max values')
subplot(2,2,4)
plot(1:8, octagon_corr_win,'bs-'); ylim([0 0.7])
ylabel('Correlation'); title([ 'Octagon Within Day Correlations (Center Only)' rot_txt_oct]); xlabel('Day')

% Average Square and Octagon
figure
plot(1:8,mean([square_corr_plot ; octagon_corr_plot],1),...
    'bs-',1:8,octagon_shufflemax_plot,'rs--',...
    [5 5], [0 1],'g-.', [7 7], [0 1], 'k-.')
xlim([1 8]); ylim([0 0.7]); set(gca,'XTickLabel', octagon_xtick)
ylabel('Correlation'); title([ 'Center of Arena Correlations' rot_txt_sq])
legend('Average Session Corrs', 'shuffled max values')
