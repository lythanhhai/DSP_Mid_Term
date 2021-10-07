 close all;clear;clc
 % input audio
 [x,fs]=audioread('studio_male.wav'); 
 
 % vẽ signal by sample
 % vẽ signal by time
 time = (1/fs)*length(x);
 t = linspace(0, time, length(x));
 figure(2);
 plot(t,x);
 xlabel('time(sec)');
 ylabel('amplitude');

 
 frame_len = 0.1 * fs;% chiều dài khung
 R = length(x);
 numberFrames = floor(R / frame_len);

 P=zeros(numberFrames, frame_len); % 
 for i = 1:numberFrames
     startIndex = (i - 1) * frame_len + 1;
     for j = 1:frame_len
         P(i, j) = x(startIndex + j - 1);
     end
 end
 figure(3);
 plot(P(10, :));
 

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
figure(10);
plot(d(10, :));



T0_min=1/400;
T0_max=1/80;


minimum = zeros(numberFrames, frame_len);
for nf=1:numberFrames
    for r=2:frame_len
           if (d(nf, r) < d(nf, r-1)) && (d(nf, r) < d(nf, r+1))
               minimum(nf, r) = d(nf, r);
           end   
    end
    [pks, locs] = findpeaks(d(10, :));
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
figure(11);
stem(minimum(10, :));
max(minimum(10, :))
fs/max(minimum(8, :))

T = zeros(1,numberFrames);
a = 0;
for nf=1:numberFrames
    a = fs/max(minimum(nf, :));
    if (a > 70 && a < 450)
        T(nf) = fs/max(minimum(nf, :));
    end
end
figure(6);
stem(T);

