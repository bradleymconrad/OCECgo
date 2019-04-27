function OCECgo_Validate_Analysis(h)
% This function validates the user-provided analysis data.

%% GET TAG INDEX
Dat.TagIndex = get(findobj(h, 'tag', 'Dat_TagOpts'), 'value');

%% GET LASER CORRECTION TYPE
switch get(get(findobj(allchild(h), 'tag', 'Dat_Laser'), 'selectedobject'), 'string')
    case 'Quadratic correction'
        Dat.LaserCorrType = 'purequadratic';
    otherwise
        Dat.LaserCorrType = 'linear';
end

%% GET / VALIDATE MASS CALIBRATION TO USE

% Get data
Dat.Cal_Mu = str2double(get(findobj(allchild(h), 'tag', 'Dat_Cal_Mu'), 'string'));
Dat.Cal_Sg = str2double(get(findobj(allchild(h), 'tag', 'Dat_Cal_Sg'), 'string'));
Dat.Cal_Nu = str2double(get(findobj(allchild(h), 'tag', 'Dat_Cal_Nu'), 'string'));
Dat.Cal_Rep = str2double(get(findobj(allchild(h), 'tag', 'Dat_Cal_Rep'), 'string'));

% Ensure mass calibration exists
if any(isnan([Dat.Cal_Mu Dat.Cal_Sg Dat.Cal_Nu]))
    uiwait(msgbox('Mass calibration distribution parameters do not exist! Try again.', 'Error', 'error', 'modal'))
    error('OCEC_Tool:Analysis:BadCalDist', 'Mass calibration distribution parameters do not exist!')
end

% Ensure mass calibration is valid
if any([Dat.Cal_Mu Dat.Cal_Sg Dat.Cal_Nu] <= 0)
    uiwait(msgbox('Mass calibration distribution parameters must be positive! Try again.', 'Error', 'error', 'modal'))
    error('OCEC_Tool:Analysis:BadCalDist', 'Mass calibration distribution parameters must be positive!')
end

% Ensure repeatability is non-negative
if Dat.Cal_Rep < 0
    uiwait(msgbox('Mass calibration repeatability must be positive! Try again.', 'Error', 'error', 'modal'))
    error('OCEC_Tool:Analysis:BadCalRep', 'Mass calibration repeatabilitymust be positive!')
end

%% GET / VALIDATE MANUAL SPLIT POINT DATA
if ~get(findobj(allchild(h), 'tag', 'Dat_Split'), 'value')
    Dat.Split_Ctr = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_ctr'), 'string'));
    Dat.Split_Wid = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_wid'), 'string'));
    Dat.Split_Att = str2double(get(findobj(allchild(h), 'tag', 'Dat_Split_Ao'), 'string'));
end
% Note: constraint of inputs negates the need to validate split point data
% at this point

%% GET / VALIDATE INSTRUMENT PRECISION
if str2double(get(findobj(allchild(h), 'tag', 'Dat_MC_InstPrec'), 'string')) < 0
    uiwait(msgbox('Instrument precision must be non-negative! Try again.', 'Error', 'error', 'modal'))
    error('OCEC_Tool:Analysis:BadInstPrec', 'Instrument precision must be non-negative!')
end

%% UPDATE USERDATA
fn = fieldnames(Dat);
for i = 1 : length(fn)
    h.UserData.Dat.(fn{i}) = Dat.(fn{i});
end

end