function lab6()
A = 1.0;
sigma = 1.5;
mult = 5;
step = 0.005;
NA = 0;
NB = 0.05;
count = 7;
M = 0.4;
t = -mult:step:mult;

% Гаусс
x0 = A * exp(-(t/sigma).^2);

% Генерация помех
% Вектор случайных чисел размером 1 на length(x0), числа от 0 до 0.05
n1 = normrnd(NA,NB,[1 length(x0)]);
x1 = x0+n1;

% Импульсивная генерация шума
n2 = impnoise(length(x0),count,M);
x2 = x0+n2;
y1 = wiener(fft(x1),fft(n1));
y2 = wiener(fft(x2),fft(n2));

figure(1)
subplot(2,1,1)
plot(t,x1,'b',t,ifft(fft(x1).*y1),'m');
title('Фильтация сигнала Гаусса фильтром Винера');
legend('С шумами','Без шумов');
subplot(2,1,2)
plot(t,x2,'b',t,ifft(fft(x2).*y2),'m');
title('Фильтация импульсного сигнала фильтром Винераа');
legend('С шумами','Без шумов');
end

% Импульсивная генерация шума
function y = impnoise(size,N,mult)
    step = floor(size/N);
    y = zeros(1,size);
    for i = 0:floor(N/2)
        y(round(size/2)+i*step) = mult*(0.5+rand);
        y(round(size/2)-i*step) = mult*(0.5+rand);
    end
end

% фильтр Винера
function y = wiener(x,n)
    y = 1 - (n./x).^2;
end