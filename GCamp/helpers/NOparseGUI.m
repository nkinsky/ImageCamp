function NOparseGUI( ~,~ )
% Tool to facilitate parsing AVI for DNMP task into event time stamps (frame numbers),
% export those numbers in an excel sheet for using with Nat's DNMP
% functions. Select lap number, toggle between frames, click button to set
% that frame number as that type of event. Have to click away from button
% on figure for going between frames to work. If lap number button is red, click it to 
% start logging on that lap number

%% Nat to-do for making NO tracker
% 1) Add-in KeyPress - 1/9 = Lower-left/upper-right exploration
% - need nLL and nUR - increment by one each time it is pushed? Display at
% top?
% 2) Make variable to save on each try?
% 3) Add in update to show which object was selected for a given frame
% 4) Change button names/eliminate buttons
% 5) De-bug - make sure each LL/UR press is accurately recorded, that
% re-writing is ok, and that you can erase properly with 5 button


%%
global miscVar
global ParsedFrames
global videoFig
global video
global NOVar

msgbox({'Notes on use:';' Q/R - step back/forward 100';...
        ' A/F - step back/forward 10'; ' S/D  - step back/forward 1';' ';...
        'Click off of button for keyboard!'})

miscVar.panelHeight = 480;
videoFig.videoPanel = figure('Position',[100,100,900,miscVar.panelHeight],'MenuBar','none','KeyPressFcn',@keyPress);
videoFig.plotted = subplot(1,2,1,'Position',[0.05,0.1,0.55,0.8]);
title('Frame 1/lots')

miscVar.upperLimit = miscVar.panelHeight - 120;
miscVar.buttonStepDown = 40;
miscVar.buttonLeftEdge = 560;
miscVar.buttonSecondCol = 705;
miscVar.buttonWidth = 130;
miscVar.Gray=[0.94,0.94,0.94];
miscVar.Red=[1,0.5,0.5];
miscVar.Green = [0.5 1 0.5];
miscVar.VideoLoadedFlag=0;
miscVar.LapsWorkedOn=[];

NOVar.LLframes = [];
NOVar.URframes = [];


videoFig.LapNumberButton = uicontrol('Style','pushbutton','String','LAP NUMBER',...
                           'Position',[miscVar.buttonLeftEdge+60,miscVar.upperLimit+50,miscVar.buttonWidth,30],...
                           'Callback',{@fcnLapNumberButton},'BackgroundColor',miscVar.Gray);
miscVar.LapNumber=1;                       

videoFig.LapNumberBox = uicontrol('Style','edit','string','1',...
                           'Position',[miscVar.buttonLeftEdge+60+miscVar.buttonWidth+15,miscVar.upperLimit+50,...
                           50,30]);
                       
videoFig.LapNumberPlus = uicontrol('Style','pushbutton','String','+',...
                           'Position',[miscVar.buttonLeftEdge+60+miscVar.buttonWidth+15+52,miscVar.upperLimit+65,...
                           20,15],'Callback',{@fcnLapNumberPlus});
                       
videoFig.LapNumberMinus = uicontrol('Style','pushbutton','String','-',...
                           'Position',[miscVar.buttonLeftEdge+60+miscVar.buttonWidth+15+52,miscVar.upperLimit+50,...
                           20,15],'Callback',{@fcnLapNumberMinus});
                       
%% Set up
fcnLoadVideo;
sessionType = questdlg('What kind of session is this?', 'Session Type',...
                              'DNMP','ForcedUnforced','Other','DNMP');
switch sessionType
    case 'DNMP'
        miscVar.sessionClass=1;
    case 'ForcedUnforced'
        miscVar.sessionClass=2;
    case 'Other'
        disp('Not yet...')
        miscVar.sessionClass=3;
        %In theory this will be where you can load or enter 
        %What labels and order and it will generate appropriate buttons
end        

%% Layout for DNMP
switch miscVar.sessionClass
    case 1
        miscVar.buttonsInUse={'LapStartButton';'EnterDelayButton';...
                               'LiftBarrierButton';'LeaveMazeButton';
                               'StartHomecageButton';'LeaveHomecageButton';'ForcedTrialDirButton';...
                               'FreeTrialDirButton'}; 
videoFig.LapStartButton = uicontrol('Style','pushbutton','String','LAP START',...
                           'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit,miscVar.buttonWidth,30],...
                           'Callback',{@fcnLapStartButton});
                       
videoFig.EnterDelayButton = uicontrol('Style','pushbutton','String','ENTER DELAY',...
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit, miscVar.buttonWidth,30],...
                             'Callback',{@fcnEnterDelayButton});
                         
videoFig.LiftBarrierButton = uicontrol('Style','pushbutton','String','LIFT BARRIER',...
                             'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*1,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnLiftBarrierButton});
                         
videoFig.LeaveMazeButton = uicontrol('Style','pushbutton','String','LEAVE MAZE',...
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit - miscVar.buttonStepDown*1,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnLeaveMazeButton});

videoFig.StartHomecageButton = uicontrol('Style','pushbutton','String','START HOMECAGE',...
                             'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*2,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnStartHomecageButton});

videoFig.LeaveHomecageButton = uicontrol('Style','pushbutton','String','LEAVE HOMECAGE',...
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit - miscVar.buttonStepDown*2,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnLeaveHomecageButton});

videoFig.ForcedTrialDirButton = uicontrol('Style','pushbutton','String','FORCED TRIAL DIR',...
                                'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*3,...
                                130,30], 'Callback',{@fcnForcedDirButton});

videoFig.PopForcedDir = uicontrol('Style','popup',... 
                             'Position',[miscVar.buttonLeftEdge+130+10,miscVar.upperLimit - miscVar.buttonStepDown*3-7,95,30],...
                             'string',{'          LEFT   ';'         RIGHT   '},...
                             'Value', 1);

videoFig.FreeTrialDirButton = uicontrol('Style','pushbutton','String','FREE TRIAL DIR',...
                             'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*4,130,30],...
                             'Callback',{@fcnFreeDirButton});

videoFig.PopFreeDir = uicontrol('Style','popup',... 
                             'Position',[miscVar.buttonLeftEdge+130+10,miscVar.upperLimit - miscVar.buttonStepDown*4-7,95,30],...
                             'string',{'          LEFT   ';'         RIGHT   '},...
                             'Value', 1); 

headings={'Trial #'; 'Start on maze (start of Forced'; 'Lift barrier (start of free choice)';...
            'Leave maze'; 'Start in homecage'; 'Leave homecage'; 'Forced Trial Type (L/R)';...
            'Free Trial Choice (L/R)'; 'Enter Delay'};
ParsedFrames.LapNumber={headings{1}};        
ParsedFrames.LapStart={headings{2}}; 
ParsedFrames.LiftBarrier={headings{3}};
ParsedFrames.LeaveMaze={headings{4}};
ParsedFrames.StartHomecage={headings{5}};
ParsedFrames.LeaveHomecage={headings{6}};
ParsedFrames.ForcedDir={headings{7}};
ParsedFrames.FreeDir={headings{8}};
ParsedFrames.EnterDelay={headings{9}};
                         

%% Layout for ForcedUnforced
    case 2
        miscVar.buttonsInUse={'LapStartButton';'EnterDelayButton';...
                               'LeaveMazeButton';'StartHomecageButton';...
                               'LeaveHomecageButton';'TrialTypeButton';...
                               'TrialDirButton'}; 
videoFig.LapStartButton = uicontrol('Style','pushbutton','String','LAP START',...
                           'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit,miscVar.buttonWidth,30],...
                           'Callback',{@fcnLapStartButton});
                       
videoFig.EnterDelayButton = uicontrol('Style','pushbutton','String','ENTER DELAY',...
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit, miscVar.buttonWidth,30],...
                             'Callback',{@fcnEnterDelayButton});
                         
videoFig.LeaveMazeButton = uicontrol('Style','pushbutton','String','LEAVE MAZE',...
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit - miscVar.buttonStepDown*1,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnLeaveMazeButton});
                         
videoFig.StartHomecageButton = uicontrol('Style','pushbutton','String','START HOMECAGE',...
                             'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*2,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnStartHomecageButton});

videoFig.LeaveHomecageButton = uicontrol('Style','pushbutton','String','LEAVE HOMECAGE',...
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit - miscVar.buttonStepDown*2,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnLeaveHomecageButton});                         

videoFig.TrialTypeButton = uicontrol('Style','pushbutton','String','TRIAL TYPE',...
                                'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*3,...
                                130,30], 'Callback',{@fcnTrialTypeButton});

videoFig.PopTrialType = uicontrol('Style','popup',... 
                             'Position',[miscVar.buttonLeftEdge+130+10,miscVar.upperLimit - miscVar.buttonStepDown*3-7,110,30],...
                             'string',{'        FORCED   ';'         FREE   '},...
                             'Value', 1);

videoFig.TrialDirButton = uicontrol('Style','pushbutton','String','TRIAL DIR',...
                             'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*4,130,30],...
                             'Callback',{@fcnTrialDirButton});

videoFig.PopTrialDir = uicontrol('Style','popup',... 
                             'Position',[miscVar.buttonLeftEdge+130+10,miscVar.upperLimit - miscVar.buttonStepDown*4-7,110,30],...
                             'string',{'          LEFT   ';'         RIGHT   '},...
                             'Value', 1); 
                         
headings={'Trial #'; 'Start on maze (start of Forced'; 'Enter delay';...
            'Leave maze'; 'Start in homecage'; 'Leave homecage'; 'Trial Type (FORCED/FREE)';...
            'Trial Dir (L/R)'};
ParsedFrames.LapNumber={headings{1}};        
ParsedFrames.LapStart={headings{2}}; 
ParsedFrames.EnterDelay={headings{3}};
ParsedFrames.LeaveMaze={headings{4}};
ParsedFrames.StartHomecage={headings{5}};
ParsedFrames.LeaveHomecage={headings{6}};
ParsedFrames.TrialType={headings{7}};
ParsedFrames.TrialDir={headings{8}};


    case 3
        disp('Sorry bro')
end
%%
                         
videoFig.LoadVideoButton = uicontrol('Style','pushbutton','String','LOAD VIDEO',...
                             'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*6,...
                             miscVar.buttonWidth,30],'Callback',{@fcnLoadVideo}); 
                         
videoFig.SaveSheetExcel = uicontrol('Style','pushbutton','String','SAVE SHEET',...                         
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit - miscVar.buttonStepDown*6,...
                             miscVar.buttonWidth,30],'Callback',{@fcnSaveSheet});     
                         
videoFig.JumpFrameButton = uicontrol('Style','pushbutton','String','JUMP TO FRAME',...
                             'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*7,...
                             miscVar.buttonWidth,30], 'Callback',{@fcnJumpFrameButton});


videoFig.LoadSheetExcel = uicontrol('Style','pushbutton','String','LOAD SHEET',...                         
                             'Position',[miscVar.buttonSecondCol,miscVar.upperLimit - miscVar.buttonStepDown*7,...
                             miscVar.buttonWidth,30],'Callback',{@fcnLoadSheet});     
                         
videoFig.fakePlay = uicontrol('Style','pushbutton','String','PLAY',...
                        'Position',[miscVar.buttonLeftEdge,miscVar.upperLimit - miscVar.buttonStepDown*8,...
                        miscVar.buttonWidth,30], 'BackgroundColor',miscVar.Gray,'Callback',{@fcnFakePlayer});

videoFig.PopFakePlaySpeed = uicontrol('Style','popup',... 
                             'Position',[miscVar.buttonLeftEdge+130+10,miscVar.upperLimit - miscVar.buttonStepDown*8-7,95,30],...
                             'string',{'          1x   ';'         2x   ';'         4x   ';'        10x   '},...
                             'Value', 1,'Callback',{@fcnSetFakePlaySpeed}); 
                         
%%


end
%%
function fcnLapNumberButton(~,~)
global miscVar
global videoFig

disp('Lap number')
try 
    miscVar.hold=miscVar.LapNumber;
    miscVar.LapNumber=str2double(videoFig.LapNumberBox.String);
    if miscVar.LapNumber<1 || mod(str2double(videoFig.LapNumberBox.String),1)~=0
        msgbox('Lap number must be integer > zero.', 'Error','error');
        miscVar.LapNumber=miscVar.hold;
        videoFig.LapNumberBox.String=miscVar.LapNumber;
        videoFig.LapNumberBox.BackgroundColor=miscVar.Red;
        disp(num2str(miscVar.LapNumber))
    else    
        videoFig.LapNumberButton.BackgroundColor=miscVar.Gray;
        %miscVar.LapNumber=str2double(videoFig.LapNumberBox.String);
        switch any(miscVar.LapsWorkedOn==miscVar.LapNumber)
            case 0
                for buttonCol=1:length(miscVar.buttonsInUse)
                    eval(['videoFig.',miscVar.buttonsInUse{buttonCol},'.BackgroundColor=miscVar.Red;'])
                end
            case 1
                %message things will be overwritten
        end
        miscVar.LapsWorkedOn=[miscVar.LapsWorkedOn; miscVar.LapNumber];
        disp(['Lap number is ' num2str(miscVar.LapNumber)])
    end    
catch
    msgbox('Lap number must be an integer.', 'Error','error');
    videoFig.LapNumberBox.BackgroundColor=miscVar.Red;
end
videoFig;

end
function fcnLapNumberPlus(~,~)
global videoFig
global miscVar
disp('Lap number plus')
switch mod(str2double(videoFig.LapNumberBox.String),1)~=0
    case 0
    videoFig.LapNumberBox.String=num2str(str2double(videoFig.LapNumberBox.String)+1);
    videoFig.LapNumberButton.BackgroundColor=miscVar.Red;
    case 1
    msgbox('Lap number must be an integer.', 'Error','error');
end    
end
function fcnLapNumberMinus(~,~)
global videoFig
global miscVar
disp('Lap number minus')
if str2double(videoFig.LapNumberBox.String)-1>0
switch mod(str2double(videoFig.LapNumberBox.String),1)~=0
    case 0
    videoFig.LapNumberBox.String=num2str(str2double(videoFig.LapNumberBox.String)-1);
    videoFig.LapNumberButton.BackgroundColor=miscVar.Red;
    case 1
    msgbox('Lap number must be an integer.', 'Error','error');
end     
end
end
%%
function fcnLapStartButton(~,~)
disp('Lap Start')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    ParsedFrames.LapStart{miscVar.LapNumber+1,1}=miscVar.frameNum;
    disp(num2str(ParsedFrames.LapStart{miscVar.LapNumber+1,1}))
    videoFig.LapStartButton.BackgroundColor=miscVar.Gray;
end
end
function fcnEnterDelayButton(~,~)
disp('Enter Delay')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    ParsedFrames.EnterDelay{miscVar.LapNumber+1,1}=miscVar.frameNum;
    disp(num2str(ParsedFrames.EnterDelay{miscVar.LapNumber+1,1}))
    videoFig.EnterDelayButton.BackgroundColor=miscVar.Gray;
end
end
function fcnLiftBarrierButton(~,~)
disp('Lift Barrier')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    ParsedFrames.LiftBarrier{miscVar.LapNumber+1,1}=miscVar.frameNum;
    disp(num2str(ParsedFrames.LiftBarrier{miscVar.LapNumber+1,1}))
    videoFig.LiftBarrierButton.BackgroundColor=miscVar.Gray;
end
end
function fcnLeaveMazeButton(~,~)
disp('Leave Maze')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    ParsedFrames.LeaveMaze{miscVar.LapNumber+1,1}=miscVar.frameNum;
    disp(num2str(ParsedFrames.LeaveMaze{miscVar.LapNumber+1,1}))
    videoFig.LeaveMazeButton.BackgroundColor=miscVar.Gray;
end
end
function fcnStartHomecageButton(~,~)
disp('Start Homecage')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    ParsedFrames.StartHomecage{miscVar.LapNumber+1,1}=miscVar.frameNum;
    disp(num2str(ParsedFrames.StartHomecage{miscVar.LapNumber+1,1}))
    videoFig.StartHomecageButton.BackgroundColor=miscVar.Gray;
end
end
function fcnLeaveHomecageButton(~,~)
disp('Leave Homecage')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    ParsedFrames.LeaveHomecage{miscVar.LapNumber+1,1}=miscVar.frameNum;
    disp(num2str(ParsedFrames.LeaveHomecage{miscVar.LapNumber+1,1}))
    videoFig.LeaveHomecageButton.BackgroundColor=miscVar.Gray;
end
end
function fcnForcedDirButton(~,~)
disp('Forced Direction')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    switch videoFig.PopForcedDir.Value
        case 1
            ParsedFrames.ForcedDir{miscVar.LapNumber+1,1}='L';
        case 2    
            ParsedFrames.ForcedDir{miscVar.LapNumber+1,1}='R';
    end        
    disp(ParsedFrames.ForcedDir{miscVar.LapNumber+1,1})
    videoFig.ForcedDirButton.BackgroundColor=miscVar.Gray;
end
end
function fcnFreeDirButton(~,~)
disp('Free Direction')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    switch videoFig.PopFreeDir.Value
        case 1
            ParsedFrames.FreeDir{miscVar.LapNumber+1,1}='L';
        case 2    
            ParsedFrames.FreeDir{miscVar.LapNumber+1,1}='R';
    end        
    disp(ParsedFrames.FreeDir{miscVar.LapNumber+1,1})
    videoFig.FreeDirButton.BackgroundColor=miscVar.Gray;
end
end
function fcnTrialTypeButton(~,~)
disp('Trial type')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    switch videoFig.PopTrialType.Value
        case 1
            ParsedFrames.TrialType{miscVar.LapNumber+1,1}='FORCED';
        case 2    
            ParsedFrames.TrialType{miscVar.LapNumber+1,1}='FREE';
    end        
    disp(ParsedFrames.TrialType{miscVar.LapNumber+1,1})
    videoFig.TrialTypeButton.BackgroundColor=miscVar.Gray;
end
end
function fcnTrialDirButton(~,~)
disp('Trial Direction')
global miscVar
global ParsedFrames
global videoFig
if miscVar.VideoLoadedFlag==1
    switch videoFig.PopTrialDir.Value
        case 1
            ParsedFrames.TrialDir{miscVar.LapNumber+1,1}='L';
        case 2    
            ParsedFrames.TrialDir{miscVar.LapNumber+1,1}='R';
    end        
    disp(ParsedFrames.TrialDir{miscVar.LapNumber+1,1})
    videoFig.TrialDirButton.BackgroundColor=miscVar.Gray;
end
end
%%
function fcnJumpFrameButton(~,~)
global videoFig
global miscVar
global video

if miscVar.VideoLoadedFlag==1
    try
        jumpFrame = inputdlg('Jump to what frame?');
        switch mod(str2double(jumpFrame{:}),1)==0
            case 0
                msgbox('Frame number must be an integer','Error','error')
            case 1  
                jumpFrame=str2double(jumpFrame{:});
                if jumpFrame>0 && jumpFrame <=miscVar.totalFrames
                    miscVar.frameNum = jumpFrame-1;
                    video.CurrentTime = miscVar.frameNum/video.FrameRate;
                    miscVar.currentFrame = readFrame(video);
                    miscVar.frameNum = miscVar.frameNum + 1;
                    videoFig.plotted = imagesc(miscVar.currentFrame);
                    title(['frame ' num2str(miscVar.frameNum) '/' num2str(miscVar.totalFrames)])
                else   
                    msgbox('Frame number must in range','Error','error')
                end
        end
    catch
        msgbox('Why would you even?')
    end 
end    
end
function fcnLoadVideo(~,~)
global videoFig
global miscVar
global video

try
[miscVar.FileName,miscVar.PathName] = uigetfile('*.AVI','Select the AVI file');
video = VideoReader(fullfile(miscVar.PathName,miscVar.FileName));
miscVar.currentTime = 0;
miscVar.currentFrame = readFrame(video);
miscVar.currentTime = miscVar.currentTime+video.FrameRate^-1;
miscVar.frameNum = 1;
miscVar.totalFrames = video.Duration/video.FrameRate^-1;
videoFig.plotted;
imagesc(miscVar.currentFrame);
title(['Frame ' num2str(miscVar.frameNum) '/' num2str(miscVar.totalFrames)])
miscVar.VideoLoadedFlag=1;
videoFig.Name=miscVar.FileName;
catch
    disp('Something went wrong')
end
end

function fcnSaveSheet(~,~)
global ParsedFrames
global miscVar
disp('Save sheet')
for laps=1:(size(ParsedFrames.LapStart,1)-1);
    ParsedFrames.LapNumber{laps+1,1}=laps;
end    
try 
switch miscVar.sessionClass
    case 1
realTable=table(ParsedFrames.LapNumber,...
                ParsedFrames.LapStart,...
                ParsedFrames.LiftBarrier,...
                ParsedFrames.LeaveMaze,...
                ParsedFrames.StartHomecage,...
                ParsedFrames.LeaveHomecage,...
                ParsedFrames.ForcedDir,...
                ParsedFrames.FreeDir);
    case 2
realTable=table(ParsedFrames.LapNumber,...
                ParsedFrames.LapStart,...
                ParsedFrames.LeaveMaze,...
                ParsedFrames.StartHomecage,...
                ParsedFrames.LeaveHomecage,...
                ParsedFrames.TrialType,...
                ParsedFrames.TrialDir);       
end        
bonusTable=table(ParsedFrames.LapNumber,...
              ParsedFrames.EnterDelay);
catch 
    save 'luckyYou.mat' 'ParsedFrames'
    disp('saved what you had')
    %Error handling!
end            
             
undecided=0; saveNow=0;
while undecided==0
    saveName = inputdlg('Name to save as:','Save Name',[1 40],{'DNMPsheet.xlsx'});             
    if exist(fullfile(miscVar.PathName,saveName{1}),'file')==2
      filechoice = questdlg('File already exists!', 'File exists',...
                              'Replace','New name','Cancel','Replace');
        switch filechoice
            case 'Replace'
                undecided=1; saveNow=1;
            case 'New name'
                undecided=0;
            case 'Cancel'
                undecided=1; saveNow=1;
        end
    else 
        disp('File does not exist.  Writing new file')
        undecided = 1; saveNow = 1;
    end
end
if saveNow==1;
    try
        xlswrite(fullfile(miscVar.PathName,saveName{1}),table2cell(realTable));
        xlswrite(fullfile(miscVar.PathName,[saveName{1}(1:end-5) '_bonus.xlsx']),table2cell(bonusTable));
    catch
        disp('Some saving error')   
    end    
end
end


function fcnLoadSheet(~,~)
disp('Load sheet')
global ParsedFrames
global miscVar
[filename, pathname, ext] = uigetfile({'*.xlsx', 'Excel Files'; '*.xls', 'Excel Files'}, 'Select previously saved sheet: ');

[~, ~, raw] = xlsread(fullfile(pathname, filename));

switch miscVar.sessionClass
    case 1
        ParsedFrames.LapNumber = raw(:,1);
        ParsedFrames.LapStart = raw(:,2);
        ParsedFrames.LiftBarrier = raw(:,3);
        ParsedFrames.LeaveMaze = raw(:,4);
        ParsedFrames.StartHomecage = raw(:,5);
        ParsedFrames.LeaveHomecage = raw(:,6);
        ParsedFrames.ForcedDir = raw(:,7);
        ParsedFrames.FreeDir = raw(:,8);
    case 2
        ParsedFrames.LapNumber = raw(:,1);
        ParsedFrames.LapStart = raw(:,2);
        ParsedFrames.LeaveMaze = raw(:,3);
        ParsedFrames.StartHomecage = raw(:,4);
        ParsedFrames.LeaveHomecage = raw(:,5);
        ParsedFrames.TrialType = raw(:,6);
        ParsedFrames.TrialDir = raw(:,7);
end
bonus_sheet = fullfile(pathname, [filename(1:end-5) '_bonus.xlsx']);
[~,~,bonus_raw] = xlsread(bonus_sheet);
ParsedFrames.EnterDelay = bonus_raw(:,2);

end

function fcnFakePlayer(~,~)
disp('fake player')
end
%%
function keyPress(~, e)%src

global miscVar
global videoFig
global video
global NOVar

%pause(0.001)
%e.Key

switch e.Key
%     case 'q' %Step back 100
%         if video.currentTime > 100/video.FrameRate
%             miscVar.frameNum = miscVar.frameNum - 101;
%             video.CurrentTime = miscVar.frameNum/video.FrameRate;
%             miscVar.currentFrame = readFrame(video);
%             miscVar.frameNum = miscVar.frameNum + 1;
%             videoFig.plotted = imagesc(miscVar.currentFrame);
%             title(['Frame ' num2str(miscVar.frameNum) ' / ' num2str(miscVar.totalFrames)])
%         end
    case 'a' %Step back 10
        if video.currentTime > 10/video.FrameRate
            miscVar.frameNum = miscVar.frameNum - 11;
            video.CurrentTime = miscVar.frameNum/video.FrameRate;
            miscVar.currentFrame = readFrame(video);
            miscVar.frameNum = miscVar.frameNum + 1;
            videoFig.plotted = imagesc(miscVar.currentFrame);
            title(['Frame ' num2str(miscVar.frameNum) ' / ' num2str(miscVar.totalFrames)])
        end
%     case 's'   %Step back
%         %can't do frame 0/1
%         if video.currentTime > 1/video.FrameRate
%             miscVar.frameNum = miscVar.frameNum - 2;
%             video.CurrentTime = miscVar.frameNum/video.FrameRate;
%             miscVar.currentFrame = readFrame(video);
%             miscVar.frameNum = miscVar.frameNum + 1;
%             videoFig.plotted = imagesc(miscVar.currentFrame);
%             title(['Frame ' num2str(miscVar.frameNum) ' / ' num2str(miscVar.totalFrames)])
%         end
%     case 'd' %Step forward 1
%         if video.currentTime+1 <= miscVar.totalFrames
%             miscVar.currentFrame = readFrame(video);
%             miscVar.frameNum = miscVar.frameNum+1;
%             videoFig.plotted = imagesc(miscVar.currentFrame);
%             title(['Frame ' num2str(miscVar.frameNum) ' / ' num2str(miscVar.totalFrames)])
%         end
    case 'f' %Step forward 10  
        if video.currentTime+10 <= miscVar.totalFrames
            miscVar.frameNum = miscVar.frameNum + 9;
            video.CurrentTime = miscVar.frameNum/video.FrameRate;
            miscVar.currentFrame = readFrame(video);
            miscVar.frameNum = miscVar.frameNum + 1;
            videoFig.plotted = imagesc(miscVar.currentFrame);
            title(['Frame ' num2str(miscVar.frameNum) ' / ' num2str(miscVar.totalFrames)])
        end
%     case 'r' %Step forward 100
%         if video.currentTime+1 <= miscVar.totalFrames
%             miscVar.frameNum = miscVar.frameNum + 99;
%             video.CurrentTime = miscVar.frameNum/video.FrameRate;
%             miscVar.currentFrame = readFrame(video);
%             miscVar.frameNum = miscVar.frameNum + 1;
%             videoFig.plotted = imagesc(miscVar.currentFrame);
%             title(['Frame ' num2str(miscVar.frameNum) ' / ' num2str(miscVar.totalFrames)])
%         end    
    case 'numpad1' % log framenum as LL
   
        NOVar.LLframes = unique([NOVar.LLframes miscVar.frameNum]); % Add existing frame number if unique and sort it
        NOVar.nLL = length(NOVar.LLframes); %
        if any(miscVar.frameNum == NOVar.URframes) % remove from NOVar.URframes if there already
            ind_remove = miscVar.frameNum == NOVar.URframes;
            NOVar.URframes = NOVar.URframes(~ind_remove);
            NOVar.nUR = length(NOVar.URframes);
            disp(['Frame ' num2str(miscVar.frameNum) ' REMOVED from upper-right exploration count'])
        end
        disp(['Frame ' num2str(miscVar.frameNum) ' ADDED to lower-left exploration count'])
        save NOVar NOVar
        
    case 'numpad9' % log framenum as UR
        
        NOVar.URframes = unique([NOVar.URframes miscVar.frameNum]); % Add existing frame number if unique and sort it
        NOVar.nUR = length(NOVar.URframes); %
        if any(miscVar.frameNum == NOVar.LLframes) % remove from NOVar.LLframes if there already
            ind_remove = miscVar.frameNum == NOVar.LLframes;
            NOVar.LLframes = NOVar.LLframes(~ind_remove);
            NOVar.nLL = length(NOVar.LLframes);
            disp(['Frame ' num2str(miscVar.frameNum) ' REMOVED from lower-left exploration count'])
        end
        disp(['Frame ' num2str(miscVar.frameNum) ' ADDED to upper-right exploration count'])
        save NOVar NOVar
        
    case 'numpad5' % remove framenum from LL or UR
        
        if any(miscVar.frameNum == NOVar.LLframes) % remove from NOVar.LLframes if there already
            ind_remove = miscVar.frameNum == NOVar.LLframes;
            NOVar.LLframes = NOVar.LLframes(~ind_remove);
            NOVar.nLL = length(NOVar.LLframes);
            disp(['Frame ' num2str(miscVar.frameNum) ' REMOVED from lower-left exploration count'])
        elseif any(miscVar.frameNum == NOVar.URframes) % remove from NOVar.URframes if there already
            ind_remove = miscVar.frameNum == NOVar.URframes;
            NOVar.URframes = NOVar.URframes(~ind_remove);
            NOVar.nUR = length(NOVar.URframes);
            disp(['Frame ' num2str(miscVar.frameNum) ' REMOVED from upper-right exploration count'])
        else
            disp(['Frame ' num2str(miscVar.frameNum) ' isn''t already logged as lower-left or upper-right exploration.'])
        end
        save NOVar NOVar

    case 'space'    
        disp('Fake player start/stop')
end
         
end
