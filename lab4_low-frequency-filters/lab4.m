function lab4()
A = 1.0;
sigma = 0.5;
mult = 5;
step = 0.005;
NA = 0;
NB = 0.05;
count = 7;
M = 0.4;
t = -mult:step:mult;

% Гаусс
x0 = A * exp(-(t/sigma).^2);

% Генерация помех. Создает новый вектор случайных чисел размером 
% 1 на length(x0). Числа от 0 до 0.05
n1 = normrnd(NA,NB,[1 length(x0)]);
x1 = x0+n1;

% Импульсивная генерация шума
n2 = impnoise(length(x0),count,M);
x2 = x0+n2;

% Расчет фильтрующих массивов
[B,A] = butter(6,0.05,'low');
G = gaussfilt(4,20,'low');
BB = buttfilt(6,20,'low');

figure(1)
plot(t,x0,'black',t,x1,'y',t,x2,'m');
title('Исходный сигнал');
figure(2)
plot(t,x0,'black',t,filtfilt(B,A,x1),'b',t,filtfilt(B,A,x2),'m');
title('Баттеруорт (рекурсивная)');
figure(3)
plot(t,x0,'black',t,filtfilt(G,1,x1),'b',t,filtfilt(G,1,x2),'m');
title('Гаусс');
figure(4)
plot(t,x0,'black',t,filtfilt(BB,1,x1),'b',t,filtfilt(BB,1,x2),'m');
title('Баттеруорт');
end

% Импульсивная генерация шума
function y = impnoise(size,N,mult)
    step = floor(size/N); % округление
    y = zeros(1,size); 
    for i = 0:floor(N/2)
        y(round(size/2)+i*step) = mult*(0.5+rand);
        y(round(size/2)-i*step) = mult*(0.5+rand);
    end
end

% Два фильтра
% Нерекурсивная реализация Баттерворта
function y = buttfilt(D,size,type)
    x = linspace(-size/2,size/2,size); % генерирует расстояние между точками
    if (strcmp(type,'low'))% сравнение
        y = 1./(1+(x./D).^4);
    elseif (strcmp(type,'high'))
        y = 1./(1+(D./x).^4);
    else
        y = x*sum(x);
    end
    y = y/sum(y);
end

% Нерекурсивная реализация Гаусса
function y = gaussfilt(sigma,size,type)
    x = linspace(-size/2,size/2,size);
    if (strcmp(type,'low'))
        y = exp(-x.^2/(2*sigma^2));  
    elseif (strcmp(type,'high'))
        y = 1 - exp(-x.^2/(2*sigma^2));
    else
        y = x*sum(x);
    end
    y = y/sum(y);
end