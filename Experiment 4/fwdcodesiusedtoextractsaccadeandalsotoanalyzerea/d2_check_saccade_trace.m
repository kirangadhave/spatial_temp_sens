%d2_check_saccade_trace
clear;clc;close
address = 'E:\monkeylogic\Amir\TPM1s\Experiment-subject_-12-04-2016(01).bhv';
BHV_TPM = bhv_read(address);
% behaviorsummary(BHV_TPM)
figure;plot(BHV_TPM.AnalogData{1, 9}.EyeSignal)
