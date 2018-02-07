%% Calib timing file , @author kirang/shuvrajitm, @version 02-05-2018
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');
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
FIX_PNT = 1;

%%% Stimuli to generate dynamically.

% Stimulus Object 1
Point1.Size = [10, 10];
Point1.Position = [0, 0];
Point1.Color = [1 1 1; 1 1 1];

% Stimulus Object 
Point2.Size = [10, 10];
Point2.Position = [0, 0];
Point2.Color = [1 1 1; 1 1 1];

Point1.Size = [10 10];
Point1.Position = [SCREEN_WIDTH/2 SCREEN_HEIGHT/2];
Point1.Color = [1 0 0; 1 0 0];

object1 = drawcircle(Point1, true);

new_pos = [10 10];

moveobject(object1, new_pos);
return;
%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
disp('Starting Experiment');
fixation_window=2;                                                                                                        


%Timing and check points
wait_for_fix=4000;                                                                                                          
hold_on_fix=1500;                                                                                                         
interval=3000;                                                                                                          

set_iti(interval);
%Task
toggleobject(fixation_point, 'status', 'on');


id = mgladdcircle([1 1 1; 1 1 1],[10 10]);        % add a circle
mglsetproperty(id,'origin',[1920/2 1080/2]);              % move the circle to the center

% toggleobject(fixation_point, 'status', 'on');
return;
% Acquire Fixation
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

% Show objects
toggleobject([o1 o2], 'status', 'on');
if ~eyejoytrack('holdfix', fixation_point, fixation_window, hold_on_fix)
   trialerror(BRK_FIXATION);
   toggleobject([o1 o2], 'status', 'off');
   return;
end

disp('Press Key');
scancode = '';
flag = 1;
time = 0;
while(flag)
    time = time + 50;
    scancode = getkeypress(50);
    fix_held = eyejoytrack('holdfix', fixation_point, fixation_window, 50);
    if (time > 2000 | scancode)
       flag = 0; 
    end
    if ~fix_held
        trialerror(BRK_FIXATION);
        return;
    end
end
% Left for 1.
if scancode ~= 203 & scancode ~= 205
   trialerror(NO_RESPONSE);
   disp('No or inappropriate response');
   return;
end

if TrialRecord.CurrentCondition == 1
    if  scancode == 203
       trialerror(CORRECT);
       toggleobject([o1, o2], 'status', 'off');
       disp('Correct response for 1 stimulus');
       return;
    else
        trailerror(INCORR_RESPONSE);
        toggleobject([o1, o2], 'status', 'off');
       disp('Incorrect response for 1 stimulus');
    end
end

if TrialRecord.CurrentCondition == 2
    if  scancode == 205
       trialerror(CORRECT);
       toggleobject([o1, o2], 'status', 'off');
       disp('Correct response for 2 stimuli');
       return;
    else
        trailerror(INCORR_RESPONSE);
        toggleobject([o1, o2], 'status', 'off');
       disp('Incorrect response for 2 stimuli');
    end
end
return;
%% 
function id = drawcircle(Circ, isActivated)
    id_ = mgladdcircle(Circ.Color, Circ.Size);      % add a circle
    mglsetproperty(id_,'origin', Circ.Position);              % move the circle to the center
    id = id_;
end

function moveobject(obj_id, pos)
    mglactivategraphic(obj_id,false);
    mglsetproperty(obj_id,'origin', pos);
    mglactivategraphic(obj_id, true);
end
