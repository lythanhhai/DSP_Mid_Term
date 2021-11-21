n = -20:20; % create vector n of 41 elements (time base of signal)

% create sine functions with different freqencies
w = 0;
x = cos(w*n);  % w0=0
subplot(5,2,1);
stem(n, x, 'fill');
title('w=0');

w = pi/8;
x = cos(w*n);  % w1=pi/4
subplot(5,2,3);
stem(n, x, 'fill');
title('w=pi/8');

w = pi/4;
x = cos(w*n);  % w0=0
subplot(5,2,5);
stem(n, x, 'fill');
title('w=pi/4');

w = pi/2;
x = cos(w*n);  % w1=pi/4
subplot(5,2,7);
stem(n, x, 'fill');
title('w=pi/2');

w = pi;
x = cos(w*n);  % w1=pi/4
subplot(5,2,9);
stem(n, x, 'fill');
title('w=pi');

%----------
w = 0;
x = cos((2*pi-w)*n);  % w=2pi
subplot(5,2,2);
stem(n, x, 'fill');
title('w=2pi-0');

w = pi/8;
x = cos((2*pi-w)*n);  % w=2pi-pi/8
subplot(5,2,4);
stem(n, x, 'fill');
title('w=2pi-pi/8');

w = pi/4;
x = cos((2*pi-w)*n);  % w=2pi-pi/4
subplot(5,2,6);
stem(n, x, 'fill');
title('w=2pi-pi/4');

w = pi/2;
x = cos((2*pi-w)*n);  % w=2pi-pi/2
subplot(5,2,8);
stem(n, x, 'fill');
title('w=2pi-pi/2');

w = pi;
x = cos((2*pi-w)*n);  % w=pi
subplot(5,2,10);
stem(n, x, 'fill');
title('w=2pi-pi');

