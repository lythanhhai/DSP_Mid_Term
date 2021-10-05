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
 figure(2);
 plot(t,x);
 xlabel('time(sec)');
 ylabel('amplitude');
 %pause;
 
 % phân frame cho tín hiệu
 K = length(x); % độ dài signal
 L = K/fs; % thời gian của signal tính bằng s
 numberFrames = round(L * 1000 / 100 / 3); % số khung
 q=round(K / numberFrames); % số sample trong mỗi khung , chia 80 khung, 1 khung khoảng 100ms.
 P=zeros(numberFrames, q); % 
 for i = 1:numberFrames
     startIndex = (i - 1) * q + 1;
     for j = 1:q
         P(i, j) = x(startIndex + j - 1);
     end
 end
 figure(3);
 plot(P);
 
%windowsize = fs/160;
%trailingsamples = mod(length(x), windowsize);
%sampleframes = reshape( x(1:end-trailingsamples), windowsize, []);
%figure(15);
%plot(sampleframes);
 
 a = x(1000:2000);
 figure(4);
 subplot(2,1,1);
 plot(a);
 title('Plot of voice part of a signal 1000 sample');
 xlabel('sample');
 ylabel('amplitude');
 grid on;
 %pause;

V = P(:);
%V
%P
N = round(K / numberFrames);% frame lenght
%N = 1000;
n = 10;% độ trễ
sum1 = 0;
d = zeros(numberFrames, q);
length(V);
%d = zeros(1, length(V));
for l=1:numberFrames
    for k=1:length(d)
        for m = 1:(N - 1 - k)
            sum1 = sum1 + abs(P(l, m) - P(l, m + k));
        end
        d(l, k) = sum1;
        sum1=0;
    end
end
%d

figure(5);
%subplot(2,1,2);
time = (1/fs)*length(d(1, :));
t = linspace(0, time, length(d(1, :)));
plot(t, d(1, :));
title('1');
xlabel('2');
ylabel('3'); 
grid on;
%d(50, :)


T0_min=fs/400
T0_max=fs/80
T = zeros(1, numberFrames);
for nf=1:numberFrames
    [pks, locs] = findpeaks(-d(nf, :));
    %pks
    %locs
    %-d(1, :)
    
    %min = pks(2) - pks(1);
    %T(nf) = 1/min;
    
    %min (fs./diff(locs)), mean(fs./diff(locs)), max(fs./diff(locs)); 


    [mm, peak1_ind] = min ((fs./diff(locs))); 

    period=locs(peak1_ind+1)-locs(peak1_ind); %comparing the "time" between peaks 
    period
    if period > T0_max && period < T0_min
        T(nf) = 0;
    end
    %pitch_Hz = fs/period
    T(nf) = fs/period;
    
end

figure(6);
plot(T);

%disp(pitch_Hz)
%min (fs./diff(locs));
%min (fs./diff(locs));
%figure(6);
%plot(pks);


