 close all;clear;clc
 % input audio
 [x,fs]=audioread('./fileTinHieuMoi/studio_M1.wav'); 
 figure(1);
 var=32;% khung thứ 

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
 time1 = (1/fs)*length(P(var, :));
 t1 = linspace(0, time1, length(P(var, :)));

% tính AMDF
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
time2 = (1/fs)*length(d(var, :));
t2 = linspace(0, time2, length(d(var, :)));

normalizedAMDF = d - min(d(:));
normalizedAMDF = normalizedAMDF ./ max(normalizedAMDF(:));

% tìm cực tiểu của khung tín hiệu
T0_min=fs/450;
T0_max=fs/70;
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
min = 1000000;
vitriMin=1000000;
for e=1:numberFrames
    min = 1000000;
    vitriMin=1000000;
    for r=2:frame_len
        if minimum(e, r) ~= 0 && min > minimum(e, r)
            min = minimum(e, r);
            vitriMin = r;
        end
    end
    minimum1(e) = min;
    vitri(e) = vitriMin;
end
%vitri
minimum1
time3 = (1/fs)*length(minimum(var, :));
t3 = linspace(0, time3, length(minimum(var, :)));


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
    if minimum1(i) > 8.6
       Fo(i) = 1/(vitri(i) / fs);
    end
end
subplot(4,1,1);
plot(Fo, '.');
k=1;
%figure(10);
%subplot(4,1,1);
for i=1:numberFrames
    k=k+1;
    if Fo(i) > 0
        hold on
        
        %plot(k-1:k-1, Fo(i), '.' ,'color', 'r');
    end
end


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
%fs
