 close all;clear;clc
 % input audio
 [x,fs]=audioread('phone_male.wav'); 
 
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
 
 a = x(1000:2000);
 figure(4);
 subplot(2,1,1);
 plot(a);
 title('Plot of voice part of a signal 1000 sample');
 xlabel('sample');
 ylabel('amplitude');
 grid on;
 %pause;

sum1 = 0;
d = zeros(1, 1000);

    for k=1:1000  
            for m = 1:(1001 - 1 - k)
                sum1 = sum1 + abs(a(m) - a(m + k));
            end
            d(k) = sum1;
            sum1=0;
    end

% độ dài khung độ trễ n -> N
% xét oitch n -> N độ dài khung
% dựa vào f0 để giảm phạm vi tìm kiếm f0 = 80 f0 = 400
% chuẩn hóa
% kỹ thuật hậu xử lý
% lỗi pitch ảo
% 6 figure hoặc 6 subplot in 1 figure

figure(5);
%subplot(2,1,2);
%time = (1/fs)*length(d(1, :));
%t = linspace(0, time, length(d(1, :)));
plot(d);
%d
title('1');
xlabel('2');
ylabel('3'); 
grid on;
%d(50, :)


T0_min=fs/400;
T0_max=fs/80;
T = zeros(1, 1000);
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
    period;
    if period > T0_max && period < T0_min
        T(nf) = 0;
    end
    %pitch_Hz = fs/period
    T(nf) = fs/period;
    
end

figure(6);
%time = (1/fs)*length(x);
%t = linspace(0, time, length(x));
plot(T);

%disp(pitch_Hz)
%min (fs./diff(locs));
%min (fs./diff(locs));
%figure(6);
%plot(pks);


