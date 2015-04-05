function radialMazeCon6edits4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Runs new single 12 arm radial maze protocol and water ports via joystick
% Tone played at the choice point on rewarded arms and during the ITI after
% 30 trials, 50% of the time.
%Required functions:
%
%genFile8 - gets trials for single 12 arm presentations and probes 1&2
%randomTrial6 - defines trials (single 12 arm config)
%joysticklistener - timer object for joystick
%getEvents -  takes in joy stick events
%playTone  - Plays a tone
%
%plexon function for outputting through the serial port
%PL_DOGetDigitalOutputInfo
%PL_DOInitDevice
%PL_DOPulseBit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%initialize global variables


filenametemp='';
rat_name{1}='s4e';
type='';
correctArms{1}=[nan nan nan nan nan nan];     % now contains 6 arms 'nan'
incorrectArms{1}=[nan nan nan nan nan nan];
%controlArms=[nan nan];
allArms=[];
trials=[];
day=[];

go=false;
exit=false;
saved = false;
toneplayed = false;
delayON= false;

joyevents=[];
starts=0;
begin=[];
elapsed=0;
elapsed_c=0;
joy=0;
waterpin=0;
pulseTime=0;
%ITItoneDelay= 5;
txt1=0; txt2=0; txt3=0; txt4=0; txt5=0;
s=[];

allArms=[];
r=1;
%intitialize hardware to give pulse to plexon file

% [~, alldev]=PL_DOGetDigitalOutputInfo;
% if any(ismember(alldev,1))
%
%     pl_init=PL_DOInitDevice(1, 1);
%     if pl_init==0
%         disp('DOI:1 initialized')
%     else
%         disp('No reward ts in file')
%     end
% else
%     disp('No reward ts in file')
%
% end

%initialize NI DIO
dio = digitalio('nidaq','NI0x14C295A');
addline(dio,0:23,'out');

for pin=1:12
    putvalue(dio.Line(pin),0);
end


%initialize timers
tim = timer('StartFcn',@startfcn,'TimerFcn',@timerfcn,...
    'StopFcn',@stopfcn,'ErrorFcn',@errorfcn,'Period',0.01,...
    'ExecutionMode','fixedDelay');
pulseWater = timer('StartFcn',@pulseON,'TimerFcn',@pulseOFF,'StartDelay',pulseTime,'BusyMode','queue');

%ITItone = timer ('StartFcn', @ITItoneON, 'TimerFnc', @ITItoneOFF,'StartDelay', ITItoneDelay, 'BusyMode', 'queue'); 




getDaysFile %set up trials

if exit
    return; %if user decides to exit
end

%define task variable
door_ts=nan(size(trials));
water_ts=nan(size(trials));  %same as choice point ts and Tone ts
reward_ts=nan(size(trials));   %denotes when the animal reaches the waterport
maxout_ts=nan(size(trials));
center_ts=nan(size(trials));
end_arm=false(size(trials));
tone_ts=nan(size(trials));    %denotes when tone was played on rewarded arms
ITItone_ts=nan(size(trials)); %denotes when the tone played during the ITI
%arm7_8=nan(size(trials));
tr=ones(size(trials,2),1);
maxTr=false(size(trials,2),1);
trial_2_crit=nan(size(trials,2),1);
lat2crit=nan(size(trials,2),1);
%set up display
h = GUI();
upDateTrial

start(tim);%start task











    function startfcn(varargin)
        %this is a start function for timer tim that uses joystick input
        %to deliver water
        choice=1;
        while choice==1
            if ~go
                try
                    joy = joysticklistener(1); %set up joystick obj timer
                    go=true;
                    choice=3;
                catch
                    
                    choice = menu('Joy Stick Not Working','Unplug and plug','Exit');
                    
                    
                    
                end
            else
                choice=3;
                
                
            end
        end
        if choice==2
            exit=true;
        end
        if(joy ~= 0 && isvalid(joy) && ~joy.running)
            
            start(joy) %start timer
            
            
        end
    end

    function timerfcn(source,varargin)
        %this is the main task function that runs at 10Hz that will
        %progress training with button input.
        
        %%%%%%%%% What does the keypad do?  %%%%%%%%%%%%
        %%%  Keypad = joyevent(1) = task progression %%%
        
        %X = 1 = mark time of end of trial,
        %Y = 4 = mark time of end of trial,
        %A = 2 = water port & tone
        %B = 3 = water port & tone
        
        %Left top = 5 = mark time for center
        %Right top = 6 = mark time for door open
        %Select = 9 = waterport reached/ reward consumption
        %Start = 10 = start the behavioral program & timer
        %Left arrow = 11 = moves trial back
        %Right arrow = 13 = advances trial
        %Up arrow = 12
        %Down arrow = 14 = restarts ITI timer
        if exit
            closeButton(source)
            return;
        end
        
        upDateTrial %updated GUI
        s = lasterror;
        
        %check if there are any button presses
        if(joy ~= 0 && isvalid(joy)) && ~ any(regexp(s.message,'Failed to read joystick status.'))
            
            
            
            
            joyevents = getEvents(joy);
            
            if size(joyevents,1)>0  && starts~=0
                switch joyevents(1)
                    case 1
                        %Button X & Y = end trial if no reward
                        %                         if length(allArms{r}(tr(r),:))==2 && ismember(allArms{r}(tr(r),:),'rows');
                        %
                        %
                        %                         end
                        maxout_ts(tr(r),r)=toc(starts);
                        
                        
                        end_arm(tr(r),r)=true;
                        elapsed=0;
                        elapsed_c=0;
                        
                        putvalue(dio.Line(23),1);
                        pause(.02)
                        putvalue(dio.Line(23),0);
                        
                    case {2,3}
                        
                        %Buttons A,B = give water & play tone
                        
                        
                        
                        
                        if any(ismember(allArms{r}(tr(r),:),correctArms(r,:)))
                            
                            %if rand(1)>0.5
                                
                            playTone  %plays tone for at the choice point for rewarded arms
                            pause(.2)
                            putvalue(dio.Line(22),1);
                            pause(.02)
                            putvalue(dio.Line(22),0);
                            tone_ts(tr(r),r)=toc(starts); %time of tone
                           %else
                           %     pause(.2)
                           % putvalue(dio.Line(22),1);
                           % pause(.02)
                           % putvalue(dio.Line(22),0);
                            
                           % end
                           
                        else
                            putvalue(dio.Line(23),1);
                            pause(.02)
                            putvalue(dio.Line(23),0);
                        end
                        
                        
                        set(pulseWater,'StartDelay',pulseTime);
                        
                        
                        
                        stop(tim)
                        
                        start(pulseWater);
                        
                        
                        
                        if any(ismember(allArms{r}(tr(r),:),correctArms(r,:)))
                            
                            water_ts(tr(r),r)=toc(starts); %time of water
                            %tone_ts(tr(r),r)=toc(starts); %time of tone
                            
                        else
                            maxout_ts(tr(r),r)=toc(starts);
                        end
                        
                        
                        end_arm(tr(r),r)=true;
                        
                        elapsed=0;
                        elapsed_c=0;
                        
                        
                        
                        if strcmpi(type,'Training')     %%%%%%%%
                            if tr(r)>48
                                ind=tr(r)-48:tr;
                                
                                
                                latency=water_ts(ind,r)-door_ts(ind,r);
                                
                                
                                lat=maxout_ts(ind,r)-door_ts(ind,r);
                                latency(isnan(latency))=lat(isnan(latency));
                                latency(~end_arm(ind,r))=nan;
                                latency(latency<0)=nan;
                                
                                latency=accumarray(allArms{r}(ind),latency,[12 1],@nanmedian,nan);
                                
                                goodTime=latency(correctArms(r,:));
                                badTime=latency(incorrectArms(r,:));
                                
                                if nanmean(badTime./goodTime) > 1.4 && all(badTime./goodTime > 1.2)
                                    maxTr(r)=true;
                                    lat2crit(r)=nanmean(badTime./goodTime);
                                    trial_2_crit(r)=tr(r);
                                    trial_2_crit(r)=inf;
                                end
                            end
                            
                            
                        end
                        
                        
                        
                        
                        
                        
                        
                    case 4
                        %Button Y = end trial if no reward
                        %                         if length(allArms{r}(tr(r),:))==2 && ismember(allArms{r}(tr(r),:),'rows');
                        %
                        %
                        %                         end
                        maxout_ts(tr(r),r)=toc(starts);
                        
                        
                        end_arm(tr(r),r)=true;
                        elapsed=0;
                        elapsed_c=0;
                        putvalue(dio.Line(23),1);
                        pause(.02)
                        putvalue(dio.Line(23),0);
                        
                        
                        
                        
                    case 9     %reward consumption
                        %Button Select = Rat has reached waterport at end of arm (reward epoch start time stamp)
                        
                        reward_ts(tr(r),r)=toc(starts);
                        
                        putvalue(dio.Line(16),1);
                        pause(.02)
                        putvalue(dio.Line(16),0);
                        
                        
                        
                        
                        
                        
                        
                        
                    case 5
%                         duration = toc(starts);
                        
                        %Button top left = mark center ts, progress trial
                        
                        putvalue(dio.Line(21),1);
                        pause(.02)
                        putvalue(dio.Line(21),0);
                        
                        
                        if isnan( maxout_ts(tr(r),r)) && isnan(water_ts(tr(r),r)) && ~maxTr(r)
                            maxout_ts(tr(r),r)=toc(starts); %end trial if no reward
                            end_arm(tr(r),r)=false;
                        end
                        saveFile(0,[]);
                        
                        
                        
                        
                        if (tr(r)<size(trials,1) && trial_2_crit(r) == tr(r)) || (tr(r)<size(trials,1) && ~maxTr(r))
                            tr(r)=tr(r)+1;
                            center_ts(tr(r),r)=toc(starts);
                            elapsed_c=tic;
                            
                            
                            
                        else
                            
                            maxTr(r)=true;
                            
                            
                        end
                        
                        if ~all(maxTr)
                            if r<length(rat_name) && (allArms{r}(tr(r))-allArms{r}(tr(r)-1))~=0
                                r=r+1;
                            elseif r>=length(rat_name) && (allArms{r}(tr(r))-allArms{r}(tr(r)-1))~=0
                                r=1;
                            end
                            
                            duration = 0;
                            while duration < 5
                                duration = toc(starts) - center_ts(tr);
                                upDateTrial
                            end
                                 
                           
                            if tr(r) > 30 && rand(1)> 0.5 && duration >= 5
                                %set delayON= true
                                %delayTime
                                playTone
                                toneplayed = true;
                                ITItone_ts(tr(r),r)=toc(starts); %time of ITItone
                                %set delayON= false

                                
                            end
                            toneplayed = false;
                            
                            
                        end
                        
                    case 6
                        %Button top right = mark door ts
                        
                        putvalue(dio.Line(24),1);
                        pause(.02)
                        putvalue(dio.Line(24),0);
                        
                        
                        door_ts(tr(r),r)=toc(starts); %time of door open
                        elapsed=tic;
                        elapsed_c=0;
                        
                    case  11
                        %Button left arrow = go back a trial
                        elapsed=0;
                        
                        elapsed_c=0;
                        
                        
                        
                        if ~ (r==1 && tr(r)==1)
                            if r==1&& (allArms{r}(tr(r))-allArms{r}(tr(r)-1))~=0
                                r=length(rat_name);
                            elseif  tr(r)==1 || (allArms{r}(tr(r))-allArms{r}(tr(r)-1))~=0
                                r=r-1;
                            end
                            
                            
                            
                            if ~maxTr(r)
                                if tr(r)>1
                                    tr(r)=tr(r)-1;
                                    
                                end
                            end
                        end
                    case 12
                        if maxTr(r)
                            maxTr(r)=false;
                        end
                    case 13
                        %Button right arrow = go forward a trial
                        
                        
                        if isnan( maxout_ts(tr(r),r)) && isnan(water_ts(tr(r),r)) && ~isnan(door_ts(tr(r),r))
                            maxout_ts(tr(r),r)=toc(starts); %end trial if no reward
                        end
                        
                        saveFile(0,[]);
                        
                        if (tr(r)<size(trials,1) && trial_2_crit(r) == tr(r)) || (tr(r)<size(trials,1) && ~maxTr(r))
                            
                            
                            tr(r)=tr(r)+1;
                            
                            
                            
                            
                        elseif tr(r)==size(trials,1)
                            
                            maxTr(r)=true;
                        end
                        
                        elapsed=0;
                        elapsed_c=0;
                        if ~all(maxTr)
                            if r<length(rat_name) && (allArms{r}(tr(r))-allArms{r}(tr(r)-1))~=0
                                r=r+1;
                            elseif r>=length(rat_name) && (allArms{r}(tr(r))-allArms{r}(tr(r)-1))~=0
                                r=1;
                            end
                        end
                    case 14
                        center_ts(tr(r),r)=toc(starts);
                        elapsed_c=tic;
                end
            elseif size(joyevents,1)>0 && joyevents(1)==10
                
                %button = start = start session
                
                elapsed_c=tic;
                starts=tic; %task starts here
                center_ts(tr(r),r)=toc(starts);
                
                dat=regexprep( datestr(now),'\W','');
                begin=[dat(1:end-6) '_' dat(end-5:end-2)];
                
            elseif size(joyevents,1)>0 && joyevents(1)==11
                %Button left arrow allows last trial to be run
                elapsed=0;
                
                maxTr(r)=false;
                
                
                
            end
        elseif go &&  any(regexp(s.message,'Failed to read joystick status.'))
            choice=1;
            while choice==1
                
                try
                    joy = joysticklistener(1); %set up joystick obj timer
                    start(joy);
                    choice=3;
                catch
                    
                    choice = menu('Joy Stick Not Working','Unplug and plug','Exit');
                    
                    
                    
                end
                if choice==2
                    exit=true;
                    
                end
                
                
            end
            
            
        end
        
    end




    function playendtask(source, varargin)
        closeButton(source)
        
    end

    function closeButton(source,varargin) %#ok<VANUS>
        %runs when GUI is shut or when user exits, prompts for saving data
        %temporary file only deleted if user explicitly says not to save
        
        %stop timers
        if ~saved
            if isvalid(tim) && all(~tim.running)
                stop(tim)
            end
            
            
            %prompt user to save
            
            choice = questdlg('Would you like to save?', ...
                'Save Data', 'Yes','No','Yes');
            switch choice
                case 'Yes'
                    
                    saved = true;
                    for r=1:length(rat_name)
                        dname = uigetdir('C:\Documents and Settings\Administrator\My Documents\Dropbox\radial unification\test sheets\',...
                            ['Rat: ' rat_name{r}]);
                        
                        filename = saveFile(dname,choice);
                        
                    end
                    
                    
                case 'No'
                    
                    filename = saveFile(0,choice);
            end
            
            if isempty(choice)
                %if user closes dialog box
                choice='closed';
                filename = saveFile(0,choice);
            end
            
            
            %once data is saved, delete all timers
            
            if(joy ~= 0 && isvalid(joy)) && joy.running
                stop(joy)
                delete(joy);
            end
            if(isvalid(tim)) && all(tim.running)
                stop(tim)
                delete(tim);
            end
            
            if(ishandle(h.cnt))
                delete(h.cnt);
            end
            
            
            if (isvalid(pulseWater))
                delete(pulseWater)
            end
            
            
            
            
            
            if any(filename)
                dash = regexp(filename,'\');
                
                dirName = filename(1:dash(end-1));
                % updateGraphs(dirName);
                
                
            end
            %reset DAQ %%%%make sure that this doesn't interrupt recording!!!!!
            daqreset
        end
    end
    function updateGraphs(filename)
        
        loadTrainingBehavior4(filename);                 %%change for new graph output%%
        
    end
    function filename = saveFile(dname,choice)
        %dname is the directory in which to save
        %choice is whether or not the user wants to save
        %if choice is empty, data saves in file temp unless user selected save
        filename = [];
        if starts~=0
            dat=regexprep( datestr(now),'\W','');
            when=dat(1:end-6);
            startstop{1}=begin;
            startstop{2}=[dat(1:end-6) '_' dat(end-5:end-2)];
            totalDuration=toc(starts); % total length of session
            ITI=door_ts(2:end,r)-center_ts(2:end,r);
            ITI=nanmean(ITI(ITI>0));
            
            
            if all(dname==0) && isempty(choice)
                
                filename=filenametemp{r}; %saving during task
                
            elseif all(dname==0) && (strcmp(choice,'Yes') || strcmp(choice,'closed'))
                filename=[filenametemp{r}(1:end-8) '.mat']; %user wanted to save but didn't enter a file
                
            else
                filename=[dname '\' rat_name{r} '_' dat(1:end-6) '.mat']; %wanted to save and chose file
                e = exist(filename,'file');
                
                if e==2
                    filename=[dname '\' rat_name{r} '_' dat(1:end-6) '_' dat(end-5:end-2) '.mat']; %adds time if file exists
                end
                
                
            end
            
            
            %delete temp file if user doesn't want to save
            if strcmp(choice,'No')
                filename = 0;
                if exist(filenametemp{r},'file')==2
                    for r=1:length(rat_name)
                        delete(filenametemp{r}) %delete temporary file
                        disp(['deleted ' filenametemp{r}]);
                    end
                    disp('Your data will be gone for good')
                end
            else
                %save temp or actual file
                ratname=rat_name{r};
                arms=allArms{r};
                doorts=door_ts(:,r);
                waterts=water_ts(:,r);
                maxoutts=maxout_ts(:,r);
                centerts=center_ts(:,r);
                endarm=end_arm(:,r);
                rewArms=correctArms(r,:);
                %arm7or8=arm7_8(:,r);
                numtr=tr(r);
                trial2crit=trial_2_crit(r);
                rewardts=reward_ts(:,r);
                tonets=tone_ts(:,r);
                ITItonets=ITItone_ts(:,r);
                 
                
                save(filename,'ratname','day','when','trials','arms','doorts','waterts',...
                    'maxoutts','centerts','startstop','totalDuration','type','ITI','endarm','rewArms',...
                    'numtr','trial2crit','rewardts', 'tonets', 'ITItonets'); %save data
                
                
                
            end
            
            
            if strcmp(choice,'Yes') || strcmp(choice,'closed')
                disp(['Saved in ' filename]);
                
                delete(filenametemp{r}) %delete temporary file after saving real file
                disp(['deleted ' filenametemp{r}]);
            end
            
        end
    end


    function pulseON(varargin)
        %turn on solenoid specified by waterpin
        putvalue(dio.Line(waterpin),1);
        
        
        
        
    end
    function pulseOFF(varargin)
        %turn off waterpin after pulseTime
        putvalue(dio.Line(waterpin),0);
        
        
        % PL_DOPulseBit(1,1,50); %send event003 into plexon file
        
        %pause(.052) %make sure that pulse is sent without interfering with other timers
        
        start(tim)
        
        
        
        
    end


    function h = GUI()
        %Display on adjacent monitor with trial #, times, rat name and quit
        %button.  When GUI is shut user is prompted to save data
        
        
        
        h.cnt = figure('Name','Control Panel','NumberTitle','off',...
            'MenuBar','none','CloseRequestFcn',@closeButton,'color','k');
        
        
        h.endTask = uicontrol(h.cnt,'Style','pushbutton','Callback',@playendtask,...
            'String','Save and Quit','Position',[5 0 160 45],'Enable','on');
        
        
        
        set(h.cnt,'Position',[1938  448     991   706])
        
        txt1=text(.25,.95,['trial: ' num2str(tr(r))],'color','w','fontsize',100); %trial #
        txt2=text(-.15,.5,['arm: ' num2str(allArms{r}(tr(r)))],'color','w','fontsize',100); %arm #
        
        
        txt3=text(.77,.5,'0','color','w','fontsize',100); % ITI / door timer
        txt4=text(-.15,.15,'time: 0','color','w','fontsize',50);  %total timer
        txt5=text(-.15,.95,rat_name{r},'color','w','fontsize',40); % subject number
        
        axis off
        
    end


    function upDateTrial
        %update GUI and water ports
        
        
        set(0,'CurrentFigure',h.cnt)
        set(txt5,'String',rat_name{r},'color','w','fontsize',40);
        if ~maxTr(r)
            set(txt1,'String',['trial: ' num2str(tr(r))],'color','w','fontsize',100);
        elseif lat2crit(r)>0 && tr(r)<size(trials,1)
            set(txt1,'String',['NR:R = ' num2str(round(lat2crit(r)*10)/10)],'color','r','fontsize',50);
        else
            set(txt1,'String','END','color','w','fontsize',100);
        end
        
        if ~maxTr(r)
            set(txt2,'String',['arm: ' num2str(allArms{r}(tr(r),:))],'color','w','fontsize',80);
        elseif trial_2_crit(r)==tr(r) && maxTr(r)
            set(txt2,'String',['trials to criteria'],'color','r','fontsize',75);
        elseif trial_2_crit(r)~=tr(r) && maxTr(r)
            set(txt2,'String',['press up arrow to run trial'],'color','w','fontsize',50);
        end
        
        if elapsed~=0 && ~ maxTr(r)
            set(txt3,'String',num2str(round(toc(elapsed))),'color','w','fontsize',100)
        elseif ~maxTr(r)
            set(txt3,'String','0','color','w','fontsize',100)
        elseif maxTr(r)
            set(txt3,'String','','color','w','fontsize',100)
        end
        
        if elapsed_c>0 && ~ maxTr(r)
            set(txt3,'String',num2str(round(toc(elapsed_c))),'color','r','fontsize',100)
        elseif elapsed==0 && ~maxTr(r)
            set(txt3,'String','0','color','r','fontsize',100)
        elseif maxTr(r)
            set(txt3,'String','','color','w','fontsize',100)
        end
        
        if  any(starts)
            set(txt4,'String',['time: ' num2str(round(toc(starts)/60)) 'min'],'color','w','fontsize',100);
            
        else
            
            set(txt4,'String','time: 0' ,'color','w','fontsize',100);
        end
        
        %define rewarded arm
        switch type
            case 'Shaping'
                rewArm=allArms{r}(tr(r));
                
            case {'Training','Probe1','Probe2' }
                rewArm=intersect(allArms{r}(tr(r),:),correctArms(r,:));
                
        end
        %set waterpin and define pulsetime                          %recalibrate
        if any(rewArm)
            switch rewArm
                
                
                case 1
                    waterpin=7;
                    
                    pulseTime=.175;
                case 2
                    waterpin=11;
                    
                    pulseTime=.22;
                    
                case 3
                    waterpin=3;
                    
                    pulseTime=.26;
                case 4
                    waterpin=12;
                    
                    pulseTime=.22;
                case 5
                    waterpin=6;
                    
                    pulseTime=.21;
                case 6
                    waterpin=1;
                    
                    pulseTime=.18;
                    
                case 7
                    waterpin=5;
                    
                    pulseTime=.24;
                    
                    
                case 8
                    waterpin=2;
                    
                    pulseTime=.18;
                case 9
                    waterpin=4;
                    
                    pulseTime=.25;
                case 10
                    waterpin=10;
                    
                    pulseTime=.25;
                case  11
                    waterpin=9;
                    
                    pulseTime=.25;
                case 12
                    waterpin=8;
                    
                    pulseTime=.17;
                    
            end
        else
            waterpin=15; %sends plx signal for incorrect trials
            pulseTime=.01;
        end
        
    end


    function getDaysFile
        %Generates trial data for each of three conditions
        %1. Shaping:  24 trials, each arm opened one at a time x2
        %2. Training: 60 trials total, 1 trial per each arm per round (12arms X 5rounds)
        %3. Probe1: 6 arm pairs- 60 trials max/ 48 trials min or until criteria met
        %4. Probe2: 40 trials of 4 novel pairs. (4pairs X 10rounds)
        
        
        
        dat=regexprep( datestr(now),'\W','');
        %Get rat name(s)
        prompt = {'Enter Rats number(s)'};
        dlg_title = 'Name';
        num_lines = 1;
        def = {''};
        rats=[];
        num = inputdlg(prompt,dlg_title,num_lines,def);
        eval(['rats = {' num{1} '};']);
        
        for i=1:length(rats)
            if ~isempty(num)
                rat_name{i} = [ 's4e' num2str(sprintf('%02i',rats{i}))];
            end
        end
        
        
        A=[];
        A=genFile8(length(rats));
        
        
        if length(A)==0
            %dialog box shut
            exit=true;
            return;
        else
            
            
            trials=cell2mat(A(:,2)'); % trial #
            allArms=A(:,3)'; %allArms
            
            
            type=A{1,1};
            
            
            if any(regexpi(type,'training')) ||any(regexpi(type,'probe1')) ||any(regexpi(type,'probe2'))
                correctArms=cell2mat(A(:,4)); %correct allArms
                incorrectArms=cell2mat(A(:,5)); %incorrect allArms
                
            else
                correctArms=1:12;
                incorrectArms=[];
            end
            
            
            
            %define temporary filename
            dirtemp='C:\Documents and Settings\Administrator\My Documents\Dropbox\radial unification\test sheets';
            for i=1:length(rat_name)
                filenametemp{i}=[dirtemp '\' rat_name{i} '_' dat(1:end-6) 'temp.mat'];
            end
        end
        
    end

    function stopfcn(varargin)
        if exit
            if joy~=0 && isvalid(joy)
                
                delete(joy)
            end
            
        end
        
    end

    function errorfcn(varargin)
        
    end
%  function getExcelDaysFile
%         directory='C:\Documents and Settings\Administrator\My Documents\Dropbox\radial unification\test sheets\';
%         fileName=0;
%         while ~ischar(fileName)
%             fileName=uigetfile({[directory '\*.xls']},'Select session excel file');
%             if fileName==0
%                 pick=menu('Exit?',{'Exit','Pick a file'});
%                 if pick==1
%                     exit=true;
%                     return;
%                 end
%             end
%         end
%         [~,~,raw] = xlsread([directory fileName]); %read data
%
%         rats=raw(2:end,1);
%         day=raw{2:2};
%
%
%
%         if islogical(raw{2,4})
%             type='premise';
%             rewArms= str2num(raw{1,13}(isstrprop(raw{1,13},'digit'))');
%             noRewArms= str2num(raw{3,13}(isstrprop(raw{3,13},'digit'))');
%             temp=raw(2:end,4);
%
%
%             temp=cellfun(@(a) str2logical(a),temp,'uni',0);
%             temp=cellfun(@(a) double(a),temp,'uni',0);
%             rewarded=cell2mat(temp);
%             trials=cell2mat(raw(2:end,5));
%             allArms=cell2mat(raw(2:end,6));
%
%         elseif length(raw{3,5})==4
%
%             type='probe';
%             rewArms= str2num(raw{1,13}(isstrprop(raw{1,13},'digit'))');
%             noRewArms= str2num(raw{3,13}(isstrprop(raw{3,13},'digit'))');
%             trials=cell2mat(raw(2:end,4));
%             allArms=raw(2:end,5);
%             allArms(cellfun(@ischar,allArms))=cellfun(@str2num,allArms(cellfun(@ischar,allArms)),'uni',0);
%             allArms(cellfun(@(a) isnan(a(1)),allArms))=cellfun(@(a) [nan nan],  allArms(cellfun(@(a) isnan(a(1)),allArms)),'uni',0);
%             allArms=cell2mat(allArms);
%
%         else
%
%
%
%             type='shaping';
%             trials=cell2mat(raw(2:end,4));
%             allArms=cell2mat(raw(2:end,5));
%
%
%         end
%
%         rats=rats(~isnan(trials));
%         allArms=allArms(~isnan(trials),:);
%         trials=trials(~isnan(trials));
%         allrats=unique(rats);
%         rati=0;
%         while rati==0
%             rati = menu('Pick a rat', allrats);
%             if rati==0
%                 pick=menu('Exit?',{'Exit','Pick a rat'});
%                 if pick==1
%                     exit=true;
%                     return;
%                 end
%             end
%         end
%         rat_name= allrats{rati};
%         keep=cellfun(@any,regexp(rats(~isnan(trials)),rat_name));
%
%
%         allArms=allArms(keep,:);
%         trials=trials(keep);
%
%
%  end

end