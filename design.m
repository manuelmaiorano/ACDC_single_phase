s = tf('s');
model_inner = 1/(s*L1 +R1);

model_outer = k/2 *(s*L2+R2)/(s^2*L2*R2 +s *L2*C2 +1);