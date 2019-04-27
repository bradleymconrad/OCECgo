function OCECgo_TabSupport_Copyright(panel)
% This function inserts the images and copyright in the bottom right corner
% of the input "panel"

% Insert copyright
axes(panel, 'Units', 'pixels', 'Position', [960 5 290 327], 'xlim', [960 1250], 'ylim', [5 332], 'xtick', [], 'ytick', [], 'visible', 'off')
str = {['Copyright ',char(169),' 2019']; 'Bradley Conrad'; 'Distributed under the MIT License'};
text(gca, 1105, 10, str, 'FontName', 'Helvetica', 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'bottom');

% Insert EERL image
axes(panel, 'Units', 'pixels', 'Position', [960 211 290 121], 'visible', 'off')
EERL = imread(fullfile(panel.Parent.Parent.UserData.folder_base, 'support', 'OCECgo_Images_EERL.png'));
imagesc(gca, EERL, 'ButtonDownFcn', {@Callback_EERL []}), axis image
set(gca, 'visible', 'off', 'layer', 'top')

% Insert FlareNet image
axes(panel, 'Units', 'pixels', 'Position', [960 85 290 97], 'visible', 'off')
FN = imread(fullfile(panel.Parent.Parent.UserData.folder_base, 'support', 'OCECgo_Images_FlareNet.png'));
imagesc(gca, FN, 'ButtonDownFcn', {@Callback_FN []}), axis image
set(gca, 'visible', 'off', 'layer', 'top')

end

function Callback_EERL(~, ~, ~)
% This callback launces the EERL website in the default browser
if ispc
    system('start www.carleton.ca/eerl');
elseif ismac
    system('open www.carleton.ca/eerl');
end
    
end

function Callback_FN(~, ~, ~)
% This callback launces the FlareNet website in the default browser
if ispc
    system('start www.flarenet.ca');
elseif ismac
    system('open www.flarenet.ca');
end
end