 close all;clear;clc
 % input audio
 [x,fs]=audioread('studio_male.wav'); 
 figure(20);
 % vẽ signal by sample
 subplot(4,2,1);
 plot(x);
 title('signal speech');
 xlabel('sample number');
 ylabel('amplitude');
 grid on;
 % vẽ signal by time
 time = (1/fs)*length(x);
 t = linspace(0, time, length(x));
 subplot(4,2,2);
 plot(t,x);
 title('signal by second');
 xlabel('time(sec)');
 ylabel('amplitude');

 
 frame_len = 0.05 * fs;% chiều dài khung, 1 khung 100ms
 R = length(x);
 numberFrames = floor(R / frame_len);

 P=zeros(numberFrames, frame_len); % 
 for i = 1:numberFrames
     startIndex = (i - 1) * frame_len + 1;
     for j = 1:frame_len
         P(i, j) = x(startIndex + j - 1);
     end
 end
 subplot(4,2,3);
 plot(P(16, :));
 

sum1 = 0;
d = zeros(numberFrames, frame_len);
for l=1:numberFrames
    for k=1:frame_len
        for m = 1:(frame_len - 1 - k)
            sum1 = sum1 + abs(P(l, m) - P(l, m + k));
        end
        d(l, k) = sum1;
        sum1=0;
    end
end
%d
subplot(4,2,4);
plot(d(16, :));


minimum = zeros(numberFrames, frame_len);
for nf=1:numberFrames
    for r=2:frame_len
           if (d(nf, r) < d(nf, r-1)) && (d(nf, r) < d(nf, r+1))
               minimum(nf, r) = d(nf, r);
           end   
    end
    %[pks, locs] = findpeaks(d(10, :));
    %pks
    %locs
    %-d(1, :)
    
    %min = pks(2) - pks(1);
    %T(nf) = 1/min;
    
    %min (fs./diff(locs)), mean(fs./diff(locs)), max(fs./diff(locs)); 


    %[mm, peak1_ind] = min ((fs./diff(locs))); 

    %period=locs(peak1_ind+1)-locs(peak1_ind); %comparing the "time" between peaks 
   
    %T(nf) = fs/period;
    
end
subplot(4,2,5);
stem(minimum(16, :));
max(minimum(10, :));
fs/max(minimum(8, :));


T0_min=fs/400;
T0_max=fs/80;
T = zeros(1,numberFrames);
a = 0;
i=1;
for nf=1:numberFrames
    a = fs/max(minimum(nf, :));
    if (a > 80 && a < 400)
        T(nf) = fs/max(minimum(nf, :));
        res(i) = T(nf);
        i = i+1;
    end
end
subplot(4,2,6);
stem(res);
subplot(4,2,7);
stem(T);

