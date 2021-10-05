 close all;clear;clc
 % input audio
 [x,fs]=audioread('16khz.wav'); 
 figure(1);
 plot(x);
 title('signal speech');
 xlabel('sample number');
 ylabel('amplitude');
 grid on;
 %pause;
 
 a = x(6480:8560);
 figure(2);
 subplot(2,1,1);
 plot(a);
 title('Plot of voice part of a signal 1000 sample');
 xlabel('sample');
 ylabel('amplitude');
 %grid on;
 %pause;
 
%sum = zeros(1, N); 

sum = zeros(1, N); 
%sum;
for k=N 
    sum(k)=0;
end 

for k=320 

    sum(k)=0 

end 

for k=1:320 

    for i=1:32 

        sum(k)=sum(k)+(a(i)*a(i+k)); 

        sum(k)=sum(k)/32; 

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

disp(locs); 

[mm, peak1_ind] = min ((fs./diff(locs))); 

period=locs(peak1_ind+1)-locs(peak1_ind); %comparing the "time" between peaks 

pitch_Hz = fs/period; 

disp(pitch_Hz); 


%oke
d = zeros(1, N);
for k=1:N
    sum1 = 0;
    for m = 1:(N - 1 - n)
        sum1 = sum1 + abs(a(m) - a(m + n));
    end
    d(k) = sum1;
end

for k = 1:N
 for m = 1:(N - 1 - n)
     sum(m) = sum(m) + abs(a(m) - a(m + n));
 end
end




[pks, locs] = findpeaks(d); 
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
 