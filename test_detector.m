T = 1/50;
h1 = T/1000;
times = 0:h1:5*T;

signal = 311 * cos(2*pi*1/T *times+pi/3);
detector = PhaseDetector(floor(T/h1), 1/h1, T);
outd = zeros('like', signal);
outq = zeros('like', signal);
outphi = zeros('like', signal);
for i= 2:numel(signal)
    [xd, xq] = detector.step(signal(i), times(i));
    outd(i) = xd;
    outq(i) = xq;
    outphi(i) = atan2(xq, xd);
end

figure;
plot(times, signal); hold on;
plot(times, outd);
plot(times, outq);
plot(times, outphi);
legend('segnale', 'diretta', 'quadratura', 'fase');