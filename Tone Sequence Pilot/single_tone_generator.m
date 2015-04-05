clear
clc

freq=[750 1500 3000 6000 12000 24000];
samplingrate=192000;
dur = 0.5; % duration of the sound in seconds

sin_tvec=1:floor(samplingrate)*0.005;
envelope(1:length(sin_tvec))=(1/2+1/2*(sin(-pi/2+sin_tvec*pi/max(sin_tvec))));

tones=zeros(6,dur*samplingrate+2*samplingrate);

for s=1:6
    clearvars -except freq tones envelope sin_tvec samplingrate dur s 

sin_tvec=1:floor(samplingrate)*0.005;
envelope(1:length(sin_tvec))=(1/2+1/2*(sin(-pi/2+sin_tvec*pi/max(sin_tvec))));
    
% number of points in one cycle
cycle_length = round(samplingrate/freq(s)); 

actual_frequency = samplingrate/cycle_length;

if freq(s)==750
    C=3;
else if freq(s)==12000
        C=.35;
    else if freq(s)==3000
            C=.17;
        else if freq(s)==1500
                C=1;    
                
            else if freq(s)==24000
                    C=50;
                else if freq(s)==6000
    C=.2;
                    end
end
    end
    end
    end
end

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

tones(s,:)=cat(1,zeros(samplingrate*1,1),A,zeros(samplingrate*1,1)); 

end



clearvars -except tones samplingrate freq 

save('single_tones')