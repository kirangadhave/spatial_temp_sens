clear all; close all; clc
load behrad.mat
offset=50;
for t=-150:150
    for c=1:3
        list=find (output(:, 1)>t & output(:, 1)<t+offset & output(:,2)==c);
        num(t+151,c)=length(list);
        out(t+151, c)=nanmean(output(list, 3));
    end 
end
newout(:, 1)=out(:, 2);
newout(:, 2)=out(:, 1);
newout(:, 3)=out(:, 3);

newnum(:, 1)=num(:, 2);
newnum(:, 2)=num(:, 1);
newnum(:, 3)=num(:, 3);

plot(nanmean(newout, 2))

