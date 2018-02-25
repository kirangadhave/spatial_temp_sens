clear
addpath('fwdcodesiusedtoextractsaccadeandalsotoanalyzerea');
close all

X = mlread('180224_test_Expt4(6).bhv2');

flag = zeros(1,31);
for i = 1:size(X,2)
   if ismember(15, X(i).BehavioralCodes.CodeNumbers)
      flag(i) = 1; 
   end
end
indx = find(flag==1);
M = X(indx);
y = nan(size(M,2),4000,2);
for i = 1:size(M,2)
    y(i,1:size(M(i).AnalogData.Eye,1),:) = M(i).AnalogData.Eye;
end
y(y<-20 | y>20) = 0;
figure

plot(squeeze(y(:,:,1))')

title('Eye Position - Successful Trials')
vff = nan(1, size(M,2));
for i = 1:size(M,2)
    vff(i) = round(M(i).BehavioralCodes.CodeTimes(M(i).BehavioralCodes.CodeNumbers == 2) - M(i).BehavioralCodes.CodeTimes(1));
end

sac_info = nan(size(y,1),6);

for i = 1:size(y,1)
    [sac, micro] = FindAllSaccadesInTrial(squeeze(y(i,vff(i):vff(i)+500,:)), 0, 0);
%     if norm(sac.start_pos - [0,0], 2) < 2 && norm(sac.stop_pos - [5,0], 2) < 2
    if ~isempty(sac)
        if length(sac) == 1
            if(sqrt(sum(sac.start_pos - [0,0]).^2) < 2 && sqrt(sum(sac.stop_pos - [5,0]).^2) < 2)
                sac_info(i, :) = [sac.start_time + vff(i), sac.stop_time + vff(i), sac.start_pos, sac.stop_pos];
            end
        else
            if(sqrt(sum(sac(1).start_pos - [0,0]).^2) < 2 && sqrt(sum(sac(1).stop_pos - [5,0]).^2) < 2)
                sac_info(i, :) = [sac(1).start_time  + vff(i), sac(1).stop_time  + vff(i), sac(1).start_pos, sac(1).stop_pos];
            end
        end
    end
end

vso = nan(1, size(M,2));
for i = 1:size(M,2)
    vso(i) = round(M(i).BehavioralCodes.CodeTimes(M(i).BehavioralCodes.CodeNumbers == 3) - M(i).BehavioralCodes.CodeTimes(1));
end

figure; 
subplot(1,3,1);
hist(sac_info(:,1) - vff', 20);
xlabel('Reaction Time(ms)');
subplot(1,3,2);
hist(sac_info(:,1) - vso', 20)
xlabel('Saccade Onset(ms)');


% % 21, 'C1 - Horz',... 22, 'C1 - Vert',... 23, 'C2 - Horz',... 24, 'C2 - %
% Vert',... 25, 'C3 - Horz',... 26, 'C3 - Vert')

cond_count = zeros(1, 30);

for i = 1:size(M,2)
    con = M(i).BehavioralCodes.CodeNumbers(M(i).BehavioralCodes.CodeNumbers > 20);
    cond_count(con) = cond_count(con) + 1;
end

c1_hor = cond_count(21)/(cond_count(21) + cond_count(22));
c2_hor = cond_count(23)/(cond_count(23) + cond_count(24));
c3_hor = cond_count(25)/(cond_count(25) + cond_count(26));

subplot(1,3,3);
bar([-0.25 0 0.25], [c1_hor, c2_hor, c3_hor]);
xlabel('Conditions');
ylabel('Horizontal Response Percentage')