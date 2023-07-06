params;

T = 1/50;
omega=2*pi/T;

fs = 2.4e+3;
Ts = 1/fs;
h = Ts/100;
t_fin = 10*T;
Vrif = 300;
x3_av = (Vrif-e)/R2;
x1_av = sqrt(Vrif*x3_av/R1);
u_segn = x3_av/x1_av;
x_av = [x1_av, Vrif, x3_av]';
A_av = A + [
        [0, u_segn/L1, 0];
        [u_segn/C2, 0, 0];
        [0, 0, 0],
    ];

B_av = [Vrif/L1, x1_av/C2, 0]';
Q = eye(3);
Q(2, 2) = 10;
R = 1000000;
[K,S,P] = lqr(A_av, B_av, Q, R);

options = odeset('RelTol',1e-5,'Stats','on','OutputFcn',@odeplot); % 'MaxStep', Ts/100);
%[t, x] = ode15s(@(t, x) model_av(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e), [0, t_fin], [0;0;0], options);
x0 = [x1_av, Vrif/2, x3_av]';
[t, x] = ode15s(@(t, x) model_real(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e, Va, omega, Ts), [0, t_fin], x0, options);

function dx = model_av(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e)

    u = u_segn - K * (x-x_av);
    dx1 = -R1/L1 * x(1) + x(2)*u/L1;
    dx2 = x(1)* u/C2 - x(3)/C2;
    dx3 = x(2)/L2 - R2/L2 * x (3) -e/L2;

    dx = [dx1, dx2, dx3]';
end

function dx = model_real(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e, Va, omega, Ts)

    u = u_segn - K * (x-x_av);
    [qa, qb] = modulator(u, t, Ts);
    %qa = 1; qb= 0;
    
    dx1 = -R1/L1 * x(1) + x(2)*(qa-qb)/L1 + sqrt(2)*Va*sin(omega*t)/L1;
    dx2 = x(1)* (qa-qb)/C2 - x(3)/C2;
    dx3 = x(2)/L2 - R2/L2 * x (3) -e/L2;

    dx = [dx1, dx2, dx3]';
end
