%% Expt2 timing file , @author kirang/shuvrajitm, @version 02-05-2018
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');
% editable('Success');
% editable('IPT');
%%-------------------------------------------------------------------------
%% Screen Size : Enter the same as selected in Monkey Logic 2
SCREEN_WIDTH    = 1920;
SCREEN_HEIGHT   = 1080;
%% Error Codes to be used for trial errors. As per documentation.
CORRECT         = 0;
NO_RESPONSE     = 1; 
BRK_FIXATION    = 3;
NO_FIXATION     = 4;
EARL_RESPONSE   = 5;
INCORR_RESPONSE = 6;
LEVER_BREAK     = 7;
IGNORED         = 8;
ABORT           = 9;
%% TRIAL_DS
TDS.TrialNumber = 0;
TDS.Distances = 0;
%% VARIABLES
TOTAL_NUM_TRIALS = 5;
%% Stimulii

Sucess = -2;
IPT = 4;

% TaskObjects from condition files
fixation_point = 1;

%%% Stimuli to generate dynamically.

% Stimulus Object 1
Point1.Size = [10, 10];
Point1.Position = [0, 0];
Point1.Color = [0 0 0; 0 0 0];

% Stimulus Object 2
Point2.Size = [10, 10];
Point2.Position = [0, 0];
Point2.Color = [0 0 0; 0 0 0];

% Hidden Object 3
Point3.Size = [10 10];
Point3.Position = [0 0];
Point3.Color = [1 0 0; 1 0 0];
%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
disp('Starting Experiment');
fixation_window = 2;                                                                                                        


%Timing and check points
wait_for_fix=4000;                                                                                                          
hold_on_fix=1500;                                                                                                         
interval=2000;                                                                                                          

set_iti(interval);
%Task
toggleobject(fixation_point, 'status', 'on');

% % Acquire Fixation
if ~eyejoytrack('acquirefix', fixation_point, fixation_window, wait_for_fix)
   trialerror(NO_FIXATION); 
   return;
end
disp('Fix Acquired');

disp('Hold Fix Started');
% Check for fixation hold
if ~eyejoytrack('holdfix', fixation_point, fixation_window, interval)
   trialerror(BRK_FIXATION);
   return;
end
disp('Hold Fix ended');

if TrialRecord.IPT >= 0
%     if TrialRecord.IPT > 2
%        TrialRecord.IPT_mod = 0.5; 
%     elseif TrialRecord.IPT < 2 & TrialRecord.IPT > 1.3
%        TrialRecord.IPT_mod = 0.1;     
%     elseif TrialRecord.IPT <= 1.3
%         TrialRecord.IPT_mod = 0.05;
%     end
    
    if TrialRecord.CurrentTrialNumber <= 6
        TrialRecord.IPT_mod = 0.5;
    elseif TrialRecord.CurrentTrialNumber > 6 && TrialRecord.CurrentTrialNumber <=14
        TrialRecord.IPT_mod = 0.25;
    else
        TrialRecord.IPT_mod = 0.1;
    end
    
    if TrialRecord.CurrentTrialNumber > 1
       if TrialRecord.TrialErrors(TrialRecord.CurrentTrialNumber - 1) == 0
           TrialRecord.Success = 1;
       elseif TrialRecord.TrialErrors(TrialRecord.CurrentTrialNumber - 1) == 6
           TrialRecord.Success = 0;
       end
    end
    
    if TrialRecord.Success == 1
       TrialRecord.IPT = TrialRecord.IPT + TrialRecord.IPT_mod;
    elseif TrialRecord.Success == 0
        TrialRecord.IPT = TrialRecord.IPT - TrialRecord.IPT_mod;
    end
    disp(TrialRecord.Success);
    disp(TrialRecord.IPT);
end


if class(TrialRecord.TRIAL_DS) == 'double'
   TrialRecord.TRIAL_DS = TDS;
   TrialRecord.TRIAL_DS.TrialNumber = [TrialRecord.CurrentTrialNumber];
   TrialRecord.TRIAL_DS.Distances = [TrialRecord.IPT];
else
    TrialRecord.TRIAL_DS.TrialNumber = [TrialRecord.TRIAL_DS.TrialNumber, TrialRecord.CurrentTrialNumber];
   TrialRecord.TRIAL_DS.Distances = [TrialRecord.TRIAL_DS.Distances, TrialRecord.IPT];
end

disp(TrialRecord.TRIAL_DS.TrialNumber);
disp(TrialRecord.TRIAL_DS.Distances);

disp('Point displayed');
[ox, oy] = get_actual_pos(0, 0);
Point3.Position = [ox, oy];

[p1, p2, p3, p4] = get_corners([5, 5], TrialRecord.IPT);
Point1.Position = p1;
Point2.Position = p3;

drawcircle(Point1, true);
drawcircle(Point2, true);
pause(0.025)
mglactivategraphic(0, false);
drawcircle(Point3, true);

Point1.Position = p2;
Point2.Position = p4;
% pause(0.025)
drawcircle(Point1, true);
drawcircle(Point2, true);
pause(0.25)
mglactivategraphic(0, false);
drawcircle(Point3, true);
disp('Point display done');
% Show objects
% toggleobject([o1 o2], 'status', 'on');
% if ~eyejoytrack('holdfix', fixation_point, fixation_window, hold_on_fix)
%    trialerror(BRK_FIXATION);
%    toggleobject([o1 o2], 'status', 'off');
%    return;
% end

disp('Press Key');
scancode = '';
flag = 1;
time = 0;
tim_del = 10;
while(flag)
    time = time + tim_del;
    scancode = getkeypress(tim_del/2);
    fix_held = eyejoytrack('holdfix', fixation_point, fixation_window, tim_del/2);
%     disp('Key and time: ');
%     disp(temp);
    if time > 5000 | scancode > 0
       flag = 0; 
    end
    
%     disp('Fix');
%     disp(fix_held);
%     if ~fix_held
%         trialerror(BRK_FIXATION);
%         return;
%     end
end

mglactivategraphic(0, false);
drawcircle(Point3, true);

% Left for Horz.
if scancode ~= 203 & scancode ~= 205
    disp('Scancode is');
    disp(scancode);
   trialerror(NO_RESPONSE);
   disp('No or inappropriate response');
   TrialRecord.Success = -1;
   return;
end

if  scancode == 203
   trialerror(CORRECT);
   disp('response for Horizontal');
   TrailRecord.Success = 1;
   return;
elseif scancode == 205
    trialerror(INCORR_RESPONSE);
   disp('response for Vertical');
   TrailRecord.Success = 0;
end

disp('Plotting');
figure
hold on
plot(TrialRecord.TRIAL_DS.TrialNumber, TrialRecord.TRIAL_DS.Distances);
ylim([0 5])
figure

return;
%% 
function id = drawcircle(Circ, isActivated)
    id_ = mgladdcircle(Circ.Color, Circ.Size);      % add a circle
    mglsetproperty(id_,'origin', Circ.Position);
    mglactivategraphic(id_, true);
    mglrendergraphic();
    mglpresent();
    id = id_;
end



function [x, y] = get_actual_pos(X, Y)
    % Convert visual angle to pixels. 1deg = 33.4291pixels
    X = X*35.496;
    Y = Y*35.496;

    X = SCREEN_WIDTH/2 + X;
    Y = SCREEN_HEIGHT/2 + Y;
    x = X;
    y = Y;
end

function [x, y] = get_actual_pos2(list)
    % Convert visual angle to pixels. 1deg = 33.4291pixels
    X = list(1)*35.496;
    Y = list(2)*35.496;

    X = SCREEN_WIDTH/2 + X;
    Y = SCREEN_HEIGHT/2 + Y;
    x = X;
    y = Y;
end

function [p1, p2, p3, p4] = get_corners(list, x_len)
    x = list(1);
    y = list(2);
    y_len = 3 - x_len;
    
    p1 = [x - x_len/2, y - y_len/2];
    p2 = [x + x_len/2, y - y_len/2];
    p3 = [x + x_len/2, y + y_len/2];
    p4 = [x - x_len/2, y + y_len/2];
    
    [a, b] = get_actual_pos2(p1);
    p1 = [a, b];
    [a, b] = get_actual_pos2(p2);
    p2 = [a, b];
    [a, b] = get_actual_pos2(p3);
    p3 = [a, b];
    [a, b] = get_actual_pos2(p4);
    p4 = [a, b];
end