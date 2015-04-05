% Test Script to simply initialize the NI-USB device with the lick-meter
% attached, signal that licking is possible with a tone, measure licks the
% entire time, and output a TTL pulse if licking occurs within the correct
% time period after the tone is played.

% Option A: use counter to check how many licks have happened, reset at end
% of tone, count each time

% Option B: run a timer and check each time if the mouse is licking. See
% all the command history from 8/22...

clear all
close all

%% STEP 1: Initialize Lick Meter ports on NIDAQ board
% 
% lick_port_num = 1; % Line number on NIDAQ board
% lick_line_num = 5; % Port number on NIDAQ board

t = daq.createSession('ni');
ch2 = t.addCounterInputChannel('Dev1','ctr0','EdgeCount');
% This is the only counter channel on the 6501, will need to adjust for the
% 6259... ctr0 port is P2.7 on 6501

t.inputSingleScan % Checks how many licks have occurred

t.resetCounters; % Use this to reset the counter.

%% STEP 2: Set up timer

time_step = 0.01; % seconds

lick_timer = timer('Period',time_step,'ExecutionMode','fixedRate');
lick_timer.TaskstoExecute = 10;

lick_timer.StartFcn = @(x,y)disp('Start'); % Function called when we start the timer
lick_timer.TimerFcn = @(x,y)disp('Hello World'); % Function called every period of the timer
lick_timer.StopFcn = @(x,y)disp('End'); % function called when the timer ends


%% THIS SEEMS TO WORK FOR NOW

clear test3 y

test3 = NiGetInput('lineNumber',7,'portNumber',2)';
tic
setup(test3);
toc

global y % This sets y as a global variable so that we can use it (called in 
% checklicks) to count how many licks have occured.

checklicks(test3)
% while sum(y) < 2
%     if sum(y) == 1
%         disp('Lick detected')
%     end
% end


