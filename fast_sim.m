params;

T = 1/50;
omega=2*pi/T;

fs = 2.4e+3;
Ts = 1/fs;
h = Ts/100;
t_fin = 250*T;

Vrif = 310;
phi_rif = 0.0;
get_controller;
modulator_state = Modulator_with_state();

times = 0:h:t_fin;
ind_fin=round(t_fin/h);
global x1ms x1phis vms vphis t_step Irifs u_hatds u_hatqs uds uqs verr id_err iq_err
t_step = h;
x1ms = zeros(1, ind_fin);
x1phis = zeros(1, ind_fin);
vms = zeros(1, ind_fin);
vphis = zeros(1, ind_fin);
Irifs = zeros(1, ind_fin);
u_hatds = zeros(1, ind_fin);
u_hatqs = zeros(1, ind_fin);
uds = zeros(1, ind_fin);
uqs = zeros(1, ind_fin);
verr = zeros(1, ind_fin);
id_err = zeros(1, ind_fin);
iq_err = zeros(1, ind_fin);

options = odeset('Stats','on','OutputFcn',@odeplot, 'Events',...
    @(t, y) fixed_time_step_controller(t, y, h, controller, modulator_state, Va, Vrif, phi_rif, Ts, omega), 'MaxStep', h);
%[t, x] = ode15s(@(t, x) model_av(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e), [0, t_fin], [0;0;0], options);
x0 = [0, Vrif/2, 0]';
%[t, x] = ode45(@(t, x) model(t, x, R1, R2, L1, L2, C2, e, Va, omega, Ts), times, x0, options);
[t, x] = eulero_forward(@(t, x) model(t, x, R1, R2, L1, L2, C2, e, Va, h, controller, modulator_state, Vrif, phi_rif, Ts, omega, t_fin), t_fin, h, x0);

figure;
plot(t, x);
hold on;
plot(t, Va*cos(omega*t));
legend('corrente ingresso', 'tensione capacità', 'corrente induttore', 'tensione ingresso');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

function [t, x] = eulero_forward(model, t_fin, t_step, x0)
    t = 0:t_step:t_fin;
    x = zeros([numel(x0), size(t, 2)]);
    x(:, 1) = x0;
    for i = 2:size(x, 2)
        %metodo eulero forward
        x(:, i) = x(:, i-1) + t_step * model(i*t_step, x(:, i-1));
    end
end

function dx = model(t, x, R1, R2, L1, L2, C2, e, Va, h, controller, modulator, Vrif, phi_rif, Ts, omega, t_fin)
    %global qa qb 
    u = Va * cos(omega*t);
    if t > t_fin/2
        phi_rif = 0.2;
    end
    
    [ud, uq] = controller.step(x, t, u, Vrif, phi_rif);

    u_m = sqrt(ud^2 + uq^2);
    u_phi = atan2(uq, ud);
    cont = u_m * cos(omega*t + u_phi);

    [qa, qb] = modulator.step(cont, t, Ts);
    dx1 = -R1/L1 * x(1) -(qa-qb)*x(2)/L1 + u/L1;
    dx2 =(qa-qb)*x(1)/C2- x(3)/C2;
    dx3 = x(2)/L2 - R2/L2 * x(3) - e/L2;

    dx = [dx1, dx2, dx3]';
end

function [value,isterminal,direction] = fixed_time_step_controller(t, x, h, controller, modulator, Va, Vrif, phi_rif, Ts, omega)
    global qa qb
    direction = 1;
    isterminal = 0;
    if abs(t/h - fix(t/h)) < 0.0001
        u = Va * cos(omega*t);
        [ud, uq] = controller.step(x, t, u, Vrif, phi_rif);
        
        u_m = sqrt(ud^2 + uq^2);
        u_phi = atan2(uq, ud);
        cont = u_m * cos(omega*t + u_phi);
       
        [qa, qb] = modulator.step(cont, t, Ts);
        value = 1;
    else
        value = 0;
    end
    
end