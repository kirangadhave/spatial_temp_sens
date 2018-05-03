function [C,timingfile,userdefined_trialholder] = movie_userloop(MLConfig,TrialRecord)

% return values
C = [];
timingfile = 'movie.m';
userdefined_trialholder = '';

% stimulus list
stim = {'mov(initializing.avi,4,4)', ...
    'mov(initializing.avi,4,-4)', ...
    'mov(initializing.avi,-4,4)', ...
    'mov(initializing.avi,-4,-4)'};

% pre-loading movies and the runtime
%
% Store the created objects in a persistent variable so that we can keep them.
% This needs to be done only once, so we do it only when the persistent
% variable is empty. Also, to maximize the advantage of pre-loading stimuli,
% we can generate the runtime beforehand (which is always the case when you
% use the conditions file).
persistent TaskObject RunTime
if isempty(TaskObject)
    TaskObject = mltaskobject(stim,MLConfig,TrialRecord);
    RunTime = get_function_handle(embed_timingfile(MLConfig,timingfile,userdefined_trialholder));
    return
end

% For a demonstration, switch between newly created stimuli and pre-loaded
% stimuli every 5 trials.
trial = mod(floor(TrialRecord.CurrentTrialNumber/5),2);
if 0==trial
    % return raw stimulus strings
    %
    % They will be newly created before the trial starts.
    C = stim;
    TrialRecord.User.PreloadStatus = 'Creating new stimuli';
else
    % retun pre-loaded stimuli
    C = TaskObject;
    TrialRecord.User.PreloadStatus = 'Using pre-loaded stimuli';
end

% return the pre-generated runtime instead of the timing file name 
timingfile = RunTime;
