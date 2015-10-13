function [outstruct] = splitterplots(spk,xydata,pos1d,ctrstem,trialID,treadmillts,xbins,trialtype,badlaps,smsigma,iter,sigp,plotopt,savepath,cmap,unitnames,filetag,picformat)
%SPLITTERPLOTS - 
%
%(filter out bad trials from trialtype and bad trial ts from trialID
%before)
%plotopt - Plot start of center stem, end of stem, both or neither:
%           'Start','End','Both','None'
%
%Jon Rueckemann 2015

%Default values
compses=true;
compsplit=true;
addmax=true;
showshuf=true;

%Confirm input format
assert(size(treadmillts,1)==size(trialtype,1)...
    && size(trialtype,1)==max(trialID),['There must be one pair of '...
    'treadmill timestamps and trialtype information for each trial.']);

%Determine the length of each tracking bin
ts=xydata(:,1);
dt=[diff(ts); median(diff(ts))];

%Determine how many spikes occurred between each tracking timestamp
binspk=cellfun(@(x) histc(x,ts),spk,'uni',false);

%Convert trialtype to a numerical index
[~,~,trialtype]=unique(trialtype);

%Find start time of each trial (center stem entry) and start of treadmill
[~,trialstart,trialID]=unique(trialID);
evtstart{1}=ts(trialstart);
evtend{1}=treadmillts(:,1);

%Find the end of each treadmill run and the first exit from the center stem
evtstart{2}=sum(treadmillts,2);
ctrstem=~ctrstem;
evtend{2}=nan(size(treadmillts,1),1);
progressidx=true(size(ctrstem));
for m=1:size(treadmillts,1)
    if ~isnan(treadmillts(m,2))
        tmillidx=interp1(ts,1:numel(ts),sum(treadmillts(m,:),2),'nearest');
        progressidx(1:tmillidx)=false;
        exitidx=find(ctrstem&progressidx,1,'first')-1;
        evtend{2}(m)=ts(exitidx);
    else
        evtend{2}(m)=nan;
    end
end

%Define the smoothing kernel
if ~isempty(smsigma)
    k=pdf('norm',(-ceil(2*smsigma):ceil(2*smsigma))',0,smsigma); 
    % >95% of gaussian represented in kernel
end

%Preallocate figure axes
switch lower(plotopt)
    case 'start'
        h=setupfigure(1);
        plotopt='StemStart';
    case 'end'
        h=setupfigure(1);
        plotopt='StemEnd';
    case 'both'
        h=setupfigure(2);
        plotopt={'StemStart','StemEnd'};
    case 'none'
        h=nan;
    otherwise
        error('Invalid ''plotopt'' entered.');
end

%Interpolate positional data for plotting
if isstruct(h)
    %Find the position for each spike
    spktrl=cellfun(@(x) interp1(ts,trialID,x,'nearest'),...
        spk,'uni',false);
    dropspk=cellfun(@(x) ismember(x,find(badlaps))|isnan(x),...
        spktrl,'uni',false);
    spktrl=cellfun(@(x,y) x(~y),spktrl,dropspk,'uni',false);
    [~,~,spktrl]=cellfun(@unique,spktrl,'uni',false);
    spk=cellfun(@(x,y) x(~y),spk,dropspk,'uni',false);
    spk1Dpos=cellfun(@(x) interp1(ts,pos1d,x),...
        spk,'uni',false);
    spk2Dpos=cellfun(@(x) ...
        [interp1(ts,xydata(:,2),x) interp1(ts,xydata(:,3),x)],...
        spk,'uni',false);
end

%Remove data corresponding to badlaps
evtstart=cellfun(@(x) x(~badlaps),evtstart,'uni',false);
evtend=cellfun(@(x) x(~badlaps),evtend,'uni',false);
trialtype(badlaps)=[];
dropts=ismember(trialID,find(badlaps));
[~,~,trialID]=unique(trialID(~dropts));%relabel trialID
binspk=cellfun(@(x) x(~dropts),binspk,'uni',false);
pos1d=pos1d(~dropts);
dt=dt(~dropts);
ts=ts(~dropts);

outstruct=struct([]);
fname={'StemStart','StemEnd'};
for m=1:numel(spk)
    for n=1:numel(evtstart)
        if isstruct(h)  %Get spike positions for raster plots
            %Find position of spiking for target epochs (raster plot)
            curspk=tagts(spk{m},evtstart{n},evtend{n});
            curspktrl=spktrl{m}(~isnan(curspk));
            curspkpos=spk1Dpos{m}(~isnan(curspk));
        end
        
        %Find occupied positions for target epochs (ratemaps)
        curts=tagts(ts,evtstart{n},evtend{n});
        curpostrl=trialID(~isnan(curts));
        curbinspk=binspk{m}(~isnan(curts));
        curdt=dt(~isnan(curts));
        curpos=pos1d(~isnan(curts));
        
        %Bin tracking for trial by rate matrix
        [~,curpos]=histc(curpos,xbins);
        curpos=curpos+1; %Add bin for spurious tracking outside range
        
        %Create a trial by rate matrix
        spkmap=accumarray([curpostrl curpos],curbinspk,...
            [max(curpostrl) numel(xbins)+1]);
        occmap=accumarray([curpostrl curpos],curdt,...
            [max(curpostrl) numel(xbins)+1]);
        
        %Add values from last column to next-to-last column
        spkmap(:,numel(xbins)-1)=...
            spkmap(:,numel(xbins)-1)+spkmap(:,numel(xbins));
        spkmap(:,numel(xbins))=[];
        occmap(:,numel(xbins)-1)=...
            occmap(:,numel(xbins)-1)+occmap(:,numel(xbins));
        occmap(:,numel(xbins))=[];
        
        %Remove bin for values outside valid range
        spkmap(:,1)=[];
        occmap(:,1)=[];
        
        
        %Test for significant tuning
        spacetune=nan(4,size(spkmap,2));
        pmap=nan(4,size(spkmap,2));
        for w=1:4
            [spacetune(w,:),pmap(w,:)]=chancetuning(...
                spkmap(trialtype==w),occmap(trialtype==w),k,iter);
        end
        outstruct(m).Centerstem.(fname{n}).MeanTuningSmoothAfter=spacetune;
        outstruct(m).Centerstem.(fname{n}).FieldPvalue=pmap;
        
        %Make rate map
        ratemap=spkmap./occmap;
        if ~isempty(smsigma)
            ratemap=nanconvn(ratemap,k','edge');
        end
        
        %Develop tuning curves and identify differences between trial types
        ses1=ismember(trialtype,[1 2]);
        ses2=ismember(trialtype,[3 4]);
        [sigd1,deltacurve1,ci1,pvalue1,tuningcurves1]=...
            sigtuning(ratemap(ses1,:),trialtype(ses1),iter,sigp);
        [sigd2,deltacurve2,ci2,pvalue2,tuningcurves2]=...
            sigtuning(ratemap(ses2,:),trialtype(ses2),iter,sigp);
        
        %Store data in struct
        outstruct(m).Centerstem.(fname{n}).MeantTuningSmoothBefore=...
            [tuningcurves1;tuningcurves2];
        outstruct(m).Centerstem.(fname{n}).FieldMax=...
            nanmax(outstruct(m).Centerstem.(fname{n}).Placefield,[],2);
        outstruct(m).Centerstem.(fname{n}).FieldDiff=...
            [deltacurve1;deltacurve2];
        outstruct(m).Centerstem.(fname{n}).FieldDiffCI=[ci1;ci2];
        outstruct(m).Centerstem.(fname{n}).SigDiff=[sigd1;sigd2];
        outstruct(m).Centerstem.(fname{n}).SigPValue=[pvalue1;pvalue2];
        
        if compses %Compare left and right turns across sessions
            trlL=ismember(trialtype,[1 3]);
            trlR=ismember(trialtype,[2 4]);
            [sigdL,deltacurveL,ciL,pL,~]=...
                sigtuning(ratemap(trlL,:),trialtype(trlL),iter,sigp);
            [sigdR,deltacurveR,ciR,pR,~]=...
                sigtuning(ratemap(trlR,:),trialtype(trlR),iter,sigp);
            
            %Store data in struct
            outstruct(m).Centerstem.(fname{n}).FieldDiffSide=...
                [deltacurveL;deltacurveR];
            outstruct(m).Centerstem.(fname{n}).FieldDiffSideCI=[ciL;ciR];
            outstruct(m).Centerstem.(fname{n}).SigDiffSide=[sigdL;sigdR];
            outstruct(m).Centerstem.(fname{n}).SigPValueSide=[pL;pR];
        end
        
        if compsplit
            [sigd,deltacurve,ci,pvalue,~]=...
                sigtuning2(ratemap,trialtype,iter,sigp);
            %Store data in struct
            outstruct(m).Centerstem.(fname{n}).SplittingDiff=deltacurve;
            outstruct(m).Centerstem.(fname{n}).SplittingDiffCI=ci;
            outstruct(m).Centerstem.(fname{n}).SigSplittingDiff=sigd;
            outstruct(m).Centerstem.(fname{n}).PValueSplittingDiff=pvalue;
        end
        
        %Plot data
        if isstruct(h) && any(strcmpi(fname{n},plotopt))
            xax=xbins(1:end-1);
            if numel(h.ax)<5
                nn=1;
            else
                nn=n;
            end
            hold(h.ax(3*nn-2),'on');
            hold(h.ax(3*nn-1),'on');
            for c=1:max(trialtype)
                %Raster Plot
                curtrials=find(trialtype==c);
                X=curspkpos(ismember(curspktrl,curtrials));
                X=repmat(X(:)',3,1);
                X=X(:);
                Y=curspktrl(ismember(curspktrl,curtrials));
                Y=[Y(:)'; Y(:)'+1; nan(1,numel(Y))];
                Y=Y(:);
                line(X,Y,'Parent',h.ax(3*nn-2),'Color',cmap(c,:));
                set(h.ax(3*nn-2),'Xlim',[min(xax) max(xax)],...
                    'Ylim',[1 max(trialID)+1],'Ydir','Reverse')
                
                %Place Field Line Plot
                curline=outstruct(m).Centerstem.(fname{n}).Placefield(c,:);
                line(xax,curline,'Parent',h.ax(3*nn-1),...
                    'Color',cmap(c,:),'Linewidth',2);
                if addmax
                    textpos=0.99-.09*(c-1);
                    text(0.005,textpos,[num2str(max(curline)) 'Hz'],...
                        'Units','normalized','Color',cmap(c,:),...
                        'Fontweight','bold','Parent',h.ax(3*nn-1));
                end
            end
            hold(h.ax(3*nn-2),'off');
            hold(h.ax(3*nn-1),'off');
            
            %Spatial Splitting Line Plot
            hold(h.ax(3*nn),'on');
            if showshuf
                shci=outstruct(m).Centerstem.(fname{n}).FieldDiffCI;
                yvalues=[shci(1,:) flip(shci(2,:))];
                yvalues(isnan(yvalues))=0;
                fill([xax flip(xax)],yvalues,...
                    cmap(5,:),'edgecolor',[0.8 0.8 0.8],...
                    'facealpha',0.25,'Parent',h.ax(3*nn));
                yvalues=[shci(3,:) flip(shci(4,:))];
                yvalues(isnan(yvalues))=0;
                fill([xax flip(xax)],yvalues,...
                    cmap(6,:),'edgecolor',[0.8 0.8 0.8],...
                    'facealpha',0.25,'Parent',h.ax(3*nn));
            end
            deltalines=outstruct(m).Centerstem.(fname{n}).FieldDiff;
            line(xax,deltalines(1,:),'Parent',h.ax(3*nn),...
                'Color',cmap(5,:),'Linewidth',2);
            line(xax,deltalines(2,:),'Parent',h.ax(3*nn),...
                'Color',cmap(6,:),'Linewidth',2);
            line(xax,zeros(size(xax)),'Parent',h.ax(3*nn),...
                'Color','k','Linewidth',2);
            xrange=get(h.ax(3*nn),'xlim');
            newticklabels=round(linspace(xax(1),xax(end),10));
            newticklabels([1 10])=[];
            newticks=interp1([xax(1) xax(end)],xrange,newticklabels);
            set(h.ax(3*nn),'xtick',newticks,'xticklabel',newticklabels,...
                'tickdir','out','ticklength',[0 0],'fontsize',7.5);
            hold(h.ax(3*nn),'off');
        end
    end
    if isstruct(h) 
        %XY plot
        hold(h.ax(end),'on');
        line(xydata(:,2),xydata(:,3),'Parent',h.ax(end),...
            'Color',[0.85 0.85 0.85]);
        curtt=trialtype(spktrl{m});
        unqtt=unique(curtt);
        for w=1:numel(unqtt)
            line('xdata',spk2Dpos{m}(curtt==unqtt(w),1),...
                'ydata',spk2Dpos{m}(curtt==unqtt(w),2),...
                'linestyle','none','marker','o',...
                'markersize',3,'color',cmap(unqtt(w),:),...
                'markeredgecolor',cmap(unqtt(w),:),...
                'markerfacecolor',cmap(unqtt(w),:),...
                'parent',h.ax(end));
        end
        title(h.ax(end),unitnames{m});
        hold(h.ax(end),'off');
        
        %Format axes
        yrange=get(h.ax(1),'ylim');
        set(h.ax(1),'ytick',5:5:yrange(2),'tickdir','out',...
            'ticklength',[0 0],'yticklabel',5:5:yrange(2),...
            'fontsize',7.5,'xlim',get(h.ax(2),'xlim'));
        
        if numel(h.ax)>4
            %Put raster on the same x-axis as other plots
            set(h.ax(4),'xlim',get(h.ax(5),'xlim'));
            
            %Put spatial tuning curves on the same y-axis
            maxy=nanmax([outstruct(m).Centerstem.(fname{1}).FieldMax;...
                outstruct(m).Centerstem.(fname{2}).FieldMax]);
            set(h.ax(2),'ylim',[0 maxy*1.1]);
            set(h.ax(5),'ylim',[0 maxy*1.1]);
            
            %Put difference tuning curves on the same y-axis
            miny=nanmin([-0.1;...
                outstruct(m).Centerstem.(fname{1}).FieldDiff(:);...
                outstruct(m).Centerstem.(fname{2}).FieldDiff(:);...
                outstruct(m).Centerstem.(fname{1}).FieldDiffCI(:);...
                outstruct(m).Centerstem.(fname{2}).FieldDiffCI(:)]);
            maxy=nanmax([0.1; ...
                outstruct(m).Centerstem.(fname{1}).FieldDiff(:);...
                outstruct(m).Centerstem.(fname{2}).FieldDiff(:);...
                outstruct(m).Centerstem.(fname{1}).FieldDiffCI(:);...
                outstruct(m).Centerstem.(fname{2}).FieldDiffCI(:)]);
            set(h.ax(3),'ylim',[miny*1.1 maxy*1.1]);
            set(h.ax(6),'ylim',[miny*1.1 maxy*1.1]);
        end
        set(h.ax(2),'ytick',[0 max(get(h.ax(2),'ylim'))],...
            'tickdir','out','ticklength',[0 0],'fontsize',7.5,...
            'yticklabel',[0 round(max(get(h.ax(2),'ylim')))]);
         set(h.ax(3),'ytick',get(h.ax(3),'ylim'),'tickdir','out',...
            'ticklength',[0 0],'fontsize',7.5,...
            'yticklabel',round(get(h.ax(3),'ylim')));
        
        %Save figure
        saveas(h.fig,...
            [savepath '\' filetag 'Place-' unitnames{m}],picformat);
        
        %Clear axes
        for g=1:numel(h.ax)
            cla(h.ax(g));
        end
    end
end
close(h.fig);
end

function [h]=setupfigure(nplots)
%Allocate 400 pixels for each column and 150 pixels for the xyplot with 25
%pixel spacing between each frame
%Allocate 280 pixels for each raster and 160 pixels for the line plot and
%the subtraction plot with 25 pixel spacing between each frame
xwidth=(nplots*425)+300;
h.fig=figure('Position',[100 50 xwidth 700],'Visible','off');

posvec=nan((nplots*3)+1,4);
for a=1:nplots
    posvec(3*a-2,:)=[25+((a-1)*425) 395 400 280]; %Raster
    posvec(3*a-1,:)=[25+((a-1)*425) 210 400 160]; %Line
    posvec(3*a,:)=[25+((a-1)*425) 25 400 160]; %Subtraction
end
posvec(end,:)=[25+(nplots*425) 150 250 400]; %XY plot
posvec=posvec./repmat([xwidth 700 xwidth 700],size(posvec,1),1);


%Create handles for plot axes
h.ax=nan(size(posvec,1),1);
for a=1:numel(h.ax)
    h.ax(a)=axes('Parent',h.fig,'Position',posvec(a,:),...
        'xtick',[],'ytick',[]); %#ok<LAXES>
end
end