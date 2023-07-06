s = tf('s');
h1 = 0.001;
err2u_tilde = [(0.001 +0.001/s), 0;
                0, (0.001 +0.001/s)];
G2 = 1/(s+1) * [(s+1), -1;
                    1, (s*L1 +R1)];
trsf = 1/s *[1, 0.00001 *s;
             0.00001*s, 1];
      
trsfz = c2d(trsf, h1, 'tustin');
controller = DiscreteController(trsfz);

tt =  0:h1:1.0;
conts = zeros(2, numel(tt));
for  i= 1:numel(tt)
    conts(:, i) = controller.step([1; 0]);
end

plot(tt, conts)
