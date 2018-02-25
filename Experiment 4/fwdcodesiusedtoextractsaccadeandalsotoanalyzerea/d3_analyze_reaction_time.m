% d3_analyze_reaction_time
clc; close ;clear
name = 'tdata_2016_12_04_16_30_11_saved_on_16_12_05_16_39_22.mat';
%%
load(['tdata\' name])
RT = nan(size(tdata_RT,2),1);
for tr = 1:size(tdata_RT,2)
%     subplot(212);plot(tdata_RT(tr).eye)
%     subplot(211);plot(tdata_RT(tr).evt_times,tdata_RT(tr).events)
    %     entered_fixation = tdata_RT(tr).evt_times(find(tdata_RT(tr).events==2,1,'first'));
    %     target_off = tdata_RT(tr).evt_times(find(tdata_RT(tr).events==10,1,'last'));
    %     [sac, micro] = FindAllSaccadesInTrial(tdata_RT(tr).eye(entered_fixation:target_off,:), 0, 0);
    xx = tdata_RT(tr).evt_times(find(tdata_RT(tr).events==2));
    fixated_on_target = xx(2);
    yy =  tdata_RT(tr).evt_times(find(tdata_RT(tr).events==10));
    fixation_off = yy(1);
    RT(tr) = fixated_on_target - fixation_off;
end
figure
hist(RT,20)
title('reaction time');
xlabel('ms')
median(RT)
