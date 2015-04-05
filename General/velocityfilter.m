function [velocityfilter,velocity,position]=velocityfilter(position,time,minvelocity,sigmapos,sigmaspeed)
%Creates a logical vector indicating whether the animal was moving faster
%than the entered minimum velocity.
%
%'position' -- position in 1D or 2D
%'time' -- timestamp of each tracking sample (scalar or vector)
%'minvelocity' -- minimum velocity that meets the velocity filter
%'sigma*' -- number of bins that are in one standard deviation of the
%           gaussian smoothing kernel; pos=position, speed=velocity
%
%Jon Rueckemann 2014

%Test for compatible input
if numel(time)>1
    assert(size(position,1)==numel(time),'There is not a timestamp for each position.')
end

if ~exist('sigmapos','var')
    sigmapos=2;
end
if ~exist('sigmaspeed','var')
    sigmaspeed=[];
end

%Smooth position data
if ~isempty(sigmapos) && sigmapos>0
    kernel=pdf('norm',(-ceil(2*sigmapos):ceil(2*sigmapos))',0,sigmapos);%>95% of gaussian represented
    posnan=isnan(position);
    position(posnan)=0; %convn does not handle nans
    position(ceil(2*sigmapos)+1:end-ceil(2*sigmapos),:)=convn(position,kernel,'valid');
    %Only the portion of the tracking with a valid convolution without zero
    %padding is smoothed.  The tails contain raw data.
    position(posnan)=nan; %replace nan
end

%Calculate velocity
deltapos=diff(position,1,1);
deltapos=[deltapos; deltapos(end,:)];
if size(position,2)==2
    deltapos=hypot(deltapos(:,1),deltapos(:,2));
elseif size(position,2)==1 %linearized tracking; corrects for loop
    deltapos=abs(deltapos);
    bigjumps=(deltapos>0.5*max(position));
    deltapos(bigjumps)=abs(max(position)-deltapos(bigjumps));
end
if numel(time)>1
    dt=diff(time);
    dt(dt>(3*mean(dt)))=3*mean(dt); %Replace jumps in the tracking timestamps
    dt=[mean(dt); dt];
else
    dt=time;
end
velocity=deltapos./dt;

%Smooth velocity
if ~isempty(sigmaspeed) && sigmaspeed>0
    kernel=pdf('norm',(-ceil(2*sigmaspeed):ceil(2*sigmaspeed))',0,sigmaspeed);%>95% of gaussian represented
    velnan=isnan(velocity);
    velocity(velnan)=0; %convn does not handle nans
    velocity(ceil(2*sigmaspeed)+1:end-ceil(2*sigmaspeed))=convn(velocity,kernel,'valid');
    velocity(velnan)=nan; %replace nan
end

%Create logical index
velocityfilter=velocity>=minvelocity;