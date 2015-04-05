function pos = getCineplexPos


try s = PL_InitClient(0);
    
catch %#ok<CTCH>
    s = 0;
end

if(s == 0)
    errorstate = true;
    warndlg('MAP Server is not running.','Failed to start.');
    
    
    
    return
end

pars = PL_GetPars(s);
if(~pars(10))
    warndlg('MAP Server is not running.','Failed to start.');
    
    return
elseif(~pars(11))
    warndlg('Sort Client is not running.','Failed to start.');
    
    return
elseif pars(11)
    
    [n,t] = PL_GetTS(s);
    [nCoords, nDim, vtmode, c] = PL_VTInterpret(t);
    
    
    pause(.5);%to get tracking info in
    [n,t] = PL_GetTS(s);
    [nCoords, nDim, vtmode, c] = PL_VTInterpret(t);
    
    if vtmode==2
        
        pos=[c(:,2) c(:,3)];
        pos=pos(pos(:,1)~=0,:);
        pos=pos(~isnan(pos(:,1)) & ~isnan(pos(:,2)),:);
        if ~isempty(pos)
            pos=mean(pos);
        else
            pos='not tracking anything';
        end
    elseif vtmode==3
        pos=[c(:,2) c(:,3)];
        pos=pos(pos(:,1)~=0,:);
        pos=pos(~isnan(pos(:,1)) & ~isnan(pos(:,2)),:);
        if ~isempty(pos)
            pos=mean(pos);
        else
            pos='not tracking anything';
        end
    elseif vtmode==6
        pos1=[c(:,2) c(:,3)];
        pos1=pos1(pos1(:,1)~=0,:);
        pos1=pos1(~isnan(pos1(:,1)) & ~isnan(pos1(:,2)),:);
        
        pos2=[c(:,4) c(:,5)];
        pos2=pos2(pos2(:,1)~=0,:);
        pos2=pos2(~isnan(pos2(:,1)) & ~isnan(pos2(:,2)),:);
        if ~isempty(pos1) && ~isempty(pos2)
            pos=[mean([pos1(end,1) pos2(end,1)]) mean([pos1(end,2) pos2(end,2)])];
            
            
        else
            pos='not tracking anything';
        end
        
        
    elseif ~isempty(pos2)
        pos=mean(pos2);
    else
        pos='not tracking anything';
    end
    
    
    
end


if isempty(c)
    warndlg('No tracking!');
    
    return
    
end

pos=round(pos);

end