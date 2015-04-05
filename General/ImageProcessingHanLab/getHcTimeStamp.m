function ts = getHcTimeStamp(info)
 imDes = info.ImageDescription;

[idLines,count] = strsplit(imDes,'\r\n');
tfsLine = idLines{find(squeeze(cell2array(strfind(idLines,'Time_From_Start = '))))};
tfsNum = sscanf(tfsLine,' Time_From_Start = %d:%d:%f');
ts.hours = tfsNum(1) + tfsNum(2)/60 + tfsNum(3)/3600;
ts.minutes = tfsNum(1)*60 + tfsNum(2) + tfsNum(3)/60;
ts.seconds = tfsNum(1)*3600 + tfsNum(2)*60 + tfsNum(3);