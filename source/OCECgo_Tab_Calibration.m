function OCECgo_Tab_Calibration(h)
% This function creates the fields within the calibration tab.

% Get parent
pnt1 = findobj(h, 'tag', 'Tab_Cal');

%% CREATE DATA SECTION

% Create panel
str = '1) Calibration Data';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [5 375 440 260], 'Title', str, 'FontSize', 16);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 440 260], 'xlim', [0 795], 'ylim', [0 260], 'visible', 'off')

% Create data table
str = 'Insert calibration data:';
text(gca, 10, 220, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
Columns = {['<html><center />Vol. of Sucrose<br />Solution [', char(181),'L]</html>']; '<html><center />"Total"<br />NDIR Area [-]</html>'; ...
    '<html><center />"Calibration"<br />NDIR Area [-]</html>'; '<html><center />Use Data?<br />(Yes = 1; No = 0)</html>'};
Data = zeros(1, 4) + nan;
uitable(pnt2, 'Units', 'pixels', 'ColumnName', Columns, 'ColumnWidth', mat2cell(92 * ones(1, 4), 1, ones(1, 4)), 'ColumnEditable', ~~[1 1 1 1], 'Data', Data, 'FontSize', 8, 'Position', [5 30 426 168], 'Tag', 'Cal_Table', 'CellSelectionCallback', {@Callback_CalTable_Selected h}); %#ok<MMTC>

% Create buttons
tip = '<html><b>Import</b> calibration data.<br />Warning: Data and results are uploaded but plots are not created.<br />To plot results, re-run the calibration procedure by pressing <b>GO</b> in section 3.</html>';
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [180 206.5 120 25], 'string', 'Import Calibration', 'BackgroundColor', 'w', 'tag', 'Cal_Import', 'Callback', {@Callback_CalibrationImport h []}, 'tooltip', tip);
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [323 210 40 18], 'string', '+ Row', 'BackgroundColor', 'w', 'tag', 'Cal_AddRow', 'Callback', {@Callback_CalTable_AddRow h});
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [368 210 40 18], 'string', '- Row', 'BackgroundColor', 'w', 'tag', 'Cal_AddRow', 'Callback', {@Callback_CalTable_DelRow h});

% Create latest known calibration text
text(gca, 50, 17, 'Calibration date:', 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
text(gca, 270, 17, 'Unknown', 'color', 'r', 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle', 'tag', 'Cal_Latest');

%% CREATE UNCERTAINTY SECTION

% Create panel and axes
str = '2) Uncertainty / Monte Carlo Settings';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [460 375 795 260], 'Title', str, 'FontSize', 16);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 795 260], 'xlim', [0 795], 'ylim', [0 260], 'visible', 'off')

% Create sucrose solution text
str = 'a) Define sucrose solution parameters:';
text(gca, 010, 220, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
text(gca, 070, 180, {'Sucrose'; 'mass [g]'}, 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 225, 180, {'Water'; 'mass [g]'}, 'FontSize', 10, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
text(gca, 070, 130, {'Scale'; 'bias [g]'}, 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 225, 130, {'Sucrose'; 'purity [%]'}, 'FontSize', 10, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
text(gca, 145, 080, {'Ambient temperature'; 'lower limit [\circC]'}, 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 145, 030, {'Ambient temperature'; 'upper limit [\circC]'}, 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');

% Create ucrose solution edit boxes
tip = '<html>Input the <b>mass of sucrose</b> used to create the<br />sucrose solution, <b>in grams</b>.</html>';
uicontrol(pnt2, 'Style', 'edit', 'Position', [075 160 070 35], 'String', '10.00', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Suc_Ms', 'tooltip', tip);
tip = '<html>Input the <b>mass of water</b> used to create the<br />sucrose solution, <b>in grams</b>.</html>';
uicontrol(pnt2, 'Style', 'edit', 'Position', [150 160 070 35], 'String', '1000.00', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Suc_Mw', 'tooltip', tip)
tip = '<html>Input the <b>bias of the scale</b> used to measure<br />sucrose and water masses, <b>in grams</b>.</html>';
uicontrol(pnt2, 'Style', 'edit', 'Position', [075 110 070 35], 'String', '0.0447', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Suc_Scale', 'tooltip', tip)
tip = '<html>Input the <b>nominal minimum sucrose purity</b><br /> of the sucrose used to create the sucrose solution, <b>in percent</b>.</html>';
uicontrol(pnt2, 'Style', 'edit', 'Position', [150 110 070 35], 'String', '99.5', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Suc_Pure', 'tooltip', tip)
tip = '<html>Input the <b>minimum ambient temperature</b> when acquiring<br />calibration data, <b>in degrees Celsius</b>.</html>';
uicontrol(pnt2, 'Style', 'edit', 'Position', [150 060 070 35], 'String', '20', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Suc_T1', 'tooltip', tip)
tip = '<html>Input the <b>maximum ambient temperature</b> when acquiring<br />calibration data, <b>in degrees Celsius</b>.</html>';
uicontrol(pnt2, 'Style', 'edit', 'Position', [150 010 070 35], 'String', '25', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Suc_T2', 'tooltip', tip)

% Create pipetter uncertainty text
str = ['b) Define pipette uncertainties (2', char(963), ') [%]:'];
text(gca, 330, 220, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
text(gca, 355, 180, {'Pipetted'; 'Volume'}, 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 435, 180, {'Equipment'; 'Accuracy'}, 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 535, 180, {'Equipment'; 'Repeatability'}, 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 635, 180, {'Intra-user'; 'Repeatability'}, 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 735, 180, {'Inter-user'; 'Reproducibility'}, 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 355, 130, ['5 ', char(181),'L'], 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 355, 080, ['10 ', char(181),'L'], 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');

% Create ipetter uncertainty edit boxes
tip = ['<html>Input the <b>2', char(963), ' equipment-rated accuracy</b><br />for an aspirated volume of 5 ', char(181),'L, <b>in percent</b>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [395 110 80 35], 'String', '0.313', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_b05a', 'tooltip', tip)
tip = ['<html>Input the <b>2', char(963), ' equipment-rated accuracy</b><br />for an aspirated volume of 10 ', char(181),'L, <b>in percent</b>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [395 060 80 35], 'String', '0.090', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_b10a', 'tooltip', tip)
tip = ['<html>Input the <b>2', char(963), ' equipment-rated repeatability</b><br />for an aspirated volume of 5 ', char(181),'L, <b>in percent</b>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [495 110 80 35], 'String', '0.796', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_p05a', 'tooltip', tip)
tip = ['<html>Input the <b>2', char(963), ' equipment-rated repeatability</b><br />for an aspirated volume of 10 ', char(181),'L, <b>in percent</b>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [495 060 80 35], 'String', '0.330', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_p10a', 'tooltip', tip)
tip = ['<html>Input the <b>2', char(963), ' intra-user repeatability</b><br />for an aspirated volume of 5 ', char(181),'L, <b>in percent</b>.<br /><i>Default values based on tests by the authors</i>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [595 110 80 35], 'String', '4.233', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_p05b', 'tooltip', tip)
tip = ['<html>Input the <b>2', char(963), ' intra-user repeatability</b><br />for an aspirated volume of 10 ', char(181),'L, <b>in percent</b>.<br /><i>Default values based on tests by the authors</i>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [595 060 80 35], 'String', '2.454', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_p10b', 'tooltip', tip)
tip = ['<html>Input the <b>2', char(963), ' inter-user reproducibility</b><br />for an aspirated volume of 5 ', char(181),'L, <b>in percent</b>.<br /><i>Default values based on tests by the authors</i>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [695 110 80 35], 'String', '3.666', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_b05b', 'tooltip', tip)
tip = ['<html>Input the <b>2', char(963), ' inter-user reproducibility</b><br />for an aspirated volume of 10 ', char(181),'L, <b>in percent</b>.<br /><i>Default values based on tests by the authors</i>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [695 060 80 35], 'String', '3.593', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_Pip_b10b', 'tooltip', tip)

% Create Monte Carlo draw text and edit box
str = 'c) Define # of Monte Carlo draws:';
text(gca, 330, 030, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
tip = ['<html>Input the <b>desired number of Monte Carlo draws</b>.<br /><i>Typical: ', char(8712), ' (10<sup>4</sup>, 10<sup>6</sup>).<br />Permitted: ', char(8712), ' (10<sup>2</sup>, 10<sup>8</sup>).</i></html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [585 010 100 35], 'String', '1000000', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Cal_MC_nd', 'tooltip', tip);

%% CREATE ANALYSIS SECTION

% Create panel
str = '3) Process Calibration';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [5 5 730 365], 'Title', str, 'FontSize', 16);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 730 365], 'xlim', [0 730], 'ylim', [0 365], 'visible', 'off')

% Create go button
str = 'Calibrate:';
text(gca, 25, 325, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
go_arrow = imread([h.UserData.folder_base, filesep, 'support\OCECgo_Images_GoArrow.png']);
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [100 310 130 28], 'cdata', go_arrow, 'BackgroundColor', 'w', 'tag', 'Cal_Run', 'Callback', {@Callback_CalibrationRun h});

% Create export and save as default buttons
tip = '<html><b>Export</b> the current result.<br />Input data and numerical results are saved in a user-selected .xlsx file.<br />Data visualization is saved in an identically-titled .png file</html>';
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [560 310 150 28], 'string', 'Export Calibration Results', 'tag', 'Cal_Export', 'Callback', {@Callback_CalibrationExport h []}, 'enable', 'off', 'tooltip', tip)
tip = '<html>Save the current result as the <b>default calibration</b>.<br />The current result is automatically reloaded upon reboot of the software.</html>';
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [400 310 150 28], 'string', 'Save as Default Calibration', 'tag', 'Cal_Default', 'Callback', {@Callback_CalibrationDefault h}, 'enable', 'off', 'tooltip', tip)

% Create axes for plotting
axes(pnt2, 'Units', 'pixels', 'Position', [55 55 290 215], 'xlim', [0 50], 'ylim', [0 60], 'xtick', 0:10:50, 'ytick', 0:10:60, 'fontsize', 10, 'tickdir', 'out', 'Tag', 'Cal_Ax_Fit', 'Box', 'on')
xlabel(['Carbon Mass [', char(181),'g]'], 'fontsize', 12)
ylabel('Integrated NDIR Area [10^3]', 'fontsize', 12)
title('Calibration Data & Fitting', 'fontsize', 14, 'FontWeight', 'bold', 'units', 'normalized', 'position', [0.5 1.02 0])
axes(pnt2, 'Units', 'pixels', 'Position', [420 55 290 215], 'xlim', [16 26], 'ylim', [30 40], 'xtick', 16:2:26, 'ytick', 30:2:40, 'fontsize', 10, 'tickdir', 'out', 'Tag', 'Cal_Ax_Unc', 'Box', 'on')
xlabel(['Calibration Mass [', char(181),'g]'], 'fontsize', 12)
ylabel('Calibration Area [10^3]', 'fontsize', 12)
title('Calibration Results', 'fontsize', 14, 'FontWeight', 'bold', 'units', 'normalized', 'position', [0.5 1.02 0])

% Create regression legend
str = {['Data & 2', char(963), ' C.I.']; ['Fit & 2', char(963), ' C.I.']; ['Cal. & 2', char(963), ' C.I.']};
axes(pnt2, 'Units', 'pixels', 'Position', [60 215 111 50], 'xtick', 0:10, 'ytick', 0:0.2:1.4, 'FontSize', 10, 'Tag', 'Cal_Ax_Fit_Leg', 'visible', 'off');
hold(gca, 'on')
fill(gca, [0.05 0.05 0.25 0.25], [0.7 0.9 0.9 0.7], 'k', 'facealpha', 0.3, 'edgecolor', 'k', 'edgealpha', 0.6);
fill(gca, [0.05 0.05 0.25 0.25], [0.4 0.6 0.6 0.4], [0.6 0 0], 'edgecolor', [0.6 0 0], 'facealpha', 0.3, 'edgealpha', 0.6);
fill(gca, [0.05 0.05 0.25 0.25], [0.1 0.3 0.3 0.1], 'b', 'facealpha', 0.3, 'edgecolor', 'b', 'edgealpha', 0);
text(gca, 0.3, 0.8, str{1}, 'fontsize', 8, 'horizontalalignment', 'left')
text(gca, 0.3, 0.5, str{2}, 'fontsize', 8, 'horizontalalignment', 'left')
text(gca, 0.3, 0.2, str{3}, 'fontsize', 8, 'horizontalalignment', 'left')
set(gca, 'xlim', [0 1], 'ylim', [0 1], 'xtick', [], 'ytick', [])

%% CREATE RESULTS SECTION

% Create panel
str = '4) Calib. Results';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [750 5 200 365], 'Title', str, 'FontSize', 16);
axes(pnt2, 'units', 'pixels', 'position', [0 0 200 365], 'xlim', [0 200], 'ylim', [0 365], 'visible', 'off')

% Add bounding rectangles
rectangle(gca, 'Position', [5 180 188 150], 'Curvature', 0.1, 'linewidth', 1.5)
rectangle(gca, 'Position', [5 015 188 150], 'Curvature', 0.1, 'linewidth', 1.5)

% Add calibration mass text
str = {'Calibrated'; ['Carbon Mass [', char(181),'g]:']};
text(gca, 100, 320, str, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')

% Add results
str1 = ['xx.xx ', char(177), ' xx.xx %'];
str2 = ['t(', char(181),', ', char(963),', ', char(957), ')'];
tip1 = ['<html>Statistics of the <b>mass calibration constant</b>.<br /><i>Mean and 2', char(963), ' confidence interval</i>.</html>'];
tip2 = ['<html>Statistics of the <b>mass calibration constant</b>.<br /><i>Generalized t-distribution t(', char(181),', ', char(963),', ', char(957), ')</i>.</html>'];
uicontrol(pnt2, 'style', 'text', 'position', [10 230 178 30], 'string', str1, 'fontsize', 12, 'HorizontalAlignment', 'center', 'Tag', 'Cal_Res1a', 'tooltip', tip1)
uicontrol(pnt2, 'style', 'text', 'position', [10 190 178 30], 'string', str2, 'fontsize', 10, 'FontAngle', 'italic', 'HorizontalAlignment', 'center', 'Tag', 'Cal_Res1b', 'tooltip', tip2)

% Add mean calibration (CH4-loop) area text
str = {'Mean calibration'; '(CH_4-loop) area [-]:'};
text(gca, 100, 155, str, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')

% Add result
str1 = ['xxxxx ', char(177), ' xx.xx%'];
str2 = ['N(', char(181),', ', char(963),')'];
tip1 = ['<html>Statistics of the <b>mean CH<sub>4</sub>-loop area</b>.<br /><i>Mean and 2', char(963), ' confidence interval</i>.</html>'];
tip2 = ['<html>Statistics of the <b>mean CH<sub>4</sub>-loop area</b>.<br /><i>Normal distribution N(', char(181),', ', char(963),')</i>.</html>'];
uicontrol(pnt2, 'style', 'text', 'position', [10 65 178 30], 'string', str1, 'fontsize', 12, 'HorizontalAlignment', 'center', 'Tag', 'Cal_Res2a', 'tooltip', tip1)
uicontrol(pnt2, 'style', 'text', 'position', [10 25 178 30], 'string', str2, 'fontsize', 10, 'FontAngle', 'italic', 'HorizontalAlignment', 'center', 'Tag', 'Cal_Res2b', 'tooltip', tip2)

%% ADD FILLER MATERIAL

OCECgo_TabSupport_Copyright(pnt1);

%% UPLOAD INITIALIZATION IF IT CAN BE FOUND

% If init file does not exist, stop here, otherwise load
file = fullfile(h.UserData.folder_base, 'Cal_init.xlsx');
if ~exist(file, 'file')
    return
end
Callback_CalibrationImport([], [], h, file);

end

function Callback_CalTable_Selected(~, eventdata, h)
% This callback function stores the most recently selected cell in the
% table

% If no cell is selected, save empty
if isempty(eventdata.Indices)
    set(findobj(allchild(h), 'tag', 'Cal_Table'), 'userdata', []);
    return
end

% Save selected row to userdata
set(findobj(allchild(h), 'tag', 'Cal_Table'), 'userdata', eventdata.Indices(1))
end

function Callback_CalTable_AddRow(~, ~, h)
% This callback function adds a row to the data table when requested by the
% user pushing the "Add Row" button.

% Get current table data
table_dat = get(findobj(h, 'tag', 'Cal_Table'), 'data');

% Append one row
table_dat = cat(1, table_dat, nan * zeros(1, 4));

% Update data
set(findobj(h, 'tag', 'Cal_Table'), 'data', table_dat);

end

function Callback_CalTable_DelRow(~, ~, h)
% This callback function deletes the selected row in the data table when
% requested by the user pushing the "Delete Row" button.

% Get current table data
table_dat = get(findobj(h, 'tag', 'Cal_Table'), 'data');

% Get row to remove one row (remove last if nothing is selected)
remrow = get(findobj(allchild(h), 'tag', 'Cal_Table'), 'userdata');
if isempty(remrow)
    remrow = size(table_dat, 1);
end

% Update data and resave
table_dat(remrow, :) = [];
set(findobj(h, 'tag', 'Cal_Table'), 'data', table_dat);

end

function Callback_CalibrationRun(~, ~, h)
% This function runs the Monte Carlo analysis to compute the mass
% calibration constant and its uncertainty.

%% PULL, PARSE, AND VALIDATE DATA

OCECgo_Validate_Calibration(h);
Cal = h.UserData.Cal; % Temporary variable for sub-routine

%% RUN MONTE CARLO ANALYSIS OF SUCROSE SOLUTION

% Compute density of solution and mass fraction of sucrose ----------------

% Obtain randomized mass of sucrose
rand_sucrose_purity = unifrnd(Cal.Suc_Pure / 100, 1, [Cal.MC_nd, 1]);
rand_sucrose_mass = rand_sucrose_purity .* normrnd(Cal.Suc_Ms, Cal.Suc_Scale / 2, [Cal.MC_nd 1]);
clear rand_sucrose_purity

% Obtain randomized mass fraction of sucrose in solution
rand_water_mass = normrnd(Cal.Suc_Mw, Cal.Suc_Scale / 2, [Cal.MC_nd 1]);
rand_mass_frac = rand_sucrose_mass ./ (rand_sucrose_mass + rand_water_mass);
clear rand_sucrose_mass rand_water_mass

% Obtain randomized ambient temperature (considered constant during
% acquisition of calibration data)
rand_temp = unifrnd(Cal.Suc_T1, Cal.Suc_T2, [Cal.MC_nd 1]);

% Define constants for solution density calculation (using
% https://doi.org/10.1081/JFP-120017815)
a1 = 1.00042;   % g/cm^3
b1 = 0.004056;  % 100 g/g_solute
a2 = -2.294e-6; % g/cm^2/dC
b2 = -1.332e-5; % 100 g/g_solute/dC
a3 = -4.646e-6; % g/cm^2/dC^2
b3 = 1.254e-7;  % 100 g/g_solute/dC^2

% Solve for density of solution in [g/L]
b = @(T, F) (b1 + b2 * T + b3 * T .^ 2) .* F - 1;
c = @(T) (a1 + a2 * T + a3 * T .^ 2);
rand_density = -c(rand_temp) ./ b(rand_temp, rand_mass_frac) * 1e3;

% Compute mass of carbon in volume of solution [gC/L]
rand_C_frac = rand_density .* rand_mass_frac * 12 * 12.0107 / 342.297;
clear a1 b1 c1 a2 b2 c2 a3 b3 c3 a b c d rand_density rand_temp rand_mass_frac

%% RUN MONTE CARLO ANALYSIS OF APPLIED VOLUME AND SUCROSE CARBON

% Obtain applied volumes
temp_volume = Cal.Table4Analysis(:, 1)';

% Initiate MC matrix of applied volume
applied_volume = zeros(Cal.MC_nd, length(temp_volume));

% Obtain bias vectors - % bias of pipetter is assumed equal for 5 and 10 uL
% of solution
bias_mat = randn(Cal.MC_nd, 1);
bias_05 = prod(1 + bsxfun(@times, bias_mat, Cal.Pip_b05 / 2 / 100), 2);
bias_10 = prod(1 + bsxfun(@times, bias_mat, Cal.Pip_b10 / 2 / 100), 2);

% Apply bias and precision for 5 uL
idx = find(temp_volume == 05);
applied_volume(:, idx) = bsxfun(@times, 05 * ones(1, length(idx)), bias_05) .* ... % bias added
    normrnd(1, norm(Cal.Pip_p05) / 2 / 100, [Cal.MC_nd length(idx)]); % precision added

% Apply bias and precision for 10 uL
idx = find(temp_volume == 10);
applied_volume(:, idx) = bsxfun(@times, 10 * ones(1, length(idx)), bias_10) .* ... % bias added
    normrnd(1, norm(Cal.Pip_p10) / 2 / 100, [Cal.MC_nd length(idx)]); % precision added

% Get random applied carbon in sucrose
rand_applied_C = bsxfun(@times, applied_volume, rand_C_frac);

clear applied_volume rand_C_frac idx Pip_* bias_*

%% RUN MONTE CARLO ON NDIR AREAS

% Obtain total and calibration area
total_area = Cal.Table4Analysis(:, 2)';
calib_area = Cal.Table4Analysis(:, 3)';

% Compute random bias of NDIR - MLE fit of calibration areas
bias_NDIR = randn(Cal.MC_nd, 1) * std(calib_area) / mean(calib_area);

% Apply bias to reported total area
rand_total_area = bsxfun(@times, 1 + bias_NDIR, total_area);

% Compute random calibration area - using standard error of the reported
% areas
rand_calib_area = bsxfun(@times, 1 + bias_NDIR / sqrt(length(calib_area)), mean(calib_area));

% Correct total area for blanks - i.e., perform blank subtraction
ave_blank = mean(rand_total_area(:, temp_volume == 00), 2);
rand_total_area = bsxfun(@minus, rand_total_area, ave_blank);

clear bias total_area ave_blank temp_volume

%% PERFORM LINEAR FITTING TO MONTE CARLO DATA

% Get standard errors of slope and intercept from linear regression to the
% average (no uncertainty) data
xx = mean(rand_total_area);
yy = mean(rand_applied_C);
crude = fitlm(xx, yy);
sm1 = crude.Coefficients.SE(2); % Standard error of slope
sb1 = crude.Coefficients.SE(1); % Standard error of intercept
rho_mb = -mean(xx) * sm1 / sb1;
clear xx yy

% Perform Monte Carlo - Linear regression is performed on each set of the
% Monte Carlo-perturbed calibration data
n = size(rand_total_area, 2);
xx = rand_total_area;
yy = rand_applied_C;
SSxx = sum(bsxfun(@minus, xx, mean(xx, 2)) .^ 2, 2);
SSxy = sum(bsxfun(@minus, xx, mean(xx, 2)) .* bsxfun(@minus, yy, mean(yy, 2)), 2);
mm = SSxy ./ SSxx;
bb = mean(yy, 2) - mm .* mean(xx, 2);
m = mean(mm); % Average slope from MC
b = mean(bb); % Average intercept from MC
sm2 = std(mm) / sqrt(size(xx, 2)); % Standard error of slope from MC
sb2 = std(bb) / sqrt(size(xx, 2)); % Standard error of intercept from MC

% Combine (in quadrature) slope and intercept uncertainty from the crude
% regression and the MC analysis
sm = sqrt(sm1 .^ 2 + sm2 .^ 2);
sb = sqrt(sb1 .^ 2 + sb2 .^ 2);

% Obtain standard error in the overall regression at the MC-preturbed
% calibration areas
se = sqrt(sb ^ 2 + sm ^ 2 * rand_calib_area .^2 + 2 * sm * sb * rho_mb * rand_calib_area);

% Compute random mass calibration constants
t_random = trnd(n - 2, [Cal.MC_nd 1]);
rand_cal_const = m .* rand_calib_area + b + t_random .* se;

% Compute fits to the calibration results
ft.area = fitdist(rand_calib_area, 'normal');
ft.mass = fitdist(rand_cal_const, 'tLocationScale');
Cal.MC_Data = cat(3, rand_applied_C, rand_total_area);

% Store MC results, fits, and statistics
Cal.Crude = crude;
Cal.MC_Results = [rand_cal_const, rand_calib_area];
Cal.MC_Fits = ft;
Cal.MC_Regress = struct('m', m, 'b', b, 'sm', sm, 'sb', sb, 'rho_mb', rho_mb, 'n', n);

clear xx yy SS* mm bb se t_r* crude

%% GET CALIBRATION STATISTICS

Z2 = normcdf(2); % Normal-equivalent 2-sigma CI
results(1) = ft.mass.mu;
results(2) = ft.mass.icdf(Z2) - results(1);
results(3) = ft.area.mu;
results(4) = ft.area.icdf(Z2) - results(3);
results(5) = results(2) / results(1) * 100;
results(6) = results(4) / results(3) * 100;

% For testing only, if all calibration areas are equal
% if ft.area.sigma == 0
%     results([4, 6]) = 0;
% end

%% PLOT FIGURES
Sub_PlotFigures(h, Cal)

%% FILL IN RESULTS TEXT AND LOG DATA

% Calibration mass
str = [num2str(results(1), '%0.2f'), ' ', char(177), ' ', num2str(results(5), '%0.2f'), '%'];
set(findobj(h, 'tag', 'Cal_Res1a'), 'string', str)
set(findobj(h, 'tag', 'Cal_Res1b'), 'string', ['~t(', num2str(Cal.MC_Fits.mass.mu, '%.2f'),', ', num2str(Cal.MC_Fits.mass.sigma, '%.3f'),', ', num2str(Cal.MC_Fits.mass.nu, '%.3f'),')'])

% Calibration area
str = [num2str(round(results(3)), '%u'), ' ', char(177), ' ', num2str(results(6), '%0.2f'), '%'];
set(findobj(h, 'tag', 'Cal_Res2a'), 'string', str)
set(findobj(h, 'tag', 'Cal_Res2b'), 'string', ['~N(', num2str(round(Cal.MC_Fits.area.mu), '%u'),', ', num2str(Cal.MC_Fits.area.sigma, '%0.1f'),')'])

% Update data analysis section
set(findobj(allchild(h), 'tag', 'Dat_Cal_Mu'), 'string', num2str(Cal.MC_Fits.mass.mu, '%.2f'))
set(findobj(allchild(h), 'tag', 'Dat_Cal_Sg'), 'string', num2str(Cal.MC_Fits.mass.sigma, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Cal_Nu'), 'string', num2str(Cal.MC_Fits.mass.nu, '%.3f'))

% Save to GUI userdata
h.UserData.Cal = Cal;

% Enable save default and export buttons
set(findobj(allchild(h), 'tag', 'Cal_Export'), 'enable', 'on')
set(findobj(allchild(h), 'tag', 'Cal_Default'), 'enable', 'on')

% Warn if R2 is low
if Cal.Crude.Rsquared.ordinary < 0.999
    msg = 'Warning! Calibration data is somewhat non-linear (R^2 < 99.90%). Consider searching for spurious calibration data and modifying calibration dataset.';
    uiwait(msgbox(msg, 'warning', 'warn', 'modal'))
end

end

function Sub_PlotFigures(h, caldat)
%% CREATE PLOT - REGRESSION

% Get axis and prep for plotting
axes(findobj(allchild(h), 'tag', 'Cal_Ax_Fit'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')

% Compute reasonable x-axis limits
xx = caldat.MC_Data(:, :, 1);
x1 = min(-5, floor(min(xx(:) * 0.2)) * 5);
x2 = ceil(0.1 * max(xx(:))) * 10;
xlim = [x1 x2];
xtick = -10 : 10 : 100;

% Compute reasonable y-axis limits
yy = caldat.MC_Data(:, :, 2);
y1 = min(-5, floor(min(yy(:)) / 1e3 * 0.2) * 5);
y2 = ceil(0.1 * max(yy(:)) / 1e3) * 10;
ylim = [y1 y2];
ytick = -10 : 10 : 200;

% Compute 2-sigma confidence interval of regression
ydat = linspace(ylim(1), ylim(2), 101);
se = sqrt(caldat.MC_Regress.sb ^ 2 + caldat.MC_Regress.sm ^ 2 * ydat .^ 2 + 2 * caldat.MC_Regress.sm * caldat.MC_Regress.sb * caldat.MC_Regress.rho_mb * ydat);
x1 = caldat.MC_Regress.b + caldat.MC_Regress.m * ydat * 1e3 + tinv(normcdf(-2), size(caldat.Table4Analysis, 1) - 2) .* se;
x2 = caldat.MC_Regress.b + caldat.MC_Regress.m * ydat * 1e3 + tinv(normcdf(+2), size(caldat.Table4Analysis, 1) - 2) .* se;

% Fill calibration results (blue area)
xlow = prctile(caldat.MC_Results(:, 1), normcdf(-2) * 100);
xhig = prctile(caldat.MC_Results(:, 1), normcdf(+2) * 100);
ylow = prctile(caldat.MC_Results(:, 2), normcdf(-2) * 100) / 1e3;
yhig = prctile(caldat.MC_Results(:, 2), normcdf(+2) * 100) / 1e3;
if ylow == yhig
    plot([xlim(1) xhig], ylow * [1 1], 'color', [0 0 1 0.3], 'linewidth', 1)
else
    fill([xlim(1) xlim(1) xlow xhig], [yhig ylow ylow yhig], 'b', 'facealpha', 0.3, 'edgecolor', 'b', 'edgealpha', 0)
end
leg(3) = fill([xhig xlow xlow xhig], [ylim(1) ylim(1) ylow yhig], 'b', 'facealpha', 0.3, 'edgecolor', 'b', 'edgealpha', 0);

% Plot CI of regression (red area)
leg(2) = fill([x1 fliplr(x2) x1(1)], [ydat fliplr(ydat), ydat(1)], [0.6 0 0], 'edgecolor', [0.6 0 0], 'facealpha', 0.3, 'edgealpha', 0.6);

% Plot calibration data (black areas)
for idx = 1 : size(xx, 2)
    xlow = prctile(xx(:, idx), normcdf(-2) * 100);
    xhig = prctile(xx(:, idx), normcdf(+2) * 100);
    ylow = prctile(yy(:, idx), normcdf(-2) * 100);
    yhig = prctile(yy(:, idx), normcdf(+2) * 100);
    if xlow == xhig
        xlow = xhig - 0.5;
        xhig = xhig + 0.5;
    end
    leg(1) = fill([xlow xlow xhig xhig], [ylow yhig yhig ylow] / 1e3, 'k', 'facealpha', 0.3, 'edgecolor', 'k', 'edgealpha', 0.6);
end

% Add R2 text
str = sprintf('R^{2} = %05.2f%%', caldat.Crude.Rsquared.Ordinary * 100);
if caldat.Crude.Rsquared.Ordinary * 100 < 99.9
    col = 'r';
else
    col = 'k';
end
text(xlim(1) + 0.98 * range(xlim), ylim(1) + 0.02 * range(ylim), str, 'color', col, 'fontsize', 10, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');

% Format axis and figure
set(gca, 'xlim', xlim, 'xtick', xtick)
set(gca, 'ylim', ylim, 'ytick', ytick)
grid(gca, 'off')
hold(gca, 'off')
uistack(findobj(allchild(h), 'tag', 'Cal_Ax_Fit_Leg'), 'top')

%% CREATE PLOT - HISTOGRAM

% Get axis and prep for plotting
axes(findobj(allchild(h), 'tag', 'Cal_Ax_Unc'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')

% Plot data (up to 10^5 points)
if size(caldat.MC_Results, 1) ~= caldat.MC_nd
    subdat = 1 : size(caldat.MC_Results, 1);
else
    subdat = randperm(caldat.MC_nd, min(caldat.MC_nd, 1e5));
end
if length(subdat) < 5e3 % Assign marker size and transparency
    sz = 4;
    al = 0.3;
elseif length(subdat) < 1e4
    sz = 3;
    al = 0.2;
elseif length(subdat) < 1e5
    sz = 2;
    al = 0.1;
else
    sz = 1;
    al = 0.05;
end
scatter(caldat.MC_Results(subdat, 1), caldat.MC_Results(subdat, 2) / 1e3, sz, [0.5 0 0], 'o', 'filled', 'markerfacealpha', al, 'markeredgealpha', 0)

% Set reasonable axis limits
xlow = fzero(@(x) caldat.MC_Fits.mass.pdf(x) - caldat.MC_Fits.mass.pdf(caldat.MC_Fits.mass.mu) / 50, [caldat.MC_Fits.mass.icdf(1e-9) caldat.MC_Fits.mass.mu]);
xhig = 2 * caldat.MC_Fits.mass.mu - xlow;
ylow = caldat.MC_Fits.area.icdf(normcdf(-6));
yhig = caldat.MC_Fits.area.icdf(normcdf(+6));
set(gca, 'xlim', [xlow xhig], 'ylim', [ylow yhig] / 1e3)

% Plot mass calibration histogram and fit
xdat = linspace(xlow - (xhig - xlow), xhig + (xhig - xlow), 1001);
ydat = (caldat.MC_Fits.mass.pdf(xdat) / caldat.MC_Fits.mass.pdf(caldat.MC_Fits.mass.mu)) * 0.2 * (yhig - ylow) / 1e3 + ylow / 1e3;
tempdat = caldat.MC_Results(and(caldat.MC_Results(:, 1) > xlow, caldat.MC_Results(:, 1) < xhig), 1);
[a, b] = hist(tempdat, 3 * sqrt(length(tempdat)));
a = a * caldat.MC_nd / length(tempdat);
a = a ./ max(sgolayfilt(a, 2, 2 * floor(length(tempdat)^0.25 / 2) + 1)) * (max(ydat) - ylow / 1e3);
bar(b, ylow / 1e3 + a, 1, 'edgecolor', 'none', 'facecolor', [0.5 0 0], 'facealpha', 0.5)
plot(xdat, ydat, '-k', 'color', [0.5 0 0], 'linewidth', 1.5)

% Plot area calibration histogram and fit
ydat = linspace(ylow, yhig, 250);
xdat = (caldat.MC_Fits.area.pdf(ydat) / caldat.MC_Fits.area.pdf(caldat.MC_Fits.area.mu)) * 0.2 * (xhig - xlow) + xlow;
tempdat = caldat.MC_Results(and(caldat.MC_Results(:, 2) > ylow, caldat.MC_Results(:, 2) < yhig), 2);
[a, b] = hist(tempdat, sqrt(length(tempdat)));
a = a * caldat.MC_nd / length(tempdat);
a = a ./ max(sgolayfilt(a, 2, 2 * floor(length(tempdat)^0.25 / 2) + 1)) * (max(xdat) - xlow);
barh(b / 1e3, xlow + a, 1, 'edgecolor', 'none', 'facecolor', [0.5 0 0], 'facealpha', 0.5)
plot(xdat, ydat / 1e3, '-k', 'color', [0.5 0 0], 'linewidth', 1.5)
set(gca, 'layer', 'top', 'xtickmode', 'auto', 'ytickmode', 'auto', 'XTickLabelMode', 'auto', 'YTickLabelMode', 'auto')

end

function Callback_CalibrationImport(~, ~, h, xlsfile)

% Get file location
if isempty(xlsfile)
    [file, fold] = uigetfile('*.xlsx', 'Select / create export file', fullfile(h.UserData.folder_load, '*.xlsx'));
    h.UserData.folder_load = fold;
    xlsfile = fullfile(fold, file);
end

% Load data

% Number of calibration data
nb = xlsread(xlsfile, 'Calibration', 'C3');

% Load calibration data
tbl = xlsread(xlsfile, 'Calibration', ['D5:', char(67 + nb), '8'])';
h.UserData.Cal.Table = tbl;
h.UserData.Cal.Table4Analysis = tbl(~~tbl(:, end), :);

% Load sucrose data
dat = xlsread(xlsfile, 'Calibration', 'C11:C16');
h.UserData.Cal.Suc_Ms = dat(1);
h.UserData.Cal.Suc_Mw = dat(2);
h.UserData.Cal.Suc_Scale = dat(3);
h.UserData.Cal.Suc_Pure = dat(4);
h.UserData.Cal.Suc_T1 = dat(5);
h.UserData.Cal.Suc_T2 = dat(6);

% Load pipette data
dat = xlsread(xlsfile, 'Calibration', 'F12:I13');
h.UserData.Cal.Pip_b05 = [dat(1, 1) dat(1, 4)];
h.UserData.Cal.Pip_b10 = [dat(2, 1) dat(2, 4)];
h.UserData.Cal.Pip_p05 = [dat(1, 2) dat(1, 3)];
h.UserData.Cal.Pip_p10 = [dat(2, 2) dat(2, 3)];

% Load MC draws
h.UserData.Cal.MC_nd = xlsread(xlsfile, 'Calibration', 'F15');

% Load calibration results
dat = xlsread(xlsfile, 'Calibration', 'L12:N13');
h.UserData.Cal.MC_Fits.mass = makedist('tLocationScale', 'mu', dat(1, 1), 'sigma', dat(1, 2), 'nu', dat(1, 3));
h.UserData.Cal.MC_Fits.area = makedist('Normal', 'mu', dat(2, 1), 'sigma', dat(2, 2));

% Print userdata
% Set data
set(findobj(allchild(h), 'tag', 'Cal_Table'), 'data', h.UserData.Cal.Table)
set(findobj(allchild(h), 'tag', 'Cal_Suc_Ms'), 'String', num2str(h.UserData.Cal.Suc_Ms, '%.2f'))
set(findobj(allchild(h), 'tag', 'Cal_Suc_Mw'), 'String', num2str(h.UserData.Cal.Suc_Mw, '%.2f'))
set(findobj(allchild(h), 'tag', 'Cal_Suc_Scale'), 'String', num2str(h.UserData.Cal.Suc_Scale, '%.4f'))
set(findobj(allchild(h), 'tag', 'Cal_Suc_Pure'), 'String', num2str(h.UserData.Cal.Suc_Pure, '%.1f'))
set(findobj(allchild(h), 'tag', 'Cal_Suc_T1'), 'String', num2str(h.UserData.Cal.Suc_T1, '%u'))
set(findobj(allchild(h), 'tag', 'Cal_Suc_T2'), 'String', num2str(h.UserData.Cal.Suc_T2, '%u'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_b05a'), 'String', num2str(h.UserData.Cal.Pip_b05(1), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_b05b'), 'String', num2str(h.UserData.Cal.Pip_b05(2), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_p05a'), 'String', num2str(h.UserData.Cal.Pip_p05(1), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_p05b'), 'String', num2str(h.UserData.Cal.Pip_p05(2), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_b10a'), 'String', num2str(h.UserData.Cal.Pip_b10(1), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_b10b'), 'String', num2str(h.UserData.Cal.Pip_b10(2), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_p10a'), 'String', num2str(h.UserData.Cal.Pip_p10(1), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_Pip_p10b'), 'String', num2str(h.UserData.Cal.Pip_p10(2), '%.3f'))
set(findobj(allchild(h), 'tag', 'Cal_MC_nd'), 'String', num2str(h.UserData.Cal.MC_nd, '%u'))
set(findobj(h, 'tag', 'Cal_Res1a'), 'string', [num2str(h.UserData.Cal.MC_Fits.mass.mu, '%0.2f'), ' ', char(177), ' ', num2str(100 * (h.UserData.Cal.MC_Fits.mass.icdf(normcdf(2)) / h.UserData.Cal.MC_Fits.mass.mu - 1), '%0.2f'), '%'])
set(findobj(h, 'tag', 'Cal_Res1b'), 'string', ['~t(', num2str(h.UserData.Cal.MC_Fits.mass.mu, '%.2f'),', ', num2str(h.UserData.Cal.MC_Fits.mass.sigma, '%.3f'),', ', num2str(h.UserData.Cal.MC_Fits.mass.nu, '%.3f'),')'])
set(findobj(h, 'tag', 'Cal_Res2a'), 'string', [num2str(h.UserData.Cal.MC_Fits.area.mu, '%0.2f'), ' ', char(177), ' ', num2str(100 * (h.UserData.Cal.MC_Fits.area.icdf(normcdf(2)) / h.UserData.Cal.MC_Fits.area.mu - 1), '%0.2f'), '%'])
set(findobj(h, 'tag', 'Cal_Res2b'), 'string', ['~N(', num2str(round(h.UserData.Cal.MC_Fits.area.mu), '%u'),', ', num2str(h.UserData.Cal.MC_Fits.area.sigma, '%0.1f'),')'])
set(findobj(allchild(h), 'tag', 'Dat_Cal_Mu'), 'string', num2str(h.UserData.Cal.MC_Fits.mass.mu, '%.2f'))
set(findobj(allchild(h), 'tag', 'Dat_Cal_Sg'), 'string', num2str(h.UserData.Cal.MC_Fits.mass.sigma, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Cal_Nu'), 'string', num2str(h.UserData.Cal.MC_Fits.mass.nu, '%.3f'))

% Update calibration date
[~, tim] = xlsread(xlsfile, 'Calibration', 'A1');
cal_date = tim{1}(regexp(tim{1}, '\d\d\d\d-\D\D\D-\d\d') : end);
if (now - datenum(cal_date, 'yyyy-mmm-dd')) > 30
    clr = 'r';
    
    % Warn if initiation file is old!
    [~, file] = fileparts(xlsfile);
    if strcmp(file, 'Cal_init')
        msg = 'Warning! Default calibration data is from >30 days ago - re-calibration is suggested.';
        uiwait(msgbox(msg, 'warning', 'warn', 'modal'))
    end
else
    clr = 'k';
end
set(findobj(allchild(h), 'tag', 'Cal_Latest'), 'string', cal_date, 'color', clr)

% Clear axes
axes(findobj(allchild(h), 'tag', 'Cal_Ax_Fit'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')
axes(findobj(allchild(h), 'tag', 'Cal_Ax_Unc'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')
end

function Callback_CalibrationDefault(~, ~, h)
% This callback saves the existing calibration data and results to be
% initialized when loaded in future

% Check that the user does want to overwrite default calibration
quest = 'Are you sure you would like to overwrite the default calibration data / results?';
tit = 'Overwrite "Cal_init"?';
slc = questdlg(quest, tit, 'Yes, continue', 'No, STOP!', 'No, STOP!');
if strcmp(slc, 'No, STOP!')
    return
end

% Save as default file
savefile = fullfile(h.UserData.folder_base, 'Cal_init.xlsx');
Callback_CalibrationExport([], [], h, savefile)
end

function Callback_CalibrationExport(~, ~, h, xlsfile)
% This callback exports input data and results to an .xlsx file in addition
% to a .png image of the axes in section 3

% Set add sheet warning to off
warning('off', 'MATLAB:xlswrite:AddSheet')

% Get user's input on the date
quest = 'Use today as the calibration date?';
tit = 'Calibration date"';
slc = questdlg(quest, tit, 'Yes', 'No', 'No');
switch slc
    case 'Yes'
        cal_date = datestr(now, 'yyyy-mmm-dd');
    case 'No'
        % Get current date
        curr = datevec(now);
        y = num2str(curr(1), '%04u');
        m = num2str(curr(2), '%02u');
        d = num2str(curr(3), '%02u');
        
        % Allow user to change
        quest = {'Enter year (yyyy)', 'Enter month (mm)', 'Enter day (dd)'};
        inp = inputdlg(quest, tit, [1 25; 1 25; 1 25], {y; m; d});
        
        % Validate inputs are numerical
        if ~all([all(ismember(inp{1}, '0123456789')), all(ismember(inp{2}, '0123456789')), all(ismember(inp{3}, '0123456789'))])
            uiwait(msgbox('Date inputs must be numerical!', 'Error', 'Error', 'Modal'))
            return
        end
        
        % Validate inputs are proper length
        if datenum(str2double(inp)') > now
            uiwait(msgbox('Calibration data cannot be in the future!', 'Error', 'Error', 'Modal'))
            return
        end
        
        % Parse inputs
        cal_date = datestr(datenum(str2double(inp)'), 'yyyy-mmm-dd');
end

% Get file location
if isempty(xlsfile)
    defname = fullfile(h.UserData.folder_load, 'OCEC_Calibration.xlsx');
    [file, fold] = uiputfile('*.xlsx', 'Select / create export file', defname);
    h.UserData.folder_load = fold;
    xlsfile = fullfile(fold, file);
    create_image = 1;
else
    create_image = 0;
end

% Copy template
loadfile = [h.UserData.folder_base, filesep, 'support\OCECgo_CalExportTemplate.xlsx'];
copyfile(loadfile, xlsfile, 'f')

% Input header
str  = {['Calibration data from: ', cal_date]};
xlswrite(xlsfile, str, 'Calibration', 'A1')

% Input number of data
xlswrite(xlsfile, size(h.UserData.Cal.Table, 1), 'Calibration', 'C3')

% Input calibration data
xlswrite(xlsfile, h.UserData.Cal.Table', 'Calibration', 'D5')

% Input sucrose / water data
dat = cat(1, h.UserData.Cal.Suc_Ms, h.UserData.Cal.Suc_Mw, h.UserData.Cal.Suc_Scale, ...
    h.UserData.Cal.Suc_Pure, h.UserData.Cal.Suc_T1, h.UserData.Cal.Suc_T2);
xlswrite(xlsfile, dat, 'Calibration', 'C11')

% Input pipette uncertainties
dat = [h.UserData.Cal.Pip_b05(1), h.UserData.Cal.Pip_p05(1), h.UserData.Cal.Pip_p05(2), h.UserData.Cal.Pip_b05(2); ...
    h.UserData.Cal.Pip_b10(1), h.UserData.Cal.Pip_p10(1), h.UserData.Cal.Pip_p10(2), h.UserData.Cal.Pip_b10(2)];
xlswrite(xlsfile, dat, 'Calibration', 'F12')

% Input # of MC draws
xlswrite(xlsfile, h.UserData.Cal.MC_nd, 'Calibration', 'F15')

% Input calibration results
dat = [h.UserData.Cal.MC_Fits.mass.mu, h.UserData.Cal.MC_Fits.mass.sigma, h.UserData.Cal.MC_Fits.mass.nu];
xlswrite(xlsfile, dat, 'Calibration', 'L12')
dat = [h.UserData.Cal.MC_Fits.area.mu, h.UserData.Cal.MC_Fits.area.sigma];
xlswrite(xlsfile, dat, 'Calibration', 'L13')

% Create figure and save
if create_image
    fg = figure();
    set(fg, 'color', 'w', 'units', 'pixels', 'position', [50 50 730 295], 'visible', 'off')
    copyobj(findobj(allchild(h), 'tag', 'Cal_Ax_Fit'), fg)
    copyobj(findobj(allchild(h), 'tag', 'Cal_Ax_Unc'), fg)
    [~, name] = fileparts(xlsfile);
    picfile = fullfile(fold, [name, '.png']);
    print(fg, picfile, '-dpng', '-r600')
    close(fg)
end

% Update calibration dateon GUI
if (now - datenum(cal_date, 'yyyy-mmm-dd')) > 30
    clr = 'r';
else
    clr = 'k';
end
set(findobj(allchild(h), 'tag', 'Cal_Latest'), 'string', cal_date, 'color', clr)

end