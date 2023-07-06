T = 1/50;
h1 = T/100;
h1 = h;
times = 0:h1:5*T;

signal = 11 * sin(2*pi*1/T *times+pi/6);
signal = x(1, :);
detector = PhaseDetector(floor(T/h1), 1/h1, T);
outA = zeros('like', signal);
outphi = zeros('like', signal);
for i= 1:numel(signal)
    [A, phi] = detector.step(signal(i), tempo(i));
    outA(i) = A;
    outphi(i) = phi;
end

plot(signal); hold on;
plot(outA);
plot(outphi);