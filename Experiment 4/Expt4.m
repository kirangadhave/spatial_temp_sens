%% Expt2 timing file , @author kirang/shuvrajitm, @version 02-05-2018
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');
% editable('Success');
% editable('IPT');
tic
Sucess = -2;
IPT = 4;
bhv_code(...
1,'Fixation On',...
2, 'Fixation Off',...
3, 'Stimulus On',...
4, 'Target Off',...
21, 'C1 - Horz',...
22, 'C1 - Vert',...
23, 'C2 - Horz',...
24, 'C2 - Vert',...
25, 'C3 - Horz',...
26, 'C3 - Vert');
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
FIXATION_WINDOW = 2.5;  
THRESHOLD_X = 1.15;
TOTAL_SUM = 3;
MAX_RXN_TIME = 5000;
%% TIMING
WAIT_FOR_FIX    = 4000;                                                                                                          
HOLD_FIX        = 1500;                                                                                                         
INTERVAL        = 2000;                                                                                                          

STIM_INTERVAL   = 0.251;
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
%% Set up experiment
disp('Starting Experiment');
set_iti(INTERVAL);
%% Get Fixation and Hold

% drawFixation([FP1, FP2]);
toggleobject([FP1, FP2], 'status', 'on', 'eventmarker', 1);
% Get fixation on FP1
if ~eyejoytrack('acquirefix', FP1, FIXATION_WINDOW, WAIT_FOR_FIX)
    trialerror(NO_FIXATION);
        return;
end

% Check for hold on fixation
if ~eyejoytrack('holdfix', FP1, FIXATION_WINDOW, HOLD_FIX)
   trialerror(BRK_FIXATION);
    return;
end
%% Check Condition and set up Threshold
% The first condition is no change in threshold.
if TrialRecord.CurrentCondition == 2
    THRESHOLD_X = THRESHOLD_X - 0.25;
elseif TrialRecord.CurrentCondition == 3
    THRESHOLD_X = THRESHOLD_X + 0.25;
end
%% Initialize and update TRIAL_DS
if class(TrialRecord.TRIAL_DS) == 'double'
    TDS.ZERO = 0;
    TDS.PLUS = 0;
    TDS.MINUS = 0;
    TDS.ZERO_TOT = 0;
    TDS.PLUS_TOT = 0;
    TDS.MINUS_TOT = 0;
    
    TDS.LastTrialStimTime = -1;
    TDS.Eye_Stim_Data = [];
   TrialRecord.TRIAL_DS = TDS;
   TrialRecord.TRIAL_DS.TrialNumber = [TrialRecord.CurrentTrialNumber];
   TrialRecord.TRIAL_DS.Distances = THRESHOLD_X;
   
else
   TrialRecord.TRIAL_DS.TrialNumber = [TrialRecord.TRIAL_DS.TrialNumber, TrialRecord.CurrentTrialNumber];
   TrialRecord.TRIAL_DS.Distances = [TrialRecord.TRIAL_DS.Distances, THRESHOLD_X];
end

% disp(TrialRecord.TRIAL_DS.TrialNumber);
% disp(TrialRecord.TRIAL_DS.Distances);
%% Setup Stimulii
[p1, p2, p3, p4] = get_corners([5, 5], THRESHOLD_X);
Point1.Position = p1;
Point2.Position = p3;

% Hide Fixation Point 1
toggleobject(FP1, 'status', 'off', 'eventmarker', 2);
jitter = randi([-50, 80]);
pause(STIM_INTERVAL + jitter/1000); % Wait for eye to get used to.
p_1 = drawcircle(Point1, true); 
p_2 = drawcircle(Point2, true);
eventmarker(3);
pause(0.028);
mglactivategraphic([p_1, p_2], false);
%toggleobject(FP2, 'status', 'on', 'eventmarker', 1);
Point1.Position = p2;
Point2.Position = p4;
p_1 = drawcircle(Point1, true);
p_2 = drawcircle(Point2, true);
pause(0.28);
mglactivategraphic([p_1, p_2], false);
fix_held = eyejoytrack('holdfix', FP2, FIXATION_WINDOW, 2000);
if ~fix_held
   trialerror(BRK_FIXATION);
   return;
end
toggleobject(FP2, 'status', 'off');
scancode = getkeypress(MAX_RXN_TIME);
%% Was appropriate response received?
if scancode ~= 203 & scancode ~= 205
    disp('Scancode is');
    disp(scancode);
   trialerror(NO_RESPONSE);
   disp('No or inappropriate response');
   return;
end


%% If yes what?
% Left for horizontal
disp(scancode);
if  scancode == 203
    if TrialRecord.CurrentCondition == 1
        eventmarker(21);
    elseif TrialRecord.CurrentCondition == 2
        eventmarker(23);
    else
        eventmarker(25);
    end
    eventmarker(15);
    trialerror(0);
elseif scancode == 205
    if TrialRecord.CurrentCondition == 1
        eventmarker(22);
    elseif TrialRecord.CurrentCondition == 2
        eventmarker(24);
    else
        eventmarker(26);
    end
    eventmarker(15);
    trialerror(0);
end


return;
%% Functions
function id = drawcircle(Circ, isActivated)
    id_ = mgladdcircle(Circ.Color, Circ.Size);      % add a circle
    mglsetproperty(id_,'origin', Circ.Position);
    mglactivategraphic(id_, true);
    mglrendergraphic();
    mglpresent();
    id = id_;
end


% function drawFixation(list)
%     for x = list
%         toggleobject(x, 'status', 'on'); 
%     end
%     mglrendergraphic();
%     mglpresent();
% end

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