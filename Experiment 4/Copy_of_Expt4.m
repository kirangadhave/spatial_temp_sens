%% Expt2 timing file , @author kirang/shuvrajitm, @version 02-05-2018
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');
% editable('Success');
% editable('IPT');

Sucess = -2;
IPT = 4;

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
% TDS.Success = -1;
% TDS.IPT = -1;
% TDS.IPT_mod = -1;
%% VARIABLES
TOTAL_NUM_TRIALS = 20;
FIXATION_WINDOW = 2;  
THRESHOLD_X = 2;
TOTAL_SUM = 3;
%% TIMING
WAIT_FOR_FIX    = 4000;                                                                                                          
HOLD_FIX        = 1500;                                                                                                         
INTERVAL        = 2000;                                                                                                          

%% Stimulii
% TaskObjects from condition files
FP1 = 1;
FP2 = 2;

%%% Stimuli to generate from MonkeyLogic Graphics Library.
% Stimulus Object 1
Point1.Size = [10, 10];
Point1.Position = [0, 0];
Point1.Color = [0 0 0; 0 0 0];

% Stimulus Object 2
Point2.Size = [10, 10];
Point2.Position = [0, 0];
Point2.Color = [0 0 0; 0 0 0];
%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
disp('Starting Experiment');
%Timing and check points

set_iti(INTERVAL);
%Task

drawFixation([FP1, FP2]);

% % Acquire Fixation
if ~eyejoytrack('acquirefix', FP1, FIXATION_WINDOW, WAIT_FOR_FIX)
   trialerror(NO_FIXATION); 
   return;
end
disp('Fix Acquired');

disp('Hold Fix Started');
% Check for fixation hold
if ~eyejoytrack('holdfix', FP1, FIXATION_WINDOW, HOLD_FIX)
   trialerror(BRK_FIXATION);
   return;
end
disp('Hold Fix ended');

if TrialRecord.CurrentTrialNumber == 2
    THRESHOLD_X = THRESHOLD_X - 0.25;
elseif TrialRecord.CurrentTrialNumber == 3
    THRESHOLD_X = THRESHOLD_X + 0.25;
end

if class(TrialRecord.TRIAL_DS) == 'double'
   TrialRecord.TRIAL_DS = TDS;
   TrialRecord.TRIAL_DS.TrialNumber = [TrialRecord.CurrentTrialNumber];
   TrialRecord.TRIAL_DS.Distances = THRESHOLD_X;
else
   TrialRecord.TRIAL_DS.TrialNumber = [TrialRecord.TRIAL_DS.TrialNumber, TrialRecord.CurrentTrialNumber];
   TrialRecord.TRIAL_DS.Distances = [TrialRecord.TRIAL_DS.Distances, THRESHOLD_X];
end

disp(TrialRecord.TRIAL_DS.TrialNumber);
disp(TrialRecord.TRIAL_DS.Distances);

disp('Stimulus Begin');
[p1, p2, p3, p4] = get_corners([5, 5], THRESHOLD_X);
Point1.Position = p1;
Point2.Position = p3;

hideFixation(FP1);
pause(0.25);
p_1 = drawcircle(Point1, true);
p_2 = drawcircle(Point2, true);
pause(0.025)
mglactivategraphic([p_1, p_2], false);
drawFixation(FP2);

Point1.Position = p2;
Point2.Position = p4;
% pause(0.025)
p_1 = drawcircle(Point1, true);
p_2 = drawcircle(Point2, true);
pause(0.25)
mglactivategraphic([p_1, p_2], false);
drawFixation(FP2);
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
    fix_held = eyejoytrack('holdfix', FP1, FIXATION_WINDOW, tim_del/2);
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

mglactivategraphic([p_1, p_2], false);
drawFixation(FP2);
% Left for Horz.
if scancode ~= 203 & scancode ~= 205
    disp('Scancode is');
    disp(scancode);
   trialerror(NO_RESPONSE);
   disp('No or inappropriate response');
   TrialRecord.Success = -1;
   return;
end

v

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


function drawFixation(list)
    for x = list
        toggleobject(x, 'status', 'on'); 
    end
    mglrendergraphic();
    mglpresent();
end

function hideFixation(list)
    for x = list
        toggleobject(x, 'status', 'off'); 
    end
    mglrendergraphic();
    mglpresent();
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
    y_len = TOTAL_SUM - x_len;
    
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