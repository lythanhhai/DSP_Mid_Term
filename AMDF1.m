 %close all;clear;clc
 function [Fo] =  AMDF1(filename, tenFile, frame_voice, frame_unvoice);
 
 % input audio
 [x,fs]=audioread(filename);
 figure('name', tenFile);
 
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

% tính AMDF cho từng khung
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

% chuẩn hóa
max123=max(d(:));
normalizedAMDF = d / max123;

%for l=1:numberFrames
%    for k=1:frame_len
%        normalizedAMDF(l, k) = d(l, k) / max(d(l, :));
%    end
%end

% tìm cực tiểu của khung tín hiệu(con người có tần số thuộc khoảng 70-450Hz)
T0_min=fs/450;
T0_max=fs/70;
minimum = zeros(numberFrames, frame_len);% lưu các cực tiểu cục bộ trong 1 khung 
maxSignal = zeros(numberFrames, 1);% tìm kiếm giá trị lớn nhất của khung tín hiệu
for nf=1:numberFrames
    for r=2:frame_len
           if (normalizedAMDF(nf, r) < normalizedAMDF(nf, r-1)) && (normalizedAMDF(nf, r) < normalizedAMDF(nf, r+1)) && r > T0_min && r < T0_max
               minimum(nf, r) = normalizedAMDF(nf, r);
           end   
    end
    maxSignal(nf) = max(normalizedAMDF(nf, :));
end
%&& r > T0_min && r < T0_max
%maxSignal

% tìm cực tiểu cục bộ nhỏ nhất của từng khung và vị trí của nó
minimum1=zeros(numberFrames, 1);
vitri=zeros(numberFrames, 1);
min1 = 10000;
vitriMin=10000;
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
%minimum1

% tính meanV, stdV


% so sánh với ngưỡng để phân biệt vô thanh, hữu thanh, khoảng lặng
Fo=zeros(numberFrames, 1);
for i=1:numberFrames
    max1 = max(normalizedAMDF(i, :));
    %minimum1(i)/max1;
    % 0.3()
    if minimum1(i) <= (max1 * 0.33)
    %if minimum1(i) > 0.05
       Fo(i) = 1 / (vitri(i) / fs);
    end
end


% tính trung bình cộng Fo (Fo_mean)
fomean = 0;
j =0;
for i=1:numberFrames
    if Fo(i) ~= 0
       fomean = fomean + Fo(i);
       j = j + 1;
    end
end

% tính độ lệch chuẩn (Fo_std)
phuongsai = 0;
for i=1:numberFrames
    if Fo(i) ~= 0
        phuongsai = phuongsai + power(Fo(i) - fomean/j, 2);
    end
end

% trung bình cộng
fo_mean = fomean/j; 
% độ lệch chuẩn
fo_std = sqrt(phuongsai / (j-1));


% lọc trung vị
soPhanTu = 5;
filterFo = zeros(1, numberFrames + 4);
% thêm 2 biên cho dãy Fo
for i=1:numberFrames+4
    if i==1 || i == 2
       filterFo(i) = Fo(1);
    elseif i== numberFrames+3 || i == numberFrames+4
       filterFo(i) = Fo(numberFrames);
    else 
       filterFo(i) = Fo(i - 2);
    end 
end

%duyệt từng giá trị
%khung=zeros(1, soPhanTu);

u=1;% số khung chứa mỗi 5 phần tử
for j=3:numberFrames+2
    for k=1:soPhanTu
        if k == 1
            khung(u, k) = filterFo(j - 2);
        elseif k == 2
            khung(u, k) = filterFo(j - 1);
        elseif k == 3
            khung(u, k) = filterFo(j);
        elseif k == 4
            khung(u, k) = filterFo(j + 1);
        else
            khung(u, k) = filterFo(j + 2);
        end
    end
    u = u + 1;
end

% sắp xếp cho từng khung 
for i=1:u-1
    for j=1:(soPhanTu - 1)
        for k=(j+1):soPhanTu
            if khung(i, j) > khung(i, k) 
                temp = khung(i, j);
                khung(i, j) = khung(i, k);
                khung(i, k) = temp;
            end
        end
    end
end

% gán điểm đang xét cho điểm chính giữa mỗi khung được tách 
index=1;
for i=3:numberFrames+2
    filterFo(i) = khung(index, 3);
    index = index + 1;
end

% tính trung bình cộng Fo sau khi lọc trung vị (Fo_mean_median)
fomean_median = 0;
j =0;
for i=1:(numberFrames + 4)
    if filterFo(i) ~= 0
       fomean_median = fomean_median + filterFo(i);
       j = j + 1;
    end
end

% tính độ lệch chuẩn (Fo_std)
phuongsai_median = 0;
for i=1:(numberFrames + 4)
    if filterFo(i) ~= 0
        phuongsai_median = phuongsai_median + power(filterFo(i) - fomean_median/j, 2);
    end
end

% trung bình cộng
fo_mean_median = fomean_median/j; 
% độ lệch chuẩn
fo_std_median = sqrt(phuongsai_median / (j-1));


% vẽ
 % vẽ signal by time
 time = (1/fs)*length(x);
 t = linspace(0, time, length(x));
 subplot(5,1,1);
 plot(t,x);
 title(['signal ', tenFile]);
 xlabel('time(sec)');
 ylabel('amplitude');
 grid on
 
 % vẽ Fo loại bỏ các phần tử bằng 0
k=1;
subplot(5,1,2);
time3 = 0.03 * length(Fo);
t3 = linspace(0, time3, length(Fo));
for i=1:numberFrames
    k=k+1;
    if Fo(i) > 0
        hold on
        %plot(k-1, Fo(i), '.', 'color', 'b');
    end
end
plot(t3, Fo,'.');
%xlim([0 length(Fo)]);
title(['Fo chưa lọc: ', 'Fomean = ', num2str(fo_mean), 'Hz ', ' Fostd = ', num2str(fo_std), 'Hz']);
xlabel('time(sec)');
ylabel('Fo(hz)');

% vẽ filterFo
index1=1;
for i=3:(numberFrames + 2)
    filterFoCopy(index1) = filterFo(i);
    index1 = index1 + 1;
end
a=1;
time2 = 0.03 * length(filterFoCopy);
t2 = linspace(0, time2, length(filterFoCopy));
subplot(5,1,3);
for i=1:length(filterFo)
    a=a+1;
    if filterFo(i) > 0
        hold on
        %plot(a-1, filterFo(i), '.' ,'color', 'b');
    end
end
plot(t2, filterFoCopy, '.');
%xlim([0 length(filterFo)]);
title(['Fo sau khi lọc trung vị: ', 'Fomean = ', num2str(fo_mean_median), 'Hz ', ' Fostd = ', num2str(fo_std_median), 'Hz']);
xlabel('time(sec)');
ylabel('Fo(Hz)');
 
 % vẽ khung voice sau khi được chuẩn hóa
subplot(5,1,4);
time1 = (1/fs)*length(normalizedAMDF);
t1 = linspace(0, time1, length(normalizedAMDF));
plot(t1, normalizedAMDF(frame_voice, :));
title(['frame voice có F0 = ', num2str(filterFo(frame_voice))]);
ylabel('amplititude');
xlabel('lag(sec)');

% vẽ khung unvoice sau khi chuẩn hóa
subplot(5,1,5);
plot(t1, normalizedAMDF(frame_unvoice, :));
title(['frame unvoice']);
ylabel('amplititude');
xlabel('lag(sec)');

%length(filterFo)
%length(Fo)
%figure(10);
%plot(khung(38, :));

end
