params;

% kp_r = 3.128e+4;
% ki_r = 1.042;
kp_r = 0.001;
ki_r = 0.001;
kp_i = kp_r;
ki_i = ki_r;
s = tf('s');

err2u_tilde = [(kp_r +ki_r/s), 0;
                0, (kp_i +ki_i/s)];
G2 = 1/(s*L1 +R1) * [(s*L1 +R1), -omega*L1;
                          omega*L1, (s*L1 +R1)];
  
err2u_hat = G2 * err2u_tilde;
err2u_hatz = c2d(err2u_hat, h, 'tustin');%subs(err2u_hat, s, 2/h*(z-1)/(z+1));
controller_inner = DiscreteController(err2u_hatz);

% kp_v = 4780;
% ki_v = 10.13;
kp_v = 0.001;
ki_v = 0.001;
errv2Irif = kp_v + ki_v/s;
errv2Irifz = c2d(errv2Irif, h, 'tustin');
controller_outer = DiscreteController(errv2Irifz);

current_detector = PhaseDetector(floor(T/h), 1/h, T);
voltage_detector = PhaseDetector(floor(T/h), 1/h, T);
controller = ACDC_single_phase_controller(controller_outer, controller_inner, current_detector, voltage_detector);

% function discrete_controller = get_discrete_controller(transfer_matrix)
%     [ny, nu] = size(transfer_matrix);
%     [num, den] = numden(transfer_matrix(1, 1));
%     den = sym2poly(den);
%     ns = numel(den);
%     coeff_matrix = zeros(ny, ny*ns);
%     for i = 1:ny
%         for j = 1:nu
%             [num, den] = numden(transfer_matrix(i, j));
%             num = sym2poly(num);
%             coeff_matrix(i, j*ns:(j+1)*ns) = num;
%         end
%     end
%     discrete_controller = DiscreteController(ny, nu, ns, coeff_matrix, den);
%     
% end




