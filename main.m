close all;
params;

Nx = 3;
Nz = 12;
%Nz = 4;
Nu = 2;
Nq = 4;
T = 1/50;
omega=2*pi/T;

fs = 2.4e+3;
Ts = 1/fs;
h = Ts/100;
durata_simulazione = 10*T;

% Integrazione del modello con backward Eulero
M1 = inv(eye(Nx)-h*A);
M2 = C*M1*h*B+D;

x_0 = zeros(3, 1);
xprec=x_0;  % Inizializzazione dello stato al passo precedente
ind_fin=round(durata_simulazione/h);
x=zeros(Nx,ind_fin);     % Allocazione matrice di stato (per ogni colonna ho
                        %il valore dello stato x1,x2 all'istante k 
                        %e ho tante colonne quanti sono i passi di integrazione del modello)
z=zeros(Nz,ind_fin);
w = zeros(Nz, ind_fin);
u=zeros(Nu,ind_fin);
sig = zeros(Nq, ind_fin);
portante = zeros(1, ind_fin);
cont = zeros(1, ind_fin);
ums = zeros(1, ind_fin);
global x1ms x1phis vms vphis t_step Irifs u_hatrs u_hatis urs uis verr ir_err iI_err
t_step = h;
x1ms = zeros(1, ind_fin);
x1phis = zeros(1, ind_fin);
vms = zeros(1, ind_fin);
vphis = zeros(1, ind_fin);
Irifs = zeros(1, ind_fin);
u_hatrs = zeros(1, ind_fin);
u_hatis = zeros(1, ind_fin);
urs = zeros(1, ind_fin);
uis = zeros(1, ind_fin);
verr = zeros(1, ind_fin);
ir_err = zeros(1, ind_fin);
iI_err = zeros(1, ind_fin);

y(1)=0;
y = zeros(1, ind_fin);
m = zeros(1, ind_fin);

Vrif = 300;
phi_rif = 0;
x2_av = Vrif;
x3_av = (Vrif-e)/R2;
ui_av = 0.5*Va/Vrif + 1.4142135623731*sqrt(-R1*Vrif*x3_av + 0.125*Va^2)/Vrif;
ur_av = 0.5*L1*omega*(-Va + 2.82842712474619*sqrt(-R1*Vrif*x3_av + 0.125*Va^2))/(R1*Vrif);
x1_av = 0.5*(Va - 2.82842712474619*sqrt(-R1*Vrif*x3_av + 0.125*Va^2))/R1;
% x1i_av = Vrif*x3_av/(2*Va);
% x1r_av = 0;
% x_av = [x1r_av, x1i_av, Vrif, x3_av]';
% A_av =[
%         [-R1/L1, -omega, -ur_av/L1, 0];
%         [-R1/L1, +omega, -ui_av/L1, 0];
%         [0.5*ur_av/C2, 0.5*ui_av/C2, 0, -1/C2];
%         [0, 0, 1/L2, -R2/L2]
%     ];
% 
% B_av = [
%     [-x2_av/L1, 0];
%     [0,  -x2_av/L1];
%     [0.5*x1r_av/C2, 0.5*x1i_av/C2];
%     [0, 0]
%    ];
% Q = eye(4);
% Q(3, 3) = 10;
% R = 1000000;
% [K,S,P] = lqr(A_av, B_av, Q, R);
% 
% csi=0;
% kp=0.0001; ki=0.02;
get_controller;
nper = 1;
xprec=[x1_av, Vrif, x3_av]';
for k = 2:ind_fin
 
    u(1, k) = Va*sin(omega*k*h);
    u(2, k) = e;
 
      ur = ur_av;
      ui = ui_av;    
    %[ur, ui] = controller.step(xprec, k*h, u(1, k), Vrif, phi_rif);
    
    u_m = sqrt(ur^2 + ui^2);
    u_phi = atan2(ur, ui);
    
    cont(k) = u_m * sin(omega*k*h + u_phi);
    ums(k) = u_m;
    [qa, qb] = modulator(cont(k), k*h, Ts);
    
    sig(1, k) = qa;%qa+
    sig(2, k) = 1-qa;%qa-
    sig(3, k) = qb;%qb+
    sig(4, k) = 1-qb;%qb-
    %sig(:, k) = 0;
    
    % Integrazione modello con algoritmo di Lemke
    q_k = C * M1 * xprec + ( C * M1 * h * E + F ) * u(:, k) + [ C * M1 * h * G + H ] * sig(:, k);
    [z(:,k),err] = LEMKE(M2, q_k);
    
    % Aggiornamento dello stato
    x(:,k) = M1 * ( xprec + h * B * z(:,k) + h * E * u(:, k) + h * G * sig(:, k));
    w(:,k)=C*x(:,k)+D*z(:,k)+F*u(:, k)  + H * sig(:, k);
    
    xprec = x(:,k);
end

tempo = h:h:ind_fin*h;

figure;
plot(tempo, x);
hold on;
plot(tempo, u(1, :));
legend('corrente ingresso', 'tensione capacità', 'corrente induttore', 'tensione ingresso');

global tempo1
tempo1 = tempo(1:end);
tempo1(end+1) = tempo1(end)+h;
figure;
plot(tempo1, x1ms);
hold on;
plot(tempo1, x1phis);
legend('ampiezza x1', 'fase x1');

figure;
plot(tempo1, vms);
hold on;
plot(tempo1, vphis);
legend('ampiezza v', 'fase v');

figure;
plot(tempo1, Irifs);
legend('corrente rif');

figure;
plot(tempo, ums);
legend('ampiezza controllo');

figure;
plot(tempo1, u_hatrs);
hold on;
plot(tempo1, u_hatrs);
legend('u_hat_r', 'u_hat_i');

figure;
plot(tempo1, urs);
hold on;
plot(tempo1, uis);
legend('u_r', 'u_i');

figure;
plot(tempo1, verr);
legend('errore x2');

figure;
plot(tempo1, ir_err);
legend('errore ir');

figure;
plot(tempo1, iI_err);
legend('errore iI');


