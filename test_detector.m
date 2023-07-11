T = 1/50;
h1 = T/1000;
h1 = h;
times = 0:h1:5*T;

signal = 311 * sin(2*pi*1/T *times);
signal = u(1, :);
detector = PhaseDetector(floor(T/h1), 1/h1, T);
outA = zeros('like', signal);
outphi = zeros('like', signal);
for i= 2:numel(signal)
    [A, phi] = detector.step(signal(i), tempo(i));
    outA(i) = A;
    outphi(i) = phi;
end

figure;
plot(tempo, signal); hold on;
plot(tempo, outA);
plot(tempo, outphi);