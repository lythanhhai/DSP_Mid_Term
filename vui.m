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
