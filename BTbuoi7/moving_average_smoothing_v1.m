% chuong trinh lam tron 1 tin hieu de khu nhieu (denoise)
% dung bo loc trung binh truot 3 diem (3-points moving-averaging filter)
% co PTSP: y[n] = 1/3*(x[n-1]+x[n]+x[n+1]) (he ko nhan qua)
% problem statement: co tin hieu bi lan voi nhieu x[n], di khoi phuc lai
% tin hieu goc s[n] (an trong x[n])
% ky vong KQ: y[n] cang giong s[n] cang tot

% sinh tin hieu bi lan voi nhieu cong (additive noise)
clear all;
clf;                            % clear figures
A = 0.5;                    % A ti le voi cong suat nhieu
L = 51;                         % do dai tin hieu
n = 0:L-1;                      % bien thoi gian roi rac
d = A*randn(1,L);             % sinh tin hieu Gausian noise d[n] 
s = 2*n.*(0.9.^n);              % sinh tin hieu goc s[n] = 2n(0.9)^n
x = s + d;                      % tin hieu co nhieu x[n]=s[n]+d[n]

figure(1)                    
hold on
subplot(3,1,1)                 
plot(n,d,'r-',n,s,'k--',n,x,'b-.'); % ve do thi d[n],s[n],x[n]
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('d[n]','s[n]','x[n]');
title('Noise d[n] vs. original s[n] vs. noisy signals x[n]');

% cach 1: cai dat he thong bang cach dich thoi gian va tinh
% TBC cua 3 tin hieu
x1 = [x(2:L), 0]        % x1[n] = x[n+1]
x2 = [x]                  % x2[n] = x[n]
x3 = [0, x(1:L-1)]    % x3[n] = x[n-1]

subplot(3,1,2)
% ve do thi x[n-1],x[n],x[n+1]
plot(n,x1,'r-.',n,x2,'b-.',n,x3,'k-.');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('x[n+1]','x[n]','x[n-1]');
title('time-shifted signals of x[n]');

y1 = 1/3*(x1+x2+x3);     % lenh cai dat he thong
subplot(3,1,3)
% ve do thi y1[n] vs. s[n]
plot(n,y1(1:L),'r-',n,s(1:L),'b-');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('y1[n]','s[n]');
title('3-points smoothed y1[n] vs. original signal s[n]');

% cach 2: cai dat he thong bang cach dung ham tinh tong chap conv()
% ghep noi tiep he som 1 don vi h1[n]=delta(n+1) va he lay TB cong nhan qua
% yNQ[n] = 1/3*(x[n]+x[n+1]+x[n+2])
h = 1/3 * ones(1,3);    % h[n] = [1/3, 1/3, 1/3] (n=-1,0,1)
y2 = conv(x1, h);         % y2[n] = x[n+1] * h[n] = x1[n] * h[n] 
% ve do thi y2[n] vs. s[n]
figure(2)
plot(n,y2(1:L),'r-',n,s(1:L),'b-');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('y2[n]','s[n]');
title('3-points smoothed y2[n] vs. original signal s[n]');

% ve do thi xep chong y1[n] va y2[n] de test ket qua
figure(3)
hold on
plot(n,y1,'r-',n,y2(1:L),'b-');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('y1[n]','y2[n]');
title('cach1  vs. cach2');

% cach 3: dung vong lap (hieu n l? mot chi so mau nao do)
% PUT YOUR CODE HERE



