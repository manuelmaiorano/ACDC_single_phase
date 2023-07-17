params;

s = tf('s');

kp_d = 0.005;
ki_d = 1;
kp_q = 0.005;
ki_q = 1;

%PI controllore interno
err2u_tilde = [(kp_d +ki_d/s), 0;
                0, (kp_q +ki_q/s)];
%matrice di trasformazione G2
G2 = 1/(s*L1 +R1) * [(s*L1 +R1), -omega*L1;
                          omega*L1, (s*L1 +R1)];
  
%controllore loop interno e discretizzazione                    
err2u_hat = G2 * err2u_tilde;
err2u_hatz = c2d(err2u_hat, h, 'tustin');
controller_inner = DiscreteController(err2u_hatz);

%controllore loop esterno e discretizzazione      
kp_v = 15;
ki_v = 15;
% kp_v = 0.0167;
% ki_v = 0.749;
errv2Irif = kp_v + ki_v/s;
errv2Irifz = c2d(errv2Irif, h, 'tustin');
controller_outer = DiscreteController(errv2Irifz);

%creazione controllore
x2_filter = AvgFilter(floor(T/h));
current_detector = PhaseDetector(floor(T/h), 1/h, T);
voltage_detector = PhaseDetector(floor(T/h), 1/h, T);
controller = ACDC_single_phase_controller(controller_outer, controller_inner,...
    current_detector, voltage_detector, x2_filter);

%test se controllore discretizzato stessa risposta al gradino 
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


