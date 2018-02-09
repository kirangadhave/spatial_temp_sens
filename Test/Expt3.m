%% Expt2 timing file , @author kirang/shuvrajitm, @version 02-05-2018
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');
editable('Success');
editable('IPT');
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
%% Stimulii

% TaskObjects from condition files
fixation_point = 1;

%%% Stimuli to generate dynamically.

% Stimulus Object 1
Point1.Size = [10, 10];
Point1.Position = [0, 0];
Point1.Color = [1 1 1; 1 1 1];

% Stimulus Object 2
Point2.Size = [10, 10];
Point2.Position = [0, 0];
Point2.Color = [1 1 1; 1 1 1];

%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
disp('Starting Experiment');
fixation_window = 2;                                                                                                        
Success = 0;
IPT = 2;

%Timing and check points
wait_for_fix=4000;                                                                                                          
hold_on_fix=1500;                                                                                                         
interval=2000;                                                                                                          

set_iti(interval);
%Task
toggleobject(fixation_point, 'status', 'on');

% Acquire Fixation
% if ~eyejoytrack('acquirefix', fixation_point, fixation_window, wait_for_fix)
%    trialerror(NO_FIXATION); 
%    return;
% end
% disp('Fix Acquired');
% 
% disp('Hold Fix Started');
% % Check for fixation hold
% if ~eyejoytrack('holdfix', fixation_point, fixation_window, interval)
%    trialerror(BRK_FIXATION);
%    return;
% end
% disp('Hold Fix ended');
success = 0;

if TrialRecord.IPT > 0
    if TrialRecord.IPT > 2
       TrialRecord.IPT_mod = 0.5; 
    elseif TrialRecord.IPT < 2 & TrialRecord.IPT > 1.3
       TrialRecord.IPT_mod = 0.05;     
    elseif TrialRecord.IPT <= 1.3
        TrialRecord.IPT_mod = 0;
    end
    
    if TrialRecord.Success
       TrialRecord.IPT = TrialRecord.IPT - TrialRecord.IPT_mod;
    else
        TrialRecord.IPT = TrialRecord.IPT + TrialRecord.IPT_mod;
    end
    
    if TrialRecord.IPT <= 1.3
       arr = [1.0, 1.1, 1.2, 1.3, 1.4];
       TrialRecord.IPT = arr(randi(size(arr)));
       disp(TrialRecord.IPT);
    end
    ipt_distance = TrialRecord.IPT;
end


disp('Point displayed');
if TrialRecord.CurrentCondition == 1
    [x, y] = get_actual_pos(10, 10);
    Point1.Position = [x, y];
    drawcircle(Point1, true);
elseif TrialRecord.CurrentCondition == 2
    [x, y] = get_actual_pos(10, 10);
    Point1.Position = [x, y];
    
    [x, y] = get_actual_pos(10 + ipt_distance, 10);
    Point2.Position = [x, y];
    
    drawcircle(Point1, true);
    drawcircle(Point2, true);
end
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
%     fix_held = eyejoytrack('holdfix', fixation_point, fixation_window, tim_del/2);
%     disp('Key and time: ');
%     disp(temp);
    if time > 4000 | scancode > 0
       flag = 0; 
    end
    
%     disp('Fix');
%     disp(fix_held);
%     if ~fix_held
%         trialerror(BRK_FIXATION);
%         return;
%     end
end

TrialRecord.Success = 0;
TrialRecord.IPT = ipt_distance;
mglactivategraphic(0, false);
% Left for 1.
if scancode ~= 203 & scancode ~= 205
    disp('Scancode is');
    disp(scancode);
   trialerror(NO_RESPONSE);
   disp('No or inappropriate response');
   return;
end

if TrialRecord.CurrentCondition == 1
    TrialRecord.Success = 0;
    if  scancode == 203
       trialerror(CORRECT);
       disp('Correct response for 1 stimulus');
       return;
    else
        trialerror(INCORR_RESPONSE);
       disp('Incorrect response for 1 stimulus');
    end
end

if TrialRecord.CurrentCondition == 2
    if  scancode == 205
       trialerror(CORRECT);
       disp('Correct response for 2 stimuli');
       TrialRecord.Success = 1;
       return;
    else
       trialerror(INCORR_RESPONSE);
       disp('Incorrect response for 2 stimuli');
    end
end
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

function moveobject(obj_id, pos)
    mglactivategraphic(obj_id,false);
    mglsetproperty(obj_id,'origin', pos);
    mglactivategraphic(obj_id, true);
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
