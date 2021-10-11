 close all;clear;clc
 % function [Fo] = AMDF(filename)
 % input audio
 [x,fs]=audioread('./fileTinHieuMoi/phone_F1.wav'); 
% [x,fs]=audioread(filename); 
 figure(1);
 var=105;% khung thứ 
 
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
 
 % phân khung cho tín hiệu
 frame_len = 0.03 * fs;% chiều dài khung, 1 khung 30ms
 R = length(x);
 numberFrames = floor(R / frame_len);% số khung được chia
 P=zeros(numberFrames, frame_len);
 for i = 1:numberFrames
     startIndex = (i - 1) * frame_len;
     for j = 1:frame_len
         P(i, j) = x(startIndex + j);
     end
 end
 time1 = (1/fs)*length(P(var, :));
 t1 = linspace(0, time1, length(P(var, :)));
 subplot(4,2,3);
 plot(t1, P(var, :));

% tính AMDF
sum1 = 0;
d = zeros(numberFrames, frame_len);
for l=1:numberFrames
    
    for k=1:frame_len
        sum1=0;
        for m = 1:(frame_len - 1 - k)
            sum1 = sum1 + abs(P(l, m) - P(l, m + k));
        end
        d(l, k) = sum1;
        sum1=0;
    end
end
time2 = (1/fs)*length(d(var, :));
t2 = linspace(0, time2, length(d(var, :)));
subplot(4,2,4);
plot(t2, d(var, :));

normalizedAMDF = d - min(d(:));
normalizedAMDF = normalizedAMDF ./ max(normalizedAMDF(:));

% tìm cực tiểu của khung tín hiệu
T0_min=fs/400;
T0_max=fs/80;
minimum = zeros(numberFrames, frame_len);
for nf=1:numberFrames
    for r=2:frame_len
           if (d(nf, r) < d(nf, r-1)) && (d(nf, r) < d(nf, r+1)) && r > T0_min && r < T0_max
               minimum(nf, r) = d(nf, r);
           end   
    end
end
%&& r > T0_min && r < T0_max

minimum1=zeros(numberFrames, 1);
vitri=zeros(numberFrames, 1);
min = 10000;
vitriMin=10000;
for e=1:numberFrames
    min = 10000;
    vitriMin=10000;
    for r=1:frame_len
        if minimum(e, r) ~= 0 && min > minimum(e, r)
            min = minimum(e, r);
            vitriMin = r;
        end
    end
    minimum1(e) = min;
    vitri(e) = vitriMin;
end
vitri;
length(vitri)
minimum1;
time3 = (1/fs)*length(minimum(var, :));
t3 = linspace(0, time3, length(minimum(var, :)));
subplot(4,2,5);
stem(t3, minimum(var, :));

% so sánh với ngưỡng
Fo=zeros(numberFrames, 1);
for i=1:numberFrames
    % 570 studio_male
    % 130 phone_female
    % 400 studio_fe
    % 170 phone_male
    %if vitri(i) < 540
    % 8.6 male_studi
    % 9 female_studi
    % 1.5 male_phone
    max1 = max(d(i, :));
    minimum1(i)/max1
    %if minimum1(i) > 3.5
    % 0.3 phone-male
    % 
    if minimum1(i) < (max1 * 0.3)
       Fo(i) = 1/(vitri(i) / fs);
    end
end
subplot(4,2,6);
plot(Fo, '.');
figure(9);
plot(Fo, '.');
xlim([0 length(Fo)]);
k=1;
figure(10);
for i=1:numberFrames
    k=k+1;
    if Fo(i) > 0
        hold on
        plot(k-1:k-1, Fo(i), '.' ,'color', 'r');
    end
end
xlim([0 length(Fo)]);


% tính trung bình cộng Fo
fomean = 0;
j =0;
for i=1:numberFrames
    if Fo(i) ~= 0
       fomean = fomean + Fo(i);
       j = j + 1;
    end
end
% tính độ leehcj chuẩn
phuongsai = 0;
for i=1:numberFrames
    if Fo(i) ~= 0
        phuongsai = phuongsai + power(Fo(i) - fomean/j, 2);
    end
end
fomean/j % trung bình cộng
sqrt(phuongsai / (j - 1)) % độ lệch chuẩn


figure(15);
 plot(t,x);
 fs
 
 %end
