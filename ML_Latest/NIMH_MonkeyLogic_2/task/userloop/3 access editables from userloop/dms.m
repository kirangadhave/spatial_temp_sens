param_file = 'func1.m';          % parameter function name
editable('-file','param_file');  % make it editable

[~,n] = fileparts(param_file);   % get the filename only
param = eval(n);                 % call the function

dashboard(1,sprintf('Parameter file: %s',param_file));
dashboard(2,sprintf('Probability: %.1f',param.probability));
dashboard(3,sprintf('Probability read in userloop: %.1f',TrialRecord.User.probability));

idle(1000);
set_iti(200);