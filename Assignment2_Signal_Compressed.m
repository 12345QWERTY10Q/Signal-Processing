clc;
clear;
%%
Y= readmatrix("Desktop\cityu\Statistics\2\b (2).xlsx")';
A=dctmtx(128)';
Weight=Y*A;
[W,I] = sort(Weight,'descend');
%%
disp("Weight")
disp(W)
disp("Rank")
disp(I)
%%
X1=A(:,1);
X2=A(:,4);
X3=A(:,9);
y=100*X1+50*X2+20*X3;
%%
subplot(1,3,1)
plot(Y,1:128)
ylim([0 128])
title('Origin Signal')
xlabel("Power")
ylabel("Time")

subplot(1,3,2)
plot(X1,1:128)
ylim([0 128])
hold on
plot(X2,1:128)
ylim([0 128])
hold on
plot(X3,1:128)
ylim([0 128]) 
title('Selected Components')
xlabel("Power")
ylabel("Time")

subplot(1,3,3)
plot(y,1:128,'r')
ylim([0 128])
xlabel("Power")
ylabel("Time")
title('Compressed Signal')