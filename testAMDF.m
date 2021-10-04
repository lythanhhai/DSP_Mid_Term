 close all;clear;clc
 % input audio
 [x,fs]=audioread('16khz.wav'); 
 
 % vẽ signal by sample
 figure(1);
 subplot(1,1,1);
 plot(x);
 title('signal speech');
 xlabel('sample number');
 ylabel('amplitude');
 grid on;
 % vẽ signal by time
 time = (1/fs)*length(x);
 t = linspace(0, time, length(x));
 figure(11);
 plot(t,x);
 xlabel('time(sec)');
 ylabel('amplitude');
 %pause;
 
 % phân frame cho tín hiệu
 K = length(x); % độ dài signal
 L = K/fs; % thời gian của signal tính bằng s
 numberFrames = round(L * 1000 / 100); % số khung
 q=round(K / numberFrames); % số sample trong mỗi khung , chia 80 khung, 1 khung khoảng 100ms.
 P=zeros(numberFrames, q); % 
 for i = 1:numberFrames
     startIndex = (i - 1) * q + 1;
     for j = 1:q
         P(i, j) = x(startIndex + j - 1);
     end
 end
 figure(10);
 plot(P(1,:));
 
 %windowsize = fs/160;
%trailingsamples = mod(length(x), windowsize);
%sampleframes = reshape( x(1:end-trailingsamples), windowsize, []);
%figure(5);
%plot(sampleframes);
 
 a = x(1000:2000);
 figure(2);
 subplot(2,1,1);
 plot(a);
 title('Plot of voice part of a signal 1000 sample');
 xlabel('sample');
 ylabel('amplitude');
 grid on;
 %pause;
 
%N = round(K / numberFrames);% frame lenght
N = 1000;
n = 10;% độ trễ
sum = zeros(1, N); 
sum1 = 0;
%sum;
for k=N 
    sum(k)=0;
end 
d = zeros(numberFrames, q);

for l=1:numberFrames
    for k=1:q
        for m = 1:(N - 1 - n)
            sum1 = sum1 + abs(P(l, m) - P(l, m + n));
        end
        d(l, k) = sum1;
        sum1=0;
    end
end


figure(3)
%subplot(2,1,2);
plot(d);
title('1');
xlabel('2');
ylabel('3'); 
grid on;
d(50, :)
[pks, locs] = findpeaks(d(50, :)); 
%pks
min (fs./diff(locs)), mean(fs./diff(locs)), max(fs./diff(locs)); 


[mm, peak1_ind] = min ((fs./diff(locs))); 
%pitch_Hz = zeros(1, length(locs));
%for r = 1:length(locs)
    %period=locs(peak1_ind + 1 + r)-locs(peak1_ind + r); %comparing the "time" between peaks 
    %pitch_Hz(r) = fs/period;
%end
period=locs(peak1_ind+1)-locs(peak1_ind); %comparing the "time" between peaks 
%pitch_Hz = fs/period; 

%disp(pitch_Hz)
min (fs./diff(locs));
min (fs./diff(locs));
figure(4);
plot(pks);


