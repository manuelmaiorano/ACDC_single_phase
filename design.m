s = tf('s');
params;
model_inner = [1/(s*L1 +R1), 0;
                        0, 1/(s*L1 +R1)];
k = 0.5;
model_outer = (s*L2+R2)/(s^2*L2*C2 +s *C2*R2 +1);

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

phi_rif = 0;
A = [cos(phi_rif), sin(phi_rif)];

controller_inner = [tunablePID('C1','pi'), 0;
                    0, tunablePID('C2','pi')];
controller_outer = tunablePID('C3','pi');
LS = AnalysisPoint('y');
LS1 = AnalysisPoint('r');
system_inner = feedback(model_inner*controller_inner, eye(2));
system_outer = feedback(controller_outer * A * system_inner * [0.5; 0.5] * model_outer, LS);
Req = TuningGoal.StepResp('r','y',5);
T = systune(LS1 *system_outer, [Req]);
%step(system_outer);

% figure;
% system = feedback(model_inner*controller_inner, eye(2));
% step(system)
% figure;
% system = feedback(model_outer*controller_outer, 1);
% step(system)