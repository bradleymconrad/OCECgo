function [] = OCECgo()

% Set system defaults
set(0, 'defaultUicontrolFontName', 'helvetica')
set(0, 'defaultUitableFontName', 'helvetica')
set(0, 'defaultAxesFontName', 'helvetica')
set(0, 'defaultTextFontName', 'helvetica')
set(0, 'defaultUipanelFontName', 'helvetica')
set(0, 'defaulttextverticalalignment', 'middle')
set(0, 'defaulttexthorizontalalignment', 'center')

% Close existing GUI
close(findobj('Name','OCECgo - A Thermal/Optical OCEC Tool'));

% Create figure
h = figure('Units', 'pixels', 'outerposition', [0 35 1280 750], ...
    'name','OCECgo - A Thermal/Optical OCEC Tool', 'resize', 'off', ...
    'integerhandle', 'off');
h.Units = 'normalized';
h.OuterPosition(1:2) = [0 0.045];
h.Units = 'pixels';
h.Color = 240 / 255 * [1 1 1];
h.WindowButtonMotionFcn = {@Callback_MousePositionAndPointer h};

% Get location
if ~isdeployed % Development environment
    % Add subfolders to path
    addpath(genpath(fileparts(which(mfilename()))))
    
    % Get base folder
    h.UserData.folder_base = fileparts(which(mfilename()));
else
    % Get base folder
    h.UserData.folder_base = [ctfroot, filesep, 'OCECgo'];
end

% Assign loadroot
h.UserData.folder_load = h.UserData.folder_base;

% Assign figure handle to base
assignin('caller', 'h', h);

% Create tab group
uitabgroup(h, 'Units', 'pixels', 'Tag', 'TabGroup', 'Position', [5 8 1260 675]);

% Create tabs
uitab(findobj(h, 'Tag', 'TabGroup'), 'Title', 'Calibration Tool', 'Units', 'pixels', 'Tag', 'Tab_Cal', 'ForegroundColor', [0.5 0 0]);
uitab(findobj(h, 'Tag', 'TabGroup'), 'Title', 'Data Analysis Tool - Inputs', 'Units', 'pixels', 'Tag', 'Tab_DatIn', 'ForegroundColor', [0 0 0.5]);
uitab(findobj(h, 'Tag', 'TabGroup'), 'Title', 'Data Analysis Tool - Results', 'Units', 'pixels', 'Tag', 'Tab_DatRes', 'ForegroundColor', [0 0.5 0]);
uitab(findobj(h, 'Tag', 'TabGroup'), 'Title', 'License', 'Units', 'pixels', 'Tag', 'Tab_Lic', 'ForegroundColor', [0 0 0]);

% Fill tabs
OCECgo_Tab_License(h);
OCECgo_Tab_AnalysisInput(h);
OCECgo_Tab_Calibration(h);
OCECgo_Tab_AnalysisResults(h);

% Enable zooming on specific axes only
zm = zoom;
setAllowAxesZoom(zm, findall(h, 'type', 'axes'), false)
setAllowAxesZoom(zm, findobj(allchild(h), 'tag', 'Cal_Ax_Unc'), true)
setAllowAxesZoom(zm, findobj(allchild(h), 'tag', 'Cal_Ax_Fit'), true)
setAllowAxesZoom(zm, findobj(allchild(h), 'tag', 'Dat_Ax_Therm'), true)
setAllowAxesZoom(zm, findobj(allchild(h), 'tag', 'Dat_Ax_AVEC'), true)

% Enable panning on specific axes only
pn = pan;
setAllowAxesPan(pn, findall(h, 'type', 'axes'), false)
setAllowAxesPan(pn, findobj(allchild(h), 'tag', 'Cal_Ax_Unc'), true)
setAllowAxesPan(pn, findobj(allchild(h), 'tag', 'Cal_Ax_Fit'), true)
setAllowAxesPan(pn, findobj(allchild(h), 'tag', 'Dat_Ax_Therm'), true)
setAllowAxesPan(pn, findobj(allchild(h), 'tag', 'Dat_Ax_AVEC'), true)

% Disallow rotation on existing axes
rt = rotate3d;
setAllowAxesRotate(rt, findall(h, 'type', 'axes'), false)

% Disable default interactivity (newer versions of MatLab)
ax = findall(h, 'type', 'axes');
try arrayfun(@(x) disableDefaultInteractivity(ax(x)), 1:length(ax)); end %#ok<*TRYNC>

% Remove items from toolbar
set(findall(h, 'ToolTipString', 'Save Figure'), 'visible', 'off')
set(findall(h, 'ToolTipString', 'Open File'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'New Figure'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Print Figure'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Link Plot'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Insert Colorbar'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Insert Legend'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Edit Plot'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Open Property Inspector'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Data Cursor'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Hide Plot Tools'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Show Plot Tools and Dock Figure'), 'visible', 'off')
set(findall(h, 'type', 'uipushtool'), 'separator', 'off')
set(findall(h, 'type', 'uitoggletool'), 'separator', 'off')

% Remove menubar
set(h, 'menubar', 'none')
h.Position(4) = 685;

% Remove axis toolbars (newer versions of MatLab)
try set(findobj(allchild(h), 'type', 'axes'), 'toolbar', []); end

% Re-add figure toolbar (newer versions of MatLab)
try addToolbarExplorationButtons(h); end
set(findall(h, 'tooltipstring', 'Rotate 3-D'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Brush/Select Data'), 'visible', 'off')
set(findall(h, 'tooltipstring', 'Data Tips'), 'visible', 'off')

% Migrate to calibration tab
set(findobj(h, 'Tag', 'TabGroup'), 'SelectedTab', findobj(h, 'Tag', 'Tab_Cal'))

% Turnoff expected / handled warnings
warning('off', 'MATLAB:nearlySingularMatrix')
warning('off', 'stats:mlecov:NonPosDefHessian')
warning('off', 'stats:tlsfit:EvalLimit')
end

function Callback_MousePositionAndPointer(~, ~, h)
% Change mouse pointer to finger if over hyperlink

% Get current point
cp = h.CurrentPoint;

t(1) = and(cp(1) >= 960, cp(1) < 1250);
t(2) = and(cp(2) >= 211, cp(2) < 332);
t(3) = and(cp(2) >= 85, cp(2) < 181);
if and(t(1), or(t(2), t(3)))
    set(h, 'pointer', 'hand')
    return
elseif strcmp(get(h, 'pointer'), 'hand')
    set(h, 'pointer', 'arrow')
end
end