%% Alternation reference
MD = MakeMouseSessionListNK('Nat');

j = 1; 
G30_start = '10_16_2014';
% G30_alt(j).Date = '10_28_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '10_30_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '10_31_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_10_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_11_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_12_2014'; G30_alt(j).Session = 1; j = j+1;
G30_alt(j).Date = '11_13_2014'; G30_alt(j).Session = 1; j = j+1;
[G30_alt(:).Animal] = deal('GCamp6f_30');

j = 1; 
G31_start = '11_24_2014';
G31_alt(j).Date = '11_24_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '11_25_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '11_26_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_02_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_03_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_04_2014'; G31_alt(j).Session = 1; j = j+1;
G31_alt(j).Date = '12_11_2014'; G31_alt(j).Session = 1; j = j+1;
[G31_alt(:).Animal] = deal('GCamp6f_31'); 

j = 1;
G45_start = '09_08_2015';
G45_alt(j).Date = '09_08_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_23_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_23_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '09_24_2015'; G45_alt(j).Session = 1; j = j+1;
G45_alt(j).Date = '09_24_2015'; G45_alt(j).Session = 2; j = j+1;
G45_alt(j).Date = '10_02_2015'; G45_alt(j).Session = 1; j = j+1;
[G45_alt(:).Animal] = deal('GCamp6f_45'); 
 
j = 1; 
G45_start = '09_10_2015';
G48_alt(j).Date = '10_13_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_13_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 1; j = j+1;
% G48_alt(j).Date = '10_14_2015'; G48_alt(j).Session = 2; j = j+1; % Bad frames need to be corrected
G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 1; j = j+1; % Need ICmovie_min_proj.tif
G48_alt(j).Date = '10_15_2015'; G48_alt(j).Session = 2; j = j+1;
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 1; j = j+1;
G48_alt(j).Date = '10_16_2015'; G48_alt(j).Session = 2; j = j+1;
[G48_alt(:).Animal] = deal('GCamp6f_48'); 

alt_all_cell{1} = G30_alt; alt_all_cell{2} = G31_alt; %Parsed out by mouse
alt_all_cell{3} = G45_alt; alt_all_cell{4} = G48_alt;
alt_all = cat(2,alt_all_cell{:}); % All together
alt_all = complete_MD(alt_all);