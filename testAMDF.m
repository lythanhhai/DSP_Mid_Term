 close all;clear;clc
 [x,fs]=audioread('16khz.wav');
 figure(1);
 plot(x);
 title('signal speech');
 xlabel('sample number');
 ylabel('amplitude');
 grid on;
 %pause;
 
 a = x(1000:5000);
 figure(2);
 %subplot(2,1,1);
 plot(a);
 title('Plot of voice part of a signal 4000 sample');
 xlabel('sample');
 ylabel('amplitude');
 grid on;
 %pause;
 
N = 1000;% frame lenght
n = 200;% độ trễ
sum = zeros(1, N); 
%sum;
%for k=1000 
    %sum(k)=0 
%end 
for k = 1:N
 for m = 1:(N - 1 - n)
     sum(m) = sum(m) + abs(a(m) - a(m + n));
 end
end 
figure(3)
%subplot(2,1,2);
plot(sum);
title('1');
xlabel('2');
ylabel('3'); 
grid on;
 
[pks, locs] = findpeaks(sum); 
min (fs./diff(locs)), mean(fs./diff(locs)), max(fs./diff(locs)); 


[mm, peak1_ind] = min ((fs./diff(locs))); 


period=locs(peak1_ind+1)-locs(peak1_ind); %comparing the "time" between peaks 

pitch_Hz = fs/period; 

disp(pitch_Hz);
mean(peak1_ind)
figure(4);
plot(pks);

