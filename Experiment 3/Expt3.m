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
%% Behaviour Codes
bhv_code(...
1,'Fixation On',...
2, 'Fixation Off',...
3, 'Stimulus On',...
4, 'Stimulus Off');
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
%% Responses
HORIZONTAL = 0;
VERTICAL = 1;
NA = 2;
%% TRIAL_DS
TDS.TrialNumber = 0;
TDS.Distances = 0;
%% VARIABLES
SUM_XY = 3;
X_THRESHOLD = 1.5;
TEMP_VAR_FNAME = 'var_f.mat';
%% Stimulii

Sucess = -2;
IPT = 4;

% TaskObjects from condition files
FP = 1;

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
Point3.Size = [0.1 0.1];
Point3.Position = [0 0];
Point3.Color = [1 0 0; 1 0 0];
%% %% Edit variables
% Location parameters
disp('Starting Experiment');
fixation_window = 2;                                                                                                        

%Timing and check points
wait_for_fix=4000;                                                                                                          
hold_on_fix=1500;                                                                                                         
interval=2000;                                                                                                          

set_iti(interval);

%% -------------------------------------------------------------------------
%Task

% if TrialRecord.IPT >= 0
%      if TrialRecord.CurrentTrialNumber <= 10
%         TrialRecord.IPT_mod = 0.5;
%         STEP_SIZE = 0.5;
%     elseif TrialRecord.CurrentTrialNumber > 10 && TrialRecord.CurrentTrialNumber <= 20
%         TrialRecord.IPT_mod = 0.25;
%         STEP_SIZE = 0.25;
%     else
%         TrialRecord.IPT_mod = 0.1;
%         STEP_SIZE = 0.1;
%     end
%     
%     if TrialRecord.CurrentTrialNumber > 1
%        if TrialRecord.TrialErrors(TrialRecord.CurrentTrialNumber - 1) == 0
%            TrialRecord.Success = 1;
%        elseif TrialRecord.TrialErrors(TrialRecord.CurrentTrialNumber - 1) == 6
%            TrialRecord.Success = 0;
%        end
%     end
%     if TrialRecord.IPT_mod < TrialRecord.IPT 
%         if TrialRecord.Success == 1
%            if TrialRecord.IPT + TrialRecord.IPT_mod < 3 
%                 TrialRecord.IPT = TrialRecord.IPT + TrialRecord.IPT_mod;
%            end
%        elseif TrialRecord.Success == 0
%         if (TrialRecord.IPT - TrialRecord.IPT_mod) > 0
%             TrialRecord.IPT = TrialRecord.IPT - TrialRecord.IPT_mod;
%         end
%     end
%         disp(TrialRecord.Success);
%         disp(TrialRecord.IPT);
%     end
% end


if TrialRecord.CurrentTrialNumber <= 10
    STEP_SIZE = 0.5;
elseif TrialRecord.CurrentTrialNumber > 10 && TrialRecord.CurrentTrialNumber <= 20
    STEP_SIZE = 0.25;
else
    STEP_SIZE = 0.1;
end

if TrialRecord.CurrentTrialNumber > 1
    if exist(TEMP_VAR_FNAME, 'file')
        load(TEMP_VAR_FNAME);
            if RESPONSE == HORIZONTAL
                if X_THRESHOLD + STEP_SIZE < SUM_XY
                    X_THRESHOLD = X_THRESHOLD + STEP_SIZE;
                end
            elseif RESPONSE == VERTICAL
               if X_THRESHOLD - STEP_SIZE > 0
                   X_THRESHOLD = X_THRESHOLD - STEP_SIZE;
               end
            end
        end
end



time_stamp = strsplit(char(datetime('now')));
time_stamp = time_stamp{1};
x_file = strcat(time_stamp, 'x_dist.mat');

if ~exist(x_file, 'file')
    t = X_THRESHOLD;
   save(x_file, 't'); 
else
   load(x_file);
   t = [t X_THRESHOLD];
   save(x_file, 't');
end

toggleobject(FP, 'status', 'on', 'eventmarker', 1);
% % Acquire Fixation
if ~eyejoytrack('acquirefix', FP, fixation_window, wait_for_fix)
   trialerror(NO_FIXATION); 
   return;
end
disp('Fix Acquired');

disp('Hold Fix Started');
% Check for fixation hold
if ~eyejoytrack('holdfix', FP, fixation_window, interval)
   trialerror(BRK_FIXATION);
   return;
end
disp('Hold Fix ended');

disp('Point displayed');
[ox, oy] = get_actual_pos(0, 0);
Point3.Position = [ox, oy];
[p1, p2, p3, p4] = get_corners([5, 5], X_THRESHOLD);
Point1.Position = p1;
Point2.Position = p3;

p_1 = drawcircle(Point1, true);
p_2 = drawcircle(Point2, true);
eventmarker(3);
pause(0.028)
mglactivategraphic([p_1 p_2], false);
% drawcircle(Point3, true);

Point1.Position = p2;
Point2.Position = p4;
p_1 = drawcircle(Point1, true);
p_2 = drawcircle(Point2, true);
pause(0.28)
mglactivategraphic([p_1 p_2], false);
eventmarker(4)
% drawcircle(Point3, true);
disp('Point display done');

disp('Press Key');
scancode = getkeypress(5000);

% Left for Horz.
if scancode ~= 203 & scancode ~= 205
    disp('Scancode is');
    disp(scancode);
   trialerror(INCORR_RESPONSE);
   RESPONSE = 2;
   disp('No or inappropriate response');
end

if  scancode == 203
   trialerror(CORRECT);
   RESPONSE = 0;
   disp('Response for Horizontal');
   TrailRecord.Success = 1;
elseif scancode == 205
    trialerror(CORRECT);
    RESPONSE = 1;
   disp('Response for Vertical');
end

save(TEMP_VAR_FNAME, 'RESPONSE', 'X_THRESHOLD');

% disp('Plotting');
% figure
% hold on
% plot(TrialRecord.TRIAL_DS.TrialNumber, TrialRecord.TRIAL_DS.Distances);
% ylim([0 5])
% figure

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