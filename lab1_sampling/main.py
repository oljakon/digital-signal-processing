import matplotlib.pyplot as plt
from numpy import exp, arange
from math import pi, sin


period = 2
samples = 150
step = 0.01
amplitude = 1.0
sigma = 1.0


class Signal:
    def gauss(self, x):
        return amplitude * exp(- ((x ** 2) / sigma) ** 2)

    def rect(self, x):
        return abs(x) <= abs(period)


# функция отсчета
def sinc(x):
    return 0 if x == 0 else sin(x) / x


def restore(t, signal_type):
    max_k = samples - 1
    min_k = - max_k
    aggr = 0
    delta = period / (samples - 1)
    signal = Signal()

    for k in range(min_k, max_k + 1):
        if signal_type == 'gauss':
            n = signal.gauss(k * delta) * sinc(pi * (t / delta - k))
        else:
            n = signal.rect(k * delta) * sinc(pi * (t / delta - k))
        aggr += n

    return aggr


def main():
    t = arange(-(period + 1), period + 1, step)

    signal = Signal()

    gauss_sampling = signal.gauss(t)
    rect_sampling = signal.rect(t)

    gauss_restored = [restore(i, 'gauss') for i in t]
    rect_restored = [restore(i, 'rect') for i in t]

    plt.figure()

    plt.subplot(211)
    plt.plot(t, gauss_sampling, color='red', label='sampling')
    plt.plot(t, gauss_restored, color='green', label='restored')
    plt.legend()
    plt.grid(True)

    plt.subplot(212)
    plt.plot(t, rect_sampling, color='red', label='sampling')
    plt.plot(t, rect_restored, color='green', label='restored')
    plt.legend()
    plt.grid(True)

    plt.show()


if __name__ == '__main__':
    main()
