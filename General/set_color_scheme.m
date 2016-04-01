function [ ] = set_color_scheme(varargin)
%set_color_scheme(scheme )
%   scheme = 'default' (also left blank) or black
%
% Note that this is a hack - to look for stuff you can possibly change,
% open the matlab.prf file using >>edit(fullfile(prefdir,'matlab.prf'));

scheme = 'default';
if ~isempty(varargin)
   scheme = varargin{1}; 
end

% cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
% listeners = cmdWinDoc.getDocumentListeners;
% 
% JText_index = nan;
% for j = 1:length(listeners)
%    temp = char(listeners(j));
%    if ~isempty(temp,'JTextArea')
%       JText_index = j; 
%    end
% end
%%

if strcmpi(scheme,'default')    
    % Use default color scheme
    com.mathworks.services.Prefs.setBooleanPref('ColorsUseSystem',1);
    com.mathworks.services.Prefs.setColorPref('Editorhighlight-lines',java.awt.Color(0.9882,0.9882,0.8627));
elseif strcmpi(scheme,'black')
    % Don't use system color
    com.mathworks.services.Prefs.setBooleanPref('ColorsUseSystem',0);
    
    % Use specified colors for foreground/background (instead of the default black on white)
    com.mathworks.services.Prefs.setColorPref('ColorsBackground',java.awt.Color.black);
    com.mathworks.services.Prefs.setColorPref('ColorsText',java.awt.Color.green);
    com.mathworks.services.Prefs.setColorPref('Editorhighlight-lines',java.awt.Color(0.15,0.15,0.15));
    com.mathworks.services.Prefs.setColorPref('Editor.VariableHighlighting.Color',java.awt.Color(0.5,0.5,0.5));
    com.mathworks.services.Prefs.setColorPref('ColorsMLintAutoFixBackground',java.awt.Color(0.64,0.08,0.19));
end

% Update everything
com.mathworks.services.ColorPrefs.notifyColorListeners('ColorsText');
com.mathworks.services.ColorPrefs.notifyColorListeners('ColorsBackground');
com.mathworks.services.ColorPrefs.notifyColorListeners('Editorhighlight-lines');

end

