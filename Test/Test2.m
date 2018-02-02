%% Calib timing file , @author mbparsa, @version 11-07-2014
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');


%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
disp('Starting expt');
fixation_window=3;                                                                                                        

%Timing and check points
wait_for_fix=4000;                                                                                                          
hold_on_fix=1500;                                                                                                         
interval=2000;                                                                                                          

% Objects : Images and stimulus (Do not change these!)
fixation_point=1;                                                                                                    
o1 = 2;
o2 = 3;


set_iti(interval);

%Task
% 
% rad = 10;
% Theta = 1;
% Theta = Theta*pi/180;
% [x, y] = pol2cart(Theta, rad)
% repositionObject(fixation_point, x, y);
% repositionObject(object_1, x, y);
% disp([x, y])
% 
%toggleobject([fixation_point object_1]);
%Get initial fixation.
toggleobject(fixation_point);
if ~eyejoytrack('acquirefix', fixation_point, fixation_window, wait_for_fix)
   trialerror(4); 
   toggleobject(fixation_point);
   return;
end
disp('Fix Acquired');
% Check for fixation hold
if ~eyejoytrack('holdfix', fixation_point, fixation_window, interval)
   trialerror(3);
   toggleobject(fixation_point);
   return;
end

% Show objects
toggleobject(o1);
toggleobject(o2);
if ~eyejoytrack('holdfix', fixation_point, fixation_window, hold_on_fix)
   trialerror(3);
   toggleobject([fixation_point o1 o2]);
   return;
end
