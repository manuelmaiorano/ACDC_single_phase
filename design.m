s = tf('s');
model_inner = [1/(s*L1 +R1), 0;
                        0, 1/(s*L1 +R1)];
k = 0.5;
model_outer = k/2 *(s*L2+R2)/(s^2*L2*R2 +s *L2*C2 +1);

kp_r = 0.0001;
ki_r = 0.0001;
kp_i = kp_r;
ki_i = ki_r;
s = tf('s');

controller_inner = [(kp_r +ki_r/s), 0;
                0, (kp_i +ki_i/s)];
            
            
kp_v = 10;
ki_v = 10;
controller_outer = kp_v + ki_v/s;

phi_rif = 0;
V_rif = 300;
A = [sin(phi_rif); cos(phi_rif)];

system = feedback([1,0]*model_inner*controller_inner*A, controller_outer);
step(system)