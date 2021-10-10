% so sánh với ngưỡng để xác định âm vô thanh hay hữu thanh

T = zeros(1,numberFrames);
a = 0;
i=1;

for nf=1:numberFrames
    a = fs/max(minimum(nf, :));
    if (a > 70 && a < 450)
        T(nf) = fs/max(minimum(nf, :));
        %res(i) = T(nf);
        i = i+1;
    end
end

subplot(4,2,6);
%stem(T);
plot(T, '.');
subplot(4,2,7);
%plot(res, '.');


% 

normalizedAMDF = d - min(d(:));
normalizedAMDF = normalizedAMDF ./ max(normalizedAMDF(:));


% tìm cực tiểu của khung tín hiệu
T0_min=fs/450;
T0_max=fs/70;
minimum = zeros(numberFrames, frame_len);
for nf=1:numberFrames
    for r=2:frame_len
           if (normalizedAMDF(nf, r) < normalizedAMDF(nf, r-1)) && (normalizedAMDF(nf, r) < normalizedAMDF(nf, r+1)) && r > T0_min && r < T0_max
               minimum(nf, r) = normalizedAMDF(nf, r);
           end   
    end
end
