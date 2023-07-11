s = tf('s');
model_inner = [1/(s*L1 +R1), 0;
                        0, 1/(s*L1 +R1)];
k = 0.5;
model_outer = k/2 *(s*L2+R2)/(s^2*L2*C2 +s *C2*R2 +1);

kp_r = 0.005;
ki_r = 3;
kp_i = kp_r;
ki_i = ki_r;
s = tf('s');

controller_inner = [(kp_r +ki_r/s), 0;
                0, (kp_i +ki_i/s)];
            
            
kp_v = 10;
ki_v = 10;
controller_outer = kp_v + ki_v/s;

if 1
    system = feedback(model_inner*controller_inner, eye(2));
    step(system)
else
    system = feedback(model_outer*controller_outer, 1);
    step(system)
end