classdef NiGetInput < hgsetget
    % ---------------------------------------------------------------------
    % NiPulseOutput
    % Han Lab
    % 1/19/2013
    % Mark Bucklin
    % ---------------------------------------------------------------------
    %
    % This class provides an interface to the National Instruments
    % Multifunction I/O board, NI USB-6259 (by default) for use with
    % experimental instruments (e.g. nosepoke, LEDs, buzzers, speakers,
    % etc.) As opposed to the NIDAQINTERFACE class, this class utilizes the
    % session-based interface which affords compatibility with 64-bit
    % versions of matlab.
    %
    % See Also TOUCHINTERFACE TOUCHDISPLAY NIDAQINTERFACE
    
    
    
    
    
    properties
        pulseTime       % in seconds
        activeHigh      % true if pulse goes high for pulseTime, then low until called again
        portNumber
        lineNumber
        deviceId
        default
    end
    properties (SetAccess = protected)
        sessionObj
        channelObj
        timerObj
        isrunning
        isready
    end
    
    
    
    
    events
    end
    
    
    
    
    methods % Initialization
        function obj = NiGetInput(varargin)
            % Assign input arguments to object properties
            if nargin > 1
                for k = 1:2:length(varargin)
                    obj.(varargin{k}) = varargin{k+1};
                end
            end
            % Display available device info
            devs = daq.getDevices;
            % Define Defaults
            obj.default = struct(...
                'pulseTime',.010,...
                'activeHigh',true,...
                'portNumber',1,...
                'lineNumber',0,...
                'deviceId',devs(1).ID);
            obj.isready = false;
        end
        function setup(obj)
            % Fill in Defaults
            props = fields(obj.default);
            for n=1:length(props)
                thisprop = sprintf('%s',props{n});
                if isempty(obj.(thisprop))
                    obj.(thisprop) = obj.default.(thisprop);
                end
            end
            % Make Daq Session and Digital-Output Channelste
            obj.sessionObj = daq.createSession('ni');
            %             for n = 1:numel(obj.lineNumber) %TODO
            obj.channelObj = obj.sessionObj.addDigitalChannel(...
                obj.deviceId,...
                sprintf('port%g/line%g',obj.portNumber,obj.lineNumber),...
                'InputOnly');
            % Set initial state
%             if obj.activeHigh
%                 obj.sessionObj.outputSingleScan(0); % (start low)
%             else
%                 obj.sessionObj.outputSingleScan(1); % (start high, pulse low)
%             end
            % Ready
            obj.isready = true;
        end
    end
    methods % Input/Output Callback Functions
        function sendPulse(obj,varargin)
            if nargin>1
                obj.pulseTime = varargin{1};
            end
            obj.timerObj = timer(...
                'ExecutionMode','singleShot',...
                'StartDelay',obj.pulseTime,...
                'TimerFcn',@(src,evnt)resetPulse(obj,src,evnt),...
                'TasksToExecute',1,...
                'StopFcn',@deleteTimerFcn,'Period',0.01);            
            if obj.activeHigh
                obj.sessionObj.outputSingleScan(1); % (set high)
            else
                obj.sessionObj.outputSingleScan(0); % (set low)
            end
            start(obj.timerObj);
        end
        function resetPulse(obj,src,evnt)
            if obj.activeHigh
                obj.sessionObj.outputSingleScan(0); % (reset low)
            else
                obj.sessionObj.outputSingleScan(1); % (reset high)
            end
        end
        
        function checklicks(obj)
            global y

            obj.timerObj = timer(...
                'ExecutionMode','fixedRate',...
                'TimerFcn',@(src,evnt)getChannelInput(obj,src,evnt),...
                'TasksToExecute',1000,...
                'Period',0.01,...
                'StopFcn',@deleteTimerFcn);
            start(obj.timerObj)
%             while sum(y) < 2 % Test to see if I can stop the timer once he licks once...works, kind of...
%                 if sum(y) == 1
%                     disp('Timer stopped')
%                     stop(obj.timerObj)
%                 end
%             end

        end
        
        function getChannelInput(obj,src,evnt)
            global y
            persistent n

            
            if isempty(n)
            n = 1;
            else
            end
            y(n) = obj.sessionObj.inputSingleScan;
            if y(n) == 1
                disp('Lick Detected')
            end

            n = n+1;
        end
    end
    methods % Cleanup
        function delete(obj)
            delete(obj.timerObj)
            obj.sessionObj.release()
            delete(obj.sessionObj);
        end
    end
    
end






function deleteTimerFcn(src,evnt)
delete(src);
end









