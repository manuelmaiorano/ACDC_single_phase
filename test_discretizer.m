s = tf('s');
h1 = 0.001;
err2u_tilde = [(0.001 +0.001/s), 0;
                0, (0.001 +0.001/s)];
G2 = 1/(s+1) * [(s+1), -1;
                    1, (s+1)];
trsf = 1/s *[1, 0.00001 *s;
             0.00001*s, 1];
trsf = G2 *trsf;
trsfz = c2d(trsf, h1, 'tustin');
controller = DiscreteController(trsfz);

t_final = 5.0;
tt =  0:h1:t_final;
conts = zeros(2, numel(tt));
for  i= 1:numel(tt)
    conts(:, i) = controller.step([1; 0]);
end
controller = DiscreteController(trsfz);
conts1 = zeros(2, numel(tt));
for  i= 1:numel(tt)
    conts1(:, i) = controller.step([0; 1]);
end

figure;
plot(tt, conts)

figure;
plot(tt, conts1)

figure;
step(trsfz, t_final);
