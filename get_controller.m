params;

% kp_r = 3.128e+4;
% ki_r = 1.042;
kp_r = 0.005;
ki_r = 3;
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
kp_v = 10;
ki_v = 10;
errv2Irif = kp_v + ki_v/s;
errv2Irifz = c2d(errv2Irif, h, 'tustin');
controller_outer = DiscreteController(errv2Irifz);

current_detector = PhaseDetector(floor(T/h), 1/h, T);
voltage_detector = PhaseDetector(floor(T/h), 1/h, T);
controller = ACDC_single_phase_controller(controller_outer, controller_inner, current_detector, voltage_detector);


%test_outer(controller_outer, errv2Irif, h);
%test_inner(controller_inner, err2u_hat, h);

function test_outer(controller, tf, h)
    t_final = 5.0;
    tt =  0:h:t_final;
    conts = zeros(2, numel(tt));
    for  i= 1:numel(tt)
        conts(:, i) = controller.step(1);
    end
    figure;
    plot(tt, conts)

    figure;
    step(tf, t_final);
    
end

function test_inner(controller, tf, h)
    t_final = 5.0;
    tt =  0:h:t_final;
    conts = zeros(2, numel(tt));
    for  i= 1:numel(tt)
        conts(:, i) = controller.step([1; 0]);
    end
    conts1 = zeros(2, numel(tt));
    controller.reset();
    for  i= 1:numel(tt)
        conts1(:, i) = controller.step([0; 1]);
    end
    
    figure;
    plot(tt, conts)

    figure;
    plot(tt, conts1)

    figure;
    step(tf, t_final);
end


