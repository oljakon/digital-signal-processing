function lab8()

A = 1.0;
sigma = 1.0;
mult = 4;
step = 0.01;
count = 20;
M = 0.4;
width = 3;

% интервал
t = -mult:step:mult;
% Гаусс
x = A * exp(-(t/sigma).^2);

% импульсная генерация шума
n = impnoise(length(x),count,M);
z = x+n;
eps = M/4;

% MEAN
y1 = z;
smooth = @(x) mean(x);
for i = 1:length(z)
    y1(i) = ampsmooth(y1, i, smooth, width, eps);
end

% MED
y2 = z;
smooth = @(x) med(x);
for i = 1:length(z)
    y2(i) = ampsmooth(y2, i, smooth, width, eps);
end

figure(1)
plot(t,z,'black',t,y1,'r');
title('MEAN');
figure(2)
plot(t,z,'black',t,y2,'b');
title('MED');
end

% Импульсная генерация шума
function y = impnoise(size,N,mult)
    y = zeros(1,size);
 	y(round(unifrnd(1,size,[1,N]))) = mult*unifrnd(0,1,[1,N]);
end

% Сглаживание амплитуды
function y = ampsmooth(A, i, SMTH, W, eps)
    y = A(i);
    if (i - W < 1)
        S = SMTH(A(1:2*W + 1));
    else if (i + W > length(A))
            S = SMTH(A(length(A) - 2*W:length(A)));
        else
            S = SMTH(A(i - W:i + W));
        end
    end
    
    for i = 1:length(A)
        if eps < abs(A(i) - S)
            y = S;
        end
    end
end

% MED функция
function y = med(A)
    rk = sort(A);
    y = rk((length(A) + 1) / 2);
end