%% Calib timing file , @author mbparsa, @version 11-07-2014
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');


%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
fixation_window=3;                                                                                                        

%Timing and check points
wait_for_fix=4000;                                                                                                          
hold_on_fix=1500;                                                                                                         
interval=1000;                                                                                                          

% Objects : Images and stimulus (Do not change these!)
fixation_point=1;                                                                                                    
object_1 = 2;
object_3 = 2;

%Task

%Get initial fixation.
toggleobject(fixation_point);
if ~eyejoytrack('acquirefix', fixation_point, fixation_window, wait_for_fix)
   trialerror(4); 
   toggleobject(fixation_point);
   return;
end

% Check for fixation hold
if ~eyejoytrack('holdfix', fixation_point, fixation_window, interval)
   trialerror(3);
   toggleobject(fixation_point);
   return;
end

% Show first object
toggleobject(object_1);
if ~eyejoytrack('holdfix', fixation_point, fixation_window, hold_on_fix)
   trialerror(3);
   toggleobject([fixation_point object_1]);
   return;
end
