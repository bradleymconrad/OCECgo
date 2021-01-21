function OCECgo_Tab_AnalysisInput(h)
% This function creates the fields within the data analysis - inputs tab.

% Get parent
pnt1 = findobj(h, 'tag', 'Tab_DatIn');

%% CREATE FILE SELECTION

% Create panel
str = '1) Select Data';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [5 350 320 285], 'Title', str, 'FontSize', 15);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 320 285], 'XLim', [0 320], 'YLim', [0 285], 'Visible', 'off')

% Create text file selection
str = 'a) Select .txt data file:';
text(gca, 10, 245, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [175 231 80 25], 'String', 'Browse...', 'FontSize', 10, 'callback', {@Callback_LoadTextData h []})
uicontrol(pnt2, 'Style', 'text', 'Position', [10 200 300 20], 'string', '.txt data file not selected', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Dat_TxtFile', 'horizontalalignment', 'center', 'Enable', 'on')

% Create tag selection
str = 'b) Select analysis tag (Sample ID):';
text(gca, 10, 185, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
uicontrol(pnt2, 'Style', 'popupmenu', 'Position', [10 150 300 15], 'string', {''}, 'tag', 'Dat_TagOpts', 'Callback', {@Callback_GetTagInfo h})

% Create metadata section
str = 'c) Review analysis metadata:';
text(gca, 10, 125, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
text(gca, 160, 95.00, 'Sample Start:', 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 160, 71.66, ['Calibration Mass [', char(181),'g]:'], 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 160, 48.33, 'Transit Time [s]:', 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 160, 25.00, 'Punch Area [cm^2]:', 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
uicontrol(pnt2, 'style', 'text', 'position', [165 82.00 140 20], 'string', '', 'fontsize', 10, 'horizontalalignment', 'left', 'tag', 'Dat_Info_Time', 'tooltip', 'Analysis metadata: Start time of OCEC sample.')
uicontrol(pnt2, 'style', 'text', 'position', [165 58.66 140 20], 'string', '', 'fontsize', 10, 'horizontalalignment', 'left', 'tag', 'Dat_Info_Cal', 'tooltip', 'Analysis metadata: Calibration mass at time of sample.')
uicontrol(pnt2, 'style', 'text', 'position', [165 35.33 140 20], 'string', '', 'fontsize', 10, 'horizontalalignment', 'left', 'tag', 'Dat_Info_Tran', 'tooltip', 'Analysis metadata: Transit time through instrument.')
uicontrol(pnt2, 'style', 'text', 'position', [165 10.00 140 20], 'string', '', 'fontsize', 10, 'horizontalalignment', 'left', 'tag', 'Dat_Info_Punch', 'tooltip', 'Analysis metadata: Quartz filter punch area.')

%% CREATE PROCESSING OPTIONS

% Create panel
str = '2) Processing Options';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [340 350 320 285], 'Title', str, 'FontSize', 15);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 320 285], 'XLim', [0 320], 'YLim', [0 285], 'Visible', 'off')

% Create laser correction selection
str = 'a) Laser temperature correction:';
text(gca, 10, 245, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
bg = uibuttongroup(pnt2, 'Units', 'pixels', 'Position', [10 200 300 25], 'BorderType', 'beveledin', 'tag', 'Dat_Laser', 'SelectionChangedFcn', {@Callback_ClearPlotsDisableAnalysis, h});
tip{1} = '<html><b>Quadratic correction: (recommended)</b> Incident laser power is modelled as<br />a second-order polynomial function of oven temperature.</html>';
tip{2} = '<html><b>Linear correction:</b> Incident laser power is modelled as<br />a linear function of oven temperature.</html>';
uicontrol(bg, 'Style', 'radiobutton', 'String', 'Quadratic correction', 'Position', [005 0 140 25], 'FontSize', 10, 'tooltip', tip{1})
uicontrol(bg, 'Style', 'radiobutton', 'String', 'Linear correction', 'Position', [175 0 130 25], 'FontSize', 10, 'tooltip', tip{2})

% Create NDIR drift correction
str = 'b) NDIR correction:';
text(gca, 10, 180, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
bg = uibuttongroup(pnt2, 'Units', 'pixels', 'Position', [10 140 300 25], 'BorderType', 'beveledin', 'tag', 'Dat_NDIR', 'SelectionChangedFcn', {@Callback_ClearPlotsDisableAnalysis, h});
tip{1} = '<html><b>Convex hull: (recommended)</b> A convex hull is fit as a lower bound<br />of the NDIR signal, to estimate NDIR drift.<br /><i>Refer to the online documentation for further details</i>.</html>';
tip{2} = '<html><b>From results file:</b> Instrument-reported NDIR areas are<br /> used to derive a linear estimation of NDIR drift.<br /><i>Refer to the online documentation for further details</i>.</html>';
uicontrol(bg, 'Style', 'radiobutton', 'String', 'Convex hull', 'Position', [025 0 095 25], 'FontSize', 10, 'tooltip', tip{1})
uicontrol(bg, 'Style', 'radiobutton', 'String', 'From results file', 'Position', [150 0 120 25], 'FontSize', 10, 'tooltip', tip{2})

% Create reported areas
text(gca, 080, 125, 'Total area:', 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 260, 125, 'Calibration area:', 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
tip{1} = '<html><b>Total area:</b> Integrated NDIR signal during the OCEC analysis.</html>';
tip{2} = '<html><b>Calibration area:</b> Integrated NDIR signal during the CH<sub>4</sub>-loop.</html>';
uicontrol(pnt2, 'Style', 'text', 'Position', [085 110 060 20], 'String', ' 454651', 'fontangle', 'italic', 'horizontalalignment', 'left', 'tag', 'Dat_TA', 'tooltip', tip{1})
uicontrol(pnt2, 'Style', 'text', 'Position', [265 110 060 20], 'String', ' 12345', 'fontangle', 'italic', 'horizontalalignment', 'left', 'tag', 'Dat_CA', 'tooltip', tip{2})

% Create calibration data
str = 'c) Calibration t-dist. and repeatability:';
text(gca, 10, 100, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
text(gca, 049, 080, [char(181), ' [', char(181),'g]'], 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 123, 080, [char(963), ' [', char(181),'g]'], 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 197, 080, [char(957), ' (dof) [-]'], 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
text(gca, 271, 080, 'Rep. [%]', 'FontSize', 10, 'HorizontalAlignment', 'center', 'verticalalignment', 'middle');
tip{1} = ['<html>Location (', char(181), ') of the generalized t-distribution<br />representing the calibrated carbon mass.</html>'];
tip{2} = ['<html>Scale (', char(963), ') of the generalized t-distribution<br />representing the calibrated carbon mass.</html>'];
tip{3} = ['<html>Degrees of freedom (', char(957), ') of the generalized t-distribution<br />representing the calibrated carbon mass.</html>'];
tip{4} = ['<html>2', char(963), ' repeatability of the OCEC instrument calibration<br /><i>Estimated to be ', char(8776), '7.90%</i>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [024 40 50 25], 'String', 'NaN', 'FontSize', 8, 'HorizontalAlignment', 'center', 'tag', 'Dat_Cal_Mu', 'tooltip', tip{1}, 'Callback', {@Callback_ClearPlotsDisableAnalysis, h})
uicontrol(pnt2, 'Style', 'edit', 'Position', [098 40 50 25], 'String', 'NaN', 'FontSize', 8, 'HorizontalAlignment', 'center', 'tag', 'Dat_Cal_Sg', 'tooltip', tip{2}, 'Callback', {@Callback_ClearPlotsDisableAnalysis, h})
uicontrol(pnt2, 'Style', 'edit', 'Position', [172 40 50 25], 'String', 'NaN', 'FontSize', 8, 'HorizontalAlignment', 'center', 'tag', 'Dat_Cal_Nu', 'tooltip', tip{3}, 'Callback', {@Callback_ClearPlotsDisableAnalysis, h})
uicontrol(pnt2, 'Style', 'edit', 'Position', [246 40 50 25], 'String', '7.90', 'FontSize', 8, 'HorizontalAlignment', 'center', 'tag', 'Dat_Cal_Rep', 'tooltip', tip{4}, 'Callback', {@Callback_ClearPlotsDisableAnalysis, h})

str = 'd) Update plots:';
text(gca, 10, 020, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
go_arrow = imread([h.UserData.folder_base, filesep, 'support\OCECgo_Images_GoArrow.png']);
go_arrow = go_arrow(3:end-2, :, :);
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [140 008 130 24], 'cdata', go_arrow, 'BackgroundColor', 'w', 'tag', 'Dat_Plot', 'Callback', {@Callback_PlotData h}, 'enable', 'off');

%% CREATE SPLIT POINT SELECTION

% Create panel
str = '3) Split Point Determination';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [675 350 400 285], 'Title', str, 'FontSize', 15);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 400 285], 'XLim', [0 400], 'ylim', [0 285], 'Visible', 'off')

% Create split point procedure selection
str = 'a) Split point procedure:';
text(gca, 10, 245, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
bg = uibuttongroup(pnt2, 'Units', 'pixels', 'Position', [05 200 385 25], 'BorderType', 'beveledin','SelectionChangedFcn', {@Callback_SplitMethod h}, 'tag', 'Dat_Split_Proc');
tip{1} = ['<html><b>Attenudation decline: (recommended)</b> Uses the TOT method to calculated the split point.<br />', ...
    'Split point uncertainty (2', char(963), ') is estimated as the difference between evolved carbon mass at<br />', ...
    'the nominal split and evolved carbon mass at a subsequent point where laser attenuation<br />', ...
    'has decreased beyond some critical quantity, prescribed as a fraction of the initial attenuation<br />', ...
    'in the <b>decline in attenuation</b> field.  The recommended <b>decline in attenuation</b> value is estimated<br />', ...
    'based on uncertainty in laser attenuation relative to its initial value, expanded by a factor two to<br />', ...
    'account for assumptions in the optical properties of the sample.</html>'];
tip{2} = ['<html><b>Manual selection:</b> The user manually defines<br />the split point and its 2', char(963), ' uncertainty.</html>'];
tip{3} = '<html><b>Sunset labs:</b> Uses the TOT method to estimate the split point.<br />Split point uncertainty is not considered.</html>';
uicontrol(bg, 'Style', 'radiobutton', 'String', 'Attenuation decline', 'Position', [05 0 130 25], 'FontSize', 10, 'tooltip', tip{1}, 'enable', 'off')
uicontrol(bg, 'Style', 'radiobutton', 'String', 'Manual selection', 'Position', [145 0 125 25], 'FontSize', 10, 'tooltip', tip{2}, 'enable', 'off')
uicontrol(bg, 'Style', 'radiobutton', 'String', 'Manufacturer', 'Position', [280 0 100 25], 'FontSize', 10, 'tooltip', tip{3}, 'enable', 'off')

% Create split data selection
str = 'b) Split Point Calculation procedure:';
text(gca, 10, 175, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');

% Create split controls
text(gca, 205, 145, ['Split mean [', char(181),'g]:'], 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 205, 110, ['Split unc. [', char(181),'g]:'], 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 205, 075, 'Initial attenuation [-]:', 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
text(gca, 205, 040, 'Decline in attenuation [%]:', 'FontSize', 10, 'HorizontalAlignment', 'right', 'verticalalignment', 'middle');
tip{1} = ['Nominal average split point in ', char(181), 'g.'];
tip{2} = ['Split point uncertainty (2', char(963), ') in ', char(181), 'g.'];
tip{3} = 'Initial laser attenuation for use in the TOT method.';
tip{4} = '<html>Critical decline in attenuation for estimation of split<br />point uncertainty in percent of initial attenuation.</html>';
uicontrol(pnt2, 'Style', 'edit', 'Position', [215 127.5 65 30], 'String', 'NaN', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Dat_Split_ctr', 'enable', 'off', 'Callback', {@Callback_BumpValues h 9}, 'tooltip', tip{1})
uicontrol(pnt2, 'Style', 'edit', 'Position', [215 092.5 65 30], 'String', 'NaN', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Dat_Split_wid', 'enable', 'off', 'Callback', {@Callback_BumpValues h 10}, 'tooltip', tip{2})
uicontrol(pnt2, 'Style', 'edit', 'Position', [215 057.5 65 30], 'String', 'NaN', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Dat_Split_Ao', 'enable', 'off', 'Callback', {@Callback_BumpValues h 11}, 'tooltip', tip{3})
uicontrol(pnt2, 'Style', 'edit', 'Position', [215 022.5 65 30], 'String', 'NaN', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Dat_Split_dA', 'enable', 'off', 'Callback', {@Callback_BumpValues h 12}, 'tooltip', tip{4})
tip{1} = ['Increase split mean by 0.01 ', char(181), 'g.'];
tip{2} = ['Decrease split mean by 0.01 ', char(181), 'g.'];
tip{3} = ['Increase split uncertainty (2', char(963), ') by 0.01 ', char(181), 'g.'];
tip{4} = ['Decrease split uncertainty (2', char(963), ') by 0.01 ', char(181), 'g.'];
tip{5} = 'Increase initial attenuation by 0.005.';
tip{6} = 'Decrease initial attenuation by 0.005.';
tip{7} = 'Increase critical decline in attenuation by 0.1%.';
tip{8} = 'Decrease critical decline in attenuation by 0.1%.';
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 142.5 15 15], 'String', '+', 'tag', 'Dat_Split_c+', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 1}, 'tooltip', tip{1})
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 127.5 15 15], 'String', '-', 'tag', 'Dat_Split_c-', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 2}, 'tooltip', tip{2})
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 107.5 15 15], 'String', '+', 'tag', 'Dat_Split_w+', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 3}, 'tooltip', tip{3})
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 092.0 15 15], 'String', '-', 'tag', 'Dat_Split_w-', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 4}, 'tooltip', tip{4})
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 072.5 15 15], 'String', '+', 'tag', 'Dat_Split_a+', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 5}, 'tooltip', tip{5})
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 057.0 15 15], 'String', '-', 'tag', 'Dat_Split_a-', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 6}, 'tooltip', tip{6})
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 037.5 15 15], 'String', '+', 'tag', 'Dat_Split_d+', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 7}, 'tooltip', tip{7})
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [285 022.0 15 15], 'String', '-', 'tag', 'Dat_Split_d-', 'FontSize', 8, 'enable', 'off', 'Callback', {@Callback_BumpValues h 8}, 'tooltip', tip{8})
str = 'Recommended attenuation decline will be calculated upon plotting';
uicontrol(pnt2, 'Style', 'text', 'position', [5 0 390 20], 'string', str, 'fontsize', 8, 'horizontalalignment', 'center', 'tag', 'Dat_Split_Sugg')

%% CREATE DATA VISUALIZATION

% Create panel
str = '4) Data Visualization';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [5 5 945 340], 'Title', str, 'FontSize', 15);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 945 340], 'XLim', [0 945], 'ylim', [0 340], 'Visible', 'off')
hold on

% Create thermogram axis
ax = axes(pnt2, 'Units', 'pixels', 'Position', [30 55 375 230], 'xlim', [0 800], 'xtick', 0:100:800, 'FontSize', 10, 'tickdir', 'out', 'Tag', 'Dat_Ax_Therm', 'Box', 'on', 'CLim', [0 9]);
set(ax.Title, 'string', 'Thermogram', 'fontsize', 14, 'fontweight', 'bold')
set(ax.XLabel, 'string', 'Time [s]', 'fontsize', 12)
set(ax.YLabel, 'string', 'Front Oven Temperature [100\circC]', 'fontsize', 12)
set(ax, 'ylim', [0 10], 'ytick', 0:2:10, 'yaxislocation', 'right')
text(ax, 'units', 'normalized', 'string', 'Laser / NDIR [a.u.] (Linear)', 'position', [-0.05 0.5 0], 'fontsize', 12, 'rotation', 90)

% Create thermogram Legend
str = {'Laser', 'NDIR', 'Set Temp.', 'Act. Temp.'};
axes(pnt2, 'Units', 'pixels', 'Position', [33 222 80 60], 'Tag', 'Dat_Ax_Therm_Leg', 'Box', 'on')
hold(gca, 'on')
plot(gca, [0.05 0.20], 0.8 * [1 1], 'Color', [0.5 0.5 0.0], 'LineStyle', '-', 'LineWidth', 1);
plot(gca, [0.05 0.20], 0.6 * [1 1], 'Color', [0.5 0.0 0.0], 'LineStyle', '-', 'LineWidth', 1);
plot(gca, [0.05 0.20], 0.4 * [1 1], 'Color', [0.0 0.0 0.5], 'LineStyle', '-', 'LineWidth', 1);
plot(gca, [0.05 0.20], 0.2 * [1 1], 'Color', [0.0 0.5 0.0], 'LineStyle', '-', 'LineWidth', 1);
text(gca, 0.25, 0.8, str{1}, 'FontSize', 8, 'horizontalalignment', 'left')
text(gca, 0.25, 0.6, str{2}, 'FontSize', 8, 'horizontalalignment', 'left')
text(gca, 0.25, 0.4, str{3}, 'FontSize', 8, 'horizontalalignment', 'left')
text(gca, 0.25, 0.2, str{4}, 'FontSize', 8, 'horizontalalignment', 'left')
set(gca, 'xtick', [], 'ytick', [], 'xlim', [0 1], 'ylim', [0.05 0.95])

% Create AVEC axis
ax = axes(pnt2, 'Units', 'pixels', 'Position', [515 55 340 230], 'xlim', [0 10], 'ylim', [0 1.4], 'xtick', 0:10, 'ytick', 0:0.2:1.4, 'FontSize', 10, 'tickdir', 'out', 'Tag', 'Dat_Ax_AVEC', 'Box', 'on', 'CLim', [0 9]);
set(ax.XLabel, 'string', ['Cumulative Evolved Carbon Mass [', char(181),'g]'], 'FontSize', 12)
set(ax.YLabel, 'string', 'Laser Attenuation [-]', 'FontSize', 12)
set(ax.Title, 'string', 'AVEC Plot', 'fontsize', 14, 'fontweight', 'bold')

% Create AVEC legend
str = {'Initial', 'Critical'};
axes(pnt2, 'units', 'pixels', 'position', [518 58 167 20], 'tag', 'Dat_Ax_AVEC_Leg', 'box', 'on')
hold(gca, 'on')
plot(gca, [0.05 0.20], 0.5 * [1 1], 'k', 'linewidth', 1.5)
plot(gca, [0.45 0.60], 0.5 * [1 1], '--r', 'linewidth', 1.5)
text(gca, 0.25, 0.5, str{1}, 'fontsize', 8, 'horizontalalignment', 'left')
text(gca, 0.65, 0.5, str{2}, 'fontsize', 8, 'horizontalalignment', 'left')
set(gca, 'xtick', [], 'ytick', [], 'xlim', [0 0.9], 'ylim', [0.05 0.95])

% Create AVEC colorbar
colormap(winter(256))
cb = colorbar(findobj(allchild(h), 'tag', 'Dat_Ax_AVEC'), 'units', 'pixels', 'position', [870 55 15 230], 'tag', 'Dat_Ax_AVEC_CB');
set(cb, 'Limits', [0 10], 'tickdir', 'both', 'fontsize', 10, 'ticks', 0:2:10)
set(cb.Label, 'String', 'Front Oven Temp. [100\circC]', 'FontSize', 12)

%% CREATE ANALYSIS SECTION

% Create panel
str = '5) Analysis';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [1090 350 160 285], 'Title', str, 'FontSize', 15);
axes(pnt2, 'units', 'pixels', 'position', [0 0 160 285], 'xlim', [0 160], 'ylim', [0 285], 'visible', 'off')

% Create input for instrument precision
str = {'a) Instrument Prec-'; ['    ision (2', char(963), ') [', char(956),'g]:']};
text(gca, 10, 225, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
tip = ['<html>Input the <b>estimated instrument precision in ', char(956), 'g</b>.<br /><i>Default value based on tests by the authors</i>.</html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [010 165 140 35], 'String', '0.031', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Dat_MC_InstPrec', 'tooltip', tip);

% Create Monte Carlo draw selection
str = {'b) Number of Monte'; '    Carlo draws:'};
text(gca, 10, 135, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
tip = ['<html>Input the <b>desired number of Monte Carlo draws</b>.<br /><i>Typical: ', char(8712), ' (10<sup>4</sup>, 10<sup>6</sup>).<br />Permitted: ', char(8712), ' (10<sup>2</sup>, 10<sup>8</sup>).</i></html>'];
uicontrol(pnt2, 'Style', 'edit', 'Position', [010 075 140 35], 'String', '1000000', 'FontSize', 10, 'HorizontalAlignment', 'center', 'tag', 'Dat_MC_nd', 'tooltip', tip);

% Create Go button
str = 'c) Calculate OCEC:';
text(gca, 10, 050, str, 'FontSize', 12, 'HorizontalAlignment', 'left', 'verticalalignment', 'middle');
go_arrow = imread([h.UserData.folder_base, filesep, 'support\OCECgo_Images_GoArrow.png']);
uicontrol(pnt2, 'Style', 'pushbutton', 'Position', [015 008 130 24], 'cdata', go_arrow, 'BackgroundColor', 'w', 'tag', 'Dat_Run', 'Callback', {@Callback_AnalysisRun h}, 'enable', 'off');

%% ADD COPYRIGHT MATERIAL

OCECgo_TabSupport_Copyright(pnt1);

end

function Callback_LoadTextData(~, ~, h, source_file)
% This callback function requests that the user selects a Sunset .txt
% results file and then parses all available data.

% Update the status
set(findobj(allchild(h), 'tag', 'Dat_TxtFile'), 'Tooltip', '', ...
    'string', '.txt data file not selected');

% Allow user to select file (if not defined in function request)
defname = fullfile(h.UserData.folder_load, '*.txt');
if isempty(source_file)
    [file, fold] = uigetfile('*.txt', 'Select data text file', defname);
else % Parse input file
    [fold, file, ext] = fileparts(source_file);
    fold = strcat(fold, filesep);
    file = strcat(file, ext);
end

% Check for good data
if ~file
    uiwait(msgbox('File not selected! Try again.', 'Error', 'error', 'Modal'))
    error('OCECgo:Analyze:FileNotSelected', 'File not selected! Try again.')
else
    h.UserData.folder_load = fold;
end

% Initialized analysis metadata
info.tags = {};
info.tims = {};
info.punch = [];
info.cal = [];
info.tran = [];
info.data = {};

% Open file (ensure it exists)
fID = fopen([fold, file], 'r');
if fID == -1
    uiwait(msgbox('Cannot find file! Try again.', 'Error', 'error', 'Modal'))
    error('OCECgo:Analyze:FileNotExist', 'Cannot find file! Try again.')
end

% Cycle through file
while ~feof(fID)
    temp = fgetl(fID); % Get line of data
    
    % Migrate to and pull tag (Sample ID)
    if strcmp(temp, 'Sample: ')
        temp = fgetl(fID);
        info.tags = cat(1, info.tags, temp);
        continue
    end
    
    % Migrate to and pull sample start time
    if strcmp(temp, 'Started: ')
        temp1 = fgetl(fID);
        temp2 = fgetl(fID);
        info.tims = cat(1, info.tims, [temp1, ' ', temp2]);
        continue
    end
    
    % Migrate to and pull punch area
    if strcmp(temp, 'Deposit Area, sq cm')
        temp = fgetl(fID);
        info.punch = cat(1, info.punch, str2double(temp(1:end-1)));
        continue
    end
    
    % Migrate to and pull calibration constant
    if strcmp(temp, 'Calib Const., ug C')
        temp = fgetl(fID);
        temp = strsplit(temp, ',');
        info.cal = cat(1, info.cal, str2double(temp(1)));
        continue
    end
    
    % Migrate to and pull transit time
    if strcmp(temp, 'Transit Time, sec')
        temp = fgetl(fID);
        info.tran = cat(1, info.tran, str2double(temp));
    end
    
    % Migrate to and pull data
    if strcmp(temp, 'Data Points for Analysis')
        nd = str2double(fgetl(fID)); % Number of data
        fgetl(fID); % Data header
        
        % Initialize data
        raw.mode = cell(nd, 1); % Analysis phase ("He", "Ox", "CH4+Ox")
        raw.Tset = zeros(nd, 1); % Set temperature
        raw.Tact = zeros(nd, 1); % Measured temperature
        raw.Lase = zeros(nd, 1); % Laser power
        raw.NDIR = zeros(nd, 1); % NDIR signal
        
        % Pull data
        for dummy = 1 : nd
            temp = strsplit(fgetl(fID), ',');
            raw.mode{dummy, 1} = temp{5};
            raw.Tset(dummy, 1) = str2double(temp{end});
            raw.Tact(dummy, 1) = str2double(temp{1});
            raw.Lase(dummy, 1) = str2double(temp{2});
            raw.NDIR(dummy, 1) = str2double(temp{8});
        end
        
        % Save into meta data structure
        info.data = cat(1, info.data, raw);
    end
end
fclose(fID); % Close file

% Update userdata and GUI
h.UserData.Dat.TagIndex = 1;
h.UserData.Dat.AnalysisInfo = info;
set(findobj(allchild(h), 'tag', 'Dat_TagOpts'), 'string', info.tags)
set(findobj(allchild(h), 'tag', 'Dat_TagOpts'), 'value', 1)
set(findobj(allchild(h), 'tag', 'Dat_Info_Time'), 'string', info.tims{1})
set(findobj(allchild(h), 'tag', 'Dat_Info_Cal'), 'string', info.cal(1))
set(findobj(allchild(h), 'tag', 'Dat_Info_Tran'), 'string', info.tran(1))
set(findobj(allchild(h), 'tag', 'Dat_Info_Punch'), 'string', info.punch(1))
Callback_GetTagInfo([], [], h);

% Clear plots and disable analysis
Callback_ClearPlotsDisableAnalysis([], [], h)

% Enable plotting
set(findobj(allchild(h), 'tag', 'Dat_Plot'), 'enable', 'on')

% Update the status
set(findobj(allchild(h), 'tag', 'Dat_TxtFile'), 'Tooltip', [fold, file], 'string', 'File selected and loaded - Hover to review');
end

function Callback_GetTagInfo(~, ~, h)
% This callback function updates the selected "Sample ID" / tag and
% prepares the axes for subsequent plotting.

% Pull existing analysis info
info = h.UserData.Dat.AnalysisInfo;

% Get index
idx = get(findobj(allchild(h), 'tag', 'Dat_TagOpts'), 'value');
h.UserData.Dat.TagIndex = idx;

% Clear plots and disable analysis
Callback_ClearPlotsDisableAnalysis([], [], h)

% Update analysis metadata
set(findobj(allchild(h), 'tag', 'Dat_Info_Time'), 'string', info.tims{idx})
set(findobj(allchild(h), 'tag', 'Dat_Info_Cal'), 'string', info.cal(idx))
set(findobj(allchild(h), 'tag', 'Dat_Info_Tran'), 'string', info.tran(idx))
set(findobj(allchild(h), 'tag', 'Dat_Info_Punch'), 'string', info.punch(idx))

% Reset NDIR areas
set(findobj(allchild(h), 'tag', 'Dat_CA'), 'string', '- - -')
set(findobj(allchild(h), 'tag', 'Dat_TA'), 'string', '- - -')

% Reset split point method to attenuation decline
set(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'SelectedObject', findobj(allchild(h), 'string', 'Attenuation decline'))
% Callback_SplitMethod([], [], h);

% Update suggested attenuation decline text
str = 'Recommended attenuation decline will be calculated upon plotting';
set(findobj(allchild(h), 'tag', 'Dat_Split_Sugg'), 'string', str)
end

function Callback_SplitMethod(~, ~, h)
% This callback function updates the current selection of the split point
% calculation procedure, and enables/disables other inputs accordingly. No
% values are changed.

% Get new selection and update AVEC plot
switch get(get(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject'), 'string')
    case 'Attenuation decline'
        selected = [zeros(6, 1); ones(6, 1)];
        tip = 'Initial laser attenuation for use in the TOT method';
        set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'foregroundcolor', 'k', 'tooltip', tip)
        
        % Update AVEC plot
        Callback_BumpValues([], [], h, 11)
        
    case 'Manufacturer'
        selected = zeros(12, 1);
        
        % Update AVEC plot
        tempdat = Sub_Sunset_TOT(h.UserData.Dat);
        AA = findobj(allchild(h), 'tag', 'split_Ao');
        AA.YData = tempdat.Split_Att * [1 1];
        DD = findobj(allchild(h), 'tag', 'split_dA');
        DD.YData = tempdat.Split_Att * [1 1];
        FF = findobj(allchild(h), 'tag', 'split_fill');
        FF.XData = tempdat.Split_Ctr * [1 1 1 1];
        uistack(findobj(allchild(h), 'tag', 'Dat_Ax_AVEC_Leg'), 'top')
        
    case 'Manual selection'
        selected = [ones(9, 1); zeros(3, 1)];
        tip = '<html>For the <b>manual selection</b> technique, initial attenuation<br />is only used to support manual estimation of split point.</html>';
        set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'foregroundcolor', 'r', 'tooltip', tip)
        
        % Update AVEC plot
        Callback_BumpValues([], [], h, 9)
end
selected = selected + 1;

% Get new status
temp = {'off', 'on'};

% Update data
set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'enable', temp{selected(1)})
set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'enable', temp{selected(2)})
set(findobj(allchild(h), 'tag', 'Dat_Split_c+'), 'enable', temp{selected(3)})
set(findobj(allchild(h), 'tag', 'Dat_Split_c-'), 'enable', temp{selected(4)})
set(findobj(allchild(h), 'tag', 'Dat_Split_w+'), 'enable', temp{selected(5)})
set(findobj(allchild(h), 'tag', 'Dat_Split_w-'), 'enable', temp{selected(6)})
set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'enable', temp{selected(7)})
set(findobj(allchild(h), 'tag', 'Dat_Split_a+'), 'enable', temp{selected(8)})
set(findobj(allchild(h), 'tag', 'Dat_Split_a-'), 'enable', temp{selected(9)})
set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'enable', temp{selected(10)})
set(findobj(allchild(h), 'tag', 'Dat_Split_d+'), 'enable', temp{selected(11)})
set(findobj(allchild(h), 'tag', 'Dat_Split_d-'), 'enable', temp{selected(12)})
end

function Callback_BumpValues(~, ~, h, id)
% This callback function increments and validates split point data, and
% also updates the AVEC plot when appropriate.

% Backup data
userdata_backup = h.UserData.Dat;

% Make appropriate edit on button push
switch id
    case 1 % Increase split
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string')) + 0.01;
        set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(new, '%.3f'))
    case 2 % Decrease split
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string')) - 0.01;
        set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(new, '%.3f'))
    case 3 % Increase split uncertainty
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string')) + 0.01;
        set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(new, '%.3f'))
    case 4 % Decrease split uncertainty
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string')) - 0.01;
        set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(new, '%.3f'))
    case 5 % Increase initial attenuation
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string')) + 0.005;
        set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', num2str(new, '%.3f'))
    case 6 % Decrease initial attenuation
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string')) - 0.005;
        set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', num2str(new, '%.3f'))
    case 7 % Increase critical attenuation decline
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string')) + 0.1;
        set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', num2str(new, '%.3f'))
    case 8 % Decrease critical attenuation decline
        new = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string')) - 0.1;
        set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', num2str(new, '%.3f'))
    case 9 % Update split
        set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string')), '%.3f'))
    case 10 % Update split uncertainty
        set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string')), '%.3f'))
    case 11 % Update initial attenuation
        set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', num2str(str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string')), '%.3f'))
    case 12 % Update decline of attenuation
        set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', num2str(str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string')), '%.3f'))
end

% Correct obvious bounds
if str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string')) < 0
    set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', '0')
end
if str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string')) < 0
    set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', '0')
end
if str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string')) < 0
    set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', '0')
end
if str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string')) < 0
    set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', '0')
end

% Depending on technique, revise other fields
switch get(get(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject'), 'string')
    case 'Attenuation decline'
        % Correct for large decline
        if str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string')) > 25
            set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', '25.000')
        end
        
        % Create data field
        tempdat = h.UserData.Dat;
        tempdat.Split_Att = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string'));
        tempdat.Split_Del = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string'));
        
        % Get split mean and unc
        tempdat = Sub_Attenuation_Decline(tempdat);
        
        % Ensure validity of new masses
        if (tempdat.Split_Ctr + tempdat.Split_Wid) > h.UserData.Dat.AnalysisInfo.data{h.UserData.Dat.TagIndex}.AVEC(end, 1)
            flag = 1;
        else
            flag = 0;
        end
        
    case 'Manual selection'
        % Correct for large total
        if (str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string')) + str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string'))) > h.UserData.Dat.AnalysisInfo.data{h.UserData.Dat.TagIndex}.AVEC(end, 1)
            switch id
                case [1, 2, 9]
                    new = h.UserData.Dat.AnalysisInfo.data{h.UserData.Dat.TagIndex}.AVEC(end, 1) - str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string'));
                    set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(new, '%.3f'))
                case [3, 4, 10]
                    new = h.UserData.Dat.AnalysisInfo.data{h.UserData.Dat.TagIndex}.AVEC(end, 1) - str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string'));
                    set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(new, '%.3f'))
            end
        end
        
        % Create data field
        tempdat = h.UserData.Dat;
        tempdat.Split_Ctr = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string'));
        tempdat.Split_Wid = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string'));
        tempdat.Split_Att = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string'));
        
        % Get initial and decline
        % tempdat = Sub_Manual_Selection(tempdat);
        
        % Ensure validity of attenuation data
        if tempdat.Split_Del > 25
            flag = 1;
        else
            flag = 0;
        end        
end

% Backup and return if bad change
if flag
    set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(userdata_backup.Split_Ctr, '%.3f'))
    set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(userdata_backup.Split_Wid, '%.3f'))
    set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', num2str(userdata_backup.Split_Att, '%.3f'))
    set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', num2str(userdata_backup.Split_Del, '%.3f'))
    return
end

% Otherwise, update strings!
set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(tempdat.Split_Ctr, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(tempdat.Split_Wid, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', num2str(tempdat.Split_Att, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', num2str(tempdat.Split_Del, '%.3f'))

% Get axis
axes(findobj(allchild(h), 'tag' ,'Dat_Ax_AVEC'))

% Update figure - Initial attenuation
AA = findobj(allchild(h), 'tag', 'split_Ao');
AA.YData = tempdat.Split_Att * [1 1];

% Update figure - Attenuation decline
DD = findobj(allchild(h), 'tag', 'split_dA');
DD.YData = tempdat.Split_Att * (1 - tempdat.Split_Del / 100) * [1 1];

% Update figure - split uncertainty

% Update split uncertainty
FF = findobj(allchild(h), 'tag', 'split_fill');
FF.XData = tempdat.Split_Ctr + tempdat.Split_Wid * [1 1 -1 -1];

% Update stacking
uistack(findobj(allchild(h), 'tag', 'Dat_Ax_AVEC_Leg'), 'top')

% Update userdata
fn = fieldnames(tempdat);
for i = 1 : length(fn)
    h.UserData.Dat.(fn{i}) = tempdat.(fn{i});
end

end

function Callback_PlotData(~, ~, h)
% This callback function plots the thermogram and AVEC plot of the selected
% "Sample ID" / tag.

%% GET AND VALIDATE DATA

OCECgo_Validate_Analysis(h);
Dat = h.UserData.Dat;

% Clear plots and disable analysis
Callback_ClearPlotsDisableAnalysis([], [], h)

% Set default split procedure and enable inputs
set(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject', findobj(allchild(h), 'string', 'Attenuation decline'))
set(allchild(findobj(allchild(h), 'tag' ,'Dat_Split_Proc')), 'enable', 'on')
set(findobj(allchild(h), 'tag' ,'Dat_Split_a+'), 'enable', 'on')
set(findobj(allchild(h), 'tag' ,'Dat_Split_a-'), 'enable', 'on')
set(findobj(allchild(h), 'tag' ,'Dat_Split_d+'), 'enable', 'on')
set(findobj(allchild(h), 'tag' ,'Dat_Split_d-'), 'enable', 'on')
set(findobj(allchild(h), 'tag' ,'Dat_Split_Ao'), 'string', 'NaN', 'enable', 'on')
set(findobj(allchild(h), 'tag' ,'Dat_Split_dA'), 'string', 'NaN', 'enable', 'on')

%% CORRECT DATA AS REQUIRED
% NDIR Correction ---------------------------------------------------------
switch get(get(findobj(allchild(h), 'tag', 'Dat_NDIR'), 'selectedobject'), 'string')
    case 'Convex hull'
        % If convex hull method is selected, solve for measured areas
        % Pull NDIR signal
        yy = Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR(:);
        
        % Get lower convex hull during analysis ---------------------------
        
        % Perform Savitzky-Golay filter over a 5 second window
        wdw = 5;
        sm = sgolayfilt(yy, 2, wdw);
        
        % Pull analysis and calibration sections (sm1 and sm2)
        crop = find(strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'Ox'), 1, 'last');
        sm1 = sm(1 : crop + 12);
        sm2 = yy(crop : end);
        
        % Get lower convex hull of analysis section
        idx = 1;
        while idx(end) < length(sm1)
            cand = (idx(end) + 1 : length(sm1))';
            slop = (sm1(cand) - sm1(idx(end))) ./ (cand - idx(end));
            [~, del] = min(slop);
            idx = cat(1, idx, idx(end) + del);
        end
        base1 = zeros(size(sm)) + nan;
        base1(1 : crop + 12) = interp1(idx, sm1(idx), (1:length(sm1))', 'pchip', nan);
        
        % Correct for pre-analysis drift
        idx = find(Dat.AnalysisInfo.data{Dat.TagIndex}.Tset > 1, 1, 'first') - 1;
        base1(1 : idx) = sm1(1 : idx);
        
        % Get lower convex hull of calibration section
        idx = 1;
        while idx(end) < length(sm2)
            cand = (idx(end) + 1 : length(sm2))';
            slop = (sm2(cand) - sm2(idx(end))) ./ (cand - idx(end));
            [~, del] = min(slop);
            idx = cat(1, idx, idx(end) + del);
        end
        base2 = zeros(size(sm)) + nan;
        base2(crop : end) = interp1(idx, sm2(idx), (1:length(sm2))', 'pchip', nan);
        
        % Merge lower convex hulls
        base = nanmean([base1 base2], 2);
        ww = linspace(0, 1, 13)';
        base(crop : crop + 12) = base1(crop : crop + 12) .* (1 - ww) + ww .* base2(crop : crop + 12);
        
        % Correct NDIR
        NDIR_Corrected = yy - base;
        NDIR_Corrected = NDIR_Corrected - mean(NDIR_Corrected(find(strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'), 14, 'first')));
        Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR_Corrected = NDIR_Corrected;
        
        % Get and set total and calibration area
        idx1 = find(~strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'), 1, 'last');
        Dat.MeasuredTA = round(trapz(NDIR_Corrected(1 : idx1)));
        Dat.MeasuredCA = round(trapz(NDIR_Corrected(idx1 : end)));
        
    case 'From results file'
        % Allow user to select file
        defname = fullfile(h.UserData.folder_load, '*.xlsx');
        [file, fold] = uigetfile('*.txt', 'Select data text file', defname);
        h.UserData.folder_load = fold;
        xlsfile = fullfile(fold, file);
        
        % Load data
        [~, ~, raw] = xlsread(xlsfile); % Reads the first sheet in the notebook
        
        % Parse data table
        [i, j] = find(strcmp(raw, 'Start Date/Time'));
        if isempty(i)
            uiwait(msgbox('Cannot find data in results file, ensure data is on the first sheet in the workbook! Try again.', 'Error', 'error', 'modal'))
            error('OCEC_Tool:Analysis:NoData', 'Cannot find data in results file!')
        end
        raw = raw(i(end) : end, :);
        
        % Find row of interest sample times
        candidate_times = mat2cell(datestr(datenum(raw(2 : end, j(end))), 'yyyy-mmm-dd HH:MM'), ones(size(raw, 1) - 1, 1), 17);
        analysis_time = datestr(datenum(Dat.AnalysisInfo.tims{Dat.TagIndex}), 'yyyy-mmm-dd HH:MM');
        jdx = find(strcmp(candidate_times, analysis_time)) + 1;
        
        % Get measured data
        Dat.MeasuredCA = raw{jdx, strcmp(raw(1, :), 'calibration area')};
        Dat.MeasuredTA = round(raw{jdx, strcmp(raw(1, :), 'TC(ug)')} / Dat.AnalysisInfo.cal(Dat.TagIndex) * Dat.MeasuredCA);
        
        % Get critical times
        idx1 = find(~strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'), 1, 'last');
        idx2 = length(Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR);
        t = (1:idx2)' - 1;
        t1 = t(idx1);
        t2 = t(idx2);
        
        % Get integrated area of raw NDIR
        TTA = trapz(t(1:idx1), Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR(1:idx1));
        TCA = trapz(t(idx1:end), Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR(idx1:end));
        
        % Pull instrument-reported areas
        TA = Dat.MeasuredTA;
        CA = Dat.MeasuredCA;
        
        % Get linear corrections
        b = ((TTA-TA)/(t1^2) - (TCA-CA)/(t2^2-t1^2))/(1/t1 - 1/(t1+t2));
        a = 2*(TTA - TA - b*t1)/t1^2;
        
        % Get corrected NDIR
        NDIR_Corrected = Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR - a * t - b;
        Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR_Corrected = NDIR_Corrected;
end

% Update NDIR areas
set(findobj(allchild(h), 'tag', 'Dat_TA'), 'string', num2str(Dat.MeasuredTA, '%u'))
set(findobj(allchild(h), 'tag', 'Dat_CA'), 'string', num2str(Dat.MeasuredCA, '%u'))

% Laser correction --------------------------------------------------------

% Get temperature and laser data during calibration loop
idx1 = find(strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'), 1, 'first');
xdat = Dat.AnalysisInfo.data{Dat.TagIndex}.Tact(idx1 : end);
ydat = Dat.AnalysisInfo.data{Dat.TagIndex}.Lase(idx1 : end);

% Perform fit
ft = fitlm(xdat, ydat, Dat.LaserCorrType);
Dat.LaserFit = ft;

% Get incident laser power from fit
Lase_Incident = ft.feval(Dat.AnalysisInfo.data{Dat.TagIndex}.Tact);
Dat.AnalysisInfo.data{Dat.TagIndex}.Lase_Incident = Lase_Incident;

% Get suggested attenuation decline ---------------------------------------

% Get noise in laser power
idx1 = find(strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'), 1, 'first');
Tdat = Dat.AnalysisInfo.data{Dat.TagIndex}.Tact(idx1 : end);
Ldat = Dat.AnalysisInfo.data{Dat.TagIndex}.Lase(idx1 : end);
[a, b] = normfit(Ldat ./ Dat.LaserFit.feval(Tdat));
U(1) = b / a * 100 * tinv(normcdf(2), length(Tdat) - 1);

% Get noise in temperature (using a cubic normalization)
Tdat = Tdat(15:end);
p = polyfit(1:length(Tdat), Tdat', 3);
[a, b] = normfit(Tdat' ./ polyval(p, 1:length(Tdat)));
U(2) = b / a * 100 * tinv(normcdf(2), length(Tdat) - 1);

% Get prediction interval of laser correction (uncertainty of laser correction)
[a, b] = predict(Dat.LaserFit, Dat.AnalysisInfo.data{Dat.TagIndex}.Tact, 'prediction', 'observation', 'alpha', normcdf(-2));
U(3) = max(range(b, 2) / 2 ./ a * 100);

% Get suggested attenuation decline (2x safety factor)
% Note: considers initial and split attenuation. Noise uncertainties are
% uncorrelated, but regression uncertainty (U(3)) is correlated.
suggested_decline = round(1e3 * sqrt(2 * U(1)^2 + 2 * U(2)^2 + 4 * U(3)^2) * 2) / 1e3;
str = sprintf('Suggested attenuation decline is %.3f%%', suggested_decline);
set(findobj(allchild(h), 'tag', 'Dat_Split_Sugg'), 'string', str)

%% OBTAIN AVEC DATA

% Get index at end of analysis phase
idx = find(~strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'), 1, 'last');

% Obtain cumulative mass
CM = cumtrapz(NDIR_Corrected) ./ Dat.MeasuredCA .* Dat.Cal_Mu;

% Obtain attenuation
AT = -log(Dat.AnalysisInfo.data{Dat.TagIndex}.Lase ./ Lase_Incident);

% Obtain oven temperature
OT = Dat.AnalysisInfo.data{Dat.TagIndex}.Tact;

% Compile AVEC data while accounting for transit time
AVEC(:, 1) = CM(Dat.AnalysisInfo.tran(Dat.TagIndex) + 1 : idx);
AVEC(:, 2) = AT(1 : idx - Dat.AnalysisInfo.tran(Dat.TagIndex));
AVEC(:, 3) = OT(1 : idx - Dat.AnalysisInfo.tran(Dat.TagIndex));

% Crop negative attenuation
idx = find(AVEC(:, 2) < 0, 1, 'first');
AVEC(idx : end, 2) = 0;

% Store AVEC data
Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC = AVEC;

%% GET SPLIT POINT

% If data is NaN, use the suggested attenuation decline as default
if strcmp(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string'), 'NaN')
    % Set method and attenuation decline
    set(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject', findobj(allchild(h), 'string', 'Attenuation decline'))
    Dat.Split_Del = suggested_decline;
    
    % Run Sunset's TOT to get Initial attenuation and split point center
    Dat = Sub_Sunset_TOT(Dat);
    
    % Run attenuation decline to get split point uncertainty
    Dat = Sub_Attenuation_Decline(Dat);
    
    % Update parameters
    set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(Dat.Split_Ctr, '%.3f'))
    set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(Dat.Split_Wid, '%.3f'))
    set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', num2str(Dat.Split_Att, '%.3f'))
    set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', num2str(Dat.Split_Del, '%.3f'))
end

switch get(get(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject'), 'string')
    case 'Attenuation decline'
        % Get data from GUI
        Dat.Split_Att = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string'));
        Dat.Split_Del = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string'));
        
        % Run attenuation decline to get split point uncertainty
        Dat = Sub_Attenuation_Decline(Dat);
        
    case 'Sunset labs' % Using the Sunset TOT procedure
        % Run Sunset's TOT
        Dat = Sub_Sunset_TOT(Dat);
        Dat.Split_Wid = 0;
        Dat.Split_Del = 0;
        
    case 'Manual selection'
        % Get data from GUI
        Dat.Split_Ctr = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string'));
        Dat.Split_Wid = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string'));
        
        % Get corresponding attenuation data
        Dat = Sub_Manual_Selection(Dat);
end

% Ensure non-negative split uncertainty
if Dat.Split_Wid < 0; Dat.Split_Wid = 0; end

% Update parameters
set(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string', num2str(Dat.Split_Ctr, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string', num2str(Dat.Split_Wid, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string', num2str(Dat.Split_Att, '%.3f'))
set(findobj(allchild(h), 'tag', 'Dat_Split_dA'), 'string', num2str(Dat.Split_Del, '%.3f'))

%% PLOT THERMOGRAM
% Get axis
axes(findobj(allchild(h), 'tag', 'Dat_Ax_Therm'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')
text(gca, 'units', 'normalized', 'string', 'Laser / NDIR [a.u.] (Linear)', 'position', [-0.05 0.5 0], 'fontsize', 12, 'rotation', 90)

% Plot data - Laser
yy = Dat.AnalysisInfo.data{Dat.TagIndex}.Lase ./ Dat.AnalysisInfo.data{Dat.TagIndex}.Lase_Incident;
yy = (yy - min(yy)) / range(yy) * 8 + 1.5;
plot(yy, '-k', 'color', [0.5 0.5 0.0], 'linewidth', 1.5)

% Plot data - NDIR
yy = Dat.AnalysisInfo.data{Dat.TagIndex}.NDIR_Corrected;
yy = (yy - min(yy)) / (max(yy(~strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'))) - min(yy)) * 6 + 1;
yzero = mean(yy(find(strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'CH4+Ox'), 14, 'first')));
area(1:length(yy), yy, yzero, 'facecolor', [0.5 0 0], 'edgecolor', 'none', 'facealpha', 0.4)
plot(yy, '-k', 'color', [0.5 0.0 0.0], 'linewidth', 1.5)
yy = ones(size(yy)) * yzero;
plot(yy, '-k', 'color', [0.5 0 0], 'linewidth', 0.5)

% Plot data - temperatures
plot(Dat.AnalysisInfo.data{Dat.TagIndex}.Tset / 100, '-k', 'color', [0.0 0.0 0.5], 'linewidth', 1.5)
plot(Dat.AnalysisInfo.data{Dat.TagIndex}.Tact / 100, '-k', 'color', [0.0 0.5 0.0], 'linewidth', 1.5)

% Format
set(gca, 'xlim', [0 length(yy)], 'xtick', 0:100:1500)
uistack(findobj(allchild(h), 'tag', 'Dat_Ax_Therm_Leg'), 'top')

%% PLOT AVEC
% Get axis
axes(findobj(allchild(h), 'tag', 'Dat_Ax_AVEC'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')
colormap(winter(256))

% Plot data
sc = scatter(AVEC(:, 1), AVEC(:, 2), 25, AVEC(:, 3) / 100, 'o', 'filled');

% Format axis
xlim = [0, ceil(max(AVEC(:, 1)))];
xdel = ceil(xlim(2) / 10);
xtck = 0 : xdel : xlim(2);
xstr = num2str(xtck, '%u\n');
set(gca, 'xlim', xlim, 'xtick', xtck, 'xticklabel', xstr)
ylim = [0, ceil(max(AVEC(:, 2)) * 10) / 10];
ydel = ceil(ylim(2) / 6 * 10) / 10;
ytck = 0 : ydel : ylim(2);
ystr = num2str(ytck, '%.1f\n');
set(gca, 'ylim', ylim, 'ytick', ytck, 'yticklabel', ystr)

% Plot split
xmid = Dat.Split_Ctr;
xhlf = Dat.Split_Wid;
xdat = xmid + xhlf * [1 1 -1 -1];
xdat(xdat < 0) = 0;
fill(xdat, ylim(2) * [0 1 1 0], 0.5 * [1 1 1], 'edgecolor', 'k', 'facealpha', 0.2, 'edgealpha', 0.5, 'tag', 'split_fill')

% Plot attenuation
plot(get(gca, 'xlim'), Dat.Split_Att * [1 1], '-k', 'linewidth', 1.5, 'tag', 'split_Ao')
plot(get(gca, 'xlim'), Dat.Split_Att * (1 - Dat.Split_Del / 100) * [1 1], '--r', 'linewidth', 1.5, 'tag', 'split_dA')

% Format stacking
uistack(sc, 'top')
uistack(findobj(allchild(h), 'tag', 'Dat_Ax_AVEC_Leg'), 'top')

% Enable analysis button
set(findobj(allchild(h), 'tag', 'Dat_Run'), 'enable', 'on')

%% UPDATE USERDATA
fn = fieldnames(Dat);
for i = 1 : length(fn)
    h.UserData.Dat.(fn{i}) = Dat.(fn{i});
end

end

function Callback_AnalysisRun(~, ~, h)
% This callback function runs the Monte Carlo analysis for carbon masses.
% It also updates the plotted data in case any prior changes were not
% plotted.

% Turn off t-distribution fitting warning
warning('off', 'stats:tlsfit:IterLimit')

%% GET DATA AND VALIDATE

% Pull data
Dat = h.UserData.Dat;
Dat.MC_nd = str2double(get(findobj(allchild(h), 'tag', 'Dat_MC_nd'), 'string'));

% Validate Monte Carlo draws
if ~~mod(Dat.MC_nd, 1) % Is integer
    uiwait(msgbox('# MC draws must be an integer! Rounding given value.', 'Warning', 'warn', 'Modal'))
    Dat.MC_nd = round(Dat.MC_nd);
    set(findobj(allchild(h), 'tag', 'Dat_MC_nd'), 'string', num2str(Dat.Dat_MC_nd, '%u'))
elseif Dat.MC_nd < 1e2 % Fix if too low
    uiwait(msgbox('# MC draws is too low, result will be inconsistent! Defaulting to minimum value.', 'Warning', 'warn', 'Modal'))
    Dat.MC_nd = 1e2;
    set(findobj(allchild(h), 'tag', 'Dat_MC_nd'), 'string', '100')
elseif Dat.MC_nd < 1e4 % Warn if too low
    uiwait(msgbox('# MC draws is low! Result may be inconsistent.', 'Warning', 'warn', 'Modal'))
elseif Dat.MC_nd  > 1e8 % Error if too high
    uiwait(msgbox('# of MC draws is large, maximum allowed is 10^8!! Try again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Analysis:MCLargeAutoStop', 'Operation stopped due to large MC draws!')
elseif Dat.MC_nd > 1e6 % Warn if too high
    quest = '# of Monte Carlo draws is large, the application may run into memory limitations and may run slowly. Would you like to continue?';
    tit = '# of MC Draws Large';
    slc = questdlg(quest, tit, 'Yes', 'No', 'Use Default', 'No');
    switch slc
        case 'No' % Raise error to stop calculation
            error('OCECgo:Analysis:MCLargeUserStop', 'Operation stopped by user!')
        case 'Use Default' % Default to 10^6
            Dat.MC_nd = 1e6;
            set(findobj(allchild(h), 'tag', 'Dat_MC_nd'), 'string', '1000000')
    end
end

% Edit temporary userdata if using sunset procedure
if strcmp(get(get(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject'), 'string'), 'Sunset labs')
    Dat.Split_Wid = 0;
end

%% RUN MONTE CARLO

% Compute masses ----------------------------------------------------------

% Get nominal total carbon from NDIR areas
PeakCM = Dat.MeasuredTA / Dat.MeasuredCA;

% Get calibration and repeatability distributions
dist_cal = makedist('tLocationScale', 'mu', Dat.Cal_Mu, 'sigma', Dat.Cal_Sg, 'nu', Dat.Cal_Nu);
dist_rep = makedist('Normal', 'mu', 1, 'sigma', Dat.Cal_Rep / 2 / 100);

% Compute MC total carbon (include calibration and repeatability)
% Random calibration
crit = dist_cal.cdf(0);
random_cal = dist_cal.icdf(crit + (1 - 2 * crit) * rand(Dat.MC_nd, 1));
% Random TC
Dat.Carbon_TC = random_cal .* dist_rep.random([Dat.MC_nd, 1]) * PeakCM;

% Get random OC fraction (from split uncertainty)
rand_OCfrac = normrnd(Dat.Split_Ctr, Dat.Split_Wid / 2, [Dat.MC_nd, 1]) / PeakCM / dist_cal.mu;
rand_OCfrac(rand_OCfrac < 0) = 0 - rand_OCfrac(rand_OCfrac < 0);
rand_OCfrac(rand_OCfrac > 1) = 2 - rand_OCfrac(rand_OCfrac > 1);

% Get random OC and EC
Dat.Carbon_OC = Dat.Carbon_TC .* rand_OCfrac;
Dat.Carbon_EC = Dat.Carbon_TC .* (1 - rand_OCfrac);

% Add instrument repeatability error
rept = str2double(get(findobj(allchild(h), 'tag', 'Dat_MC_InstPrec'), 'string')) / 2;
TC_rand = randn(size(Dat.Carbon_OC)) * rept;
OC_frac = Dat.Carbon_OC ./ Dat.Carbon_TC;
Dat.Carbon_OC = Dat.Carbon_OC + TC_rand .* OC_frac;
Dat.Carbon_EC = Dat.Carbon_EC + TC_rand .* (1 - OC_frac);
Dat.Carbon_TC = Dat.Carbon_TC + TC_rand;

% Get bar chart data
[bardata(1, :, 1), bardata(1, :, 2)] = hist(Dat.Carbon_OC, sqrt(Dat.MC_nd));
[bardata(2, :, 1), bardata(2, :, 2)] = hist(Dat.Carbon_EC, sqrt(Dat.MC_nd));
[bardata(3, :, 1), bardata(3, :, 2)] = hist(Dat.Carbon_TC, sqrt(Dat.MC_nd));

% Normalize bar data so peak is = 1 (smoothed with Savitzky-Golay filter)
frame = 2 * floor(sqrt(size(bardata, 2)) / 2) + 1;
nrm = max(sgolayfilt(bardata(:, :, 1), 2, frame, [], 2), [], 2);
bardata(:, :, 1) = bsxfun(@rdivide, bardata(:, :, 1), nrm);

%% PRINT STATISTICS

% Get axes
axes(findobj(allchild(h), 'tag', 'Dat_Ax_Stats'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')

% Cycle through carbon masses
for j = 1:3
    % Get data
    switch j
        case 1; dat = Dat.Carbon_OC;
        case 2; dat = Dat.Carbon_EC;
        case 3; dat = Dat.Carbon_TC;
    end
    
    % Compute and write stats
    
    % Mean & 95% CI
    ave = mean(dat);
    low = (1 - prctile(dat, normcdf(-2)*100) / ave) * 100;
    hig = (prctile(dat, normcdf(2)*100) / ave - 1) * 100;
    str = {num2str(ave, '%4.4G'); ['(-', num2str(low, '%3.3G'), ' / +', num2str(hig, '%3.3G'), '%)']};
    text(70 + j * 160, 172, str, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    Dat.Stats.Mean{j} = [str{1}, char(10), str{2}];
    
    % Median
    Dat.Stats.Median{j} = median(dat);
    str = num2str(Dat.Stats.Median{j}, '%4.4G');
    text(70 + j * 160, 121, str, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    
    % Std. Dev.
    Dat.Stats.StdDev{j} = std(dat);
    str = num2str(Dat.Stats.StdDev{j}, '%4.4G');
    text(70 + j * 160, 079, str, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
end

% Split range
split1 = num2str(find(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC(:, 1) <= (Dat.Split_Ctr - Dat.Split_Wid), 1, 'last'), '%u');
split2 = num2str(find(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC(:, 1) >= (Dat.Split_Ctr + Dat.Split_Wid), 1, 'first'), '%u');
if isempty(split1); split1 = '0'; end
if isempty(split2); split2 = num2str(find(strcmp(Dat.AnalysisInfo.data{Dat.TagIndex}.mode, 'Ox'), 1, 'last'), '%u'); end
str = ['- - - - - - - - - - - - - - -  ', split1, ' to ', split2, '  - - - - - - - - - - - - - - -'];
text(390, 035, str, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
Dat.Stats.SplitRange = sprintf('%s to %s', split1, split2);

%% GET AND PRINT OUT BEST FITS

% Get best-fitting distributions
Dat = Sub_BestFit(Dat);

% Print distributions
str = cell(3, 1);
for i = 1:3
    best = Dat.BestFits{i};
    params = ['(', strjoin(strcat(strsplit(num2str(best.ParameterValues, '%4.4G '), ' ')), ', '), ')'];
    switch best.DistributionName
        case 'Extreme Value'; nm = 'Extreme Value';
        case 't Location-Scale'; nm = 'Geneneralized T';
        otherwise
            nm = best.DistributionName;
    end
    str{i} = {nm; params};
end
set(findobj(allchild(h), 'tag', 'Dat_BestOC'), 'string', str{1})
set(findobj(allchild(h), 'tag', 'Dat_BestEC'), 'string', str{2})
set(findobj(allchild(h), 'tag', 'Dat_BestTC'), 'string', str{3})

%% PLOT HISTOGRAM

% Migrate to axis
axes(findobj(allchild(h), 'tag', 'Dat_Ax_Hists'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')

% Define colors
cols = {[0.5 0 0], [0 0.5 0], [0 0 0.5]};

% Plot data
for j = 1:3
    % Compute distribution maximum / peak
    switch Dat.BestFits{j}.DistributionName
        case {'Normal', 't Location-Scale', 'Logistic', 'Extreme Value'}
            peak = Dat.BestFits{j}.pdf(Dat.BestFits{j}.mean);
        case 'Gamma'
            peak = Dat.BestFits{j}.pdf((Dat.BestFits{j}.a - 1) * Dat.BestFits{j}.b);
        case 'Lognormal'
            peak = Dat.BestFits{j}.pdf(exp(Dat.BestFits{j}.mu - Dat.BestFits{j}.sigma ^ 2));
        case 'Log-Logistic'
            if Dat.BestFits{1, j}.sigma < 1
                peak = Dat.BestFits{j}.pdf(exp(Dat.BestFits{j}.mu) * ((1 - Dat.BestFits{j}.sigma) / (1 + Dat.BestFits{j}.sigma)) ^ Dat.BestFits{j}.sigma);
            else
                [~, idx] = max(bardata(j, :, 1));
                scale_value = bardata(j, idx, 2);
                peak = Dat.BestFits{j}.pdf(scale_value);
            end
        case 'Folded-Normal'
            mu = Dat.BestFits{j}.ParameterValues(1);
            sg = Dat.BestFits{j}.ParameterValues(2);
            try md = fzero(@(x) x + sg ^ 2 / 2 / mu .* log((mu - x) ./ (mu + x)), [1e-9 mu - 1e-9]);
            catch
                md = 0;
            end
            peak = Dat.BestFits{j}.pdf(md);
    end
    
    % Scale and plot bar data
    bar(bardata(j, :, 2), bardata(j, :, 1) * peak, 'FaceColor', cols{j}, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'BarWidth', 1)
    
    % Plot distribution pdf
    fp = fplot(@(x) Dat.BestFits{j}.pdf(x), [Dat.BestFits{j}.icdf(0.0005) Dat.BestFits{j}.icdf(0.9995)]);
    set(fp, 'linewidth', 1.5, 'color', cols{j}, 'linestyle', '-')
end

% Format axis
xlim = [0 ceil(Dat.BestFits{3}.icdf(0.995))];
xdel = ceil(xlim(2) / 12);
xtck = 0 : xdel : xlim(2);
xstr = num2str(xtck, '%u\n');
set(gca, 'xlim', xlim, 'xtick', xtck, 'yticklabel', xstr, 'ticklength', 0.005 * [1 1])

%% UPDATE USERDATA
fn = fieldnames(Dat);
for i = 1 : length(fn)
    h.UserData.Dat.(fn{i}) = Dat.(fn{i});
end

%% MIGRATE TO RESULTS
set(findobj(h, 'Tag', 'TabGroup'), 'SelectedTab', findobj(h, 'Tag', 'Tab_DatRes'))

end

function Dat = Sub_Sunset_TOT(Dat)
% This sub-routine function computes the initial attenuation and
% corresponding split point using Sunset's TOT (with smoothing) approach

% Get critical attenuation
att = exp(-Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC(:, 2));
smo = smooth(att, 10); % Smoothed over 10-second window
crit = max(smo(1 : 70)); % Maximum over first 70 seconds

% Find split point index in AVEC data
idx = min(length(att), find(att <= crit, 1, 'last') + 1);
idx = idx - 1 + (crit - att(idx - 1)) / (att(idx) - att(idx - 1));
idx = min(idx, size(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC, 1));

% Write outputs
Dat.Split_Ctr = interp1(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC(:, 1), idx, 'linear');
Dat.Split_Att = -log(crit);
end

function Dat = Sub_Attenuation_Decline(Dat)
% This sub-routine function computes the split point and its uncertainty
% using the given attenuation decline data

% Get critical attenuations
att = exp(-Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC(:, 2));
crit1 = exp(- Dat.Split_Att);
crit2 = exp(- Dat.Split_Att * (1 - Dat.Split_Del / 100));

% Find split point index in AVEC data
idx1 = find(att <= crit1, 1, 'last') + 1;
idx1 = min(idx1, length(att));
idx1 = idx1 - 1 + (crit1 - att(idx1 - 1)) / (att(idx1) - att(idx1 - 1));
idx1 = min(idx1, size(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC, 1));

% Find critical attenuation idx
idx2 = find(att <= crit2, 1, 'last') + 1;
idx2 = min(idx2, length(att));
idx2 = idx2 - 1 + (crit2 - att(idx2 - 1)) / (att(idx2) - att(idx2 - 1));
idx2 = min(idx2, size(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC, 1));

% Write outputs
Dat.Split_Ctr = interp1(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC(:, 1), idx1, 'linear');
Dat.Split_Wid = interp1(Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC(:, 1), idx2, 'linear') - Dat.Split_Ctr;
end

function Dat = Sub_Manual_Selection(Dat)
% This sub-routine computes the initial attenuation and attenuation decline
% corresponding to a given split point and split point uncertainty

% Pull AVEC temporarily
AVEC = Dat.AnalysisInfo.data{Dat.TagIndex}.AVEC;

% Initial attenuation
idx1 = find(AVEC(:, 1) <= Dat.Split_Ctr, 1, 'last') + 1;
idx1 = idx1 - 1 + (Dat.Split_Ctr - AVEC(idx1 - 1, 1)) / (AVEC(idx1, 1) - AVEC(idx1 - 1, 1));
idx1 = min(idx1, size(AVEC, 1));
A0 = interp1(AVEC(:, 2), idx1, 'linear');

% Decline in 
idx2 = find(AVEC(:, 1) <= (Dat.Split_Ctr + Dat.Split_Wid), 1, 'last') + 1;
idx2 = idx2 - 1 + (Dat.Split_Ctr + Dat.Split_Wid - AVEC(idx2 - 1, 1)) / (AVEC(idx2, 1) - AVEC(idx2 - 1, 1));
idx2 = min(idx2, size(AVEC, 1));
A1 = interp1(AVEC(:, 2), idx2, 'linear');

% Write outputs
Dat.Split_Att = A0;
Dat.Split_Del = (1 - A1 / A0) * 100;
end

function Dat = Sub_BestFit(Dat)
% This sub-routine computes the three distributions that best fit the Monte
% Carlo-computed carbon masses.

% Define fits to attempt
fitnames = {'ev', 'gamma', 'HalfNormal', 'logistic', 'loglogistic', 'lognormal', ...
    'rayleigh', 'normal', 'tlocationscale'};

% Initialize fit results cell and Cramer von Mises statistic tracking
ft = cell(length(fitnames), 3);
AICc = zeros(size(ft)) + Inf;

% Cycle through carbon masses
for j = 1:3
    switch j % Pull the appropriate data
        case 1; xx = Dat.Carbon_OC;
        case 2; xx = Dat.Carbon_EC;
        case 3; xx = Dat.Carbon_TC;
    end
    
    % Get a randomsubset of data for quicker fitting (as necessary) - fit
    % on a subset of 1 million data points
    if Dat.MC_nd > 1e6
        xx = xx(randperm(Dat.MC_nd, 1e6));
    end
    
    % Cycle through optional fits
    for i = 1 : length(fitnames)
        if ~strcmp(fitnames{i}, 'HalfNormal') % If NOT fitting a folded normal
            ft{i, j} = fitdist(xx, fitnames{i});
        else % If fitting a folded normal
            % If specific carbon mass is the lesser of OC and EC, try
            % fitting a folded normal
            if or(and(j == 1, mean(Dat.Carbon_OC) < mean(Dat.Carbon_EC)), and(j == 2, mean(Dat.Carbon_OC) > mean(Dat.Carbon_EC)))
                % Get mean from the nominal split point
                if j == 1 % OC
                    mu = Dat.Split_Ctr;
                elseif j == 2 % EC
                    mu = mean(Dat.Carbon_TC) - Dat.Split_Ctr;
                else
                    continue % Skip - no folded normal for TC
                end
                
                % Get standard deviation
                sg = sqrt(mean(xx .^ 2) - mu ^ 2);
                
                % If mu >> sg, just use a normal distribution
                if mu > 3 * sg; continue; end
                
                % If sigma is imaginary, skip
                if ~~imag(sg); continue; end
                
                % Define the distribution and its statistics
                ft{i, j}.pdf = @(x) 1 / sg / sqrt(2 * pi) * (exp(-(x - mu) .^ 2 / 2 / sg ^ 2) + exp(-(x + mu) .^ 2 / 2 / sg ^ 2)) ;
                ft{i, j}.cdf = @(x) 0.5 * (erf((x + mu) / sg / sqrt(2)) + erf((x - mu) / sg / sqrt(2)));
                tt = linspace(0, mu + 6 * sg, 1e4);
                ft{i, j}.icdf = @(x) interp1(ft{i, j}.cdf(tt), tt, x, 'pchip', nan);
                ft{i, j}.ParameterValues = [mu sg];
                ft{i, j}.DistributionName = 'Folded-Normal';
                ft{i, j}.NumParameters = 2;
                ft{i, j}.negloglik = sum(-log(ft{i,j}.pdf(xx)));
            else
                continue
            end
        end
        
        % Compute the corrected Akaike Information criterion (AICc)
        k = ft{i, j}.NumParameters;
        n = length(xx);
        AICc(i, j) = 2 * k + 2 * ft{i, j}.negloglik + (2 * k ^ 2 + 2 * k) / (n - k - 1);
        
        % If generalized t-distribution has a large DOF, it is essentially
        % normal, so disregard it
        if strcmp(fitnames{i}, 'tlocationscale')
            if ft{i, j}.nu > 60
                AICc(i, j) = inf;
            end
        end
    end
end

% Get best fits indices
[~, best_idx] = sort(AICc);

% Pull the best fits
BestFits = cell(3, 1);
for i = 1:3
    BestFits{i, 1} = ft{best_idx(1, i), i};
end

% Save the results
Dat.BestFits = BestFits;
end

function Callback_ClearPlotsDisableAnalysis(~, ~, h)
% This function disables analysis - it is triggered if upstream inputs are
% changed

% Clear axes - Thermogram
axes(findobj(allchild(h), 'tag', 'Dat_Ax_Therm'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')
text(gca, 'units', 'normalized', 'string', 'Laser / NDIR [a.u.] (Linear)', 'position', [-0.05 0.5 0], 'fontsize', 12, 'rotation', 90)
uistack(findobj(allchild(h), 'tag', 'Dat_Ax_Therm_Leg'), 'top')

% Clear axes - AVEC plot
axes(findobj(allchild(h), 'tag', 'Dat_Ax_AVEC'))
h.CurrentAxes = gca;
cla
set(gca, 'nextplot', 'replacechildren')
hold(gca, 'on')
uistack(findobj(allchild(h), 'tag', 'Dat_Ax_AVEC_Leg'), 'top')
colormap(winter(256))

% Disable analysis button
set(findobj(allchild(h), 'tag', 'Dat_Run'), 'enable', 'off')

% Re-set split method
set(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject', findobj(allchild(h), 'string', 'Attenuation decline'))

% Reset and disable split point data
set(allchild(findobj(allchild(h), 'tag' ,'Dat_Split_Proc')), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_ctr'), 'string', 'NaN', 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_wid'), 'string', 'NaN', 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_Ao'), 'string', 'NaN', 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_dA'), 'string', 'NaN', 'enable', 'off')
h.UserData.Dat.Split_Ctr = nan;
h.UserData.Dat.Split_Wid = nan;
h.UserData.Dat.Split_Att = nan;
h.UserData.Dat.Split_Del = nan;
set(findobj(allchild(h), 'tag' ,'Dat_Split_c+'), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_c-'), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_w+'), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_w-'), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_a+'), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_a-'), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_d+'), 'enable', 'off')
set(findobj(allchild(h), 'tag' ,'Dat_Split_d-'), 'enable', 'off')
end