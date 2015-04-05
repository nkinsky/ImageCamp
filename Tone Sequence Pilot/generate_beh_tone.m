clear
clc

freq=749;
samplingrate=192000;
dur = 0.5; % duration of the sound in seconds
rise_time=0.01;

sin_tvec=1:floor(samplingrate)*rise_time;
envelope(1:length(sin_tvec))=(1/2+1/2*(sin(-pi/2+sin_tvec*pi/max(sin_tvec))));

tones=zeros(6,dur*samplingrate+2*samplingrate);


    clearvars -except freq tones envelope sin_tvec samplingrate dur s rise_time

sin_tvec=1:floor(samplingrate)*rise_time;
envelope(1:length(sin_tvec))=(1/2+1/2*(sin(-pi/2+sin_tvec*pi/max(sin_tvec))));
    
% number of points in one cycle
cycle_length = round(samplingrate/freq); 

actual_frequency = samplingrate/cycle_length;

    C=1;

% create one cycle first
b = 1:cycle_length;
b = b';
b = b./cycle_length.*2*pi;
a =   C.*sin(b);


% calculate how many cycles in the duration
% add one more cycle just in case
cycle_number = ceil(samplingrate*dur/cycle_length)+1;

% replicate the cycle to the length of teh duration 
a = repmat(a,cycle_number,1);

mid_tvec=1:length(a)-2*length(sin_tvec);

envelope(length(sin_tvec)+1:length(sin_tvec)+length(mid_tvec))=1;
envelope(length(sin_tvec)+length(mid_tvec)+1:length(a))=(1/2+1/2*(cos(sin_tvec*pi/max(sin_tvec))));
%a = a.*normpdf(1:length(a),length(a)/2,length(a)/6)';
a=a.*envelope';
A = a(1:samplingrate*dur);

clear mid_tvec envelope      

tones=A;



clearvars -except tones samplingrate freq dur

 filename=['tones' num2str(dur) 'sec' num2str(freq) '.wav'];
  wavwrite(tones,samplingrate, filename);