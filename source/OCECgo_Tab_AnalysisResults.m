function OCECgo_Tab_AnalysisResults(h)
% This function creates the fields within the data analysis - results tab.

% Get parent
pnt1 = findobj(h, 'tag', 'Tab_DatRes');

%% CREATE RESULTS SECTION

% Create panel
str = 'Carbon Mass - Statistics of Monte Carlo Results';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [5 350 635 285], 'Title', str, 'FontSize', 16);
axes(pnt2, 'units', 'pixels', 'position', [0 0 635 285], 'xlim', [0 635], 'ylim', [0 285], 'visible', 'off')

% UIcontrols text boxes for tooltips
clear tip str
str{1} = {'Mean &'; ['2', char(963),' Unc.']};
str{2} = 'Median';
str{3} = 'Std. Dev.';
str{4} = 'Split Range [s]';
tip{1} = ['<html>Mean and 2', char(963), ' uncertainty of Monte Carlo results.</html>'];
tip{2} = '<html>Median of Monte Carlo results.</html>';
tip{3} = ['<html>Standard deviation (1', char(963),') of Monte Carlo results.</html>'];
tip{4} = ['<html>Range of split points (in time) corresponding to 2', char(963), ' split point uncertainty.</html>'];
uicontrol(pnt2, 'style', 'text', 'position', [5 151 140 38], 'string', str{1}, 'fontsize', 12, 'tooltip', tip{1})
uicontrol(pnt2, 'style', 'text', 'position', [5 109 140 20], 'string', str{2}, 'fontsize', 12, 'tooltip', tip{2})
uicontrol(pnt2, 'style', 'text', 'position', [5 067 140 20], 'string', str{3}, 'fontsize', 12, 'tooltip', tip{3})
uicontrol(pnt2, 'style', 'text', 'position', [5 025 140 20], 'string', str{4}, 'fontsize', 12, 'tooltip', tip{4})

% Add table text
text(gca, 230, 225, {'Organic Carbon'; ['(OC) [', char(181),'g]']}, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(gca, 390, 225, {'Elemental Carbon'; ['(EC) [', char(181),'g]']}, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(gca, 550, 225, {'Total Carbon'; ['(TC) [', char(181),'g]']}, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

% Create write-able axes
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 635 285], 'XLim', [0 635], 'YLim', [0 285], 'Visible', 'off', 'tag', 'Dat_Ax_Stats')

%% CREATE FIT SECTION

% Create panel
str = 'Carbon Mass - Fitted Distributions';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [655 350 400 285], 'Title', str, 'FontSize', 16);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 400 285], 'XLim', [0 400], 'YLim', [0 285], 'Visible', 'off')

% Add table text
text(gca, 255, 225.0, 'Best-fitting Distribution', 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(gca, 065, 170.0, {'Organic'; ['Carbon [', char(181), 'g]']}, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(gca, 065, 102.5, {'Elemental'; ['Carbon [', char(181), 'g]']}, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(gca, 065, 035.0, {'Total'; ['Carbon [', char(181), 'g]']}, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

% UI objects for best-fitting distributions
uicontrol(pnt2, 'style', 'text', 'position', [130 150.0 250 38], 'string', '', 'fontsize', 12, 'tag', 'Dat_BestOC')
uicontrol(pnt2, 'style', 'text', 'position', [130 082.5 250 38], 'string', '', 'fontsize', 12, 'tag', 'Dat_BestEC')
uicontrol(pnt2, 'style', 'text', 'position', [130 015.0 250 38], 'string', '', 'fontsize', 12, 'tag', 'Dat_BestTC')

%% CREATE EXPORT SECTION

% Create panel
str = 'Export Analysis';
pnt2 = uipanel(pnt1, 'units', 'pixels', 'position', [1070 350 180 285], 'title', str, 'fontsize', 16);
uicontrol(pnt2, 'style', 'pushbutton', 'position', [5 90 170 105], 'string', '<html><center>Export<br />Analysis<br />Results</center></html>', 'FontSize', 14, 'callback', {@Callback_ExportAnalysis h})

%% CREATE HISTOGRAM RESULTS AXIS

% Create panel
str = 'Carbon Mass - Data Visualization';
pnt2 = uipanel(pnt1, 'Units', 'pixels', 'Position', [5 5 945 340], 'Title', str, 'FontSize', 16);
axes(pnt2, 'Units', 'pixels', 'Position', [0 0 730 340], 'xlim', [0 730], 'ylim', [0 340], 'visible', 'off')

% Create histogram axis
axes(pnt2, 'Units', 'pixels', 'Position', [55 60 725 240], 'FontSize', 10, 'TickDir', 'out', 'Tag', 'Dat_Ax_Hists', 'box', 'on', 'ytick', [], 'ticklength', 0.005 * [1 1])
xlabel(['Carbon Mass on Filter, [', char(181),'g]'], 'FontSize', 12)
ylabel(['Probability [', char(181),'g^{-1}]'], 'FontSize', 12)

% Create legend
axes(pnt2, 'Units', 'pixels', 'Position', [795 60 130 240], 'Tag', 'Dat_Ax_Hists_Leg', 'box', 'on', 'xtick', [], 'ytick', [])
hold(gca, 'on')
fill([0.04 0.04 0.21 0.21], 0.9 + 0.025 * [1 -1 -1 1], [0.5 0 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none')
fill([0.04 0.04 0.21 0.21], 0.7 + 0.025 * [1 -1 -1 1], [0 0.5 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none')
fill([0.04 0.04 0.21 0.21], 0.5 + 0.025 * [1 -1 -1 1], [0 0 0.5], 'FaceAlpha', 0.5, 'EdgeColor', 'none')
plot([0.04 0.21], 0.8 * [1 1], '-k', 'color', [0.5 0 0], 'linewidth', 1.5)
plot([0.04 0.21], 0.6 * [1 1], '-k', 'color', [0 0.5 0], 'linewidth', 1.5)
plot([0.04 0.21], 0.4 * [1 1], '-k', 'color', [0 0 0.5], 'linewidth', 1.5)
text(0.25, 0.9, 'OC Results', 'FontSize', 12, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
text(0.25, 0.8, 'OC Best Fit', 'FontSize', 12, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
text(0.25, 0.7, 'EC Results', 'FontSize', 12, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
text(0.25, 0.6, 'EC Best Fit', 'FontSize', 12, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
text(0.25, 0.5, 'TC Results', 'FontSize', 12, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
text(0.25, 0.4, 'TC Best Fit', 'FontSize', 12, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
set(gca, 'xlim', [0 1], 'ylim', [0.35 0.95], 'xtick', [], 'ytick', [])

%% ADD FILLER MATERIAL

OCECgo_TabSupport_Copyright(pnt1);

end

function Callback_ExportAnalysis(~, ~, h)
% This callback exports input data and results to an .xlsx file in addition
% to a .png image of the thermogram, AVEC, and histogram axes

% Set add sheet warning to off
warning('off', 'MATLAB:xlswrite:AddSheet')

% Get file location
Sample_ID = get(findobj(allchild(h), 'tag', 'Dat_TagOpts'), 'string');
Sample_ID = Sample_ID{h.UserData.Dat.TagIndex};
defname = fullfile(h.UserData.folder_load, ['Analysis_', Sample_ID, '_', datestr(now, 'yyyy-mm-dd')]);
[file, fold] = uiputfile('*.xlsx', 'Select / create export file', defname);
h.UserData.folder_load = fold;
xlsfile = fullfile(fold, file);

% Copy template
loadfile = [h.UserData.folder_base, filesep, 'support\OCECgo_AnalysisExportTemplate.xlsx'];
copyfile(loadfile, xlsfile, 'f')

% Input header
tagindex = [h.UserData.Dat.TagIndex];
str = {['Analysis data exported for Sample ID "', h.UserData.Dat.AnalysisInfo.tags{tagindex}, '" on: ', datestr(now)]};
xlswrite(xlsfile, str, 'Exported Analysis', 'A1')

% Input sample metadata
dat = cell(4, 1);
dat{1} = datestr(datenum(h.UserData.Dat.AnalysisInfo.tims{tagindex}), ['yyyy-mmm-dd', char(10), 'HH:MM:SS']);
dat{2} = h.UserData.Dat.AnalysisInfo.cal(tagindex);
dat{3} = h.UserData.Dat.AnalysisInfo.tran(tagindex);
dat{4} = h.UserData.Dat.AnalysisInfo.punch(tagindex);
xlswrite(xlsfile, dat, 'Exported Analysis', 'C4')

% Input processing parameters
dat = cell(8, 1);
str = strsplit(get(get(findobj(allchild(h), 'tag', 'Dat_Laser'), 'selectedobject'), 'string'), ' ');
dat{1} = str{1};
dat{2} = get(get(findobj(allchild(h), 'tag', 'Dat_NDIR'), 'selectedobject'), 'string');
dat{3} = h.UserData.Dat.MeasuredTA;
dat{4} = h.UserData.Dat.MeasuredCA;
dat{5} = h.UserData.Dat.Cal_Mu;
dat{6} = h.UserData.Dat.Cal_Sg;
dat{7} = h.UserData.Dat.Cal_Nu;
dat{8} = h.UserData.Dat.Cal_Rep;
xlswrite(xlsfile, dat, 'Exported Analysis', 'C11')

% Input split point determination
dat = cell(5, 1);
dat{1} = get(get(findobj(allchild(h), 'tag', 'Dat_Split_Proc'), 'selectedobject'), 'string');
dat{2} = h.UserData.Dat.Split_Ctr;
dat{3} = h.UserData.Dat.Split_Wid;
dat{4} = h.UserData.Dat.Split_Att;
dat{5} = h.UserData.Dat.Split_Del;
xlswrite(xlsfile, dat, 'Exported Analysis', 'F4')

% Input MC draws
xlswrite(xlsfile, h.UserData.Dat.MC_nd, 'Exported Analysis', 'F10')

% Input carbon mass statistics
dat = cell(3, 3);
dat{1, 1} = h.UserData.Dat.Stats.Mean{1};
dat{1, 2} = h.UserData.Dat.Stats.Mean{2};
dat{1, 3} = h.UserData.Dat.Stats.Mean{3};
dat{2, 1} = h.UserData.Dat.Stats.Median{1};
dat{2, 2} = h.UserData.Dat.Stats.Median{2};
dat{2, 3} = h.UserData.Dat.Stats.Median{3};
dat{3, 1} = h.UserData.Dat.Stats.StdDev{1};
dat{3, 2} = h.UserData.Dat.Stats.StdDev{2};
dat{3, 3} = h.UserData.Dat.Stats.StdDev{3};
xlswrite(xlsfile, dat, 'Exported Analysis', 'I5')

% Input split point range
xlswrite(xlsfile, {h.UserData.Dat.Stats.SplitRange}, 'Exported Analysis', 'I8')

% Input best fits
dat = cell(1, 3);
str = get(findobj(allchild(h), 'tag', 'Dat_BestOC'), 'string');
dat{1} = [str{1}, char(10), str{2}];
str = get(findobj(allchild(h), 'tag', 'Dat_BestEC'), 'string');
dat{2} = [str{1}, char(10), str{2}];
str = get(findobj(allchild(h), 'tag', 'Dat_BestTC'), 'string');
dat{3} = [str{1}, char(10), str{2}];
xlswrite(xlsfile, dat, 'Exported Analysis', 'I12')

% Create figure and copy axes
fg = figure();
set(fg, 'color', 'w', 'units', 'pixels', 'position', [50 50 980 660], 'visible', 'off')
ax1 = copy([findobj(allchild(h), 'tag', 'Dat_Ax_Therm'), findobj(allchild(h), 'tag', 'Dat_Ax_Therm_Leg')], fg);
ax2 = copy([findobj(allchild(h), 'tag', 'Dat_Ax_AVEC'), findobj(allchild(h), 'tag', 'Dat_Ax_AVEC_Leg'), findobj(allchild(h), 'tag', 'Dat_Ax_AVEC_CB')], fg);
ax3 = copy([findobj(allchild(h), 'tag', 'Dat_Ax_Hists'), findobj(allchild(h), 'tag', 'Dat_Ax_Hists_Leg')], fg);

% Adjust axis positions
ax1(1).Position(1) = ax1(1).Position(1) + 15;
ax1(2).Position(1) = ax1(2).Position(1) + 15;
ax1(1).Position(2) = ax1(1).Position(2) + 335;
ax1(2).Position(2) = ax1(2).Position(2) + 335;
pause(0.2)
ax2(1).Position(1) = ax2(1).Position(1) + 35;
ax2(2).Position(1) = ax2(2).Position(1) + 35;
ax2(3).Position(1) = ax2(3).Position(1) + 35;
ax2(1).Position(2) = ax2(1).Position(2) + 335;
ax2(2).Position(2) = ax2(2).Position(2) + 335;
ax2(3).Position(2) = ax2(3).Position(2) + 335;
pause(0.2)
ax3(1).Position(1) = ax1(1).Position(1);
ax3(1).Position(3) = ax3(1).Position(3) + 50;
ax3(2).Position(1) = ax3(2).Position(1) + 40;
pause(0.2)
uistack(ax1(2), 'top')
uistack(ax2(2), 'top')

% Set colormap on AVEC plot
colormap(ax2(1), winter(256))

% Set and tweak titles
set(findobj(allchild(fg), 'type', 'axes'), 'fontsize', 10)
set(ax3(1).Title, 'string', 'Carbon Mass Distributions')
set([ax1(1).Title, ax2(1).Title, ax3(1).Title], 'fontsize', 14, 'units', 'normalized', 'position', [0.5 1.04 0], 'fontweight', 'bold');
set([ax1(1).XLabel, ax2(1).XLabel, ax3(1).XLabel], 'fontsize', 12)

% Save
[~, name] = fileparts(xlsfile);
picfile = fullfile(fold, [name, '.png']);
print(fg, picfile, '-dpng', '-r600')
close(fg)

end