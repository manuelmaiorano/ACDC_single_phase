T = 1/50;
h1 = T/1000;
times = 0:h1:5*T;

signal = 311 * sin(2*pi*1/T *times);
detector = PhaseDetector(floor(T/h1), 1/h1, T);
outA = zeros('like', signal);
outphi = zeros('like', signal);
for i= 2:numel(signal)
    [A, phi] = detector.step(signal(i), times(i));
    outA(i) = A;
    outphi(i) = phi;
end

figure;
plot(times, signal); hold on;
plot(times, outA);
plot(times, outphi);