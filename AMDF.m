 close all;clear;clc
 [x,fs]=audioread('16khz.wav');
 t1=0;t2=3;% bien thoi gian
 T=1/fs;% chu ky lay mau
 t=t1:T:t2; % vector thoi gian gom cac thoi diem lay mau
 N = 1000;% frame lenght
 n = 10;% độ trễ
 res = 0;
 d = [];
 for m = 1:(N - 1 - n)
     res = res + abs(x(m) - x(m + n));
     if(m == N - n)
        d(n) = res + abs(x(m) - x(m + n));
        res = 0;
     end
 end
 figure(1)
subplot(2,1,2);
plot(sum);
title('1');
 xlabel('2');
 ylabel('3');
