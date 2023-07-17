params;

T = 1/50;
omega=2*pi/T;

fs = 2.4e+3;
Ts = 1/fs;
h = Ts/100;
t_fin = 10*T;
Vrif = 310;

options = odeset('RelTol',1e-5,'Stats','on','OutputFcn',@odeplot); % 'MaxStep', Ts/100);
%[t, x] = ode15s(@(t, x) model_av(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e), [0, t_fin], [0;0;0], options);
x0 = [0, Vrif/2, 0]';
[t, x] = ode45(@(t, x) model_real(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e, Va, omega, Ts), [0, t_fin], x0, options);

% function dx = model_av(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e)
% 
%     u = u_segn - K * (x-x_av);
%     dx1 = -R1/L1 * x(1) + x(2)*u/L1;
%     dx2 = x(1)* u/C2 - x(3)/C2;
%     dx3 = x(2)/L2 - R2/L2 * x (3) -e/L2;
% 
%     dx = [dx1, dx2, dx3]';
% end

function dx = model_real(t, x, u_segn, x_av, K, R1, R2, L1, L2, C2, e, Va, omega, Ts)
    %qa = 1; qb= 0;
    
    xd = x(1); xq=x(2); x2= x(3); x3=x(4);
    
    dxd = -R1/L1 * xd + omega*xq + x2*ud/L1 + sqrt(2)*Va/L1;
    dxq = -R1/L1 * xq - omega*xd + x2*uq/L1;
    
    dx2 =1/2*(xd*ud+xq*uq)- x3/C2;
    dx3 = x2/L2 - R2/L2 * x3 - e/L2;

    dx = [dxd, dxq, dx2, dx3]';
end
