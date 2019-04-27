function OCECgo_Validate_Calibration(h)
% This function validates the user-provided calibration data.

%% GET / VALIDATE DATA TABLE

% Get data
Cal.Table = get(findobj(h, 'tag', 'Cal_Table'), 'data');

% Remove all NaN rows
Cal.Table = Cal.Table(~any(isnan(Cal.Table), 2), :);
set(findobj(allchild(h), 'tag', 'Cal_Table'), 'Data', Cal.Table)

% Find good indices (i.e., no NaN values, and desired for use (column 4))
good = find(and(sum(~isnan(Cal.Table), 2) == 4, Cal.Table(:, 4) == 1));

% Ensure at least three valid data points exist
if length(good) < 3
    uiwait(msgbox('Must provide at least three data points for use in calibration! Try again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Calibrate:InsuffData', 'Must provide at least 3 data points for use in calibration!')
end

% Ensure all volumes are 0, 5, or 10
if ~all(sum(~bsxfun(@minus, Cal.Table(:, 1), [0, 5, 10]), 2))
    uiwait(msgbox('Volumes of Sucrose Solution must be 0, 5, or 10 uL! Try Again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Calibrate:BadVolume', 'Sucrose volume must be in {0, 5, 10}!')
end

% Ensure at least one volume is zero
if ~any(~Cal.Table(:, 1))
    uiwait(msgbox('Must include at least one blank calibration point! Try Again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Calibrate:NoBlank', 'Must include at least one blank calibration point!')
end

% Save table for analysis (i.e., do not delete unused data)
Cal.Table4Analysis = Cal.Table(good, :);

% Remove NaN rows
Cal.Table = Cal.Table(all(~isnan(Cal.Table(:, 1:3)), 2), :);

%% GET / VALIDATE SUCROSE MIXTURE DATA

% Get data
Cal.Suc_Ms = str2double(get(findobj(allchild(h), 'tag', 'Cal_Suc_Ms'), 'string'));
Cal.Suc_Mw = str2double(get(findobj(allchild(h), 'tag', 'Cal_Suc_Mw'), 'string'));
Cal.Suc_Pure = str2double(get(findobj(allchild(h), 'tag', 'Cal_Suc_Pure'), 'string'));
Cal.Suc_Scale = str2double(get(findobj(allchild(h), 'tag', 'Cal_Suc_Scale'), 'string'));
Cal.Suc_T1 = str2double(get(findobj(allchild(h), 'tag', 'Cal_Suc_T1'), 'string'));
Cal.Suc_T2 = str2double(get(findobj(allchild(h), 'tag', 'Cal_Suc_T2'), 'string'));

% Ensure solution masses are non-negative
if or(Cal.Suc_Ms <= 0, Cal.Suc_Mw <= 0)
    uiwait(msgbox('Sucrose / water masses must be positive! Try again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Calibrate:NonPosSolution', 'Sucrose / water masses must be positive!')
end

% Ensure scale bias is non-negative
if Cal.Suc_Scale < 0
    uiwait(msgbox('Scale bias must be non-negative! Defaulting to 0%.', 'Warning', 'warn', 'Modal'))
    Cal.Suc_Scale = 0;
    set(findobj(allchild(h), 'tag', 'Cal_Suc_Scale'), 'string', '0.000')
end

% Ensure sucrose purity is realistic
if Cal.Suc_Pure > 100
    uiwait(msgbox('Sucrose purity is greater than 100%! Defaulting to 100%.', 'Warning', 'warn', 'Modal'))
    Cal.Suc_Pure = 100;
    set(findobj(allchild(h), 'tag', 'Cal_Suc_Pure'), 'string', '100.0')
elseif Cal.Suc_Pure < 99
    uiwait(msgbox('Sucrose purity seems low! Minimum purity of 99% is recommended.', 'Warning', 'Warn', 'Modal'))
end

% Ambient temperatue range - flip if out of order
if Cal.Suc_T1 > Cal.Suc_T2
    low = get(findobj(allchild(h), 'tag', 'Cal_Suc_T2'), 'string');
    hig = get(findobj(allchild(h), 'tag', 'Cal_Suc_T1'), 'string');
    set(findobj(allchild(h), 'tag', 'Cal_Suc_T1'), 'string', low)
    set(findobj(allchild(h), 'tag', 'Cal_Suc_T2'), 'string', hig)
    low = Cal.Suc_T1;
    hig = Cal.Suc_T2;
    Cal.Suc_T1 = hig;
    Cal.Suc_T2 = low;
end

% Ambient temperature range - ensure realistic values
if or(Cal.Suc_T1 <= 0, Cal.Suc_T2 >= 60)
    uiwait(msgbox('Ambient temperature must be in (0, 60)! Try again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Calibrate:AmbientTemp', 'Ambient temperature must be in (0, 60)!')
elseif or(Cal.Suc_T1 < 15, Cal.Suc_T2 > 30)
    uiwait(msgbox('Ambient temperature data seems extreme! Results may be suspect.', 'Warning', 'Warn', 'Modal'))
end

%% GET / VALIDATE PIPETTE UNCERTAINTIES

% Get data
Cal.Pip_b05(1) = str2double(get(findobj(h, 'tag', 'Cal_Pip_b05a'), 'string'));
Cal.Pip_b05(2) = str2double(get(findobj(h, 'tag', 'Cal_Pip_b05b'), 'string'));
Cal.Pip_b10(1) = str2double(get(findobj(h, 'tag', 'Cal_Pip_b10a'), 'string'));
Cal.Pip_b10(2) = str2double(get(findobj(h, 'tag', 'Cal_Pip_b10b'), 'string'));
Cal.Pip_p05(1) = str2double(get(findobj(h, 'tag', 'Cal_Pip_p05a'), 'string'));
Cal.Pip_p05(2) = str2double(get(findobj(h, 'tag', 'Cal_Pip_p05b'), 'string'));
Cal.Pip_p10(1) = str2double(get(findobj(h, 'tag', 'Cal_Pip_p10a'), 'string'));
Cal.Pip_p10(2) = str2double(get(findobj(h, 'tag', 'Cal_Pip_p10b'), 'string'));

% Test pipette uncertainties are reasonable (in [0, 10])
pipdat = [Cal.Pip_b05 Cal.Pip_b10 Cal.Pip_p05 Cal.Pip_p10];
if any(pipdat < 0)
    uiwait(msgbox('Pipetter uncertainties must be non-negative! Try again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Calibrate:NonPosPipette', 'Pipetter uncertainties must be positive!')
elseif any(pipdat > 10)
    uiwait(msgbox('Pipetter uncertainties seem large! Results may be suspect.', 'Warning', 'warn', 'Modal'))
end

%% GET / VALIDATE MONTE CARLO DATA

% Get data
Cal.MC_nd = str2double(get(findobj(h, 'tag', 'Cal_MC_nd'), 'string'));

% Validate
if ~~mod(Cal.MC_nd, 1) % Is integer
    uiwait(msgbox('# MC draws must be an integer! Rounding given value.', 'Warning', 'warn', 'Modal'))
    Cal.MC_nd = round(Cal.MC_nd);
    set(findobj(allchild(h), 'tag', 'Cal_MC_nd'), 'string', num2str(Cal.Cal_MC_nd, '%u'))
elseif Cal.MC_nd < 1e2 % Fix if too low
    uiwait(msgbox('# MC draws is too low, result will be inconsistent! Defaulting to minimum value.', 'Warning', 'warn', 'Modal'))
    Cal.MC_nd = 1e2;
    set(findobj(allchild(h), 'tag', 'Cal_MC_nd'), 'string', '100')
elseif Cal.MC_nd < 1e4 % Warn if too low
    uiwait(msgbox('# MC draws is low! Result may be inconsistent.', 'Warning', 'warn', 'Modal'))
elseif Cal.MC_nd  > 1e8 % Error if too high
    uiwait(msgbox('# of MC draws is large, maximum allowed is 10^8!! Try again.', 'Error', 'Error', 'Modal'))
    error('OCECgo:Calibrate:MCLargeAutoStop', 'Operation stopped due to large MC draws!')
elseif Cal.MC_nd > 1e6 % Warn if too high
    quest = '# of Monte Carlo draws is large, the application may run into memory limitations and may run slowly. Would you like to continue?';
    tit = '# of MC Draws Large';
    slc = questdlg(quest, tit, 'Yes', 'No', 'Use Default', 'No');
    switch slc
        case 'No' % Raise error to stop calculation
            error('OCECgo:Calibrate:MCLargeUserStop', 'Operation stopped by user!')
        case 'Use Default' % Default to 10^6
            Cal.MC_nd = 1e6;
            set(findobj(allchild(h), 'tag', 'Cal_MC_nd'), 'string', '1000000')
    end
end

% Update user data
h.UserData.Cal = Cal;

end