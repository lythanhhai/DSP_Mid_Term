 %close all;clear;clc
 function [Fo] =  AMDF1(filename)
 % input audio
 [x,fs]=audioread('./fileTinHieuMoi/phone_F1.wav');
 figure(1);
 var=47;% khung thứ 
 
 % vẽ signal by sample
 subplot(4,1,1);
 plot(x);
 title('signal speech');
 xlabel('sample number');
 ylabel('amplitude');
 grid on;
 
 % vẽ signal by time
 time = (1/fs)*length(x);
 t = linspace(0, time, length(x));
 subplot(4,1,2);
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
     startIndex = (i - 1) * frame_len + 1;
     for j = 1:frame_len
         P(i, j) = x(startIndex + j - 1);
     end
 end

% tính AMDF
sum1 = 0;
d = zeros(numberFrames, frame_len);
for l=1:numberFrames
    sum1=0;
    for k=1:frame_len
        for m = 1:(frame_len - 1 - k)
            sum1 = sum1 + abs(P(l, m) - P(l, m + k));
        end
        d(l, k) = sum1;
        sum1=0;
    end
end

normalizedAMDF = d - min(d(:));
normalizedAMDF = normalizedAMDF ./ max(normalizedAMDF(:));

% tìm cực tiểu của khung tín hiệu
T0_min=fs/400;
T0_max=fs/80;
minimum = zeros(numberFrames, frame_len);
for nf=1:numberFrames
    for r=2:frame_len
           if (normalizedAMDF(nf, r) < normalizedAMDF(nf, r-1)) && (normalizedAMDF(nf, r) < normalizedAMDF(nf, r+1)) && r > T0_min && r < T0_max
               minimum(nf, r) = normalizedAMDF(nf, r);
           end   
    end
end
%&& r > T0_min && r < T0_max

minimum1=zeros(numberFrames, 1);
vitri=zeros(numberFrames, 1);
min1 = 1000000;
vitriMin=1000000;
for e=1:numberFrames
    min1 = 10000;
    vitriMin=10000;
    for r=1:frame_len
        if minimum(e, r) ~= 0 && min1 > minimum(e, r)
            min1 = minimum(e, r);
            vitriMin = r;
        end
    end
    minimum1(e) = min1;
    vitri(e) = vitriMin;
end
%vitri

% so sánh với ngưỡng
Fo=zeros(numberFrames, 1);
for i=1:numberFrames
    max1 = max(normalizedAMDF(i, :));
    minimum1(i)/max1;

    if minimum1(i) < (max1 * 0.25)
       Fo(i) = 1/(vitri(i) / fs);
    end
end
k=1;
subplot(4,1,3);
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
sqrt(phuongsai / (j-1)) % độ lệch chuẩn

 
 end
