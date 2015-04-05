% Sequential Order Pilot Script

clear all
close all

seq{1} = 'ABCDE';
seq{2} = 'LMNOP';

SO{1} = [16 22 ; 29 15; 12.4 3.4 ; 17.1 8.3 ; 19.6 1; 5.9 7.1];
SO{2} = [5 2.5; 13.8 26.4; 15.4 5.2; 3.2 6.9; 2.9 0 ; 2 2.65 ];
SO{3} = [5.6 4.3; 2.3 5; 15.4 5.2; 7.6 4.7; 1.7 0.5; 3.3 6.3 ];
SO{4} = [ 9.7 19.1; 15.1 25.9; 30 2.5; 10 5.7; 11.4 4.5; 10 2.6];
SO{5} = {'L' 'P' ; 'C' 'D' ; 'M' 'O' ; 'A' 'D' ; 'N' 'P'; 'B' 'C'};

SO_bw{1} = [1.3 2.6; 0 0; 2.1 4 ; 1 2.9];
SO_bw{2} = [1.2 0.8; 3.5 0; 0 1.2 ; 0.7 0]; 
SO_bw{3} = [0.6 0.7; 1.2 0; 0.4 0.4 ; 0.7 0.6];
SO_bw{4} = [4.4 2.4; 3 0.4 ; 4.2 5.7 ; 1.5 4.8 ];
SO_bw{5} = {'A' 'N' ; 'E' 'O'; 'D' 'L' ; 'C' 'M'};

% Get positions and lags for within sequence probes
temp{1} = cellfun(@(a) strfind(seq{1},a),SO{5},'UniformOutput',0);
temp{2} = cellfun(@(a) strfind(seq{2},a),SO{5},'UniformOutput',0);
for j = 1:size(temp{1},1)
   for k = 1:size(temp{1},2)
      if isempty(temp{1}{j,k}) && isempty(temp{2}{j,k})
          pos(j,k) = 0;
      elseif isempty(temp{1}{j,k}) && ~isempty(temp{2}{j,k})
          pos(j,k) = temp{2}{j,k};
      elseif ~isempty(temp{1}{j,k}) && isempty(temp{2}{j,k})
          pos(j,k) = temp{1}{j,k};
      end
   end
end
lags = abs(pos(:,2)-pos(:,1)) - 1;
greater_index = [(pos(:,2) > pos(:,1))] ;

temp_bw{1} = cellfun(@(a) strfind(seq{1},a),SO_bw{5},'UniformOutput',0);
temp_bw{2} = cellfun(@(a) strfind(seq{2},a),SO_bw{5},'UniformOutput',0);
for j = 1:size(temp_bw{1},1)
   for k = 1:size(temp_bw{1},2)
      if isempty(temp_bw{1}{j,k}) && isempty(temp_bw{2}{j,k})
          pos_bw(j,k) = 0;
      elseif isempty(temp_bw{1}{j,k}) && ~isempty(temp_bw{2}{j,k})
          pos_bw(j,k) = temp_bw{2}{j,k};
      elseif ~isempty(temp_bw{1}{j,k}) && isempty(temp_bw{2}{j,k})
          pos_bw(j,k) = temp_bw{1}{j,k};
      end
   end
end
lags_bw = abs(pos_bw(:,2)-pos_bw(:,1)) - 1;
greater_bw_index = [(pos_bw(:,2) > pos_bw(:,1))] ;



% Calculate PIs and compile data
pooled = []; pooled_short = []; pooled_long = [];
pooled_bw = []; pooled_bw_short = []; pooled_bw_long = [];
for j = 1:4
   SO_PI{j}(:,1) = (SO{j}(:,1)-SO{j}(:,2))./(SO{j}(:,1)+SO{j}(:,2)) ;
   for k = 1:length(SO_PI{j}) % Adjust sign if first odor comes after second in the sequence
      if greater_index(k) == 0
          SO_PI{j}(k,1) = -SO_PI{j}(k,1);
      else
      end
   end
   SO_PI_short{j}(:,1) = SO_PI{j}(lags == 0 | lags == 1);
   SO_PI_long{j}(:,1) = SO_PI{j}(lags == 2 | lags == 3);
   pooled = [pooled; SO_PI{j}];
   pooled_short = [pooled_short; SO_PI_short{j}];
   pooled_long = [pooled_long; SO_PI_long{j}];
   
   SO_PI_bw{j}(:,1) = (SO_bw{j}(:,1)-SO_bw{j}(:,2))./(SO_bw{j}(:,1)+SO_bw{j}(:,2)) ;
   
   for k = 1:length(SO_PI_bw{j}) % Adjust sign if first odor comes after second in the sequence
      if greater_bw_index(k) == 0
          SO_PI_bw{j}(k,1) = -SO_PI_bw{j}(k,1);
      else
      end
   end
   
   SO_PI_bw_short{j}(:,1) = SO_PI_bw{j}(lags_bw == 0 | lags_bw == 1);
   SO_PI_bw_long{j}(:,1) = SO_PI_bw{j}(lags_bw == 2 | lags_bw == 3);
   pooled_bw = [pooled_bw; SO_PI_bw{j}];
   pooled_bw_short = [pooled_bw_short; SO_PI_bw_short{j}];
   pooled_bw_long = [pooled_bw_long; SO_PI_bw_long{j}];
   
end


% Run stats
total_mean = mean(pooled);
total_std = std(pooled);
total_t = total_mean/total_std*sqrt(length(pooled));
p_pooled = 1-tcdf(total_t,length(pooled)-1);

short_mean = mean(pooled_short);
short_std = std(pooled_short);
short_t = short_mean/short_std*sqrt(length(pooled_short));
p_short = 1-tcdf(short_t,length(pooled_short)-1);

long_mean = mean(pooled_long);
long_std = std(pooled_long);
long_t = long_mean/long_std*sqrt(length(pooled_long));
p_long = 1-tcdf(long_t,length(pooled_long)-1);

bw_mean = nanmean(pooled_bw);
bw_std = nanstd(pooled_bw);
