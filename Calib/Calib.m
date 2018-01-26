%% Calib timing file , @author mbparsa, @version 11-07-2014
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');


%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
fixationWindow=3;                                                                                                       % Fixation window size 
stimRadius=10;                                                                                                          % Stim radius on screen 

%Timing and check points
wait4fix=4000;                                                                                                          % Waiting time for fixation
holdonFix=1500;                                                                                                         % Holding on fixation 
StimulationTime=100;																										% Time of stimulation                                                                                                 % Delay after reward
delayAfterReward= 500; 
interval=1000;                                                                                                          % Interval between trials


% Reward variables
goodboy=150;                                                                                                            % Reward duration

% Objects : Images and stimulus (Do not change these!)
fixationPoint=1;                                                                                                        % FixSpot image
StmI=2;                                                                                                                 % Stimulation inntiated
Stimulation=3;                                                                                                          % Stimulation 
StmT=4;                                                                                                                 % Stimulation Terminated

%%-------------------------------------------------------------------------
%% Pre-Trial calculations and loadings

if TrialRecord.CurrentBlock==2 && TrialRecord.CurrentCondition>1,
    Theta=((TrialRecord.CurrentCondition)-2)*90;
    Theta=(Theta*(pi/180)); 
    [x ,y]=pol2cart(Theta,stimRadius);                                                                                % Getting x,y from R and Theta
    reposition_object(fixationPoint,x,y);
end

% Setting up event codes and loadings

set_iti(interval);                                                                                                      % Interval between trials
hotkey('g',['x=','1;']);
eventmarker(100);                                                                                                       % Task name 
eventmarker(50+TrialRecord.CurrentCondition);                                                                           % Send condition number event
eventmarker(TrialRecord.CurrentBlock+47);																				% Block number

%%-------------------------------------------------------------------------
%%  Fixation Stage(1) 

toggleobject(fixationPoint, 'eventmarker',1);                                                                          % FixSpot on
ontarget = eyejoytrack('acquirefix', fixationPoint, fixationWindow, wait4fix);
if ~ontarget,
    eventmarker(36);                                                                                                   % Did Not Fixate
	toggleobject(fixationPoint, 'eventmarker',10 ,'status','off');                                                     % FixSpot off
    trialerror(4);                                                                                                     % Not fixted
	return 
end
eventmarker(2);                                                                                                        % Entered Fixation Window
ontarget = eyejoytrack('holdfix', fixationPoint, fixationWindow, holdonFix);                                           % Holding fixation point 
if ~ontarget,
	eventmarker(14);                                                                                                   % Broke fixation
    toggleobject(fixationPoint, 'eventmarker',10 ,'status','off');                                                     % FixSpot off
    trialerror(3);                                                                                                     % Broke fixation
    return
end
eventmarker(28);                                                                                                       % Hold On Fixation Point

%%-------------------------------------------------------------------------
%%  Stimulation stage(2) optional. 
%   For stimating you should select first block from monkeylogic menu  

if TrialRecord.CurrentBlock==1,
    toggleobject(Stimulation,'eventmarker',37);
	StimBegin=trialtime;
	while(trialtime-StimBegin<StimulationTime)
		ontarget = eyejoytrack('acquirefix', 1,0.1, 1);
	end
	toggleobject(Stimulation);
end

%eventmarker([31,37,35]); %Stimualation

%%-------------------------------------------------------------------------
%%  Trial is correct: Reward & Reinforcement -Stage(7)
eventmarker(15); trialerror(0); 																					    % Correct Trials
[analogdata frq]=get_analog_data('photodiode',1);
if round(analogdata)>0
	pause(0.5);
	disp('pause');
	eventmarker(22); 																									% Reward Initiated
	goodmonkey(goodboy, 'NumReward', 2, 'PauseTime',150); 																% Deliver reward
else
	eventmarker(22); 																									% Reward Initiated
	goodmonkey(goodboy, 'NumReward', 2, 'PauseTime',150); 																% Deliver reward
end
eventmarker(23);                                                                                                        % Reward Terminated
toggleobject(fixationPoint, 'eventmarker',10 ,'status','off');                                                          % FixSpot off 
eventmarker(29);                                                                                                        % Delay Period Initiated 
DelayBegin=trialtime;
while(trialtime-DelayBegin<delayAfterReward)
	ontarget = eyejoytrack('acquirefix', 1,0.1, 1);
end
eventmarker(30);                                                                                                        % Delay Period Terminated