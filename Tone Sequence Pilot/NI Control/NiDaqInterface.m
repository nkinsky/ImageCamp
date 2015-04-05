classdef NiDaqInterface < hgsetget
    % ---------------------------------------------------------------------
    % NiDaqInterface
    % Han Lab
    % 7/11/2011
    % Mark Bucklin
    % ---------------------------------------------------------------------
    %
    % This class provides an interface to the National Instruments
    % Multifunction I/O board, NI USB-6259 (by default) for use with
    % experimental instruments (e.g. nosepoke, LEDs, buzzers, speakers,
    % etc.)
    %
    % See Also TOUCHINTERFACE RECTANGLE TOUCHDISPLAY
    
    
    
    
    
    properties
        samplePeriod
        port
        outputNumber
        digitalInput
        digitalOutput
        analogInput
        analogOutput
        default
    end
    properties (SetAccess = protected)
        isrunning
        isready
    end
    
    
    
    
    events
        NosePokeOn
        NosePokeOff
        LED
        Audio
        Reward
        Punish
    end
    
    
    
    
    methods % Initialization
        function obj = NiDaqInterface(varargin)
            % Assign input arguments to object properties
            if nargin > 1
                for k = 1:2:length(varargin)
                    obj.(varargin{k}) = varargin{k+1};
                end
            end
            % Define Defaults
            obj.default = struct(...
                'samplePeriod',.01,...
                'port',struct(...
                'digitalinput',0,...
                'digitaloutput',1),...
                'outputNumber',...
                struct(...
                'pump',0,...
                'rewardlight',1,...
                'houselight',2,...
                'laser',3));
            
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
            % Make I/O Objects
            obj.digitalInput = digitalio('nidaq','Dev1');
            obj.digitalOutput = digitalio('nidaq','Dev1');
            obj.analogOutput = analogoutput('nidaq','Dev1');
            obj.analogInput = analoginput('nidaq','Dev1');
            % Add Digital Input 'Lines'
            addline(obj.digitalInput,0:7,obj.port.digitalinput,'in')
            % Add Digital Ouput 'Lines'
            addline(obj.digitalOutput,0:7,obj.port.digitaloutput,'out')
            linename = fields(obj.outputNumber);
            for n = 1:numel(linename)
                linenum = obj.outputNumber.(sprintf('%s',linename{n})) +1; %Index, (1:8, not 0:7)
                obj.digitalOutput.Line(linenum).LineName = linename{n};
            end
            % Add Analog Outputs
            %                 addchannel();
            % Set Digital I/O Timer Function
            set(obj.digitalInput,...
                'TimerFcn',@(src,evnt)digitalInputFcn(obj,src,evnt),...
                'TimerPeriod',obj.samplePeriod);
            % Ready
            obj.isready = true;
            start(obj.digitalInput);
        end
    end
    methods % Input/Output Callback Functions
        function digitalInputFcn(obj,src,evnt)
            % This function is called every .01 seconds by the timer
            % contained by the digitalInput object. It is currently written
            % as if each line has a nosepoke
            persistent priorVal
            dio = src;
            byteval = getvalue(dio);
            %fprintf('%s\n',mat2str(byteval(:)'));
            if isempty(priorVal)
                priorVal = byteval;
            end
            if any(byteval~=priorVal)
                pokeNum = find(byteval~=priorVal);
                pokeDir = priorVal-byteval;
                switch pokeDir(pokeNum)
                    case 1
                        notify(obj,'NosePokeOn')
                        %fprintf('NosePoke %i ON\n',pokeNum)
                    case -1
                        notify(obj,'NosePokeOff')
                        %fprintf('NosePoke %i OFF\n',pokeNum)
                end
            end
            priorVal = byteval;
        end
        function reward(obj,varargin)
            % This function controls the water pump using a TTL output
            if nargin<2
                duration = .5;
            else
                duration = varargin{1};
            end
            if duration>5 % (argument made in milliseconds)
                duration = duration/1000;
            end
            priorVal = getvalue(obj.digitalOutput);
            byteval = priorVal;
            byteval(obj.digitalOutput.rewardlight.Index) = true;
            byteval(obj.digitalOutput.pump.Index) = true;
            putvalue(obj.digitalOutput,byteval)
            %fprintf('Reward On: %f seconds\n',duration)
            t = timer('StartDelay',duration,...
                'Tag','reward',...
                'UserData',priorVal,...
                'TimerFcn',@(src,evnt)timedValueRestore(obj,src,evnt),... 
                'TasksToExecute',1,...
                'StopFcn',@deleteTimerFcn);
            start(t)
            notify(obj,'Reward')
        end
        function punish(obj,varargin)
            % This function controls the punish light using a TTL output
            if nargin<2
                duration = .5;
            else
                duration = varargin{1};
            end
            if duration>5 % (argument made in milliseconds)
                duration = duration/1000;
            end
            priorVal = getvalue(obj.digitalOutput);
            byteval = priorVal;
            byteval(obj.digitalOutput.houselight.Index) = true;
            putvalue(obj.digitalOutput,byteval)
            % fprintf('Punishment On: %f seconds\n',duration)
            t = timer('StartDelay',duration,...
                'Tag','punish',...
                'UserData',priorVal,...
                'TimerFcn',@(src,evnt)timedValueRestore(obj,src,evnt),...
                'TasksToExecute',1,...
                'StopFcn',@deleteTimerFcn);
            start(t)
            notify(obj,'Punish')
        end
        function timedValueRestore(obj,src,evnt)
            val2write = get(src,'UserData');
            putvalue(obj.digitalOutput,val2write);
            %fprintf('End %s\n',get(src,'Tag'))
        end
        function digitalSwitch(obj,line,varargin)
            % This function provides a generic way to turn a digital output
            % channel on or off. 'line' can be the name of a line or the
            % hardware number associated with the line (0 to 7)
            
            % Determine the Index of the Specified Bit
            if ischar(line) %user is specifying the line name
                line = lower(line);
                if ~any(strcmp(line,get(obj.digitalOutput.Line,'LineName')))
                    warndlg(sprintf('No line named %s exists',line))
                    return
                end
                index = obj.digitalOutput.(sprintf('%s',line)).Index;
            else %assume it's the numeric hardware line number
                hwlines = get(obj.digitalOutput.Line,'HwLine');
                index = find(line==[hwlines{:}]);
            end
            % Toggle Bit if On/Off is not specified            
            byteval = getvalue(obj.digitalOutput);
            if nargin<3
                bit2write = ~byteval(index);
            else
                onoroff = varargin{1};
                % Get Format of ON/OFF Command
                if ischar(onoroff)
                    switch lower(onoroff)
                        case 'on'
                            bit2write = true;
                        case 'off'
                            bit2write = false;
                    end
                else
                    bit2write = logical(onoroff);
                end
            end
            % Send the value to the board
            byteval(index) = bit2write;
            putvalue(obj.digitalOutput,byteval)
        end
    end
    methods % Cleanup
        function delete(obj)
            putvalue(obj.digitalOutput,false(1,8))
            delete(obj.digitalInput);
            delete(obj.digitalOutput);
            delete(obj.analogInput);
            delete(obj.analogOutput);
        end
    end
    
end





function deleteTimerFcn(src,evnt)
delete(src);
end











