clear
addpath('fwdcodesiusedtoextractsaccadeandalsotoanalyzerea');
close all

A = mlread('180226_115242_test_Expt4.bhv2');
B = mlread('180226_115242_test_Expt4.bhv2');
C = mlread('180226_113109_test_Expt4.bhv2');
D = mlread('180226_113109_test_Expt4.bhv2');
E = mlread('180226_104003_test_Expt4.bhv2');
F = mlread('180224_test_Expt4(7).bhv2');
G = mlread('180224_test_Expt4(6).bhv2');
H = mlread('180226_102342_test_Expt4.bhv2');

% Todays Data
I = mlread('180227_125652_test_Expt4.bhv2');
J = mlread('180227_131157_test_Expt4.bhv2');
K = mlread('180226_120141_test_Expt4.bhv2');
L = mlread('180227_134413_test_Expt4.bhv2');
N = mlread('180227_140712_test_Expt4.bhv2');
X = [A B C D E F G H I J K L N];

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
tri_con = nan(1, size(M,2));
tri_resp = nan(1, size(M,2));
for i = 1:size(M,2)
    con = M(i).BehavioralCodes.CodeNumbers(M(i).BehavioralCodes.CodeNumbers > 20);
    cond_count(con) = cond_count(con) + 1;
    switch con
        case 21
            tri_con(i) = 1;
            tri_resp(i) = 0;
        case 22
            tri_con(i) = 1;
            tri_resp(i) = 1;
        case 23
            tri_con(i) = 2;
            tri_resp(i) = 0;
        case 24
            tri_con(i) = 2;
            tri_resp(i) = 1;
        case 25
            tri_con(i) = 3;
            tri_resp(i) = 0;
        case 26
            tri_con(i) = 3;
            tri_resp(i) = 1;
    end
end

c1_hor = cond_count(21)/(cond_count(21) + cond_count(22));
c2_hor = cond_count(23)/(cond_count(23) + cond_count(24));
c3_hor = cond_count(25)/(cond_count(25) + cond_count(26));

subplot(1,3,3);
bar([-0.25 0 0.25], [c1_hor, c2_hor, c3_hor]);
xlabel('Conditions');
ylabel('Horizontal Response Percentage');


fp2sacon = sac_info(:,1) - vso';
% fp2sacon_ = fp2sacon;
output = [fp2sacon, tri_con', tri_resp'];

% eye_time = sac_info(:,1);
% 
% eye_mat = zeros([size(y,1), 301, size(y,3)]);
% for i = 1:size(eye_mat, 1)
%     if isnan(eye_time(i))
%         start = eye_time(i)-150;
%         end_ =eye_time(i)+150;
%        eye_mat(i,:,:) = y(i,start:end_,:);
%     end
% end


%% added by amir 18_02_28
indx = find(~isnan(sac_info(:,1)));
figure;hold on
for tr = 1:length(indx)
    tt = sac_info(indx(tr),1);
    plot(-350:300,squeeze(y(indx(tr),tt-350:tt+300,1)),'b');
end
ylabel('dva');
xlabel('time to sacc onset (ms)');
title('eye position traces for 629 trials(Kiran-Shuvrajit experiment)')